"""Record the reproduced cache defect and preserve immutable diagnostic evidence."""
from pathlib import Path
import hashlib,json,os
P=Path(__file__).resolve();W=P.parents[3];R=W/'lean-computational-mathematics';D=P.parent.parent;A=R/'gates/leveque-finite-volume/artifacts/session-20260908/hook-git-cache-diagnosis'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
warm=json.loads((P.parent/'warm-posix-gate-v2/receipt.json').read_bytes());native=json.loads((P.parent/'native-diff-after-warm/receipt.json').read_bytes());slow=json.loads((P.parent/'after-native-diff/receipt.json').read_bytes())
assert all(v['exit_code']==0 for v in [warm,native,slow])
assert warm['stdout_sha256']==slow['stdout_sha256']=='4e44f911e22da48fe40a8e37fc9207ce974dc59caa02d78cd34338b31596ada4'
assert warm['index_before_sha256']==warm['index_after_sha256']==native['index_before_sha256']==slow['index_after_sha256']
assert native['index_after_sha256']==slow['index_before_sha256']!=warm['index_before_sha256']
assert warm['elapsed_seconds']<20<slow['elapsed_seconds'] and native['working_tree_diff_empty']
for p in [D/'receipt.json',D/'source-provenance.json',D/'empirical-review.json']:
 assert p.is_file(),str(p)
pins={}
def verify(v):
 if isinstance(v,dict):
  if 'path' in v and 'sha256' in v:
   p=Path(v['path'].replace('/c/','C:/',1)) if str(v['path']).startswith('/c/') else Path(v['path'])
   if not p.is_absolute(): p=(D/p).resolve(); assert p.is_relative_to(D.resolve()),str(p)
   assert sha(p)==v['sha256'],str(p);pins[str(p)]=v['sha256']
  for x in v.values():verify(x)
 elif isinstance(v,list):
  for x in v:verify(x)
for p in [D/'receipt.json',D/'source-provenance.json',D/'empirical-review.json']:verify(json.loads(p.read_bytes()))
ledger=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
old=ledger.read_bytes();assert b'LEV-SKILL-GIT-STAT-CACHE-070' not in old
rows=[
'| LEV-SKILL-GIT-STAT-CACHE-070 | codex-start-1-v5-0-1-20260908 | reproducible inner Stop-check timeout mechanism | Native Windows porcelain Git diff rewrites shared cached file-status fields, forcing the next MSYS2 gate diff to rehash and refresh 33262 entries | Use the prepared POSIX Git consistently for repository staging, commits and final worktree checks; preserve all cache freshness settings, hook and validator bytes | cause reproduced; operational runtime choice corrected; actual next host event remains separate | Identical checker output: warm 6.4294983 s, native empty diff 17.0303026 s changes index, next checker 39.4251195 s restores original index bytes; independent empirical-review.json verifies Trace2 and stat fields | This supersedes the host-only hypothesis without rewriting prior evidence. Initial probe used the absent lakefile.lean; corrected fresh probe uses existing lakefile.toml. No checkStat, trustctime, diff auto-refresh, timeout, guard or source policy was weakened. |',
'| LEV-SKILL-OBSERVER-ANCESTRY-071 | codex-start-1-v5-0-1-20260908 | optional passive Stop observer | Snapshot-only ancestry can omit a surviving MSYS child when an intermediate Windows parent disappears between polls | Preserve the original observer and smoke; record bounded ancestry tests and use directly instrumented Git measurements for this diagnosis | documented limitation; actual Stop observer not launched | ancestry-review.json verifies four pure cases; smoke only observed nine direct cmd children over five snapshots | The smoke does not certify MSYS process coverage or hook success. A broader observer is unnecessary for the reproduced stat-cache mechanism. |']
nl=b'\r\n' if b'\r\n' in old else b'\n'
with (P.parent/'process-ledger-before-070.bin').open('xb') as f:f.write(old)
with ledger.open('ab') as f:f.write((b'' if old.endswith(b'\n') else nl)+nl.join(x.encode() for x in rows)+nl)
update={'before_sha256':hashlib.sha256(old).hexdigest(),'after_sha256':sha(ledger),'appended_ids':['LEV-SKILL-GIT-STAT-CACHE-070','LEV-SKILL-OBSERVER-ANCESTRY-071'],'book_ledgers_changed':False}
(P.parent/'ledger-update.json').write_bytes((json.dumps(update,indent=2)+'\n').encode())
A.mkdir(exist_ok=False);files=[]
sources=[p for p in sorted(D.rglob('*')) if p.is_file() and 'source' not in p.relative_to(D).parts]
# Source text copies remain local; provenance pins retain exact primary-source identities.
for src in sources:
 dest=A/src.relative_to(D);dest.parent.mkdir(parents=True,exist_ok=True)
 with dest.open('xb') as f:f.write(src.read_bytes())
 files.append({'path':dest.relative_to(R).as_posix(),'source_path':str(src),'sha256':sha(dest),'bytes':dest.stat().st_size})
observer=W/'workflow-v5.0.1-local/chapter01-hook-stop-observer/ancestry-review.json';assert sha(observer)=='9559a79d5fe23da1266b90f62716005e8d7ee5e64e5a405a452d795b2c0fc7a6'
dest=A/'observer-ancestry-review.json'
with dest.open('xb') as f:f.write(observer.read_bytes())
files.append({'path':dest.relative_to(R).as_posix(),'source_path':str(observer),'sha256':sha(dest),'bytes':dest.stat().st_size})
rec={'kind':'root-verified-reproducible-git-cache-diagnosis','files':files,'verified_referenced_pins':pins,'gate_warm_seconds':warm['elapsed_seconds'],'gate_after_native_seconds':slow['elapsed_seconds'],'unchanged_gate_output_sha256':warm['stdout_sha256'],'configuration_changes':[],'operational_choice':'Consistent prepared POSIX Git for repository worktree/index operations; native Lean remains pinned and unchanged.','actual_host_stop_success_observed':False}
(A/'archive-manifest.json').write_bytes((json.dumps(rec,indent=2)+'\n').encode())
print(json.dumps({'status':'REPRODUCED_AND_ARCHIVED','files':len(files),'pins_verified':len(pins),'archive_manifest_sha256':sha(A/'archive-manifest.json'),'ledger_sha256':sha(ledger)}))
