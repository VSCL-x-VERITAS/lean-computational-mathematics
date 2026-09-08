"""Inspect the coordinator's current modules after the unpublished path correction."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent
R=S.parents[3]
old=json.loads((S/"production-declaration-inputs.json").read_text())
move=json.loads((S/"production-rename-receipt.json").read_text())
mapping={f["old"]:f["path"] for f in move["files"]}
files=[mapping[f["path"]] for f in old["files"]]
records=[]
decls=[]
for f in sorted(files):
 data=(R/f).read_bytes()
 ns=re.search(r"^namespace ([\w.]+)$",data.decode(),re.M).group(1)
 names=re.findall(r"^(?:noncomputable )?(?:def|abbrev|structure|theorem) ([\w.]+)",data.decode(),re.M)
 full=[ns+"."+name for name in names]
 decls.extend(full)
 records.append({"path":f,"sha256":hashlib.sha256(data).hexdigest(),"declarations":full})
lines=["import "+f[:-5].replace("/",".") for f in sorted(files)]
lines+=[""]
for name in decls:lines.extend(["#check "+name,"#print axioms "+name])
payload=("\n".join(lines)+"\n").encode()
(S/"production-postrename-declarations.lean").write_bytes(payload)
(S/"production-postrename-inputs.json").write_text(json.dumps({
 "schema":1,"files":records,"declarations":decls,"count":len(decls),
 "check_file_sha256":hashlib.sha256(payload).hexdigest(),
 "prior_input":"production-declaration-inputs.json",
 "rename_receipt_sha256":hashlib.sha256((S/"production-rename-receipt.json").read_bytes()).hexdigest(),
 "additional_change":"DiscontinuityWitnesses contains an additional combined witness theorem."},indent=2)+"\n",encoding="utf-8")
ps=["$ErrorActionPreference = 'Stop'",
 "$directory = 'gates/leveque-finite-volume/artifacts/session-20260908'",
 "& lake build "+" ".join(f[:-5].replace("/",".") for f in sorted(files))+" 2>&1 | Tee-Object -FilePath \"$directory/production-postrename-build-output.txt\"",
 "$buildExit = $LASTEXITCODE",
 "[ordered]@{command='lake build (24 modules enumerated in production-postrename-inputs.json)';exit_code=$buildExit} | ConvertTo-Json | Set-Content -LiteralPath \"$directory/production-postrename-build-exit.json\" -Encoding utf8",
 "if ($buildExit -ne 0) { exit $buildExit }",
 "& lake env lean \"$directory/production-postrename-declarations.lean\" 2>&1 | Tee-Object -FilePath \"$directory/production-postrename-declarations-output.txt\"",
 "$checkExit = $LASTEXITCODE",
 "[ordered]@{command='lake env lean gates/leveque-finite-volume/artifacts/session-20260908/production-postrename-declarations.lean';exit_code=$checkExit} | ConvertTo-Json | Set-Content -LiteralPath \"$directory/production-postrename-declarations-exit.json\" -Encoding utf8",
 "exit $checkExit"]
(S/"run-production-postrename-checks.ps1").write_text("\n".join(ps)+"\n",encoding="utf-8")
print(json.dumps({"files":len(files),"declarations":len(decls)}))

