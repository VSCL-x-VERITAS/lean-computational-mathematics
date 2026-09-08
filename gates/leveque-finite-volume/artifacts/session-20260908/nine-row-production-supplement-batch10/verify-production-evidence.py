"""Bounded read-only verification; writes only this new supplement's evidence file.

This does not invoke Lean, released scripts, Git, audits, or operational gates.
It checks actual immutable native receipts and parses every byte of their outputs.
"""
from pathlib import Path
from datetime import datetime, timezone
from collections import Counter
import hashlib
import json
import re

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
ROOT = SESSION.parents[3]
PROD = SESSION / 'information-coordinate-production'
PRIOR = SESSION / 'nine-row-local-route-review-batch10'
OUTPUT = HERE / 'verification.json'
assert not OUTPUT.exists(), 'Append-only output already exists'


def sha_bytes(data):
    return hashlib.sha256(data).hexdigest()


def sha(path):
    return sha_bytes(path.read_bytes())


def relative(path):
    return path.resolve().relative_to(ROOT).as_posix()


observed = {}
checks = []


def bind(path, expected=None):
    path = path.resolve()
    key = relative(path)
    data = path.read_bytes()
    actual = sha_bytes(data)
    if expected is not None:
        assert actual == expected, ('hash mismatch', key, expected, actual)
    if key in observed:
        assert observed[key] == actual, ('input changed', key)
    observed[key] = actual
    return data


def read_json(path, expected=None):
    return json.loads(bind(path, expected))


def refs(value, base=ROOT):
    if isinstance(value, dict):
        if isinstance(value.get('path'), str) and isinstance(value.get('sha256'), str):
            bind(base / value['path'], value['sha256'])
        for sub in value.values():
            refs(sub, base)
    elif isinstance(value, list):
        for sub in value:
            refs(sub, base)


def hash_map(mapping):
    for path, digest in mapping.items():
        assert re.fullmatch('[0-9a-f]{64}', digest), path
        bind(ROOT / path, digest)


started = datetime.now(timezone.utc).isoformat()
prior_tree = {relative(p): sha(p) for p in PRIOR.rglob('*') if p.is_file()}
prior_manifest = read_json(PRIOR / 'manifest.json',
    '270b25158f597e519dfba22957ec89c7afa94941e7035a06b2e2c20a173fb804')
refs(prior_manifest, PRIOR)
prior_review = read_json(PRIOR / 'local-route-review.json',
    'a1f573c281e28f67b42bc22cf01a3209a659eea74c8cf92a86efe401d23ad2cd')
source_ref = prior_review['source_manifest']
refs(source_ref)
final = read_json(PROD / 'final-receipt.json',
    'e9a2d569889ef35f4b24cb9831c7e0e967ddb0cebd34ee91ae8768ff064b123d')
manifest = read_json(PROD / 'manifest.json',
    'a697b97e8c52d2c421b1ef78e8a84bc8cd1ccdf1f1de57b384b9540c3cbb3bdf')
inventory = read_json(PROD / 'normalized-files.json',
    'adf2b7741f00bba2aa3c9dd48b37e6729c4613346081a3011325666d1a95751c')
refs(final)
refs(manifest)
hash_map(manifest['dependency_pins'])
assert manifest['files'] == inventory['files']
assert len(inventory['files']) == 5
decls = [d for f in inventory['files'] for d in f['declarations']]
assert len(decls) == len(set(decls)) == inventory['authored_public_declaration_count'] == 41
for f in inventory['files']:
    data = bind(ROOT / f['path'], f['sha256']).decode('utf-8')
    assert len(data.splitlines()) == f['lines']
    namespace = re.search(r'^namespace (\S+)', data, re.M).group(1)
    names = re.findall(r'^(?:noncomputable )?(?:def|theorem|abbrev|structure) (\w+)', data, re.M)
    assert [namespace + '.' + name for name in names] == f['declarations'], f['path']
    assert not re.search(r'^\s*(?:axiom|opaque)\s|\bsorry\b|\badmit\b', data, re.M), f['path']
    assert not re.search(r'^import .*Draft|^import .*gates', data, re.M), f['path']
checks.append('All five canonical source bytes, line counts and 41 declared names match the frozen inventory; no scratch imports or proof holes.')

native = []
for label in ['build-02', 'declarations-01', 'comparisons-04']:
    receipt_path = PROD / (label + '-receipt.json')
    receipt = read_json(receipt_path)
    assert receipt['exit_code'] == 0 and receipt['inputs_unchanged'] is True
    assert Path(receipt['cwd']).resolve() == ROOT
    hash_map(receipt['input_files'])
    hash_map(receipt.get('compiled_production', {}))
    refs(receipt)
    output_path = PROD / (label + '-output.txt')
    text = bind(output_path, receipt['output_sha256']).decode('utf-8')
    assert not re.search(r'\b(?:error|warning):|\bsorryAx\b', text), label
    if label == 'build-02':
        assert receipt['command'] == ['C:/Users/qed_s/.elan/bin/lake.exe', 'build'] + [f['module'] for f in inventory['files']]
        assert 'Build completed successfully' in text
    else:
        assert receipt['command'] == ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', relative(PROD / (label + '-input.lean'))]
    native.append({
        'label': label, 'receipt': {'path': relative(receipt_path), 'sha256': sha(receipt_path)},
        'output': {'path': relative(output_path), 'sha256': sha(output_path)},
        'command': receipt['command'], 'cwd': receipt['cwd'],
        'exit_code': receipt['exit_code'], 'inputs_unchanged': receipt['inputs_unchanged'],
        'elapsed_ms': receipt['elapsed_ms'],
        'started_at_utc': receipt['started_at_utc'], 'completed_at_utc': receipt['completed_at_utc']})
