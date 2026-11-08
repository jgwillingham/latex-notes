"""Write manifest.json and a plain index.html for the built PDFs.

Usage: python3 scripts/manifest.py <site-dir>

manifest.json is read by the Notes page on the personal site to show each note's
last-updated date and size. A note's date is the last commit that touched its folder.
"""
import datetime
import html
import json
import os
import subprocess
import sys

site = sys.argv[1] if len(sys.argv) > 1 else "_site"


def last_commit_date(path):
    try:
        out = subprocess.run(
            ["git", "log", "-1", "--format=%cs", "--", path],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        out = ""
    return out or datetime.date.today().isoformat()


notes = {}
for name in sorted(os.listdir(site)):
    if not name.endswith(".pdf"):
        continue
    key = name[:-4]
    notes[key] = {
        "updated": last_commit_date(f"notes/{key}"),
        "size_kb": max(1, round(os.path.getsize(os.path.join(site, name)) / 1024)),
    }

manifest = {
    "generated": datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds"),
    "commit": os.environ.get("GITHUB_SHA", "local")[:7],
    "notes": notes,
}
with open(os.path.join(site, "manifest.json"), "w", encoding="utf-8") as f:
    json.dump(manifest, f, indent=2)

# Fallback page for anyone who visits the notes site root directly.
items = "\n".join(
    f'<li><a href="{html.escape(k)}.pdf">{html.escape(k)}</a> '
    f'<small>({v["updated"]}, {v["size_kb"]} KB)</small></li>'
    for k, v in notes.items()
)
with open(os.path.join(site, "index.html"), "w", encoding="utf-8") as f:
    f.write(f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Notes (PDFs)</title>
<style>body{{font-family:system-ui,sans-serif;max-width:40rem;margin:2rem auto;padding:0 1rem;line-height:1.6}}</style>
</head><body>
<h1>Notes (PDFs)</h1>
<p>Browse these with descriptions at <a href="https://jgwillingham.github.io/notes/">jgwillingham.github.io/notes</a>.</p>
<ul>
{items}
</ul>
</body></html>
""")

print(f"manifest.json: {len(notes)} note(s)")
