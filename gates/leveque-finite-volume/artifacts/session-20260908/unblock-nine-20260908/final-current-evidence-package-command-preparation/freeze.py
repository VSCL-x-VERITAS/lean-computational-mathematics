"""Freeze reviewed assembler preparation; never run the operational assembler."""
from pathlib import Path
import hashlib
import json
P=Path(__file__).resolve().parent
D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
test=read(P/'tests01/receipt.json')
result=read(P/'tests01/stdout.txt')
assert test['exit_code']==0 and test['inputs_unchanged'] and not (P/'tests01/stderr.txt').read_bytes()
assert result['passed']==34 and not result['operational_assembler_invoked']
derivation=read(P/'derivation.json')
successor=R/derivation['successor']['path']
assert ref(successor)==derivation['successor']
for p in [P/'independent-review.md',P/'independent-review-receipt.json']:
    assert p.is_file()
correction=D/'physical-dim-package-runtime-preparation/HANDOFF-COMMAND-CORRECTION.md'
files=[successor,correction,*sorted(p for p in P.iterdir() if p.is_file() and p.name not in ('manifest.json','final-receipt.json')),
       P/'tests01/receipt.json',P/'tests01/stdout.txt',P/'tests01/stderr.txt']
for item in result['inputs']:
    assert sha(R/item['path'])==item['sha256']
manifest={'status':'REVIEWED_PREPARATION_ONLY_NO_OPERATIONAL_ASSEMBLY',
          'files':[ref(p) for p in files],'actual_tests':ref(P/'tests01/receipt.json'),
          'helper_suite':result['real_suite'],'effective_fingerprints':result['real_effective_fingerprints'],
          'preserved_function_asts':derivation['preserved_function_asts'],
          'all41_actual_acceptance_required':True,'pending_authority_supplied':False,
          'gate_source_git_mutations':False}
with (P/'manifest.json').open('x',encoding='utf-8') as f:f.write(json.dumps(manifest,indent=2)+'\n')
receipt={'status':manifest['status'],'manifest':ref(P/'manifest.json'),'successor':ref(successor),
         'actual_test_exit_code':0,'guard_count':34,'global_dependency_count':11,
         'independent_review':ref(P/'independent-review-receipt.json'),
         'command_correction':ref(correction),'operational_assembler_invoked':False}
with (P/'final-receipt.json').open('x',encoding='utf-8') as f:f.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(ref(P/'final-receipt.json')))
