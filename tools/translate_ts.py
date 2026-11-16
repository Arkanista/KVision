#!/usr/bin/env python3
"""
Translate KVision LNG_XXXXX keys across all 23 Qt .ts translation files
using Google Translate API (preserving LLM context/tokens).

Usage examples:
  python3 tools/translate_ts.py --id LNG_00587 --en "English text" --pl "Polish text" --compile
  python3 tools/translate_ts.py --json changes.json --compile

JSON format for --json:
  [
    {"id": "LNG_00587", "en": "...", "pl": "..."}
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
PL_FILE = "kvision_pl_PL.ts"

GOOGLE_LANG_MAP = {
    "kvision_ar_AR.ts": "ar",
    "kvision_bg_BG.ts": "bg",
    "kvision_cs_CZ.ts": "cs",
    "kvision_da_DK.ts": "da",
    "kvision_de_DE.ts": "de",
    "kvision_el_GR.ts": "el",
    "kvision_es_ES.ts": "es",
    "kvision_fi_FI.ts": "fi",
    "kvision_fr_FR.ts": "fr",
    "kvision_hu_HU.ts": "hu",
    "kvision_it_IT.ts": "it",
    "kvision_nb_NO.ts": "no",
    "kvision_nl_NL.ts": "nl",
    "kvision_pt_PT.ts": "pt",
    "kvision_ro_RO.ts": "ro",
    "kvision_sk_SK.ts": "sk",
    "kvision_sv_SE.ts": "sv",
    "kvision_tr_TR.ts": "tr",
    "kvision_uk_UA.ts": "uk",
    "kvision_zh_CN.ts": "zh-CN",
}


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
    parser = argparse.ArgumentParser(description="Translate KVision .ts files using Google Translate API")
    parser.add_argument("--id", help="Single key ID (e.g. LNG_00587)")
    parser.add_argument("--en", help="English text for --id")
    parser.add_argument("--pl", help="Polish text for --id (optional; uses Google Translate if omitted)")
    parser.add_argument("--json", help="Path to JSON file containing list of {id, en, pl?} objects")
    parser.add_argument("--compile", action="store_true", help="Run lrelease translations/*.ts after updating")
    args = parser.parse_args()

    items = []
    if args.json:
        items = json.loads(Path(args.json).read_text(encoding="utf-8"))
    elif args.id and args.en:
        items = [{"id": args.id, "en": args.en, "pl": args.pl}]
    else:
        parser.error("Provide either --json or both --id and --en")

    en_entries = {item["id"]: item["en"] for item in items}
    for fname in EN_FILES:
        path = TRANS_DIR / fname
        if path.exists():
            n = upsert_messages(path, en_entries)
            print(f"Updated {n} entries in {fname}")

    pl_path = TRANS_DIR / PL_FILE
    if pl_path.exists():
        pl_entries = {}
        for item in items:
            pl_text = item.get("pl")
            if not pl_text:
                pl_text = google_translate(item["en"], "pl")
                time.sleep(0.2)
            pl_entries[item["id"]] = pl_text
        n = upsert_messages(pl_path, pl_entries)
        print(f"Updated {n} entries in {PL_FILE}")

    for fname, lang_code in GOOGLE_LANG_MAP.items():
        path = TRANS_DIR / fname
        if not path.exists():
            print(f"Skipping missing {fname}")
            continue
        translated = {}
        for item in items:
            translated[item["id"]] = google_translate(item["en"], lang_code)
            time.sleep(0.2)
        n = upsert_messages(path, translated)
        print(f"Translated {n} entries -> {fname} ({lang_code})")

    if args.compile:
        ts_files = sorted(str(p) for p in TRANS_DIR.glob("*.ts"))
        subprocess.run(["lrelease", *ts_files], check=True)
        print("Compiled .qm files with lrelease.")


if __name__ == "__main__":
    main()
