"""Freeze a combined exact input manifest for the organized 34-module increment."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
records=json.loads((S/"production-postrename-inputs.json").read_text())["files"]
worker=json.loads((S/"shock-production/post-rename-lf/declarations.json").read_text())
for file in json.loads((S/"shock-production/post-rename-lf/files-before-check.json").read_text()):
 records.append({"path":file["path"],"declarations":[d["name"] for d in worker if d["module"]==file["module"]]})
records=sorted(records,key=lambda f:f["path"])
for f in records:f["sha256"]=hashlib.sha256((R/f["path"]).read_bytes()).hexdigest()
names=[d for f in records for d in f["declarations"]]
assert len(records)==34 and len(names)==138 and len(set(names))==138
lines=["import "+f["path"][:-5].replace("/",".") for f in records]+[""]
for name in names:lines.extend(["#check "+name,"#print axioms "+name])
payload=("\n".join(lines)+"\n").encode()
(S/"production-organized-declarations.lean").write_bytes(payload)
(S/"production-organized-inputs.json").write_text(json.dumps({"schema":1,"files":records,
 "declarations":names,"count":len(names),"check_file_sha256":hashlib.sha256(payload).hexdigest(),
 "previous_root_input":"production-postrename-inputs.json",
 "previous_worker_input":"shock-production/post-rename-lf/files-before-check.json",
 "current_change":"Aggregate imports and exact tier records added; RiemannDataRegularity trailing blank line removed."},indent=2)+"\n",encoding="utf-8")
ps=["$ErrorActionPreference = 'Stop'",
 "$directory = 'gates/leveque-finite-volume/artifacts/session-20260908'",
 "& lake build ComputationalMathematics.Source.LeVeque.Chapter01 NumStability.Source.LeVeque.Chapter01 2>&1 | Tee-Object -FilePath \"$directory/production-organized-build-output.txt\"",
 "$buildExit = $LASTEXITCODE",
 "[ordered]@{command='lake build ComputationalMathematics.Source.LeVeque.Chapter01 NumStability.Source.LeVeque.Chapter01';exit_code=$buildExit} | ConvertTo-Json | Set-Content -LiteralPath \"$directory/production-organized-build-exit.json\" -Encoding utf8",
 "if ($buildExit -ne 0) { exit $buildExit }",
 "& lake env lean \"$directory/production-organized-declarations.lean\" 2>&1 | Tee-Object -FilePath \"$directory/production-organized-declarations-output.txt\"",
 "$checkExit = $LASTEXITCODE",
 "[ordered]@{command='lake env lean gates/leveque-finite-volume/artifacts/session-20260908/production-organized-declarations.lean';exit_code=$checkExit} | ConvertTo-Json | Set-Content -LiteralPath \"$directory/production-organized-declarations-exit.json\" -Encoding utf8",
 "exit $checkExit"]
(S/"run-production-organized-checks.ps1").write_text("\n".join(ps)+"\n",encoding="utf-8")
print(json.dumps({"modules":34,"declarations":138}))

