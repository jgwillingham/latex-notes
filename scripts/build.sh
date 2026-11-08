#!/usr/bin/env bash
# Compile every note folder notes/<name>/ to <out>/<name>.pdf.
# Usage: bash scripts/build.sh [out-dir]    (default out-dir: _site)
#
# A note's main file is notes/<name>/main.tex if present, otherwise the single
# .tex file in the folder. A folder with several .tex files and no main.tex is an error.
#
# If any note fails (or no notes are found), the script exits non-zero after trying
# them all, so the workflow doesn't deploy and the previously published PDFs stay live.
set -uo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:-_site}"
mkdir -p "$out"
out="$(cd "$out" && pwd)"

# Shared packages/classes/macros in shared/ are found by every note.
# (MiKTeX under Git Bash needs a Windows path and ';' as the separator.)
if command -v cygpath >/dev/null 2>&1; then
  export TEXINPUTS="$(cygpath -m "$root/shared")//;"
else
  export TEXINPUTS="$root/shared//:"
fi

# Build stamp available to notes as \buildstamp (see shared/jgwnotes.sty).
printf '\\def\\buildstamp{Built %s from commit %s}\n' \
  "$(date -u +%Y-%m-%d)" "${BUILD_COMMIT:-local}" > "$root/shared/buildinfo.tex"

failed=()
count=0
for dir in "$root"/notes/*/; do
  dir="${dir%/}"
  note="$(basename "$dir")"

  if [ -e "$dir/main.tex" ]; then
    tex="$dir/main.tex"
  else
    texfiles=("$dir"/*.tex)
    if [ ! -e "${texfiles[0]}" ]; then
      echo "::warning title=No .tex file::notes/$note has no .tex file, skipping"
      continue
    elif [ ${#texfiles[@]} -ne 1 ]; then
      echo "::error title=Ambiguous note::notes/$note has several .tex files; add a main.tex"
      failed+=("$note")
      continue
    fi
    tex="${texfiles[0]}"
  fi

  echo "::group::$note"
  # -jobname=main keeps every note's output named main.* (git-ignored), whatever the .tex is called.
  if latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error -jobname=main -cd "$tex"; then
    cp "$dir/main.pdf" "$out/$note.pdf"
    count=$((count + 1))
  else
    failed+=("$note")
  fi
  echo "::endgroup::"
done

echo "Built $count note(s) into $out"
if [ "$count" -eq 0 ] && [ ${#failed[@]} -eq 0 ]; then
  echo "::error title=No notes found::nothing to build in $root/notes"
  exit 1
fi
if [ ${#failed[@]} -gt 0 ]; then
  for f in "${failed[@]}"; do echo "::error title=LaTeX build failed::$f (expand its log group above)"; done
  exit 1
fi
