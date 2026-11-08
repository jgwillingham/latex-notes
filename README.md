# latex-notes

LaTeX sources for my notes. On every push to `main`, GitHub Actions compiles each note and
publishes the PDFs at `https://jgwillingham.github.io/latex-notes/<note>.pdf`.
They're listed, with descriptions, at <https://jgwillingham.github.io/notes/>.

## Layout

```
notes/<note>/<file>.tex           # one folder per note; images go in the folder (e.g. img/)
shared/                           # .sty / macro files available to every note
scripts/build.sh                  # compiles all notes into _site/
scripts/manifest.py               # writes _site/manifest.json + index.html
```

Folder names become URLs, so use lowercase-with-underscores (e.g. `notes/berry_phase/`
publishes `berry_phase.pdf`).

## One-time setup

1. Create a **public** GitHub repo named `latex-notes` and push this folder to it.
2. In the repo: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. Push (or run the workflow from the **Actions** tab). The first build takes a few minutes
   while TeX Live downloads.

## Adding or updating a note

1. Add `notes/<note>/<file>.tex` (plus any images; the folder may hold only one .tex file, or name it `main.tex`) and push.
2. In the website repo, add an entry to `_data/notes.yml` with `path: <note>` (the folder name).

Edits to an existing note only need step 1: the site picks up the new PDF and its updated date.

If any note fails to compile, nothing is deployed and the last good PDFs stay live. The
failing note is listed at the bottom of the workflow log.

## Keeping the repo small

PDFs are build output and are git-ignored, so rebuilding never grows the repo. Only the
images you commit stay in history, so:

- prefer TikZ/pgfplots, or commit the script that generates a plot rather than the plot,
- shrink raster images (~1500px on the long side) before the first commit.

## Building locally

`bash scripts/build.sh` compiles everything into `_site/`. It needs `latexmk`. On Windows
with MiKTeX, `latexmk` also needs Perl (e.g. Strawberry Perl).

To build a single note in an editor such as VS Code + LaTeX Workshop, add `shared/` to the
`TEXINPUTS` environment variable, or copy what you need from `shared/` while drafting.
