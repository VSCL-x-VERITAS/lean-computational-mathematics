from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
inspection=json.loads((P/'inspection.json').read_bytes())
run=json.loads((P/'inspection-01/receipt.json').read_bytes())
assert run['actual_exit_code']==0 and not (P/'inspection-01/stderr.txt').read_bytes()
assert inspection['local_module_count']==16 and inspection['expected_total_with_AuditTarget']==17
assert inspection['Mathlib_snapshot_compilations']==0 and inspection['native_refs_verified']==309
for item in inspection['files']:assert sha(R/item['path'])==item['sha256']
files=[P/'inspect.py',P/'run_inspection.py',P/'inspection.json',P/'REVIEW.md',P/'freeze.py',
       P/'inspection-01/receipt.json',P/'inspection-01/stdout.txt',P/'inspection-01/stderr.txt']
manifest={'status':'READ_ONLY_INFO_READINESS_AUTHORITY_PENDING','files':[ref(p) for p in files],
          'target':inspection['target'],'native_extension':inspection['current_native_extension'],
          'source_compilations_if_prepared':17,'Mathlib_snapshot_compilations':0,
          'current_native_refs_verified':309,'new_runtime_or_spec_created':False,
          'literal_answer_assumed':False,'operational_action':False}
with (P/'manifest.json').open('x',encoding='utf-8') as stream:stream.write(json.dumps(manifest,indent=2)+'\n')
receipt={'status':manifest['status'],'manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md'),
         'actual_read_only_exit':0,'inspection':ref(P/'inspection.json'),'source_or_gate_changes':False}
with (P/'receipt.json').open('x',encoding='utf-8') as stream:stream.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(ref(P/'receipt.json')))
