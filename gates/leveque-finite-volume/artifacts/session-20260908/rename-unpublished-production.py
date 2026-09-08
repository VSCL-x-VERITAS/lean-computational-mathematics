"""Rename only unpublished Chapter 1 additions, preserving every pre-move byte."""
from pathlib import Path
import datetime, hashlib, json, subprocess
S=Path(__file__).resolve().parent
R=S.parents[3].resolve()
snapshot=S/"production-pre-rename-v2"
assert not snapshot.exists(), "append-only snapshot already exists"
core=json.loads((S/"production-declaration-inputs.json").read_text())["files"]
shock=json.loads((S/"shock-production/modules.json").read_text())
files=sorted(set([f["path"] for f in core]+[m.replace(".","/")+".lean" for m in shock]))
prefix="ComputationalMathematics/Analysis/PartialDifferentialEquations/"
mapping={}
for f in files:
    target=f.replace(prefix+"ConservationLaw/",prefix+"ConservationLaws/").replace(
        prefix+"Hyperbolicity/",prefix+"LinearSystems/").replace(
        prefix+"FiniteVolume/RiemannData/Regularity.lean",
        prefix+"FiniteVolume/RiemannDataRegularity.lean")
    mapping[f]=target
tracked=set(subprocess.check_output(["git","-c","core.longpaths=true","ls-files","-z"],cwd=R).decode().split("\0"))
assert not (set(files)&tracked), sorted(set(files)&tracked)
owners=[prefix+"ConservationLaw.lean",prefix+"Hyperbolicity.lean",prefix+"FiniteVolume/RiemannData.lean"]
oldowners={f:hashlib.sha256((R/f).read_bytes()).hexdigest() for f in owners}
for old,new in mapping.items():
    src,dst=(R/old).resolve(),(R/new).resolve()
    assert src.is_relative_to(R) and dst.is_relative_to(R)
    assert src.is_file()
    if src!=dst: assert not dst.exists(), str(dst)
# Full pre-edit snapshot precedes every production mutation.
snapshot.mkdir()
before={}
for f in files:
    data=(R/f).read_bytes()
    dest=snapshot/(hashlib.sha256(data).hexdigest()+".lean")
    dest.write_bytes(data)
    before[f]=hashlib.sha256(data).hexdigest()
for old,new in mapping.items():
    if old==new:continue
    dst=R/new
    dst.parent.mkdir(parents=True,exist_ok=True)
    (R/old).rename(dst)
# Imports alone are rewritten. Bodies, statements, namespace and docstrings stay byte-identical.
module_map={old[:-5].replace("/","."):new[:-5].replace("/",".") for old,new in mapping.items() if old!=new}
records=[]
for old,new in mapping.items():
    p=R/new
    data=p.read_bytes()
    lines=data.splitlines(keepends=True)
    changes=[]
    for i,line in enumerate(lines):
        if not line.startswith(b"import "): continue
        token=line[7:].strip().decode()
        if token in module_map:
            lines[i]=line.replace(token.encode(),module_map[token].encode())
            changes.append({"old":token,"new":module_map[token]})
    result=b"".join(lines)
    p.write_bytes(result)
    records.append({"old":old,"path":new,"before_sha256":before[old],
        "sha256":hashlib.sha256(result).hexdigest(),"imports_changed":changes})
# Remove only verified-empty directories under the three unpublished old families.
for folder in [R/(prefix+"ConservationLaw"),R/(prefix+"Hyperbolicity"),
               R/(prefix+"FiniteVolume/RiemannData")]:
    assert folder.resolve().is_relative_to(R)
    if folder.exists():
        for child in sorted([p for p in folder.rglob("*") if p.is_dir()],key=lambda p:len(p.parts),reverse=True):
            child.rmdir()
        folder.rmdir()
assert oldowners=={f:hashlib.sha256((R/f).read_bytes()).hexdigest() for f in owners}
receipt={"schema":1,"reason":"Avoid declaration-bearing umbrella collisions with existing public owners.",
 "timestamp_utc":datetime.datetime.now(datetime.timezone.utc).isoformat(),"files":records,
 "existing_owners_unchanged":oldowners,"snapshot":"production-pre-rename-v2",
 "snapshot_format":"Flat content-addressed Lean bytes; each file's before_sha256 names its snapshot.",
 "prior_attempt":"production-pre-rename contains an incomplete pre-mutation snapshot; Windows path-length failure occurred before every production mutation.",
 "body_statement_namespace_changes":False}
(S/"production-rename-receipt.json").write_text(json.dumps(receipt,indent=2)+"\n",encoding="utf-8")
print(json.dumps({"files":len(files),"renamed":sum(a!=b for a,b in mapping.items()),
 "imports_changed":sum(len(f["imports_changed"]) for f in records),"receipt":"production-rename-receipt.json"}))
