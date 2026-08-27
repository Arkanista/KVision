#!/usr/bin/env python3
"""
Mock Hikvision NVR Server
Simulates a Hikvision NVR with:
1. HTTP ISAPI endpoints (Camera discovery, Device info, Search) on a custom HTTP port (default 17080)
2. RTSP H.264 video streaming on a custom RTSP port (default 17554) with live time overlay

Usage:
    python3 mock_hikvision_server.py [--http-port 17080] [--rtsp-port 17554] [--channels 4] [--user admin] [--pass 12345]
"""

import sys
import os
import argparse
import socket
import threading
import subprocess
import time
import re
from http.server import HTTPServer, BaseHTTPRequestHandler

DEFAULT_HTTP_PORT = 17080
DEFAULT_RTSP_PORT = 17554
DEFAULT_CHANNELS = 4
DEFAULT_USER = "admin"
DEFAULT_PASS = "12345"

class HikvisionISAPIHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        print(f"[ISAPI HTTP] {self.address_string()} - {format % args}")

    def do_GET(self):
        print(f"[ISAPI HTTP] GET {self.path}")
        if self.path.startswith("/ISAPI/System/deviceInfo"):
            self._send_xml(self._xml_device_info())
        elif self.path.startswith("/ISAPI/System/Video/inputs/channels"):
            self._send_xml(self._xml_analog_channels())
        elif self.path.startswith("/ISAPI/ContentMgmt/InputProxy/channels"):
            self._send_xml(self._xml_proxy_channels())
        elif self.path.startswith("/ISAPI/Streaming/channels"):
            self._send_xml(self._xml_streaming_channels())
        elif self.path.startswith("/ISAPI/Security/userCheck"):
            self._send_xml(self._xml_user_check())
        else:
            self._send_xml(self._xml_status_ok())

    def do_POST(self):
        print(f"[ISAPI HTTP] POST {self.path}")
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length).decode('utf-8', errors='ignore') if content_length > 0 else ""
        print(f"[ISAPI HTTP] Body:\n{body}")

        if self.path.startswith("/ISAPI/ContentMgmt/search"):
            self._send_xml(self._xml_search_results(body))
        else:
            self._send_xml(self._xml_status_ok())

    def _send_xml(self, content_str, status_code=200):
        data = content_str.strip().encode('utf-8')
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/xml')
        self.send_header('Content-Length', str(len(data)))
        self.send_header('Connection', 'close')
        self.end_headers()
        self.wfile.write(data)

    def _xml_status_ok(self):
        return """<?xml version="1.0" encoding="UTF-8"?>
<ResponseStatus xmlns="http://www.hikvision.com/ver20/XMLSchema" version="2.0">
    <requestURL>/</requestURL>
    <statusCode>1</statusCode>
    <statusString>OK</statusString>
</ResponseStatus>"""

    def _xml_user_check(self):
        return """<?xml version="1.0" encoding="UTF-8"?>
<userCheck xmlns="http://www.hikvision.com/ver20/XMLSchema" version="2.0">
    <statusValue>200</statusValue>
    <statusString>OK</statusString>
</userCheck>"""

    def _xml_device_info(self):
        return """<?xml version="1.0" encoding="UTF-8"?>
<DeviceInfo xmlns="http://www.hikvision.com/ver20/XMLSchema" version="2.0">
    <deviceName>Mock-Hikvision-NVR</deviceName>
    <deviceID>88888888-4444-4444-4444-121212121212</deviceID>
    <model>DS-7608NI-I2</model>
    <serialNumber>DS-7608NI-I20820260827CCRR123456789WCVU</serialNumber>
    <macAddress>00:11:22:33:44:55</macAddress>
    <firmwareVersion>V4.61.025</firmwareVersion>
    <firmwareReleasedDate>build 260827</firmwareReleasedDate>
    <encoderVersion>V5.0</encoderVersion>
    <encoderReleasedDate>build 260827</encoderReleasedDate>
    <deviceType>NVR</deviceType>
    <telecontrolID>88</telecontrolID>
</DeviceInfo>"""

    def _xml_analog_channels(self):
        channels_xml = ""
        num_channels = getattr(self.server, "channels_count", DEFAULT_CHANNELS)
        for i in range(1, num_channels + 1):
            channels_xml += f"""
    <VideoInputChannel version="2.0" xmlns="http://www.hikvision.com/ver20/XMLSchema">
        <id>{i}</id>
        <inputPort>{i}</inputPort>
        <name>Camera {i}</name>
        <videoInputEnabled>true</videoInputEnabled>
        <videoFormat>PAL</videoFormat>
    </VideoInputChannel>"""
        return f"""<?xml version="1.0" encoding="UTF-8"?>
<VideoInputChannelList xmlns="http://www.hikvision.com/ver20/XMLSchema" version="2.0">{channels_xml}
</VideoInputChannelList>"""

    def _xml_proxy_channels(self):
        return """<?xml version="1.0" encoding="UTF-8"?>
<InputProxyChannelList xmlns="http://www.hikvision.com/ver20/XMLSchema" version="2.0">
</InputProxyChannelList>"""

    def _xml_streaming_channels(self):
        channels_xml = ""
        num_channels = getattr(self.server, "channels_count", DEFAULT_CHANNELS)
        for i in range(1, num_channels + 1):
            main_id = i * 100 + 1
            sub_id = i * 100 + 2
            channels_xml += f"""
    <StreamingChannel version="2.0" xmlns="http://www.hikvision.com/ver20/XMLSchema">
        <id>{main_id}</id>
        <channelName>Camera {i} Main</channelName>
        <enabled>true</enabled>
        <Video>
            <enabled>true</enabled>
            <videoCodecType>H.264</videoCodecType>
            <videoResolutionWidth>1920</videoResolutionWidth>
            <videoResolutionHeight>1080</videoResolutionHeight>
        </Video>
    </StreamingChannel>
    <StreamingChannel version="2.0" xmlns="http://www.hikvision.com/ver20/XMLSchema">
        <id>{sub_id}</id>
        <channelName>Camera {i} Sub</channelName>
        <enabled>true</enabled>
        <Video>
            <enabled>true</enabled>
            <videoCodecType>H.264</videoCodecType>
            <videoResolutionWidth>640</videoResolutionWidth>
            <videoResolutionHeight>480</videoResolutionHeight>
        </Video>
    </StreamingChannel>"""
        return f"""<?xml version="1.0" encoding="UTF-8"?>
<StreamingChannelList xmlns="http://www.hikvision.com/ver20/XMLSchema" version="2.0">{channels_xml}
</StreamingChannelList>"""

    def _xml_search_results(self, search_request_xml):
        now = time.gmtime()
        today_str = time.strftime("%Y-%m-%dT", now)
        start_time = today_str + "00:00:00Z"
        end_time = today_str + "23:59:59Z"

        return f"""<?xml version="1.0" encoding="utf-8"?>
<CMSearchResult xmlns="http://www.hikvision.com/ver20/XMLSchema">
    <searchID>1</searchID>
    <responseStatus>true</responseStatus>
    <responseStatusStrg>OK</responseStatusStrg>
    <numOfMatches>1</numOfMatches>
    <matchList>
        <searchMatchItem>
            <trackID>101</trackID>
            <timeSpan>
                <startTime>{start_time}</startTime>
                <endTime>{end_time}</endTime>
            </timeSpan>
            <mediaSegmentDescriptor>
                <contentType>video</contentType>
                <codecType>H.264</codecType>
            </mediaSegmentDescriptor>
        </searchMatchItem>
    </matchList>
</CMSearchResult>"""


