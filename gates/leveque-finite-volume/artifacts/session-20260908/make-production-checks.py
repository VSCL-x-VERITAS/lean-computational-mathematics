"""Resolve and inspect each declaration newly placed by the coordinator."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent
R=S.parents[3]
files=[]
for name in ["production-placement-first.json","production-placement-rectangle.json",
             "production-placement-source.json","production-placement-moving-step.json"]:
    files.extend(f["path"] for f in json.loads((S/name).read_text(encoding="utf-8"))["files"])
files += [
 "ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData/Regularity.lean",
 "ComputationalMathematics/Source/LeVeque/Chapter01/DiscontinuityWitnesses.lean"]
records=[]
decls=[]
for f in sorted(set(files)):
    data=(R/f).read_bytes()
    text=data.decode()
    ns=re.search(r"^namespace ([\w.]+)$",text,re.M).group(1)
    names=re.findall(r"^(?:noncomputable )?(?:def|abbrev|structure|theorem) ([\w.]+)",text,re.M)
    full=[ns+"."+name for name in names]
    assert names, f
    decls.extend(full)
    records.append({"path":f,"sha256":hashlib.sha256(data).hexdigest(),"declarations":full})
lines=["import "+f[:-5].replace("/",".") for f in sorted(set(files))]
lines+=[""]
for name in decls:lines.extend(["#check "+name,"#print axioms "+name])
payload=("\n".join(lines)+"\n").encode()
(S/"production-declaration-checks.lean").write_bytes(payload)
(S/"production-declaration-inputs.json").write_text(json.dumps({
 "schema":1,"files":records,"declarations":decls,"count":len(decls),
 "check_file_sha256":hashlib.sha256(payload).hexdigest()},indent=2)+"\n",encoding="utf-8")
print(json.dumps({"files":len(records),"declarations":len(decls),"check_file":"production-declaration-checks.lean"}))

