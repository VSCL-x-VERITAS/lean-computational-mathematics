"""Stage only frozen introductory production/evidence and verify every selected index blob."""
from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent
R=S.parents[3]
assert os.name!="nt", "Use the prepared POSIX launcher for complete deep-path traversal."
files=set(f["path"] for f in json.loads((S/"production-rename-receipt.json").read_text())["files"])
files.add("gates/leveque-finite-volume/chapter-01.json")
for p in S.iterdir():
 if p.is_file() and p.suffix != ".log" and not p.name.startswith("library-build") and not p.name.startswith("production-checkpoint-"):
  files.add(p.relative_to(R).as_posix())
# All four roots are frozen. Other audit outputs are actively owned by the coordinator.
for ident in [
 "LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908",
 "LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908",
 "LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908",
 "LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908"]:
 for p in (S/"audits"/ident).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
# Task metadata is immutable even when its separate preparation output is active.
for p in (S/"audits").glob("*/audit-task.json"):files.add(p.relative_to(R).as_posix())
for name in ["production-pre-rename","production-pre-rename-v2","shock-continuation","shock-production",
 "shock-foundation","riemann-foundation","verification-receipts"]:
 for p in (S/name).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
# The worker's final LF checks have now frozen; the earlier selected list is redundant but harmless.
for name in ["modules.json","candidate-producer-map.json","declarations.json","Declarations.lean",
 "files-before-check.json","reuse-searches.json","extract.py","prepare-checks.py",
 "run-focused-checks.ps1","freeze-verification.py","extraction-review.md",
 "focused-build-first.txt","focused-build-first-exit.json","focused-exits.json",
 "declarations-output.txt","declarations-exit.json","pre-rename-parent-file-scan.json"]:
 p=S/"shock-production"/name
 if p.is_file():files.add(p.relative_to(R).as_posix())
for p in (S/"shock-production").glob("module-*-elaboration.txt"):files.add(p.relative_to(R).as_posix())
for p in (S/"shock-production/lf-normalization").rglob("*"):
 if p.is_file():files.add(p.relative_to(R).as_posix())
for f in [
 "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md"]:files.add(f)
selection=S/"production-checkpoint-selection.json"
files.add(selection.relative_to(R).as_posix())
paths=sorted(files)
selection.write_text(json.dumps({"schema":1,"files":paths,
 "excluded_mutable":["library-build*","all non-frozen audit output roots","rectangle-riemann-interface"],
 "excluded_duplicate":"Ignored hyperbolicity-declaration-checks.log; its frozen .txt counterpart is retained."},indent=2)+"\n",encoding="utf-8")
spec=S/"production-checkpoint-pathspec.bin"
spec.write_bytes(b"\0".join(p.encode() for p in paths)+b"\0")
subprocess.run(["git","-c","core.longpaths=true","add","--pathspec-from-file="+str(spec),"--pathspec-file-nul"],cwd=R,check=True)
index_data=subprocess.check_output(["git","-c","core.longpaths=true","ls-files","--stage","-z"],cwd=R)
index={}
for item in index_data.split(b"\0"):
 if not item:continue
 header,path=item.split(b"\t",1)
 mode,oid,stage=header.split()
 assert stage==b"0"
 index[path.decode()]=oid.decode()
queries=[index[p] for p in paths]
batch=subprocess.run(["git","-c","core.longpaths=true","cat-file","--batch"],cwd=R,
 input=("\n".join(queries)+"\n").encode(),stdout=subprocess.PIPE,check=True).stdout
offset=0;records=[]
for path,oid in zip(paths,queries,strict=True):
 end=batch.index(b"\n",offset)
 actual,kind,size=batch[offset:end].decode().split()
 assert actual==oid and kind=="blob"
 start=end+1;finish=start+int(size)
 blob=batch[start:finish]
 assert batch[finish:finish+1]==b"\n"
 data=(R/path).read_bytes()
 assert blob==data, "Index/worktree mismatch: "+path
 records.append({"path":path,"sha256":hashlib.sha256(data).hexdigest()})
 offset=finish+1
assert offset==len(batch)
receipt=S/"production-checkpoint-staged-verification.json"
receipt.write_text(json.dumps({"schema":1,"verified_files":len(records),"files":records,
 "git_blob_bytes_equal_worktree":True,"method":"Complete POSIX traversal and actual git cat-file --batch blob comparison; no native long-path omission."},indent=2)+"\n",encoding="utf-8")
rel=receipt.relative_to(R).as_posix()
subprocess.run(["git","-c","core.longpaths=true","add","--",rel],cwd=R,check=True)
assert subprocess.check_output(["git","-c","core.longpaths=true","show",":"+rel],cwd=R)==receipt.read_bytes()
print(json.dumps({"verified_files":len(records),"receipt":rel,"receipt_sha256":hashlib.sha256(receipt.read_bytes()).hexdigest(),
 "gate_sha256":hashlib.sha256((R/"gates/leveque-finite-volume/chapter-01.json").read_bytes()).hexdigest()}))
