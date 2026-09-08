"""Stage only frozen organization and semantic-finding evidence and verify every selected index blob."""
from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent
R=S.parents[3]
assert os.name!="nt", "Use the prepared POSIX launcher for complete deep-path traversal."
files=set(f["path"] for f in json.loads((S/"right-domain-increment-verification.json").read_text())["files"])
files.update({
 "ComputationalMathematics/Analysis.lean",
 "ComputationalMathematics/Source/LeVeque/Chapter01.lean",
 "ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean",
 "docs/architecture/tiers.json",
 "gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md",
 "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"})
# Every top-level check has finished; the full-library build is still mutable.
for p in S.iterdir():
 if p.is_file() and p.name.startswith((
    "right-domain-", "right-mode-", "real-measure-root-", "verify-real-measure-",
    "run-frozen-command-20260908b", "record-right-", "derive-right-", "place-right-",
    "prepare-right-", "validate-right-", "prepared-final-LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-",
    "chapter01-current-producer-", "inventory-current-chapter01-", "verify-current-chapter01-",
    "chapter01-source-inventory-", "snapshot-source-inventory-", "transport-integral-nonaccepted-",
    "source-ledger-before-right-mode-", "gate-before-right-mode-", "gate-before-right-domain-",
    "tiers-before-right-domain-", "ledger-before-LEV-C1-TRANSPORT-", "ledger-before-BF-LEV-RUN-20260908-013-",
    "ledger-before-BF-LEV-RUN-20260908-014-", "stage-right-domain-"
 )) and not p.name.startswith("right-domain-checkpoint-"):
  files.add(p.relative_to(R).as_posix())
# These eleven roots are explicitly frozen by the audit coordinator.
for ident in [
 "LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908",
 "LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908",
 "LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908",
 "LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908",
 "LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908",
 "LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908",
 "LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908",
 "LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908",
 "LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908",
 "LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908",
 "LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908"]:
 for p in (S/"audits"/ident).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for p in (S/"audits").glob("*/audit-task.json"):
 if "TRANSPORT-CONTEXT" not in p.parent.name:
  files.add(p.relative_to(R).as_posix())
# All selected completed draft directories are frozen, with no canonical placement claimed.
for name in ["rectangle-riemann-interface", "equation03-transport", "equation02-transport", "equation04-acoustic-model", "acoustics-algebraic-domain", "real-measure-dependency"]:
 for p in (S/name).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
selection=S/"right-domain-checkpoint-selection.json"
files.add(selection.relative_to(R).as_posix())
paths=sorted(files)
selection.write_text(json.dumps({"schema":1,"files":paths,
 "excluded_mutable":["library-build*","all non-frozen audit output roots","fresh context task/config still being prepared"],
 "excluded_duplicate":"Ignored hyperbolicity-declaration-checks.log; its frozen .txt counterpart is retained."},indent=2)+"\n",encoding="utf-8")
spec=S/"right-domain-checkpoint-pathspec.bin"
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
receipt=S/"right-domain-checkpoint-staged-verification.json"
receipt.write_text(json.dumps({"schema":1,"verified_files":len(records),"files":records,
 "git_blob_bytes_equal_worktree":True,"method":"Complete POSIX traversal and actual git cat-file --batch blob comparison; no native long-path omission."},indent=2)+"\n",encoding="utf-8")
rel=receipt.relative_to(R).as_posix()
subprocess.run(["git","-c","core.longpaths=true","add","--",rel],cwd=R,check=True)
assert subprocess.check_output(["git","-c","core.longpaths=true","show",":"+rel],cwd=R)==receipt.read_bytes()
print(json.dumps({"verified_files":len(records),"receipt":rel,"receipt_sha256":hashlib.sha256(receipt.read_bytes()).hexdigest(),
 "gate_sha256":hashlib.sha256((R/"gates/leveque-finite-volume/chapter-01.json").read_bytes()).hexdigest()}))
