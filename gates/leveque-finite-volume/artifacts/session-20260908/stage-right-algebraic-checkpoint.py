from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!="nt"
for label in ["right-algebraic-gate","right-algebraic-organization","right-algebraic-trackers","candidate-architecture-wrapper-check"]:
 assert json.loads((S/(label+"-exit.json")).read_text())["exit_code"]==0,label
files={"gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md",
 "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"}
for p in S.iterdir():
 if p.is_file() and p.name.startswith(("right-algebraic-row-closure-","right-algebraic-gate-",
  "right-algebraic-organization-","right-algebraic-trackers-","record-right-algebraic-acceptance.py",
  "right-algebraic-acceptance-verification.json","ledger-before-right-acceptance-",
  "validate-candidate-architecture.py","candidate-architecture-wrapper-check-",
  "derive-right-algebraic-stager.py","stage-right-algebraic-checkpoint.py")):
  files.add(p.relative_to(R).as_posix())
for p in (S/"audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-PRODUCTION-20260908").rglob("*"):
 if p.is_file():files.add(p.relative_to(R).as_posix())
selection=S/"right-algebraic-checkpoint-selection.json"
files.add(selection.relative_to(R).as_posix())
paths=sorted(files)
selection.write_text(json.dumps({"schema":1,"files":paths,
 "excluded_mutable":["all still-active audit outputs"],
 "excluded_duplicate":"Ignored hyperbolicity-declaration-checks.log; its frozen .txt counterpart is retained."},indent=2)+"\n",encoding="utf-8")
spec=S/"right-algebraic-checkpoint-pathspec.bin"
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
receipt=S/"right-algebraic-checkpoint-staged-verification.json"
receipt.write_text(json.dumps({"schema":1,"verified_files":len(records),"files":records,
 "git_blob_bytes_equal_worktree":True,"method":"Complete POSIX traversal and actual git cat-file --batch blob comparison; no native long-path omission."},indent=2)+"\n",encoding="utf-8")
rel=receipt.relative_to(R).as_posix()
subprocess.run(["git","-c","core.longpaths=true","add","--",rel],cwd=R,check=True)
assert subprocess.check_output(["git","-c","core.longpaths=true","show",":"+rel],cwd=R)==receipt.read_bytes()
print(json.dumps({"verified_files":len(records),"receipt":rel,"receipt_sha256":hashlib.sha256(receipt.read_bytes()).hexdigest(),
 "gate_sha256":hashlib.sha256((R/"gates/leveque-finite-volume/chapter-01.json").read_bytes()).hexdigest()}))
