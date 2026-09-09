"""Freeze actual native success for the proposed physical coordinate source wrapper."""
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
A = P / 'native-01'
assert read(A/'receipt.json')['exit_code'] == 0 and read(A/'receipt.json')['inputs_unchanged']
assert read(A/'lake-receipt.json')['exit_code'] == 0
assert read(A/'lean-receipt.json')['exit_code'] == 0
assert raw(P/'Admitted.lean.fragment') == raw(A/'Admitted.lean.fragment')
assert raw(P/'SourceTarget.lean.fragment') == raw(A/'SourceTarget.lean.fragment')
authors = re.findall(r'^#check (\S+)$', (raw(P/'Admitted.lean.fragment')+raw(P/'SourceTarget.lean.fragment')).decode(), re.M)
assert len(authors) == len(set(authors)) == 3
output = raw(A/'lean-output.txt').decode()
assert not re.search(r'\berror(?:\(|:)|\bwarning:|\bsorryAx\b', output)
reports = re.findall(r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)", output)
assert len(reports) == 61, len(reports)
observed = {}
for name, body in reports:
    assert name not in observed
    axioms = [x.strip() for x in body.split(',') if x.strip()]
    assert set(axioms) <= {'propext', 'Classical.choice', 'Quot.sound'}, (name, axioms)
    observed[name] = axioms
assert all(name in observed for name in authors)
inputs = read(A/'input-pins.json')['inputs']
for item in inputs:
    path = Path(item['path'])
    if not path.is_absolute(): path = R/path
    assert sha(path) == item['sha256'], str(path)
verification = {'format': 'physical-admitted-high-resolution-sweep-verification-1',
    'actual_native_exit_code': 0, 'actual_parent_exit_code': 0,
    'authored_declarations': authors, 'total_axiom_reports': len(reports), 'axioms': observed,
    'input_pin_count': len(inputs), 'all_input_pins_unchanged': True,
    'native_input': ref(A/'Candidate.lean'), 'output': ref(A/'lean-output.txt'),
    'native_receipt': ref(A/'receipt.json'), 'native_provenance': ref(A/'input-pins.json'),
    'source_acceptance': False, 'production_changes': 0, 'concrete_joint_consumer': False}
write(P/'verification.json', verification)
files = sorted(p for p in P.rglob('*') if p.is_file() and p.name not in {'manifest.json','receipt.json'} and '__pycache__' not in p.parts)
write(P/'manifest.json', {'format': 'physical-admitted-high-resolution-sweep-artifacts-1', 'files': [ref(p) for p in files]})
final = {'format': 'physical-admitted-high-resolution-sweep-receipt-1', 'source': ref(A/'Candidate.lean'),
    'fragment': ref(P/'Admitted.lean.fragment'), 'source_target': ref(P/'SourceTarget.lean.fragment'),
    'verification': ref(P/'verification.json'), 'manifest': ref(P/'manifest.json'), 'review': ref(P/'REVIEW.md'),
    'actual_exit_code': 0, 'authored_declarations': 3, 'total_axiom_reports': 61,
    'source_acceptance': False, 'concrete_joint_consumer': False}
write(P/'receipt.json', final)
print(json.dumps({'receipt': ref(P/'receipt.json'), **final}, indent=2))
