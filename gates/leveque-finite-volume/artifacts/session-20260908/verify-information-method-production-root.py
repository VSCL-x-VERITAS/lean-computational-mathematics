"""Verify actual outputs and freeze placement evidence, never source acceptance."""
from pathlib import Path
from hashlib import sha256
from collections import Counter
import datetime, json, re

here = Path(__file__).resolve().parent/'information-method-production'
digest = lambda p: sha256(p.read_bytes()).hexdigest()
bind = lambda p: dict(path=str(p), sha256=digest(p))
def put(name, data):
    target = here/name
    assert not target.exists(), target
    target.write_text(json.dumps(data, indent=2)+'\n', encoding='utf-8', newline='\n')
    return target
mapping = json.loads((here/'placement-map.json').read_bytes())
plan = json.loads((here/'comparison-plan.json').read_bytes())
repair = json.loads((here/'comparison-repair-02.json').read_bytes())
provenance = json.loads((here/'dependency-provenance.json').read_bytes())
def verify_bindings(obj):
    if isinstance(obj, dict):
        if 'path' in obj and 'sha256' in obj:
            assert digest(Path(obj['path'])) == obj['sha256'], obj['path']
        for value in obj.values(): verify_bindings(value)
    elif isinstance(obj, list):
        for value in obj: verify_bindings(value)
for obj in [mapping, repair, provenance]: verify_bindings(obj)
assert digest(here/'comparisons-01.fragment') == plan['source_sha256']
assert (here/'comparisons-01.fragment').read_bytes() in (here/'comparisons-01.lean').read_bytes()
for row in mapping['new_files']:
    raw = Path(row['path']).read_bytes()
    assert b'\r' not in raw and len(raw.splitlines()) == row['lines']
    assert not any(x in raw for x in [b'InformationOnlyRiemannDraft', b'import Source.', b'import NumStability.'])
assert [x['declaration_count'] for x in mapping['new_files']] == [5,6,2,11]
canonical = [row['canonical'] for row in mapping['declaration_map']]
draft = re.findall(r'^#print axioms (\S+)', Path(mapping['frozen_draft']['path']).read_text(encoding='utf-8'), re.M)
comparisons = plan['checked_declarations']
assert len(canonical) == 24 and len(draft) == 29 and len(comparisons) == 52
allowed = {'propext','Classical.choice','Quot.sound'}
reports, receipts = {}, []
for label, expected_exit, expected_names in [
    ('build-01',0,None), ('declarations-01',0,canonical),
    ('comparisons-01',1,None), ('comparisons-02',0,draft+comparisons),
    ('final-check-01',0,draft+comparisons+canonical)]:
    receipt_path = here/(label+'.receipt.json')
    record = json.loads(receipt_path.read_bytes())
    assert type(record['exit_code']) is int and record['exit_code'] == expected_exit and record['inputs_unchanged'], label
    for path,h in record['inputs'].items(): assert digest(Path(path)) == h, path
    output = Path(record['output'])
    assert digest(output) == record['output_sha256']
    text = output.read_text(encoding='utf-8')
    if expected_exit == 0:
        assert not re.search(r'error:|warning:|sorryAx',text), label
    else:
        assert 'error:' in text
    if expected_names is not None:
        parsed = []
        for match in re.finditer(r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)", text, re.S):
            name = re.sub(r'\.\{[^}]*\}$','',match.group(1))
            axioms = [] if match.group(2) is None else [x.strip() for x in match.group(2).split(',') if x.strip()]
            assert set(axioms) <= allowed, (name,axioms)
            parsed.append(dict(name=name,axioms=axioms))
        assert Counter(x['name'] for x in parsed) == Counter(expected_names), (label,len(parsed),len(expected_names))
        reports[label] = dict(count=len(parsed), empty=sum(not x['axioms'] for x in parsed), declarations=parsed)
    receipts.append(dict(label=label,actual_exit=expected_exit,receipt=bind(receipt_path),output=bind(output)))
modules = ['.'.join(Path(x['path']).relative_to(here.parents[4]).with_suffix('').parts) for x in mapping['new_files']]
prefix = ('\n'.join('import '+x for x in modules)+'\n\n').encode()
candidate = Path(mapping['frozen_draft']['path']).read_bytes()
fragment = (here/'Comparisons.lean.fragment').read_bytes()
assert (here/'comparisons-02.lean').read_bytes() == prefix+candidate+b'\n\n'+fragment
checks = '\n'.join(f'#check {x}\n#print axioms {x}' for x in canonical)+'\n'
assert (here/'final-check-01.lean').read_bytes() == (here/'comparisons-02.lean').read_bytes()+b'\n'+checks.encode()

for name in ['manifest.json','final-receipt.json','axiom-verification.json']:
    verify_bindings(json.loads((here/name).read_bytes()))
final=json.loads((here/'final-check-01.receipt.json').read_bytes())
assert final['command'][:3]==['C:/Users/qed_s/.elan/bin/lake.exe','env','lean']
assert Path(final['command'][3])==here/'final-check-01.lean'
out=here.parent/'root-information-method-production-verification.json'
data={'status':'PASS','source_acceptance':False,'production_files':4,'canonical_declarations':24,'comparison_declarations':52,'native_report_counts':{k:v['count'] for k,v in reports.items()},'actual_exits':{x['label']:x['actual_exit'] for x in receipts},'canonical_lines':sum(x['lines'] for x in mapping['new_files']),'manifest_sha256':digest(here/'manifest.json'),'final_receipt_sha256':digest(here/'final-receipt.json'),'placement_map_sha256':digest(here/'placement-map.json'),'root_review':'Read all four complete canonical leaves, full nominal/type comparison fragment, scope review and freezer. Explicit maps preserve distinct six-/four-field structures; seven transported theorem contracts and ten unaffected complete types checked. No source acceptance or full-repository build inferred.'}
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','verification_sha256':digest(out),'canonical_declarations':24,'comparison_declarations':52,'final_reports':105}))
