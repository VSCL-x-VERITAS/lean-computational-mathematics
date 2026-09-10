#!/usr/bin/env python3
"""Compute the referenced-evidence set for the 2026-09 evidence retirement.

Read-only. Writes the sorted reference set to --out and a summary to --report.

A tracked path under gates/ or audits/ is RETAINED when any of these holds:

R1  A gate document names it.  The three gate documents (gates/ch01.json,
    gates/ch02.json, gates/leveque-finite-volume/chapter-01.json) mention
    paths both repository-relative ("gates/...", "audits/...") and relative
    to the gate directory ("artifacts/..."), embedded inside prose strings.
R2  A tracked text file outside gates/ and audits/ names it (docs, ledgers,
    tools, the CI workflow, top-level Markdown).
R3  It belongs to an audit evidence package.  A package is any directory
    holding an audit-task.json.  Packages are the atomic unit of audit
    evidence, so a package's decision, manifest, report, inputs,
    agent_outputs and gate-bindings are retained together.
R4  A retained faithfulness manifest or decision hashes it ("path" fields).
    Those records are integrity statements: removing a file they hash would
    leave a retained package unverifiable.  Applied to a fixpoint.
R5  It sits directly in a gate scaffolding directory (a gate document's own
    directory, or that directory's artifacts/ level, non-recursively).  These
    are the gate's evidence-producing scripts and their evidence JSON, a
    self-consistent chain: finalize-chapter-01-gate.py runs the sibling scan
    scripts and writes the sibling evidence files.

A named directory retains every file beneath it only when it is an evidence
package or below (at most one audit-task.json beneath it).  A directory that
holds many packages is a navigational mention - the README layout table, the
audit-kit glob, a gate scope line - and retains nothing by itself; the files
inside it are retained by their own references or by R3.

Three classes are never retained by any rule:

  faithfulness/orchestration/   raw agent transcripts and rendered source-page
                                images.  Verified: no manifest or decision in
                                the repository hashes a path beneath it.
  faithfulness/history/         superseded rerun snapshots.  The current run of
                                each package is the live evidence; the retired
                                timestamps are indexed instead.
  *.pdf                         third-party source documents.  Audit manifests
                                hash the book PDF as their source input, so the
                                sha256 provenance survives in the manifest, but
                                a public repository should not carry the
                                copyrighted document itself.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path

GATES = (
    "gates/ch01.json",
    "gates/ch02.json",
    "gates/leveque-finite-volume/chapter-01.json",
)
EVIDENCE_ROOTS = ("gates/", "audits/")
NEVER_RETAIN_SUBSTRINGS = ("/faithfulness/orchestration/", "/faithfulness/history/")
NEVER_RETAIN_SUFFIXES = (".pdf",)
TEXT_SUFFIXES = {
    ".md", ".json", ".py", ".yml", ".yaml", ".toml", ".lean", ".txt",
    ".tsv", ".cff", ".ps1", ".c", ".sh",
}
PATH_RE = re.compile(r"(?:gates|audits)/[A-Za-z0-9_.@+\-/]+")
GATE_RELATIVE_RE = re.compile(r"(?<![A-Za-z0-9_./\-])artifacts/[A-Za-z0-9_.@+\-/]+")
HASHED_PATH_RE = re.compile(r'"path":\s*"([^"]+)"')
SCAN_BYTE_LIMIT = 8 * 1024 * 1024


def tracked_files() -> list[str]:
    out = subprocess.run(
        ["git", "ls-files", "-z"], capture_output=True, text=True, encoding="utf-8", check=True
    ).stdout
    return [p for p in out.split("\0") if p]


def read_text(path: str) -> str:
    try:
        handle = Path(path)
        if handle.stat().st_size > SCAN_BYTE_LIMIT:
            return ""
        return handle.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return ""


def never_retained(path: str) -> bool:
    if any(marker in path for marker in NEVER_RETAIN_SUBSTRINGS):
        return True
    return path.lower().endswith(NEVER_RETAIN_SUFFIXES)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", required=True)
    parser.add_argument("--report", required=True)
    args = parser.parse_args()

    tracked_list = tracked_files()
    tracked = set(tracked_list)
    evidence = sorted(p for p in tracked_list if p.startswith(EVIDENCE_ROOTS))

    by_prefix: dict[str, list[str]] = {}
    for path in evidence:
        parts = path.split("/")
        for cut in range(1, len(parts)):
            by_prefix.setdefault("/".join(parts[:cut]), []).append(path)

    package_dirs = sorted(p.rsplit("/", 1)[0] for p in evidence if p.endswith("/audit-task.json"))
    packages_under: dict[str, int] = {}
    for package in package_dirs:
        parts = package.split("/")
        for cut in range(1, len(parts) + 1):
            key = "/".join(parts[:cut])
            packages_under[key] = packages_under.get(key, 0) + 1

    referenced: dict[str, str] = {}
    navigational: set[str] = set()

    def mark(paths: list[str], rule: str) -> None:
        for path in paths:
            if never_retained(path):
                continue
            referenced.setdefault(path, rule)

    def resolve(raw: str) -> list[str]:
        candidate = raw.strip().strip('"').strip("'").rstrip(".,;:)]}").lstrip("./")
        if not candidate:
            return []
        if candidate in tracked:
            return [candidate]
        directory = candidate.rstrip("/")
        subtree = by_prefix.get(directory)
        if not subtree:
            return []
        if packages_under.get(directory, 0) > 1:
            navigational.add(directory)
            return []
        return subtree

    # R1 - gate documents.
    for gate in GATES:
        text = read_text(gate)
        mark([gate], "R1-gate-document")
        for raw in PATH_RE.findall(text):
            mark(resolve(raw), "R1-gate-reference")
        base = gate.rsplit("/", 1)[0]
        for raw in GATE_RELATIVE_RE.findall(text):
            mark(resolve(base + "/" + raw), "R1-gate-reference-relative")

    # R2 - anything outside the evidence trees that names an evidence path.
    for path in tracked_list:
        if path.startswith(EVIDENCE_ROOTS):
            continue
        if Path(path).suffix.lower() not in TEXT_SUFFIXES:
            continue
        text = read_text(path)
        if not text:
            continue
        for raw in PATH_RE.findall(text):
            mark(resolve(raw), "R2-referenced-by:" + path)

    # R3 - audit evidence packages.
    for package in package_dirs:
        mark(by_prefix.get(package, []), "R3-audit-package")

    # R5 - gate scaffolding: files directly in a gate directory or its artifacts/ level.
    for gate in GATES:
        gate_dir = gate.rsplit("/", 1)[0]
        for scaffold in (gate_dir, gate_dir + "/artifacts"):
            depth = scaffold.count("/") + 1
            mark(
                [p for p in by_prefix.get(scaffold, []) if p.count("/") == depth],
                "R5-gate-scaffolding",
            )

    # R4 - fixpoint over integrity records that are themselves retained.
    scanned: set[str] = set()
    while True:
        records = [
            p for p in referenced
            if p.rsplit("/", 1)[-1] in ("manifest.json", "decision.json") and p not in scanned
        ]
        if not records:
            break
        for record in records:
            scanned.add(record)
            for raw in HASHED_PATH_RE.findall(read_text(record)):
                resolved = [p for p in resolve(raw) if p.startswith(EVIDENCE_ROOTS)]
                mark(resolved, "R4-hashed-by-manifest")

    Path(args.out).write_text("\n".join(sorted(referenced)) + "\n", encoding="utf-8")

    rules: dict[str, int] = {}
    for rule in referenced.values():
        key = rule.split(":", 1)[0]
        rules[key] = rules.get(key, 0) + 1
    report = {
        "tracked_files": len(tracked_list),
        "evidence_files": len(evidence),
        "referenced_evidence_files": len(referenced),
        "removable_evidence_files": len(evidence) - len(referenced),
        "by_rule": dict(sorted(rules.items())),
        "integrity_records_scanned": len(scanned),
        "navigational_directory_mentions": sorted(navigational),
        "never_retained_counts": {
            "orchestration": len([p for p in evidence if "/faithfulness/orchestration/" in p]),
            "history": len([p for p in evidence if "/faithfulness/history/" in p]),
            "pdf": sorted(p for p in evidence if p.lower().endswith(".pdf")),
        },
    }
    Path(args.report).write_text(json.dumps(report, indent=1) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=1))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
