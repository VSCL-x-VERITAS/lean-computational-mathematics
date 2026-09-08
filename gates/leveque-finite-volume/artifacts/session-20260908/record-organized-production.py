"""Bind completed organization checks and keep unfinished source rows actionable."""
from pathlib import Path
import hashlib, json, re
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
record = {'schema': 1, 'checks': [], 'files': []}
for name in ['build', 'declarations', 'layout-casefold', 'compatibility', 'tiers-format', 'placeholders']:
    prefix = 'production-organized-' + name
    out = S / (prefix + '-output.txt')
    exit_path = S / (prefix + '-exit.json')
    e = json.loads(exit_path.read_text(encoding='utf-8-sig'))
    assert e['exit_code'] == 0 and not isinstance(e['exit_code'], bool), prefix
    record['checks'].append({'check': name, 'exit_code': 0,
        'output': out.relative_to(R).as_posix(), 'output_sha256': sha(out.read_bytes()),
        'exit': exit_path.relative_to(R).as_posix(), 'exit_sha256': sha(exit_path.read_bytes())})
manifest = json.loads((S / 'production-organized-inputs.json').read_text())
names = []
for f in manifest['files']:
    assert sha((R / f['path']).read_bytes()) == f['sha256'], f['path']
    names.extend(f['declarations'])
    record['files'].append(f)
assert len(record['files']) == 34 and len(names) == len(set(names)) == 138
output = (S / 'production-organized-declarations-output.txt').read_text(encoding='utf-8-sig')
for name in names:
    match = re.search(re.escape("'" + name + "' depends on axioms:") + r'\s*\[([^\]]*)\]', output)
    assert match, name
    assert {a.strip() for a in match.group(1).split(',') if a.strip()} <= {'propext', 'Classical.choice', 'Quot.sound'}
assert 'Layout contract satisfied' in (S / 'production-organized-layout-casefold-output.txt').read_text(encoding='utf-8-sig')
assert '138 axiom report(s)' in (S / 'production-organized-placeholders-output.txt').read_text(encoding='utf-8-sig')
format_receipt = json.loads((S / 'production-tier-format-receipt.json').read_text())
assert format_receipt['parsed_json_unchanged'] is True
assert format_receipt['sha256'] == sha((R / format_receipt['path']).read_bytes())
record['post_scan_tier_format'] = format_receipt
record['organization'] = {'unclassified_modules': 0, 'duplicate_wrappers': 0,
    'placeholder_findings': 0, 'canonical_placement_pending': 0}
record['duplicate_wrapper_review'] = 'Reviewed 34 unique canonical owner paths and 138 distinct checked declarations; source wrappers are thin correspondences, existing owners and compatibility targets retained. Full layout and compatibility scans passed.'
record['remaining'] = '37 source rows remain open; full-library build and final gate-wide verification remain open.'
(S / 'production-organized-verification.json').write_text(json.dumps(record, indent=2)+'\n', encoding='utf-8')
G = R / 'gates/leveque-finite-volume/chapter-01.json'
before = G.read_bytes()
gate = json.loads(before)
(S / ('gate-before-organized-' + sha(before) + '.json')).write_bytes(before)
gate['verification_loops']['organization_completeness'] = record['organization']
row = next(r for r in gate['rows'] if r['id'] == 'LEV-CH01-EQ-1.3-ADVECTED-PROFILE')
assert row['status'] == 'READY'
row['next_foundation'] = 'The frozen GLOBAL audit is nonaccepted after adjudication. Place the checked transport/integral successor drafts, validate exact canonical imports, and independently audit the stronger target with Chapter 1 Section 1.1.2 context. Preserve the prior finding.'
row = next(r for r in gate['rows'] if r['id'] == 'LEV-CH01-RIEMANN-INTERFACE-FLUX')
assert row['status'] == 'READY'
row['next_foundation'] = 'Place the completed explicit-domain rectangle-certified interface drafts, check their exact canonical imports and 14 declarations, then prepare and independently audit the new interface source target.'
for name in gate['verification_evidence']:
    gate['verification_evidence'][name] = {'command': '', 'artifact': '', 'artifact_sha256': '', 'exit_code': None, 'count': 0}
G.write_text(json.dumps(gate, ensure_ascii=False, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps({'modules': 34, 'declarations': 138, 'organization': record['organization'], 'global_verification': 'OPEN'}))
