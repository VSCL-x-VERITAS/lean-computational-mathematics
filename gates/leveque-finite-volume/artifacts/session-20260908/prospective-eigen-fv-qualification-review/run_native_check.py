"""One native, read-only Lean qualification check; outputs stay in this folder."""
from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
assert os.name == "nt"
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
out = HERE / "native01-output.txt"
receipt = HERE / "native01-exit.json"
assert not out.exists() and not receipt.exists()
check = HERE / "Checks.lean"
lake = shutil.which("lake")
assert lake
sources = [ROOT / "lean-toolchain", ROOT / "lake-manifest.json", check]
imports = re.findall(r"^import (\S+)$", check.read_text(encoding="utf-8"), re.M)
for module in imports:
    relative = Path(*module.split("."))
    if module.startswith("Mathlib."):
        owner = ROOT / ".lake/packages/mathlib"
    else:
        owner = ROOT
    sources.extend([owner / relative.with_suffix(".lean"),
                    owner / ".lake/build/lib/lean" / relative.with_suffix(".olean")])
inputs = [{"path": str(path), "sha256": sha(path)} for path in sources]
head = subprocess.check_output(["git", "-c", "core.longpaths=true", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
argv = ["lake", "env", "lean", check.relative_to(ROOT).as_posix()]
start = time.monotonic()
with out.open("xb") as output:
    result = subprocess.run([lake, *argv[1:]], cwd=ROOT, stdout=output, stderr=subprocess.STDOUT)
changed = [item["path"] for item in inputs if sha(Path(item["path"])) != item["sha256"]]
record = {"kind": "native-qualification-check-only", "argv": argv, "native_lake": lake,
          "exit_code": result.returncode, "input_commit": head,
          "elapsed_ms": round((time.monotonic() - start) * 1000),
          "output_sha256": sha(out), "inputs": inputs,
          "changed_inputs": changed, "source_acceptance": False,
          "scope": "Checks existing declarations, definitions, instances and direct applications; no build or audit acceptance."}
receipt.write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8")
print(json.dumps({k: v for k, v in record.items() if k != "inputs"}, indent=2))
raise SystemExit(result.returncode or bool(changed))
