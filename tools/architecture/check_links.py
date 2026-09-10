#!/usr/bin/env python3
"""Enforce that relative links in tracked Markdown resolve to tracked files.

A document that points at a path which no longer exists is worse than one that
says nothing: it asserts a location. Every removal in this repository has left
such assertions behind - the 2026-09 retirements broke the contributor
instructions, six compatibility links, the library lookup's module links and
the README's layout - and a search for the deleted path finds only the links,
never the prose. This check catches the linkable half automatically.

The rule: for every tracked `*.md`, every inline link or image target that is
not a URL, a mail address or a pure fragment must resolve, relative to the
containing file's directory, to a path that exists. A `#fragment` suffix is
stripped before resolving; fragment targets themselves are not checked.

ARCHIVED_PREFIXES are exempt, and report a count rather than failing. Those
trees hold the narrative of completed campaigns whose machine data was retired
on 2026-09-10: the prose is kept so that links from live documents still
resolve, and its own references to sibling data are known to dangle. Each such
directory carries an `ARCHIVED-DATA.md` note saying so. Exempting them is what
lets the rule be exactly zero everywhere else, which is the property worth
enforcing; a ratchet that tolerated a growing number would not have caught any
of the breakages above.

Usage:
  python tools/architecture/check_links.py [--self-test]

Exit status is 1 on any unexempt dangling link, or on a self-test failure.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

ARCHIVED_PREFIXES = (
    "docs/architecture/phases/",
    "docs/architecture/baselines/",
    "docs/migrations/",
)

# [text](target) and ![alt](target), with an optional "title" and optional <>.
LINK_RE = re.compile(r"!?\[[^\]]*\]\(\s*<?([^)>\s]+)>?(?:\s+\"[^\"]*\")?\s*\)")
SKIP_PREFIXES = ("http://", "https://", "mailto:", "#", "tel:", "data:")


def tracked_markdown() -> list[str]:
    out = subprocess.run(
        ["git", "ls-files", "-z", "*.md"],
        cwd=ROOT, check=True, capture_output=True, text=True, encoding="utf-8",
    ).stdout
    return sorted(p for p in out.split("\0") if p)


def dangling_in(path: str, text: str, root: Path) -> list[tuple[int, str]]:
    """Return (line number, target) for each unresolvable relative target."""
    base = (root / path).parent
    problems: list[tuple[int, str]] = []
    for number, line in enumerate(text.split("\n"), start=1):
        for target in LINK_RE.findall(line):
            if target.startswith(SKIP_PREFIXES):
                continue
            resolved = base / target.split("#", 1)[0]
            if str(resolved) == str(base):
                continue  # a bare fragment on this file
            if not resolved.exists():
                problems.append((number, target))
    return problems


def scan(root: Path, paths: list[str]) -> tuple[list[str], int]:
    failures: list[str] = []
    archived = 0
    for path in paths:
        try:
            text = (root / path).read_text(encoding="utf-8", errors="replace")
        except OSError as error:
            failures.append(f"cannot read {path}: {error}")
            continue
        problems = dangling_in(path, text, root)
        if not problems:
            continue
        if path.startswith(ARCHIVED_PREFIXES):
            archived += len(problems)
            continue
        for number, target in problems:
            failures.append(f"{path}:{number}: link target does not exist: {target}")
    return failures, archived


def self_test() -> list[str]:
    """Exercise the rule against synthetic fixtures."""
    failures: list[str] = []
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        (root / "docs" / "architecture" / "phases").mkdir(parents=True)
        (root / "docs" / "nested").mkdir(parents=True)
        (root / "target.md").write_text("# target\n", encoding="utf-8")
        (root / "docs" / "nested" / "leaf.md").write_text("# leaf\n", encoding="utf-8")

        cases = {
            "good.md": "[a](target.md) [b](docs/nested/leaf.md#x) [c](https://example.invalid/x)\n"
                       "![i](target.md) [d](#local)\n",
            "bad.md": "[a](missing.md)\nline two\n[b](docs/nowhere/leaf.md)\n",
            "docs/architecture/phases/archived.md": "[a](gone.tsv)\n",
        }
        for name, body in cases.items():
            (root / name).write_text(body, encoding="utf-8")

        found, archived = scan(root, sorted(cases))

        if any(f.startswith("good.md") for f in found):
            failures.append("resolvable links, images and fragments must not be reported")
        bad = [f for f in found if f.startswith("bad.md")]
        if len(bad) != 2:
            failures.append(f"expected 2 dangling links in bad.md, reported {len(bad)}")
        if bad and not bad[0].startswith("bad.md:1:"):
            failures.append(f"line number not reported: {bad[0]}")
        if any("archived.md" in f for f in found):
            failures.append("archived-tree links must be counted, not reported as failures")
        if archived != 1:
            failures.append(f"expected 1 archived dangling link, counted {archived}")

        # a link relative to the containing file's own directory, not the root
        (root / "docs" / "nested" / "sibling.md").write_text("[x](leaf.md)\n", encoding="utf-8")
        found2, _ = scan(root, ["docs/nested/sibling.md"])
        if found2:
            failures.append(f"sibling-relative link wrongly reported: {found2}")
    return failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--self-test", action="store_true",
                        help="exercise the contract against synthetic fixtures")
    args = parser.parse_args()

    if args.self_test:
        problems = self_test()
        for problem in problems:
            print(f"error: {problem}")
        if problems:
            return 1
        print("link contract self-test passed: resolvable, dangling, image, "
              "fragment, sibling-relative and archived-tree cases")
        return 0

    paths = tracked_markdown()
    failures, archived = scan(ROOT, paths)
    for failure in failures:
        print(f"error: {failure}")
    if failures:
        print(f"error: {len(failures)} dangling link(s) in tracked Markdown")
        return 1
    print(f"link contract satisfied: {len(paths)} Markdown file(s), no dangling "
          f"relative link outside the archived trees "
          f"({archived} known dangling reference(s) inside them)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
