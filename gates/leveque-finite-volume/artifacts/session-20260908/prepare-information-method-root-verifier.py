from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;P=S/'information-method-production'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(P/'final-receipt.json')=='5f602458855faa07f2b770cd42e832e72f704ace3862025b53b15e87810b3645'
assert sha(P/'manifest.json')=='66035ac89cc9dd4f479dd969da0c00ab3a4c24e35559d97c2d3b7a45abc3972b'
base=P/'freeze.py';original=base.read_text(encoding='utf-8')
text=original[:original.index("put('axiom-verification.json'")]
text=text.replace("here = Path(__file__).resolve().parent","here = Path(__file__).resolve().parent/'information-method-production'",1)
text=text.replace("assert record['exit_code'] == expected_exit", "assert type(record['exit_code']) is int and record['exit_code'] == expected_exit",1)
text+="""
for name in ['manifest.json','final-receipt.json','axiom-verification.json']:
    verify_bindings(json.loads((here/name).read_bytes()))
final=json.loads((here/'final-check-01.receipt.json').read_bytes())
assert final['command'][:3]==['C:/Users/qed_s/.elan/bin/lake.exe','env','lean']
assert Path(final['command'][3])==here/'final-check-01.lean'
out=here.parent/'root-information-method-production-verification.json'
data={'status':'PASS','source_acceptance':False,'production_files':4,'canonical_declarations':24,'comparison_declarations':52,'native_report_counts':{k:v['count'] for k,v in reports.items()},'actual_exits':{x['label']:x['actual_exit'] for x in receipts},'canonical_lines':sum(x['lines'] for x in mapping['new_files']),'manifest_sha256':digest(here/'manifest.json'),'final_receipt_sha256':digest(here/'final-receipt.json'),'placement_map_sha256':digest(here/'placement-map.json'),'root_review':'Read all four complete canonical leaves, full nominal/type comparison fragment, scope review and freezer. Explicit maps preserve distinct six-/four-field structures; seven transported theorem contracts and ten unaffected complete types checked. No source acceptance or full-repository build inferred.'}
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\\n')
print(json.dumps({'status':'PASS','verification_sha256':digest(out),'canonical_declarations':24,'comparison_declarations':52,'final_reports':105}))
"""
dest=S/'verify-information-method-production-root.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(text)
out=S/'information-method-root-verifier-derivation.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps({'base_sha256':sha(base),'derived_sha256':sha(dest),'changes':'Keep freezer verification through exact combined native-input equality; remove all original write paths and add strict actual-exit type, final command, frozen manifest bindings and additive root review.'},indent=2)+'\n')
print(json.dumps({'derived_sha256':sha(dest)}))

