"""Read-only byte/reference inspection; no Git, Lean, layout or rebind operations."""
from pathlib import Path
import hashlib,json,os,shutil,subprocess
H=Path(__file__).resolve().parent
S=H.parent
R=S.parents[3]
W=R.parent
def native(p):
 p=Path(p)
 return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
def host(value):return Path('C:/'+value[3:]) if os.name=='nt' and value.startswith('/c/') else Path(value)
sha=lambda p:hashlib.sha256(native(p).read_bytes()).hexdigest()
records=[]
def bind(path,expected=None):
 actual=sha(path)
 assert expected is None or actual==expected,(str(path),expected,actual)
 records.append({'path':str(path),'sha256':actual})
 return native(path).read_bytes()
mapping_path=S/'generated-capstone-cache-preservation/preservation.json'
mapping=json.loads(bind(mapping_path,'3bd9a4893d9713259398d5ead7e9cadc4fd7b4792a51c2c5253f125e76837b4c'))
assert mapping['status']=='EXACT_GENERATED_CACHE_BYTES_PRESERVED' and len(mapping['files'])==2
expected_names={'capstones-final-03.olean','measure-final-02.olean'}
assert {Path(f['original_path']).name for f in mapping['files']}==expected_names
facts=[]
for item in mapping['files']:
 original=R/item['original_path'];snapshot=R/item['snapshot_path']
 raw=bind(original,item['original_sha256']);copy=bind(snapshot,item['snapshot_sha256'])
 assert raw==copy and len(raw)==item['bytes']
 blob=hashlib.sha1(b'blob '+str(len(raw)).encode()+b'\0'+raw).hexdigest()
 assert blob==item['historical_git_blob']
 receipt_path=R/item['native_receipt']['path']
 receipt=json.loads(bind(receipt_path,item['native_receipt']['sha256']))
 assert receipt['exit_code']==0 and receipt['compiled']==original.name
 assert receipt['compiled_sha256']==item['original_sha256']
 command=receipt['command'];idx=command.index('-o')
 assert Path(command[idx+1]).name==original.name
 source=receipt_path.parent/receipt['source'];output=receipt_path.parent/receipt['output']
 bind(source,receipt['source_sha256_before']);assert sha(source)==receipt['source_sha256_after']
 bind(output,receipt['output_sha256'])
 facts.append({'original_path':item['original_path'],'snapshot_path':item['snapshot_path'],
  'sha256':item['original_sha256'],'bytes':len(raw),'git_blob_sha1_recomputed_without_git':blob,
  'role':'native -o compiled output; exact historical generated-artifact evidence',
  'native_exit':receipt['exit_code'],'native_source':receipt['source'],'native_receipt_sha256':item['native_receipt']['sha256']})
manifest=json.loads(bind(R/mapping['original_manifest']['path'],mapping['original_manifest']['sha256']))
def all_refs(value):
 if isinstance(value,dict):
  if isinstance(value.get('path'),str) and isinstance(value.get('sha256'),str):yield value
  for child in value.values():yield from all_refs(child)
 elif isinstance(value,list):
  for child in value:yield from all_refs(child)
for item in mapping['files']:
 hits=[ref for ref in all_refs(manifest) if ref['path'].replace('\\','/')==item['original_path']]
 assert hits and all(ref['sha256']==item['original_sha256'] and ref.get('bytes')==item['bytes'] for ref in hits)
ex=mapping['local_exclusion'];before=bind(R/ex['backup_path'],ex['before_sha256'])
after=bind(host(ex['path']),ex['after_sha256'])
patterns=['/'+f['original_path'] for f in mapping['files']]
assert ex['added_exact_patterns']==patterns
assert after==before+(b'\n' if before and not before.endswith(b'\n') else b'')+''.join(x+'\n' for x in patterns).encode()
recovery=json.loads(bind(S/'root-generated-capstone-cache-recovery-exit.json'))
bind(S/'root-generated-capstone-cache-recovery-output.txt',recovery['raw_output_sha256'])
assert recovery['exit_code']==0
bind(S/'recover-generated-capstone-cache-preservation.py')
for path in [S/'batch9-capstone-independent-review/verify.py',S/'batch9-capstone-independent-review/verification.json',
 S/'nine-row-local-route-review-batch10/verify_evidence_v3.py',S/'nine-row-local-route-review-batch10/evidence-verification-v3.json',
 S/'root-nine-row-evidence-verification.json',S/'final-epoch-asset-helper-draft/REVIEW.md',
 R/'tools/architecture/check_layout.py',
 W/'formalization-collaboration-v5.0.1/skills/book-formalization-migration/scripts/reconciliation_launcher.py',
 W/'formalization-collaboration-v5.0.1/skills/book-formalization-migration/scripts/reconciliation.py',
 W/'formalization-collaboration-v5.0.1/skills/book-formalization-migration/references/schemas/reconciliation-epoch.schema.json']:
 bind(path)
rg=shutil.which('rg');assert rg
searches=[]
for label,roots in [('frozen-references',[S]),('canonical-and-audit-references',[R/'ComputationalMathematics',R/'NumStability',S/'audits'])]:
 command=[rg,'-n','-F','-e','capstones-final-03.olean','-e','measure-final-02.olean',
          '--glob','*.json','--glob','*.py','--glob','*.md','--glob','*.lean',
          '--glob','!**/generated-capstone-cache-review/**',*[str(p) for p in roots]]
 run=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 assert run.returncode in (0,1)
 out=H/(label+'.txt')
 with out.open('xb') as stream:stream.write(run.stdout)
 searches.append({'command':command,'exit_code':run.returncode,'output':out.name,'output_sha256':sha(out),
                  'scope':'Exact basename search over listed current roots; no global absence inference.'})
for item in records:assert sha(host(item['path']))==item['sha256'],item
result={'schema':1,'scope':'Independent read-only generated-cache preservation and reference review',
 'mapping_sha256':sha(mapping_path),'files':facts,'searches':searches,'inputs':records,
 'exact_original_snapshot_native_receipt_manifest_binding':True,'exact_local_exclusion_additions':True,
 'root_recovery_receipt_exit':0,'historical_commit_independently_resolved':False,
 'git_index_independently_queried':False,'git_command_run':False,'layout_or_rebind_run':False,
 'source_acceptance':False,'terminal_verdict_asserted':False}
with (H/'verification.json').open('xb') as out:out.write((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps({'verified':True,'files':2,'binding_occurrences':len(records),'verification_sha256':sha(H/'verification.json'),'git_command_run':False}))
