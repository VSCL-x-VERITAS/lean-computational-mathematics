"""Native Lean capture for these isolated scratch artifacts only; no operational writes."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import subprocess
import sys
import time


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    here = Path(__file__).resolve().parent
    repo = here.parents[4]
    if len(sys.argv) != 3 or sys.argv[1] not in {"Capstones.lean", "MeasureSupplement.lean"}:
        raise SystemExit("usage: run_native_checks.py {Capstones.lean|MeasureSupplement.lean} LABEL")
    source = here / sys.argv[1]
    label = sys.argv[2]
    if not label or any(c not in "abcdefghijklmnopqrstuvwxyz0123456789-" for c in label):
        raise SystemExit("label must contain only lowercase letters, digits and hyphens")
    output = here / f"{label}.native.txt"
    receipt = here / f"{label}.receipt.json"
    compiled = here / f"{label}.olean"
    if output.exists() or receipt.exists() or compiled.exists():
        raise SystemExit("capture outputs already exist; choose a fresh label")
    lake = shutil.which("lake")
    if lake is None:
        raise SystemExit("native lake unavailable")
    command = [lake, "env", "lean", "-o", str(compiled), str(source)]
    before = sha256(source)
    started = datetime.datetime.now(datetime.timezone.utc).isoformat()
    t0 = time.monotonic()
    with output.open("xb") as out:
        process = subprocess.run(command, cwd=repo, stdout=out, stderr=subprocess.STDOUT)
    after = sha256(source)
    version = subprocess.run([lake, "env", "lean", "--version"], cwd=repo,
                             capture_output=True, text=True, check=True).stdout.strip()
    commit = subprocess.run(["git", "-c", "core.longpaths=true", "rev-parse", "HEAD"],
                            cwd=repo, capture_output=True, text=True, check=True).stdout.strip()
    log = output.read_text(encoding="utf-8", errors="replace")
    payload = {
        "artifact_kind": "scratch-native-lean-capture", "started_utc": started,
        "elapsed_seconds": round(time.monotonic() - t0, 3),
        "command": command, "cwd": str(repo), "exit_code": process.returncode,
        "source": source.name, "source_sha256_before": before, "source_sha256_after": after,
        "output": output.name, "output_sha256": sha256(output), "lean_version": version,
        "compiled": compiled.name if compiled.is_file() else None,
        "compiled_sha256": sha256(compiled) if compiled.is_file() else None,
        "observed_repo_head_after_run": commit,
        "lean_toolchain_sha256": sha256(repo / "lean-toolchain"),
        "lake_manifest_sha256": sha256(repo / "lake-manifest.json"),
        "axiom_report_lines": [line for line in log.splitlines() if "depends on axioms:" in line or "does not depend on any axioms" in line],
        "axiom_reports": [{"declaration": name, "axioms": re.findall(r"[A-Za-z_][A-Za-z0-9_.]*", body)}
                          for name, body in re.findall(r"'([^']+)' depends on axioms: \[([^]]*)\]", log)],
        "contains_sorryAx": "sorryAx" in log,
        "source_unchanged": before == after,
        "source_interpretations": "unanswered; no adoption or verdict",
    }
    with receipt.open("x", encoding="utf-8", newline="\n") as out:
        json.dump(payload, out, indent=2, ensure_ascii=False)
        out.write("\n")
    print(json.dumps({"receipt": str(receipt), "exit_code": process.returncode,
                      "source_unchanged": before == after, "contains_sorryAx": "sorryAx" in log}))
    raise SystemExit(process.returncode or (1 if before != after or "sorryAx" in log else 0))


if __name__ == "__main__":
    main()
