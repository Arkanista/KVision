#!/usr/bin/env python3
"""
Generate GitHub Release notes (CHANGELOG.md section + Downloads links) from tag assets.
"""

import argparse
import re
from pathlib import Path


def extract_changelog_section(changelog_path: Path, version: str) -> str:
    """Extract the body of CHANGELOG.md for the given version without the top header."""
    if not changelog_path.is_file():
        return f"Release v{version} of KVision VMS."

    lines = changelog_path.read_text(encoding="utf-8").splitlines()
    header_re = re.compile(rf"^##\s+\[{re.escape(version)}\](?:\s|$)")
    next_header_re = re.compile(r"^##\s+\[")

    capturing = False
    collected: list[str] = []
    for line in lines:
        if not capturing:
            if header_re.match(line):
                capturing = True
            continue
        if next_header_re.match(line):
            break
        collected.append(line)

    while collected and not collected[0].strip():
        collected.pop(0)
    while collected and not collected[-1].strip():
        collected.pop()

    if not collected:
        return f"Release v{version} of KVision VMS."
    return "\n".join(collected)


def format_deb_label(filename: str) -> str:
    m = re.search(r"_([a-zA-Z]+)([0-9.]+)_[^_]+\.deb$", filename)
    if not m:
        return filename
    distro = m.group(1).lower()
    ver = m.group(2)
    if distro == "debian":
        return f"Debian {ver}"
    if distro == "ubuntu":
        return f"Ubuntu {ver}"
    return f"{distro.capitalize()} {ver}"


def format_rpm_label(filename: str) -> str:
    m = re.search(r"\.(fc|el)([0-9]+)\.[^.]+\.rpm$", filename)
    if not m:
        return filename
    prefix, num = m.group(1).lower(), m.group(2)
    if prefix == "fc":
        return f"Fedora {num}"
    if prefix == "el":
        return f"EL{num}"
    return f"{prefix.upper()} {num}"


def rpm_sort_key(filename: str) -> tuple[int, str]:
    m = re.search(r"\.(fc|el)([0-9]+)\.", filename)
    if not m:
        return (2, filename)
    group = 0 if m.group(1).lower() == "fc" else 1
    return (group, f"{int(m.group(2)):04d}_{filename}")


def build_downloads_section(tag: str, repo: str, filenames: list[str]) -> str:
    base_url = f"https://github.com/{repo}/releases/download/{tag}"

    def link(fname: str) -> str:
        return f"[{fname}]({base_url}/{fname})"

    exe_files = sorted(f for f in filenames if f.endswith("-setup.exe") or (f.endswith(".exe") and "setup" in f.lower()))
    zip_files = sorted(f for f in filenames if f.endswith(".zip"))
    appimages = sorted(f for f in filenames if f.endswith(".AppImage"))
    zsyncs = sorted(f for f in filenames if f.endswith(".AppImage.zsync"))
    flatpaks = sorted(f for f in filenames if f.endswith(".flatpak"))
    archs = sorted(f for f in filenames if f.endswith(".pkg.tar.zst"))
    debs = sorted(f for f in filenames if f.endswith(".deb"))
    rpms = sorted((f for f in filenames if f.endswith(".rpm")), key=rpm_sort_key)

    out: list[str] = ["### Downloads", ""]

    win_parts: list[str] = []
    for f in exe_files:
        win_parts.append(f"{link(f)} (Installer)")
    for f in zip_files:
        win_parts.append(f"{link(f)} (Portable)")
    if win_parts:
        out.append(f"* **Windows (x64):** {' | '.join(win_parts)}")

    if appimages:
        app_line = f"* **Linux Portable (AppImage):** {link(appimages[0])}"
        if zsyncs:
            app_line += f" ([.zsync]({base_url}/{zsyncs[0]}))"
        out.append(app_line)

    if flatpaks:
        out.append(f"* **Linux Flatpak:** {link(flatpaks[0])}")

    out.append(
        f"* **NixOS / Nix Flakes (`x86_64-linux`):** `nix run github:{repo}/{tag}` "
        f"(or add as a flake input — see [README](https://github.com/{repo}#5-nixos--nix-flakes-x86_64-linux))"
    )

    if archs:
        out.append(f"* **Arch Linux:** {link(archs[0])}")

    if debs:
        out.append("* **Debian / Ubuntu (`.deb`):**")
        for f in debs:
            out.append(f"  * {format_deb_label(f)}: {link(f)}")

    if rpms:
        out.append("* **Fedora / RHEL (`.rpm`):**")
        for f in rpms:
            out.append(f"  * {format_rpm_label(f)}: {link(f)}")

    return "\n".join(out)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate GitHub Release notes from CHANGELOG.md and assets.")
    parser.add_argument("--tag", required=True, help="Git tag name (e.g. v2.8.5)")
    parser.add_argument("--repo", default="Arkanista/KVision", help="GitHub owner/repo")
    parser.add_argument("--changelog", default="CHANGELOG.md", help="Path to CHANGELOG.md")
    parser.add_argument("--assets-dir", default="release-assets", help="Directory containing built release assets")
    parser.add_argument("--output", default="release-notes.md", help="Output markdown path")
    args = parser.parse_args()

    version = args.tag[1:] if args.tag.startswith("v") else args.tag
    changelog_body = extract_changelog_section(Path(args.changelog), version)

    assets_dir = Path(args.assets_dir)
    filenames = [p.name for p in assets_dir.iterdir() if p.is_file()] if assets_dir.is_dir() else []
    downloads_body = build_downloads_section(args.tag, args.repo, filenames)

    notes = f"{changelog_body}\n\n---\n\n{downloads_body}\n"
    Path(args.output).write_text(notes, encoding="utf-8")
    print(f"Generated {args.output} for {args.tag} ({len(filenames)} assets found).")


if __name__ == "__main__":
    main()
