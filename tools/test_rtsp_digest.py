#!/usr/bin/env python3
"""Check the FFmpeg RTSP client against local Digest challenges."""

import hashlib
import socket
import subprocess
import sys
from urllib.request import parse_http_list, parse_keqv_list


def verify_digest(authorization, expected_algorithm, method, uri):
    scheme, _, fields = authorization.partition(" ")
    digest = parse_keqv_list(parse_http_list(fields))
    if scheme != "Digest" or digest.get("algorithm") != expected_algorithm:
        raise RuntimeError(f"Expected a {expected_algorithm} Digest response")

    def hash_text(text):
        return hashlib.new(expected_algorithm.replace("-", "").lower(), text.encode()).hexdigest()

    ha1 = hash_text("test-user:test-realm:test-password")
    ha2 = hash_text(f"{method}:{uri}")
    expected = hash_text(f"{ha1}:test-nonce:{digest['nc']}:{digest['cnonce']}:auth:{ha2}")
    if digest.get("uri") != uri or digest.get("response") != expected:
        raise RuntimeError(f"Invalid {expected_algorithm} Digest response")


def serve_rtsp(listener, algorithms):
    connection, _ = listener.accept()
    with connection, connection.makefile("rb") as reader:
        connection.settimeout(5)
        for _ in range(4):
            request = reader.readline().decode().strip()
            if not request:
                break
            method, uri, _ = request.split()
            headers = {}
            while line := reader.readline().decode().strip():
                name, _, value = line.partition(":")
                headers[name.lower()] = value.strip()

            authorization = headers.get("authorization")
            if method == "OPTIONS":
                response = ["200 OK", "Public: OPTIONS, DESCRIBE, SETUP, PLAY"]
            elif authorization:
                verify_digest(authorization, algorithms[-1], method, uri)
                # Authentication is the end of this test. No SDP or media is needed.
                response = ["404 Not Found"]
            else:
                response = ["401 Unauthorized"]
                response.extend(
                    f'WWW-Authenticate: Digest realm="test-realm", nonce="test-nonce", '
                    f'algorithm="{algorithm}", qop="auth"'
                    for algorithm in algorithms
                )
                response.append('WWW-Authenticate: Basic realm="test-realm"')

            status, *extra = response
            reply = [f"RTSP/1.0 {status}", f"CSeq: {headers['cseq']}", *extra, "", ""]
            connection.sendall("\r\n".join(reply).encode())
            if method == "DESCRIBE" and authorization:
                return

    raise RuntimeError(f"No authenticated RTSP DESCRIBE for {' + '.join(algorithms)}")


def test_client(ffmpeg, algorithms):
    with socket.socket() as listener:
        listener.bind(("127.0.0.1", 0))
        listener.listen(1)
        listener.settimeout(5)
        port = listener.getsockname()[1]
        uri = f"rtsp://test-user:test-password@127.0.0.1:{port}/Streaming/Channels/101"
        command = [ffmpeg, "-nostdin", "-loglevel", "error", "-rtsp_transport", "tcp", "-i", uri, "-f", "null", "-"]
        with subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True) as client:
            try:
                serve_rtsp(listener, algorithms)
            finally:
                try:
                    _, errors = client.communicate(timeout=5)
                except subprocess.TimeoutExpired:
                    client.kill()
                    _, errors = client.communicate()
                if errors and "404 Not Found" not in errors:
                    print(errors, file=sys.stderr, end="")

    print(f"Verified RTSP Digest with {' + '.join(algorithms)}")


if __name__ == "__main__":
    for challenges in [("MD5",), ("SHA-256",), ("MD5", "SHA-256")]:
        test_client(sys.argv[1], challenges)
