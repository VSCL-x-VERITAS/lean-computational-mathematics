"""Record completed current-tree organization and canonical acoustic proof checks."""
from pathlib import Path
import hashlib, json, re
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
record = {'schema': 1, 'checks': [], 'files': []}
for prefix in [
    'transport-acoustic-organized-build', 'transport-acoustic-organized-layout',
    'transport-acoustic-organized-compatibility', 'transport-acoustic-organized-tiers',
    'transport-acoustic-organized-placeholders', 'equation04-acoustic-production-build',
    'equation04-acoustic-production-checks', 'equation06-row-closure']:
    output = S / (prefix + '-output.txt')
    receipt = S / (prefix + '-exit.json')
    e = json.loads(receipt.read_text(encoding='utf-8-sig'))
    assert type(e['exit_code']) is int and e['exit_code'] == 0, prefix
    record['checks'].append({'check': prefix, 'exit_code': 0,
        'output': output.relative_to(R).as_posix(), 'output_sha256': sha(output.read_bytes()),
        'exit': receipt.relative_to(R).as_posix(), 'exit_sha256': sha(receipt.read_bytes())})
layout = (S / 'transport-acoustic-organized-layout-output.txt').read_text(encoding='utf-8-sig')
for line in ['Lean modules: 5920', 'unclassified modules: 0', 'mixed modules: 0',
    'modules missing module docs: 0', 'legacy naming exceptions: 0',
    'declaration-bearing umbrellas: 0', 'unsorted aggregate imports: 0',
    'Layout contract satisfied']:
    assert line in layout, line
assert '14837 Lean file(s)' in (S / 'transport-acoustic-organized-placeholders-output.txt').read_text(encoding='utf-8-sig')
assert '1 axiom report(s)' in (S / 'transport-acoustic-organized-placeholders-output.txt').read_text(encoding='utf-8-sig')
for manifest in ['transport-intro-proof-verification.json', 'equation04-acoustic-production-inputs.json']:
    source = json.loads((S / manifest).read_text())
    for f in source['files']:
        assert sha((R / f['path']).read_bytes()) == f['sha256'], f['path']
        record['files'].append(f)
assert len(record['files']) == 9
acoustic = json.loads((S / 'equation04-acoustic-production-inputs.json').read_text())
name = acoustic['files'][0]['declarations'][0]
output = (S / 'equation04-acoustic-production-checks-output.txt').read_text(encoding='utf-8-sig')
match = re.search(re.escape("'" + name + "' depends on axioms:") + r'\s*\[([^\]]*)\]', output)
assert match and {a.strip() for a in match.group(1).split(',') if a.strip()} <= {'propext', 'Classical.choice', 'Quot.sound'}
assert sha((S / 'equation04-acoustic-production-checks.lean').read_bytes()) == acoustic['check_file_sha256']
aggregate = acoustic['aggregate']
assert sha((R / aggregate['path']).read_bytes()) == aggregate['sha256']
tier_update = json.loads((S / 'transport-tier-update.json').read_text())
assert tier_update['introduction_commit'] == '46038487a021089cf26b3327ab5ee5610dfa4a76'
assert tier_update['counts']['production_modules'] == 5920 and tier_update['new_exact_rules'] == 8
record['tier_update'] = tier_update
record['organization'] = {'unclassified_modules': 0, 'duplicate_wrappers': 0,
    'placeholder_findings': 0, 'canonical_placement_pending': 0}
record['review'] = 'Eight transport/interface owners were reviewed in transport-production-organization-review.md. The additional source wrapper only combines the existing scalar-wave model and given-system acoustic right-mode theorem; its source-reuse-review.md records exact current-tree search and reasons. All nine owners are unique and reachable; compatibility and layout pass. Eight exact tier entries cite their actual addition commit; the new acoustic wrapper is covered by the reviewed source prefix.'
record['controlled_inputs'] = [{'path': p, 'sha256': sha((R / p).read_bytes())} for p in
    ['docs/architecture/tiers.json', 'ComputationalMathematics/Analysis.lean', 'ComputationalMathematics/Source/LeVeque/Chapter01.lean']]
record['rebound_existing_rows'] = json.loads((S / 'transport-acoustic-organized-rebinding-receipt.json').read_text())
assert len(record['rebound_existing_rows']) == 5
G = R / 'gates/leveque-finite-volume/chapter-01.json'
before = G.read_bytes()
g = json.loads(before)
assert next(r for r in g['rows'] if r['id'] == 'LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX')['status'] == 'REUSED'
closed = [r for r in g['rows'] if r['status'] in ['REUSED', 'PROVED']]
assert len(closed) == 6
(S / ('gate-before-transport-acoustic-organization-' + sha(before) + '.json')).write_bytes(before)
g['verification_loops']['organization_completeness'] = record['organization']
row = next(r for r in g['rows'] if r['id'] == 'LEV-CH01-EQ-1.4-ONE-WAY-WAVE')
assert row['status'] == 'READY'
row['next_foundation'] = 'The stronger given-system acoustic source wrapper is placed and native build/declaration/axiom checked. Complete exact preparation and independent audit LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908; bind only an accepted complete decision. Preserve the prior weaker-model rejection.'
for item in g['verification_evidence']:
    g['verification_evidence'][item] = {'command': '', 'artifact': '', 'artifact_sha256': '', 'exit_code': None, 'count': 0}
record['gate_counts'] = {'formalized': len(closed), 'denominator': 41, 'remaining': 35, 'skipped': 16, 'deferred': 0}
record['remaining'] = 'Independent audits and all eight final global evidence checks remain actionable; full library build is not yet certified.'
destination = S / 'transport-acoustic-organized-verification.json'
assert not destination.exists()
destination.write_text(json.dumps(record, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
G.write_text(json.dumps(g, indent=2, ensure_ascii=False)+'\n', encoding='utf-8', newline='\n')
print(json.dumps({'organization': record['organization'], 'counts': record['gate_counts'], 'global_verification': 'OPEN'}))

