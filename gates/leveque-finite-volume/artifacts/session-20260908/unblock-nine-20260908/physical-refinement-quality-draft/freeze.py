"""Freeze the actual successful generic quality draft and its native provenance."""
from pathlib import Path
import hashlib, json, os, re
P = Path(__file__).resolve().parent
R = P.parents[5]
native = lambda p: '\\\\?\\' + os.path.abspath(p) if os.name == 'nt' else str(p)
def raw(p):
    with open(native(p), 'rb') as stream: return stream.read()
def sha(p): return hashlib.sha256(raw(p)).hexdigest()
def ref(p): return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def read(p): return json.loads(raw(p))
def write(p, obj):
    with open(native(p), 'xb') as stream: stream.write((json.dumps(obj, indent=2) + '\n').encode())
A = P / 'native-02'
receipt = read(A / 'receipt.json')
assert receipt['exit_code'] == 0 and receipt['inputs_unchanged']
assert read(A / 'lake-receipt.json')['exit_code'] == 0
assert read(A / 'lean-receipt.json')['exit_code'] == 0
assert read(P / 'native-01/receipt.json')['exit_code'] == 1
assert raw(P / 'PhysicalRefinement.lean.fragment') == raw(A / 'PhysicalRefinement.lean.fragment')
checks = raw(P / 'Checks.lean.fragment').decode()
authors = re.findall(r'^#check (\S+)$', checks, re.M)
assert len(authors) == len(set(authors)) == 10
output = raw(A / 'lean-output.txt').decode()
assert not re.search(r'\berror(?:\(|:)|\bwarning:|\bsorryAx\b', output)
reports = re.findall(r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)", output)
assert len(reports) == 53, len(reports)
observed = {}
for name, body in reports:
    assert name not in observed
    axioms = [x.strip() for x in body.split(',') if x.strip()]
    assert set(axioms) <= {'propext', 'Classical.choice', 'Quot.sound'}, (name, axioms)
    observed[name] = axioms
assert all(name in observed for name in authors)
inputs = read(A / 'input-pins.json')['inputs']
for item in inputs:
    path = Path(item['path'])
    if not path.is_absolute(): path = R / path
    assert sha(path) == item['sha256'], str(path)
verification = {
    'format': 'physical-refinement-quality-native-verification-1',
    'actual_native_exit_code': 0, 'actual_parent_exit_code': 0,
    'authored_declarations': authors, 'total_axiom_reports': len(reports),
    'axioms': observed, 'input_pin_count': len(inputs), 'all_input_pins_unchanged': True,
    'native_input': ref(A / 'Candidate.lean'), 'output': ref(A / 'lean-output.txt'),
    'native_receipt': ref(A / 'receipt.json'), 'native_provenance': ref(A / 'input-pins.json'),
    'failed_first_native_receipt': ref(P / 'native-01/receipt.json'),
    'first_failure': 'The first native attempt used Family dot notation for declarations placed in the enclosing namespace. The exact failed source and diagnostics are retained. The next input places these declarations in namespace Family and also adds the explicit separate-stability perturbation corollary.',
    'source_acceptance': False, 'production_changes': 0,
}
write(P / 'verification.json', verification)
files = sorted(p for p in P.rglob('*') if p.is_file() and p.name not in {'manifest.json', 'receipt.json'} and '__pycache__' not in p.parts)
manifest = {'format': 'physical-refinement-quality-artifacts-1',
    'files': [ref(p) for p in files], 'input_pins': ref(A / 'input-pins.json')}
write(P / 'manifest.json', manifest)
final = {'format': 'physical-refinement-quality-draft-receipt-1',
    'source': ref(A / 'Candidate.lean'), 'fragment': ref(P / 'PhysicalRefinement.lean.fragment'),
    'verification': ref(P / 'verification.json'), 'manifest': ref(P / 'manifest.json'),
    'review': ref(P / 'DESIGN-REVIEW.md'), 'actual_exit_code': 0,
    'authored_declarations': len(authors), 'total_axiom_reports': len(reports),
    'source_acceptance': False, 'full_family_instance': False}
write(P / 'receipt.json', final)
print(json.dumps({'receipt': ref(P / 'receipt.json'), **final}, indent=2))
