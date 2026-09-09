"""Native lake-environment child with explicit overlay-only Lean outputs."""
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

R = Path(r"C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics")
D = R / "gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908"
P = D / "dim-five-owner-overlay"
O = P / "overlay"
LIB = O / "lib"
LAKE = Path(r"C:\Users\qed_s\.elan\bin\lake.exe")


def native(path):
    text = os.path.abspath(path)
    return text if text.startswith("\\\\?\\") else "\\\\?\\" + text


def raw(path):
    with open(native(path), "rb") as stream:
        return stream.read()


def ref(path):
    data = raw(path)
    try:
        logical = Path(path).relative_to(R).as_posix()
    except ValueError:
        logical = str(path)
    return {"path": logical, "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}


def read(path):
    return json.loads(raw(path))


def create(path, data):
    os.makedirs(native(Path(path).parent), exist_ok=True)
    if not isinstance(data, bytes):
        data = (json.dumps(data, indent=2, ensure_ascii=False) + "\n").encode()
    with open(native(path), "xb") as stream:
        stream.write(data)
    return ref(path)


def capture(label, command, cwd, env=None):
    dest = P / "runs" / label
    os.makedirs(native(dest), exist_ok=False)
    start = datetime.now(timezone.utc).isoformat()
    clock = time.monotonic()
    print(json.dumps({"start": label, "command": command}), flush=True)
    with open(native(dest / "output.txt"), "xb") as out, open(native(dest / "stderr.txt"), "xb") as err:
        proc = subprocess.run(command, cwd=cwd, env=env, stdout=out, stderr=err)
    receipt = {"command": command, "cwd": str(cwd), "started_at_utc": start,
               "completed_at_utc": datetime.now(timezone.utc).isoformat(),
               "elapsed_seconds": time.monotonic() - clock, "exit_code": proc.returncode,
               "stdout": ref(dest / "output.txt"), "stderr": ref(dest / "stderr.txt")}
    receipt_ref = create(dest / "receipt.json", receipt)
    print(json.dumps({"completed": label, "exit_code": proc.returncode,
                      "elapsed_seconds": receipt["elapsed_seconds"], "receipt": receipt_ref}), flush=True)
    return receipt


def require_success(receipt):
    if receipt["exit_code"] != 0:
        for key in ("stdout", "stderr"):
            path = R / receipt[key]["path"]
            print(raw(path).decode("utf-8", errors="replace")[-12000:], flush=True)
        raise SystemExit(receipt["exit_code"])


def unchanged(plan):
    for item in plan["all_read_inputs"]:
        assert ref(R / item["path"])["sha256"] == item["sha256"], ("input changed", item["path"])


if "--child" not in sys.argv:
    result = capture("lake-launch", [str(LAKE), "env", sys.executable, "-X", "utf8", "-B", str(P / "run_overlay.py"), "--child"], R)
    require_success(result)
    raise SystemExit(0)

plan = read(P / "plan.json")
unchanged(plan)
assert not LIB.exists(), "fresh overlay output directory required"
os.makedirs(native(LIB))
inherited = os.environ.get("LEAN_PATH", "")
assert inherited, "lake env did not supply LEAN_PATH"
inherited_entries = [str((R / entry).resolve()) if not Path(entry).is_absolute() else entry
                     for entry in inherited.split(os.pathsep) if entry]
assert any(str(R / ".lake/build/lib/lean").casefold() == str(Path(entry)).casefold()
           for entry in inherited_entries), inherited_entries
env = os.environ.copy()
env["LEAN_PATH"] = os.pathsep.join([str(LIB)] + inherited_entries)
lean = shutil.which("lean")
assert lean, "no native Lean selected by lake env"
create(P / "environment.json", {"child_of": "lake env native Python", "lean_executable": ref(Path(lean)),
       "inherited_LEAN_PATH": inherited, "effective_LEAN_PATH": env["LEAN_PATH"],
       "source_root": str(O), "output_root": str(LIB), "compiled_source_root": str(R / ".lake/build/lib/lean"),
       "environment_dump_scope": "LEAN_PATH only; no other environment variables captured"})
require_success(capture("lean-version", [lean, "--version"], O, env))
owners = {item["module"]: item for item in plan["owners"]}
affected = set(plan["affected_modules_topological"])
completed = set()
resolved_deps = []


def dependencies(label, relative_source):
    rec = capture(label + "-deps", [lean, "-R", str(O), "--deps", relative_source], O, env)
    require_success(rec)
    paths = []
    for line in raw(R / rec["stdout"]["path"]).decode("utf-8").splitlines():
        if not line.strip():
            continue
        path = Path(line.strip())
        if not path.is_absolute():
            path = O / path
        assert str(path).endswith(".olean"), ("unexpected dependency output", line)
        item = ref(path)
        paths.append(item)
        for mod in affected:
            suffix = mod.replace(".", "/") + ".olean"
            if path.as_posix().endswith(suffix):
                assert mod in completed, ("affected import not freshly built", mod)
                assert path.resolve() == (LIB / suffix).resolve(), ("stale affected import", mod, str(path))
    assert paths, (label, "empty dependency output")
    resolved_deps.append({"label": label, "dependencies": paths, "receipt": rec})


for index, mod in enumerate(plan["affected_modules_topological"], 1):
    source = mod.replace(".", "/") + ".lean"
    label = f"module-{index:02}-{mod.rsplit('.', 1)[1]}"
    dependencies(label, source)
    output = LIB / (mod.replace(".", "/") + ".olean")
    info = LIB / (mod.replace(".", "/") + ".ilean")
    os.makedirs(native(output.parent), exist_ok=True)
    assert not os.path.exists(native(output))
    result = capture(label, [lean, "-R", str(O), source, "-o", str(output), "-i", str(info)], O, env)
    require_success(result)
    assert os.path.isfile(native(output)), mod
    completed.add(mod)
    unchanged(plan)

for name in ["IsolationProbe.lean", "SourceJoint.lean", "CanonicalChecks.lean"]:
    label = name.removesuffix(".lean")
    dependencies(label, name)
    result = capture(label, [lean, "-R", str(O), name, "-o", str(LIB / (label + ".olean")),
                             "-i", str(LIB / (label + ".ilean"))], O, env)
    require_success(result)
    unchanged(plan)

closure_source = b'''import Lean
import SourceJoint
import CanonicalChecks
run_cmd do
  for moduleName in (\xe2\x86\x90 Lean.getEnv).header.moduleNames do
    let path \xe2\x86\x90 Lean.findOLean moduleName
    liftIO <| IO.println s!"COMPILED_IMPORT {moduleName} {path}"
'''
create(O / "ImportClosureProbe.lean", closure_source)
result = capture("ImportClosureProbe", [lean, "-R", str(O), "ImportClosureProbe.lean"], O, env)
require_success(result)
compiled_imports = []
for line in raw(R / result["stdout"]["path"]).decode("utf-8").splitlines():
    if not line.startswith("COMPILED_IMPORT "):
        continue
    _, mod, location = line.split(" ", 2)
    path = Path(location)
    if not path.is_absolute():
        path = O / path
    if mod in affected:
        assert path.resolve() == (LIB / (mod.replace(".", "/") + ".olean")).resolve(), mod
    compiled_imports.append({"module": mod, "file": ref(path), "overlay": path.is_relative_to(LIB)})
assert affected <= {x["module"] for x in compiled_imports}
unchanged(plan)
create(P / "dependency-resolutions.json", {"schema": 1, "direct": resolved_deps, "full_compiled_imports": compiled_imports})
create(P / "completion.json", {"schema": 1, "status": "OVERLAY_NATIVE_REPLAY_COMPLETE", "source_acceptance": False,
       "affected_modules_built": sorted(completed), "full_compiled_imports": len(compiled_imports),
       "production_sources_and_captured_compiled_outputs_unchanged": True,
       "overlay_only": True, "canonical_placement_verified": False})
print(json.dumps({"status": "OVERLAY_NATIVE_REPLAY_COMPLETE", "affected_modules": len(completed), "full_compiled_imports": len(compiled_imports)}), flush=True)
