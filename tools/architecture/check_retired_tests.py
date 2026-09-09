#!/usr/bin/env python3
"""Verify archived duplicate import probes and their live isolated replacements."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import tempfile
import zipfile
from pathlib import Path, PurePosixPath


REPOSITORY = Path(__file__).resolve().parents[2]
DEFAULT_MANIFEST = Path("docs/architecture/retired-tests/2026-09-09/manifest.json")
IMPORT = re.compile(r"import\s+([A-Za-z_][A-Za-z0-9_.]*)\s*")
# The pinned Lean module grammar accepts one module identifier per import;
# whitespace after modifiers, `import`, and optional `all` can include newlines.
IMPORT_COMMAND = re.compile(
    r"(?:(?:public|private|meta)\s+)*import\s+"
    r"(?:all\s+)?([A-Za-z_][A-Za-z0-9_'.]*)"
)


def git_blob(data: bytes) -> str:
    return hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()


def without_comments(text: str, *, mask_strings: bool = False) -> str:
    """Mask nested comments and optionally literals, preserving line positions."""
    result: list[str] = []
    depth = 0
    index = 0
    while index < len(text):
        pair = text[index : index + 2]
        if depth and pair == "/-":
            depth += 1
            result.extend("  ")
            index += 2
        elif depth and pair == "-/":
            depth -= 1
            result.extend("  ")
            index += 2
        elif depth:
            result.append("\n" if text[index] == "\n" else " ")
            index += 1
        elif pair == "/-":
            depth = 1
            result.extend("  ")
            index += 2
        elif pair == "--":
            end = text.find("\n", index)
            if end == -1:
                end = len(text)
            result.extend(" " * (end - index))
            index = end
        else:
            # A quote in a character literal is not a string delimiter. Primes
            # in Lean identifiers are otherwise ordinary characters.
            character = re.match(r"'(?:\\.|[^\\'\n])'", text[index:]) if text[index] == "'" else None
            raw = re.match(r'r(#+)"', text[index:]) if text[index] == "r" else None
            if character:
                literal = character.group()
                result.extend(" " * len(literal) if mask_strings else literal)
                index += len(literal)
                continue
            if raw:
                delimiter = '"' + raw.group(1)
                end = text.find(delimiter, index + len(raw.group()))
                if end < 0:
                    raise ValueError("unterminated Lean raw string")
                end += len(delimiter)
                literal = text[index:end]
                result.extend(
                    "".join("\n" if char == "\n" else " " for char in literal)
                    if mask_strings else literal
                )
                index = end
                continue
            if text[index] == '"':
                end = index + 1
                while end < len(text):
                    if text[end] == "\\":
                        end += 2
                    elif text[end] == '"':
                        end += 1
                        break
                    else:
                        end += 1
                else:
                    raise ValueError("unterminated Lean string")
                literal = text[index:end]
                result.extend(
                    "".join("\n" if char == "\n" else " " for char in literal)
                    if mask_strings else literal
                )
                index = end
                continue
            result.append(text[index])
            index += 1
    if depth:
        raise ValueError("unterminated Lean block comment")
    return "".join(result)


def imported_modules(text: str) -> list[str]:
    """Read the module header, including imports sharing a line or spanning lines."""
    code = without_comments(text, mask_strings=True)
    cursor = 0

    def skip_space() -> None:
        nonlocal cursor
        while cursor < len(code) and code[cursor].isspace():
            cursor += 1

    skip_space()
    for keyword in ("module", "prelude"):
        match = re.compile(keyword + r"(?=\s|$)").match(code, cursor)
        if match:
            cursor = match.end()
            skip_space()
    modules = []
    while match := IMPORT_COMMAND.match(code, cursor):
        modules.append(match.group(1))
        cursor = match.end()
        skip_space()
    return modules


def isolated_import(data: bytes) -> str:
    code = without_comments(data.decode("utf-8-sig")).strip()
    match = IMPORT.fullmatch(code)
    if match is None:
        raise ValueError("probe must contain exactly one import and comments only")
    return match.group(1)


def safe_relative(value: str) -> Path:
    path = PurePosixPath(value)
    if path.is_absolute() or ".." in path.parts or "\\" in value or ":" in value:
        raise ValueError(f"unsafe archive path: {value}")
    if not value.startswith("NumStabilityTest/") or path.suffix != ".lean":
        raise ValueError(f"not a test source path: {value}")
    return Path(*path.parts)


def historical_sources(repository: Path, commit: str, paths: list[str]) -> dict[str, bytes]:
    """Read exact historical blobs in one Git process, without a checkout."""
    paths = sorted(set(paths))
    requests = "".join(f"{commit}:{path}\n" for path in paths).encode()
    output = subprocess.check_output(
        ["git", "cat-file", "--batch"], input=requests, cwd=repository
    )
    sources = {}
    offset = 0
    for path in paths:
        end = output.index(b"\n", offset)
        header = output[offset:end].split()
        if len(header) != 3 or header[1] != b"blob":
            raise ValueError(f"missing historical source: {commit}:{path}")
        size = int(header[2])
        sources[path] = output[end + 1 : end + 1 + size]
        offset = end + size + 2
    if offset != len(output):
        raise ValueError("unexpected trailing historical Git output")
    return sources


def verify(repository: Path, manifest_path: Path, verify_history: bool = False) -> dict:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest["schema_version"] != 1:
        raise ValueError("unsupported retired-test manifest schema")
    archive = manifest_path.parent / manifest["archive"]
    if archive.parent.resolve() != manifest_path.parent.resolve():
        raise ValueError("archive must be adjacent to its manifest")
    if hashlib.sha256(archive.read_bytes()).hexdigest() != manifest["archive_sha256"]:
        raise ValueError("archive SHA-256 mismatch")
    entries = manifest["entries"]
    paths = [entry["path"] for entry in entries]
    if paths != sorted(set(paths)) or len(paths) != manifest["retired_probe_count"]:
        raise ValueError("manifest paths must be sorted, unique and match the count")
    retired = set(paths)
    survivors: dict[str, str] = {}
    historical = (
        historical_sources(
            repository,
            manifest["base_commit"],
            paths + [entry["retained_probe"] for entry in entries],
        )
        if verify_history
        else {}
    )
    with zipfile.ZipFile(archive) as bundle:
        if bundle.namelist() != paths:
            raise ValueError("archive members differ from manifest paths")
        for entry in entries:
            relative = safe_relative(entry["path"])
            if (repository / relative).exists():
                raise ValueError(f"retired probe is still live: {relative}")
            data = bundle.read(entry["path"])
            if len(data) != entry["bytes"]:
                raise ValueError(f"archive size mismatch: {relative}")
            if hashlib.sha256(data).hexdigest() != entry["sha256"]:
                raise ValueError(f"archive source SHA-256 mismatch: {relative}")
            if git_blob(data) != entry["git_blob"]:
                raise ValueError(f"archive source Git blob mismatch: {relative}")
            imported = isolated_import(data)
            if imported != entry["isolated_import"]:
                raise ValueError(f"archive import mismatch: {relative}")
            survivor = entry["retained_probe"]
            if survivor in retired:
                raise ValueError(f"retired replacement: {survivor}")
            survivor_data = (repository / safe_relative(survivor)).read_bytes()
            if isolated_import(survivor_data) != imported:
                raise ValueError(f"replacement is not the same isolated import: {survivor}")
            if survivors.setdefault(imported, survivor) != survivor:
                raise ValueError(f"inconsistent survivor for {imported}")
            if verify_history:
                if historical[entry["path"]] != data:
                    raise ValueError(f"archive differs from base Git tree: {relative}")
                original_survivor = historical[survivor]
                if (
                    git_blob(original_survivor) != entry["retained_probe_git_blob"]
                    or hashlib.sha256(original_survivor).hexdigest()
                    != entry["retained_probe_sha256"]
                    or isolated_import(original_survivor) != imported
                ):
                    raise ValueError(f"retained probe history mismatch: {survivor}")
    if len(survivors) != manifest["isolated_import_count"]:
        raise ValueError("isolated-import count mismatch")
    retired_modules = {path[:-5].replace("/", ".") for path in retired}
    live_sources = [repository / "NumStabilityTest.lean"]
    live_sources.extend((repository / "NumStabilityTest").rglob("*.lean"))
    test_imports: dict[str, list[str]] = {}
    for source in live_sources:
        imports = imported_modules(source.read_text(encoding="utf-8-sig"))
        source_module = ".".join(source.relative_to(repository).with_suffix("").parts)
        test_imports[source_module] = imports
        for module in imports:
            if module in retired_modules:
                raise ValueError(f"live import of retired test in {source}: {module}")
    reachable: set[str] = set()
    pending = ["NumStabilityTest"]
    while pending:
        module = pending.pop()
        if module in reachable:
            continue
        reachable.add(module)
        pending.extend(test_imports.get(module, []))
    for survivor in survivors.values():
        if survivor[:-5].replace("/", ".") not in reachable:
            raise ValueError(f"retained probe unreachable from NumStabilityTest: {survivor}")
    return {
        "retired_probes": len(entries),
        "isolated_imports_preserved": len(survivors),
        "live_test_sources": len(live_sources),
        "reachable_retained_probes": len(survivors),
        "history_verified": verify_history,
    }


def self_test() -> None:
    imported = "Mathlib.Data.Nat.Basic"
    original = f"/- outer /- nested -/ comment -/\nimport {imported}\n".encode()
    if isolated_import(original) != imported:
        raise AssertionError("nested comments changed the isolated import")
    for invalid in (
        b"import A\nimport B\n",
        b"import A B\n",
        b'import A\n#check Nat\n',
        b'import A\n"extra literal"\n',
        b"import A /- unclosed",
    ):
        try:
            isolated_import(invalid)
        except ValueError:
            pass
        else:
            raise AssertionError(f"accepted a non-isolated probe: {invalid!r}")
    with tempfile.TemporaryDirectory(prefix="retired-tests-self-test-") as folder:
        repository = Path(folder)
        tests = repository / "NumStabilityTest"
        tests.mkdir()
        retained = tests / "Kept.lean"
        retained.write_bytes(f"import {imported}\n".encode())
        root = repository / "NumStabilityTest.lean"
        root.write_text("import NumStabilityTest.Kept\n", encoding="utf-8")
        archive = repository / "import-probes.zip"
        with zipfile.ZipFile(archive, "w") as bundle:
            bundle.writestr("NumStabilityTest/Retired.lean", original)
        manifest = {
            "schema_version": 1,
            "archive": archive.name,
            "archive_sha256": hashlib.sha256(archive.read_bytes()).hexdigest(),
            "retired_probe_count": 1,
            "isolated_import_count": 1,
            "entries": [{
                "path": "NumStabilityTest/Retired.lean",
                "bytes": len(original),
                "sha256": hashlib.sha256(original).hexdigest(),
                "git_blob": git_blob(original),
                "retained_probe": "NumStabilityTest/Kept.lean",
                "isolated_import": imported,
            }],
        }
        manifest_path = repository / "manifest.json"

        def write_manifest() -> None:
            manifest_path.write_text(json.dumps(manifest), encoding="utf-8")

        def reject(expected: str) -> None:
            try:
                verify(repository, manifest_path)
            except ValueError as error:
                if expected not in str(error):
                    raise AssertionError(f"wrong rejection: {error}") from error
            else:
                raise AssertionError(f"failed to reject {expected}")

        write_manifest()
        verify(repository, manifest_path)
        root.write_text("/- The isolated replacement still exists, but is not built. -/\n", encoding="utf-8")
        reject("retained probe unreachable from NumStabilityTest")
        root.write_text("import NumStabilityTest.Kept\n", encoding="utf-8")
        intact_archive = archive.read_bytes()
        archive.write_bytes(intact_archive + b"corruption")
        reject("archive SHA-256 mismatch")
        archive.write_bytes(intact_archive)
        manifest["entries"][0]["sha256"] = "0" * 64
        write_manifest()
        reject("archive source SHA-256 mismatch")
        manifest["entries"][0]["sha256"] = hashlib.sha256(original).hexdigest()
        write_manifest()
        retained.write_text("import Mathlib.Data.Int.Basic\n", encoding="utf-8")
        reject("replacement is not the same isolated import")
        retained.write_bytes(f"import {imported}\n".encode())
        for command in (
            "import NumStabilityTest.Retired\n",
            "  public meta import NumStabilityTest.Retired\n",
            "\tprivate import NumStabilityTest.Retired\n",
            "import\n  NumStabilityTest.Retired\n",
            "public\n meta /- comment -/\n import\n NumStabilityTest.Retired\n",
            "import\n all\n NumStabilityTest.Retired\n",
            "import NumStabilityTest.Kept import NumStabilityTest.Retired\n",
        ):
            root.write_text(command, encoding="utf-8")
            reject("live import of retired test")
        root.write_text("import\n /- comment -/ NumStabilityTest.Kept\n", encoding="utf-8")
        verify(repository, manifest_path)
        root.write_text("public\n meta\n import\n NumStabilityTest.Kept\n", encoding="utf-8")
        verify(repository, manifest_path)
        root.write_text("module prelude import Init public meta import NumStabilityTest.Kept\n", encoding="utf-8")
        verify(repository, manifest_path)
        root.write_text(
            'import NumStabilityTest.Kept\n'
            '/- outer /- inner -/\nimport NumStabilityTest.Retired\n-/\n'
            '-- import NumStabilityTest.Retired\n'
            'def text := "escaped quote \\" and /-\n'
            'import NumStabilityTest.Retired\n"\n'
            'def raw := r##"embedded " quote\n'
            'import NumStabilityTest.Retired\n"##\n'
            "def quote : Char := '\"'\n",
            encoding="utf-8",
        )
        verify(repository, manifest_path)
    print("retired-test self-test passed: archive/hash corruption, isolated replacements, "
          "orphaned replacements, dangling imports, modifiers, comments, literals, "
          "and multi-import rejection")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=REPOSITORY)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--verify-history", action="store_true")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        self_test()
        return 0
    manifest = args.manifest if args.manifest.is_absolute() else args.root / args.manifest
    result = verify(args.root.resolve(), manifest, args.verify_history)
    print("retired import probes verified: " + json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