class MockRtspServer:
    def __init__(self, host="0.0.0.0", port=DEFAULT_RTSP_PORT):
        self.host = host
        self.port = port
        self.running = True
        self.server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server_sock.bind((self.host, self.port))
        self.server_sock.listen(10)
        print(f"[RTSP] Server listening on {self.host}:{self.port}")

    def start(self):
        t = threading.Thread(target=self._accept_loop, daemon=True)
        t.start()

    def _accept_loop(self):
        while self.running:
            try:
                client_sock, addr = self.server_sock.accept()
                print(f"[RTSP] Connection accepted from {addr}")
                ct = threading.Thread(target=self._handle_client, args=(client_sock, addr), daemon=True)
                ct.start()
            except Exception as e:
                if not self.running:
                    break
                print(f"[RTSP] Accept error: {e}")

    def _handle_client(self, sock, addr):
        session_id = str(int(time.time() * 1000) % 100000000)
        ffmpeg_proc = None
        is_interleaved = False
        interleaved_channel = 0
        client_rtp_port = None
        client_rtcp_port = None
        transport_line = ""
        uri_path = ""

        try:
            buffer = ""
            while self.running:
                data = sock.recv(4096)
                if not data:
                    break

                if data[0] == 0x24:
                    continue

                buffer += data.decode('utf-8', errors='ignore')
                while "\r\n\r\n" in buffer:
                    header, buffer = buffer.split("\r\n\r\n", 1)
                    lines = header.strip().split("\r\n")
                    req_line = lines[0]
                    parts = req_line.split(" ")
                    if len(parts) < 3:
                        continue
                    method, uri, version = parts[0], parts[1], parts[2]
                    uri_path = uri

                    cseq = 1
                    for line in lines[1:]:
                        if line.lower().startswith("cseq:"):
                            cseq = int(line.split(":")[1].strip())
                        elif line.lower().startswith("transport:"):
                            transport_line = line.split(":", 1)[1].strip()

                    print(f"[RTSP] {addr} -> {method} {uri} (CSeq: {cseq})")

                    if method == "OPTIONS":
                        resp = (
                            f"RTSP/1.0 200 OK\r\n"
                            f"CSeq: {cseq}\r\n"
                            f"Public: OPTIONS, DESCRIBE, SETUP, PLAY, PAUSE, TEARDOWN\r\n\r\n"
                        )
                        sock.sendall(resp.encode())

                    elif method == "DESCRIBE":
                        sdp = (
                            "v=0\r\n"
                            f"o=- {int(time.time())} 1 IN IP4 0.0.0.0\r\n"
                            "s=Mock Hikvision RTSP Stream\r\n"
                            "t=0 0\r\n"
                            "a=control:*\r\n"
                            "a=range:npt=0-\r\n"
                            "m=video 0 RTP/AVP 96\r\n"
                            "c=IN IP4 0.0.0.0\r\n"
                            "b=AS:2000\r\n"
                            "a=rtpmap:96 H264/90000\r\n"
                            "a=fmtp:96 packetization-mode=1;profile-level-id=42e01e\r\n"
                            "a=control:trackID=1\r\n"
                        )
                        resp = (
                            f"RTSP/1.0 200 OK\r\n"
                            f"CSeq: {cseq}\r\n"
                            f"Content-Type: application/sdp\r\n"
                            f"Content-Length: {len(sdp)}\r\n\r\n"
                            f"{sdp}"
                        )
                        sock.sendall(resp.encode())

                    elif method == "SETUP":
                        if "interleaved=" in transport_line:
                            is_interleaved = True
                            m = re.search(r"interleaved=(\d+)-(\d+)", transport_line)
                            interleaved_channel = int(m.group(1)) if m else 0
                            server_transport = f"RTP/AVP/TCP;unicast;interleaved={interleaved_channel}-{interleaved_channel+1}"
                        else:
                            is_interleaved = False
                            m = re.search(r"client_port=(\d+)-(\d+)", transport_line)
                            if m:
                                client_rtp_port = int(m.group(1))
                                client_rtcp_port = int(m.group(2))
                            server_transport = f"RTP/AVP;unicast;client_port={client_rtp_port}-{client_rtcp_port};server_port=60000-60001"

                        resp = (
                            f"RTSP/1.0 200 OK\r\n"
                            f"CSeq: {cseq}\r\n"
                            f"Session: {session_id}\r\n"
                            f"Transport: {server_transport}\r\n\r\n"
                        )
                        sock.sendall(resp.encode())

                    elif method == "PLAY":
                        resp = (
                            f"RTSP/1.0 200 OK\r\n"
                            f"CSeq: {cseq}\r\n"
                            f"Session: {session_id}\r\n"
                            f"Range: npt=0.000-\r\n"
                            f"RTP-Info: url={uri}/trackID=1;seq=1;rtptime=0\r\n\r\n"
                        )
                        sock.sendall(resp.encode())
                        print(f"[RTSP] Streaming started for {addr} on channel {uri_path} (TCP interleaved={is_interleaved})")

                        chan_label = "CH1"
                        chan_match = re.search(r"/Channels/(\d+)", uri_path)
                        if chan_match:
                            chan_label = f"Channel {chan_match.group(1)}"

                        local_udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                        local_udp.bind(('127.0.0.1', 0))
                        local_udp_port = local_udp.getsockname()[1]

                        cmd = [
                            "ffmpeg",
                            "-hide_banner", "-loglevel", "error",
                            "-re",
                            "-f", "lavfi",
                            "-i", f"testsrc=size=640x480:rate=25,drawtext=text='Mock NVR - {chan_label}':fontsize=26:fontcolor=white:box=1:boxcolor=black@0.6:x=20:y=20,drawtext=text='%{{localtime}}':fontsize=24:fontcolor=yellow:box=1:boxcolor=black@0.6:x=20:y=60",
                            "-c:v", "libx264",
                            "-pix_fmt", "yuv420p",
                            "-preset", "ultrafast",
                            "-tune", "zerolatency",
                            "-g", "25",
                            "-payload_type", "96",
                            "-f", "rtp",
                            f"rtp://127.0.0.1:{local_udp_port}"
                        ]
                        ffmpeg_proc = subprocess.Popen(cmd)

                        def stream_forwarder():
                            try:
                                while self.running and ffmpeg_proc.poll() is None:
                                    pkt, _ = local_udp.recvfrom(2048)
                                    if is_interleaved:
                                        hdr = bytearray([0x24, interleaved_channel, (len(pkt) >> 8) & 0xFF, len(pkt) & 0xFF])
                                        sock.sendall(hdr + pkt)
                                    else:
                                        if client_rtp_port:
                                            local_udp.sendto(pkt, (addr[0], client_rtp_port))
                            except Exception:
                                pass
                            finally:
                                local_udp.close()

                        stream_thread = threading.Thread(target=stream_forwarder, daemon=True)
                        stream_thread.start()

                    elif method == "TEARDOWN":
                        resp = (
                            f"RTSP/1.0 200 OK\r\n"
                            f"CSeq: {cseq}\r\n"
                            f"Session: {session_id}\r\n\r\n"
                        )
                        sock.sendall(resp.encode())
                        break

        except Exception as e:
            print(f"[RTSP] Client exception: {e}")
        finally:
            if ffmpeg_proc:
                ffmpeg_proc.kill()
            sock.close()
            print(f"[RTSP] Connection closed for {addr}")