checks.append('Focused build, 41 production declarations and complete preservation run have recorded actual exit 0, unchanged inputs and no output errors/warnings; all recorded current input pins match.')

plan = read_json(PROD / 'comparison-plan-04.json')
comparison = read_json(PROD / 'comparison-verification.json')
assert plan['comparisons'] == comparison['comparisons']
assert len(plan['comparisons']) == 41
assert set(c['new'] for c in plan['comparisons']) == set(decls)
assert len(set(c['name'] for c in plan['comparisons'])) == 41
assert comparison['definitional_type_value_comparisons'] == 35
assert comparison['inductive_predicate_function_equalities'] == 1
assert comparison['heterogeneous_proof_comparisons_after_type_transport'] == 5
full = bind(PROD / 'comparisons-04-input.lean')
old = bind(ROOT / plan['frozen_input']['path'], plan['frozen_input']['sha256'])
assert full.count(old) == 1, 'Byte-exact prior complete input must occur once'
assert full == bind(PROD / 'Comparisons04.lean')
full_text = full.decode('utf-8')
old_text = old.decode('utf-8')
print_names = re.findall(r'^#print axioms (\S+)\s*$', full_text, re.M)
check_names = re.findall(r'^#check (\S+)\s*$', full_text, re.M)
inherited = re.findall(r'^#print axioms (\S+)\s*$', old_text, re.M)
assert len(inherited) == 116
assert len(print_names) == len(set(print_names)) == 199
assert Counter(check_names) == Counter(print_names)
support = plan['support_declarations']
assert support == ['NumStability.InformationCoordinatePlacementChecks.proof_transport']
expected = inherited + [c['name'] for c in plan['comparisons']] + support + decls
assert set(print_names) == set(expected)
checks.append('All 41 final producers map exactly once; complete frozen full04 input occurs byte-for-byte once; 199 distinct check/axiom commands cover 116 inherited, 41 preservation, one proof transport and 41 production declarations.')

raw_output = bind(PROD / 'comparisons-04-output.txt').decode('utf-8')
pattern = r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)"
reports = []
for name, axioms in re.findall(pattern, raw_output, re.S):
    reports.append({'declaration': name, 'axioms': [a.strip() for a in axioms.split(',') if a.strip()]})
assert len(reports) == len(set(r['declaration'] for r in reports)) == 199
assert Counter(r['declaration'] for r in reports) == Counter(print_names)
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
assert all(set(r['axioms']) <= allowed for r in reports)
assert reports == read_json(PROD / 'axiom-verification.json')['reports']
checks.append('Every actual native axiom report was independently parsed, with exact command/name coverage and exact agreement with the frozen report inventory; only propext/Classical.choice/Quot.sound appear.')

for path, digest in observed.items():
    assert sha(ROOT / path) == digest, ('concurrent change', path)
assert prior_tree == {relative(p): sha(p) for p in PRIOR.rglob('*') if p.is_file()}
checks.append('All observed evidence bytes and the entire original review folder remain unchanged at completion.')
result = {
    'schema_version': 1, 'kind': 'bounded-independent-production-evidence-check',
    'status': 'PASS_WITHIN_STATED_CHECKS', 'started_at_utc': started,
    'completed_at_utc': datetime.now(timezone.utc).isoformat(),
    'checks': checks, 'observed_file_count': len(observed),
    'observed_files': [{'path': p, 'sha256': h} for p,h in sorted(observed.items())],
    'original_review_folder_snapshot': prior_tree, 'original_review_unchanged': True,
    'canonical_files': inventory['files'], 'native_receipts_reviewed': native,
    'mapping': plan['comparisons'], 'axiom_reports': reports,
    'counts': {'canonical_files': 5, 'production_declarations': 41,
        'definitional_comparisons': 35, 'inductive_predicate_equalities': 1,
        'proof_comparisons_after_type_transport': 5, 'transport_support': 1,
        'inherited_reports': 116, 'all_native_reports': 199},
    'new_lean_execution': False, 'new_released_execution': False,
    'global_zero_actionable': 'NOT ASSERTED', 'all_local_work_complete': 'NOT ASSERTED',
    'source_acceptance': False, 'operational_mutations': []}
with OUTPUT.open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(json.dumps(result, indent=2, ensure_ascii=False) + '\n')
print(json.dumps({'status': result['status'], 'observed_file_count': len(observed),
    'counts': result['counts'], 'verification_sha256': sha(OUTPUT)}))
