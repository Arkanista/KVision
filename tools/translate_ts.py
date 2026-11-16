#!/usr/bin/env python3
"""
Update KVision LNG_XXXXX keys in the English and Bulgarian Qt .ts files.

Usage examples:
  python3 tools/translate_ts.py --id LNG_00587 --en "English text" --bg "Bulgarian text" --compile
  python3 tools/translate_ts.py --json changes.json --compile

JSON format for --json:
  [
    {"id": "LNG_00587", "en": "...", "bg": "..."}
  ]
"""

import argparse
import json
import subprocess
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
TRANS_DIR = ROOT_DIR / "translations"

EN_FILES = ("en_US.ts", "kvision_en_US.ts")
BG_FILE = "kvision_bg_BG.ts"


def google_translate(text: str, target_lang: str, source_lang: str = "en") -> str:
    """Translate text via Google Translate public endpoint with retries."""
    url = "https://translate.googleapis.com/translate_a/single"
    params = urllib.parse.urlencode({
        "client": "gtx",
        "sl": source_lang,
        "tl": target_lang,
        "dt": "t",
        "q": text,
    })
    for attempt in range(5):
        try:
            req = urllib.request.Request(
                f"{url}?{params}",
                headers={"User-Agent": "Mozilla/5.0"},
            )
            with urllib.request.urlopen(req, timeout=15) as resp:
                data = json.loads(resp.read().decode("utf-8"))
            return "".join(part[0] for part in data[0] if part[0])
        except Exception as exc:
            wait_s = (attempt + 1) * 2
            print(f"  Attempt {attempt + 1} failed for {target_lang}: {exc}. Retrying in {wait_s}s...")
            time.sleep(wait_s)
    raise RuntimeError(f"Failed to translate to {target_lang} after 5 attempts")


def upsert_messages(ts_path: Path, entries: dict[str, str]) -> int:
    """Update existing or append new LNG_XXXXX messages in a Qt .ts file."""
    tree = ET.parse(ts_path)
    root = tree.getroot()

    contexts = root.findall("context")
    if not contexts:
        raise ValueError(f"No <context> element found in {ts_path}")

    existing_map: dict[str, ET.Element] = {}
    for ctx in contexts:
        for msg in ctx.findall("message"):
            src = msg.find("source")
            if src is not None and src.text:
                existing_map[src.text] = msg

    target_ctx = contexts[0]
    count = 0
    for key, value in entries.items():
        if key in existing_map:
            msg = existing_map[key]
        else:
            msg = ET.SubElement(target_ctx, "message")
            src = ET.SubElement(msg, "source")
            src.text = key
        trn = msg.find("translation")
        if trn is None:
            trn = ET.SubElement(msg, "translation")
        trn.text = value
        trn.attrib.pop("type", None)
        count += 1

    # Restore <!DOCTYPE TS> cleanly after ET write
    xml_bytes = ET.tostring(root, encoding="utf-8")
    content = '<?xml version="1.0" encoding="utf-8"?>\n<!DOCTYPE TS>\n' + xml_bytes.decode("utf-8") + "\n"
    ts_path.write_text(content, encoding="utf-8")
    return count


def main() -> None:
    parser = argparse.ArgumentParser(description="Update KVision English and Bulgarian .ts files")
    parser.add_argument("--id", help="Single key ID (e.g. LNG_00587)")
    parser.add_argument("--en", help="English text for --id")
    parser.add_argument("--bg", help="Bulgarian text for --id (optional; uses Google Translate if omitted)")
    parser.add_argument("--json", help="Path to JSON file containing list of {id, en, bg?} objects")
    parser.add_argument("--compile", action="store_true", help="Run lrelease translations/*.ts after updating")
    args = parser.parse_args()

    items = []
    if args.json:
        items = json.loads(Path(args.json).read_text(encoding="utf-8"))
    elif args.id and args.en:
        items = [{"id": args.id, "en": args.en, "bg": args.bg}]
    else:
        parser.error("Provide either --json or both --id and --en")

    en_entries = {item["id"]: item["en"] for item in items}
    for fname in EN_FILES:
        path = TRANS_DIR / fname
        if path.exists():
            n = upsert_messages(path, en_entries)
            print(f"Updated {n} entries in {fname}")

    bg_path = TRANS_DIR / BG_FILE
    if bg_path.exists():
        bg_entries = {}
        for item in items:
            bg_text = item.get("bg")
            if not bg_text:
                bg_text = google_translate(item["en"], "bg")
                time.sleep(0.2)
            bg_entries[item["id"]] = bg_text
        n = upsert_messages(bg_path, bg_entries)
        print(f"Updated {n} entries in {BG_FILE}")

    if args.compile:
        ts_files = sorted(str(p) for p in TRANS_DIR.glob("*.ts"))
        subprocess.run(["lrelease", *ts_files], check=True)
        print("Compiled .qm files with lrelease.")


if __name__ == "__main__":
    main()
