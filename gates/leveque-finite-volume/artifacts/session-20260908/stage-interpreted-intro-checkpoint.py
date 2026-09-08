from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!="nt"
for label in ["interpreted-intro-gate","interpreted-intro-organization","interpreted-intro-trackers"]:
 assert json.loads((S/(label+"-exit.json")).read_text())["exit_code"]==0,label
files={"gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md",
 "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"}
m=json.loads((S/"interpreted-transport-production-inputs.json").read_text())
files.update(x["path"] for x in m["files"]+m["aggregates"])
for name in ["run-native-lake-check.py","record-user-transport-interpretation.py","user-transport-interpretation-20260908.json",
 "place-interpreted-transport-domains.py","verify-interpreted-transport-production.py",
 "interpreted-transport-organization-review.md","derive-proved-rebind-adapter.py",
 "proved-rebind-adapter-derivation.json","rebind-audited-proved-row.py",
 "record-interpreted-intro-progress.py","derive-interpreted-intro-stager.py","stage-interpreted-intro-checkpoint.py"]:
 files.add((S/name).relative_to(R).as_posix())
prefixes=("interpreted-transport-production-","interpreted-intro-",
 "transport-domain-draft-check-","uniform-transport-domain-draft-check-",
 "rectangle-mass-derivative-", "two-wave-row-closure-",
 "chapter01-default-full-build-3d205d6-","chapter01-import-regressions-3d205d6-",
 "discontinuity-nonaccepted-complete-","left-mode-nonaccepted-complete-",
 "gate-before-interpreted-intro-",
 "ledger-before-LEV-C1-DISCONTINUITY-GENERALITY-014-",
 "ledger-before-LEV-C1-USER-TRANSPORT-INTERPRETATION-015-",
 "ledger-before-LEV-C1-LEFT-MODE-PROFILE-CONTEXT-016-",
 "ledger-before-BF-LEV-RUN-20260908-016-","ledger-before-BF-LEV-RUN-20260908-017-")
for p in S.iterdir():
 if p.is_file() and p.name.startswith(prefixes) and not p.name.startswith("interpreted-intro-checkpoint-"):
  files.add(p.relative_to(R).as_posix())
for name in ["transport-domain-context-review","transport-domain-draft","discontinuity-general-foundation"]:
 for p in (S/name).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for ident in ["LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908",
 "LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908",
 "LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908"]:
 for p in (S/"audits"/ident).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
g=json.loads((R/"gates/leveque-finite-volume/chapter-01.json").read_text())
for row in g["rows"]:
 if row["status"] not in ["PROVED","REUSED","DISCREPANCY"]:continue
 for p in (R/row["faithfulness_task"]).parent.joinpath("gate-bindings").rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
selection=S/"interpreted-intro-checkpoint-selection.json"
files.add(selection.relative_to(R).as_posix())
paths=sorted(files)
selection.write_text(json.dumps({"schema":1,"files":paths,
 "excluded_mutable":["all still-active audit outputs"],
 "excluded_duplicate":"Ignored hyperbolicity-declaration-checks.log; its frozen .txt counterpart is retained."},indent=2)+"\n",encoding="utf-8")
spec=S/"interpreted-intro-checkpoint-pathspec.bin"
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
receipt=S/"interpreted-intro-checkpoint-staged-verification.json"
receipt.write_text(json.dumps({"schema":1,"verified_files":len(records),"files":records,
 "git_blob_bytes_equal_worktree":True,"method":"Complete POSIX traversal and actual git cat-file --batch blob comparison; no native long-path omission."},indent=2)+"\n",encoding="utf-8")
rel=receipt.relative_to(R).as_posix()
subprocess.run(["git","-c","core.longpaths=true","add","--",rel],cwd=R,check=True)
assert subprocess.check_output(["git","-c","core.longpaths=true","show",":"+rel],cwd=R)==receipt.read_bytes()
print(json.dumps({"verified_files":len(records),"receipt":rel,"receipt_sha256":hashlib.sha256(receipt.read_bytes()).hexdigest(),
 "gate_sha256":hashlib.sha256((R/"gates/leveque-finite-volume/chapter-01.json").read_bytes()).hexdigest()}))
