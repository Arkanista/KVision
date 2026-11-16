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
import re
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
    """Translate text via Google Translate public endpoints with retries."""
    endpoints = [
        (
            "https://translate.googleapis.com/translate_a/single?"
            + urllib.parse.urlencode({
                "client": "gtx",
                "sl": source_lang,
                "tl": target_lang,
                "dt": "t",
                "q": text,
            }),
            lambda data: "".join(part[0] for part in data[0] if part[0]),
        ),
        (
            "https://clients5.google.com/translate_a/t?"
            + urllib.parse.urlencode({
                "client": "dict-chrome-ex",
                "sl": source_lang,
                "tl": target_lang,
                "q": text,
            }),
            lambda data: (
                data[0]
                if isinstance(data, list) and data and isinstance(data[0], str)
                else "".join(
                    str(x[0]) if isinstance(x, list) and x else str(x)
                    for x in (data if isinstance(data, list) else [])
                )
            ),
        ),
    ]
    for attempt in range(5):
        for endpoint_url, parser in endpoints:
            try:
                req = urllib.request.Request(
                    endpoint_url,
                    headers={"User-Agent": "Mozilla/5.0"},
                )
                with urllib.request.urlopen(req, timeout=15) as resp:
                    data = json.loads(resp.read().decode("utf-8"))
                result = parser(data).strip()
                if result:
                    return result
                raise ValueError("Empty translation returned")
            except Exception as exc:
                print(f"  Attempt {attempt + 1} failed for {target_lang}: {exc}.")
        wait_s = (attempt + 1) * 2
        print(f"  Retrying {target_lang} in {wait_s}s...")
        time.sleep(wait_s)
    raise RuntimeError(f"Failed to translate to {target_lang} after 5 attempts")


def detect_qml_contexts(src_dir: Path | None = None) -> dict[str, list[str]]:
    """Scan src/**/*.qml and src/**/*.cpp to map LNG_XXXXX -> sorted list of context names."""
    if src_dir is None:
        src_dir = ROOT_DIR / "src"
    mapping: dict[str, set[str]] = {}
    for ext in ("*.qml", "*.cpp"):
        for path in src_dir.rglob(ext):
            if "3rd" in path.parts:
                continue
            try:
                text = path.read_text(encoding="utf-8", errors="ignore")
            except OSError:
                continue
            ctx_name = path.stem
            for match in re.finditer(r'qsTr\(\s*"(LNG_[A-Za-z0-9_]+)"\s*\)', text):
                mapping.setdefault(match.group(1), set()).add(ctx_name)
    return {k: sorted(v) for k, v in mapping.items()}


def get_or_create_context(root: ET.Element, ctx_name: str) -> ET.Element:
    for ctx in root.findall("context"):
        name_el = ctx.find("name")
        if name_el is not None and name_el.text == ctx_name:
            return ctx
    ctx = ET.SubElement(root, "context")
    name_el = ET.SubElement(ctx, "name")
    name_el.text = ctx_name
    return ctx


def upsert_messages(
    ts_path: Path,
    entries: dict[str, str],
    key_contexts: dict[str, list[str]] | None = None,
) -> int:
    """Update existing or append new LNG_XXXXX messages in matching Qt .ts <context> blocks."""
    tree = ET.parse(ts_path)
    root = tree.getroot()

    contexts = root.findall("context")
    if not contexts:
        raise ValueError(f"No <context> element found in {ts_path}")

    existing_by_ctx: dict[str, dict[str, ET.Element]] = {}
    for ctx in contexts:
        name_el = ctx.find("name")
        cname = name_el.text if name_el is not None and name_el.text else ""
        ctx_map = existing_by_ctx.setdefault(cname, {})
        for msg in ctx.findall("message"):
            src = msg.find("source")
            if src is not None and src.text:
                ctx_map[src.text] = msg

    count = 0
    for key, value in entries.items():
        target_ctx_names = (key_contexts or {}).get(key) or []
        if not target_ctx_names:
            # Fallback to contexts where the key already exists, or contexts[0]
            found = [cname for cname, cmap in existing_by_ctx.items() if key in cmap]
            if found:
                target_ctx_names = found
            else:
                first_name_el = contexts[0].find("name")
                target_ctx_names = [first_name_el.text] if first_name_el is not None and first_name_el.text else []

        # Remove key from any wrong contexts when explicit/detected target contexts are known
        if key_contexts and key_contexts.get(key):
            allowed = set(target_ctx_names)
            for ctx in root.findall("context"):
                name_el = ctx.find("name")
                cname = name_el.text if name_el is not None and name_el.text else ""
                if cname not in allowed:
                    for msg in list(ctx.findall("message")):
                        src = msg.find("source")
                        if src is not None and src.text == key:
                            ctx.remove(msg)
                            existing_by_ctx.get(cname, {}).pop(key, None)

        for cname in target_ctx_names:
            ctx = get_or_create_context(root, cname)
            cmap = existing_by_ctx.setdefault(cname, {})
            if key in cmap:
                msg = cmap[key]
            else:
                msg = ET.SubElement(ctx, "message")
                src = ET.SubElement(msg, "source")
                src.text = key
                cmap[key] = msg
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
    parser.add_argument("--context", help="Comma-separated Qt <context> name(s) for --id (auto-detected from src/ if omitted)")
    parser.add_argument("--json", help="Path to JSON file containing list of {id, en, pl?, contexts?} objects")
    parser.add_argument("--compile", action="store_true", help="Run lrelease translations/*.ts after updating")
    args = parser.parse_args()

    detected_contexts = detect_qml_contexts()
    items = []
    if args.json:
        items = json.loads(Path(args.json).read_text(encoding="utf-8"))
    elif args.id and args.en:
        explicit_ctx = [c.strip() for c in args.context.split(",") if c.strip()] if args.context else None
        items = [{"id": args.id, "en": args.en, "pl": args.pl, "contexts": explicit_ctx}]
    else:
        parser.error("Provide either --json or both --id and --en")

    key_contexts: dict[str, list[str]] = {}
    for item in items:
        ctxs = item.get("contexts") or detected_contexts.get(item["id"]) or []
        if ctxs:
            key_contexts[item["id"]] = ctxs

    en_entries = {item["id"]: item["en"] for item in items}
    for fname in EN_FILES:
        path = TRANS_DIR / fname
        if path.exists():
            n = upsert_messages(path, en_entries, key_contexts)
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
        n = upsert_messages(pl_path, pl_entries, key_contexts)
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
        n = upsert_messages(path, translated, key_contexts)
        print(f"Translated {n} entries -> {fname} ({lang_code})")

    if args.compile:
        ts_files = sorted(str(p) for p in TRANS_DIR.glob("*.ts"))
        subprocess.run(["lrelease", *ts_files], check=True)
        print("Compiled .qm files with lrelease.")


if __name__ == "__main__":
    main()
