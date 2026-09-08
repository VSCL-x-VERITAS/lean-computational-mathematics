"""Verify actual outputs and freeze placement evidence, never source acceptance."""
from pathlib import Path
from hashlib import sha256
from collections import Counter
import datetime, json, re

here = Path(__file__).resolve().parent
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
    assert record['exit_code'] == expected_exit and record['inputs_unchanged'], label
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
put('axiom-verification.json',dict(status='PASS',allowed_axioms=sorted(allowed),reports=reports,
    canonical_count=24,comparison_count=52,final_report_count=105,canonical_sources_unchanged=True))
frozen_dir = Path(mapping['frozen_draft']['path']).parent
historical = [bind(frozen_dir/'native-01-Examples.lean.fragment'), bind(frozen_dir/'run-01.py')]
assert historical[0]['sha256']=='8b4b4508554070f31115591b7e171c2adc94dca3d35e015792607edb2fb3c4d9'
assert historical[1]['sha256']=='b60cd3821416b0cd97af26477ba1de830cb6b82ea64e33d0dedbcf9065901cbb'
artifacts = [bind(p) for p in sorted(here.rglob('*')) if p.is_file() and '__pycache__' not in p.parts
             and p.name not in ['manifest.json','final-receipt.json']]
manifest = put('manifest.json',dict(schema=1,scope='Four approved generic information-method leaves only',
    frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_acceptance=False,
    frozen_draft=mapping['frozen_draft'],frozen_draft_receipt=mapping['frozen_receipt'],historical_draft_resolutions=historical,
    production=mapping['new_files'],placement_map=bind(here/'placement-map.json'),
    final_comparison_fragment=bind(here/'Comparisons.lean.fragment'),
    original_comparison_plan=bind(here/'comparison-plan.json'),comparison_repair=bind(here/'comparison-repair-02.json'),
    dependencies=bind(here/'dependency-provenance.json'),native_attempts=receipts,artifacts=artifacts,
    deferred_to_root=mapping['deferred_to_root']))
receipt = put('final-receipt.json',dict(schema=1,status='PASS',source_acceptance=False,
    manifest=bind(manifest),review=bind(here/'REVIEW.md'),axiom_verification=bind(here/'axiom-verification.json'),
    production=[dict(path=x['path'],sha256=x['sha256']) for x in mapping['new_files']],
    canonical_declarations=24,comparison_declarations=52,final_axiom_reports=105,
    final_native_receipt=bind(here/'final-check-01.receipt.json'),final_actual_exit=0,
    retained_failed_attempts=['comparisons-01'],evidence_artifacts=len(artifacts),
    limits='No source wrapper, audit, accuracy adoption, full-repository build, aggregate/tier/gate/Git changes.'))
print(json.dumps(dict(final_receipt=bind(receipt),manifest=bind(manifest),review=bind(here/'REVIEW.md'),
                     actual_exit=0,canonical_declarations=24,comparison_declarations=52,final_axiom_reports=105)))