def main():
    parser = argparse.ArgumentParser(description="Mock Hikvision NVR Server (ISAPI + RTSP)")
    parser.add_argument("--http-port", type=int, default=DEFAULT_HTTP_PORT, help=f"HTTP ISAPI port (default: {DEFAULT_HTTP_PORT})")
    parser.add_argument("--rtsp-port", type=int, default=DEFAULT_RTSP_PORT, help=f"RTSP stream port (default: {DEFAULT_RTSP_PORT})")
    parser.add_argument("--channels", type=int, default=DEFAULT_CHANNELS, help=f"Number of channels (default: {DEFAULT_CHANNELS})")
    parser.add_argument("--user", type=str, default=DEFAULT_USER, help=f"Username (default: {DEFAULT_USER})")
    parser.add_argument("--pass", dest="password", type=str, default=DEFAULT_PASS, help=f"Password (default: {DEFAULT_PASS})")
    args = parser.parse_args()

    print("=" * 60)
    print("           MOCK HIKVISION NVR SERVER")
    print("=" * 60)
    print(f" HTTP (ISAPI) Port: {args.http_port}")
    print(f" RTSP Stream Port:  {args.rtsp_port}")
    print(f" Channels:          {args.channels}")
    print(f" Credentials:       {args.user}:{args.password}")
    print("=" * 60)

    rtsp_server = MockRtspServer(port=args.rtsp_port)
    rtsp_server.start()

    http_server = HTTPServer(('0.0.0.0', args.http_port), HikvisionISAPIHandler)
    http_server.channels_count = args.channels
    http_thread = threading.Thread(target=http_server.serve_forever, daemon=True)
    http_thread.start()
    print(f"[ISAPI HTTP] Server listening on 0.0.0.0:{args.http_port}")
    print("\nPress Ctrl+C to stop.\n")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nStopping Mock NVR Server...")
        rtsp_server.running = False
        http_server.shutdown()
        print("Server stopped.")

if __name__ == "__main__":
    main()
