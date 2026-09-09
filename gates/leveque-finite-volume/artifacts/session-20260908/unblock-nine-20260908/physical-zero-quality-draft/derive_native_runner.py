"""Derive an input-pinned native capture for the complete zero-flux quality proof."""
from pathlib import Path
import hashlib, json, difflib
P = Path(__file__).resolve().parent
D = P.parent
parent = D / 'physical-refinement-quality-draft/run_native.py'
assert hashlib.sha256(parent.read_bytes()).hexdigest() == 'e5f95c00d48e90854ed98e310fe8e7b4a6df556a6e8000a556573ee38b517087'
before = parent.read_text(encoding='utf-8'); text = before
changes = [
    ("P=D/'physical-refinement-quality-draft'", "P=D/'physical-zero-quality-draft'"),
    ("bridge=D/'capacity-ghost-boundary-draft/native-01/Candidate.lean'", "bridge=D/'physical-refinement-quality-draft/native-02/Candidate.lean'"),
    ("f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2", "c2b8d278def563d0e181536f745a18e5e461b7a595089bc639c87c736aee7415"),
    ("fragment_ref=ref(P/'PhysicalRefinement.lean.fragment')", "extra=D/'capacity-zero-flux-witness/native-01/Zero.lean.fragment'\nextra_ref=ref(extra);assert extra_ref['sha256']=='cd7714c46194d050edbd0b7ae0d3a25acc86139bcf653af2bf78c79fc09efb19'\nfragment_ref=ref(P/'PhysicalRefinement.lean.fragment')"),
    ("+raw(bridge)+b'\\n'+raw(P/'PhysicalRefinement.lean.fragment')", "+raw(bridge)+b'\\n'+raw(extra)+b'\\n'+raw(P/'PhysicalRefinement.lean.fragment')"),
    ("pins=[bridge_ref,fragment_ref", "pins=[bridge_ref,extra_ref,fragment_ref"),
]
for old, new in changes:
    assert text.count(old) == 1, old
    text = text.replace(old, new)
assert text.count('PhysicalRefinement.lean.fragment') == 4
text = text.replace('PhysicalRefinement.lean.fragment', 'ZeroQuality.lean.fragment')
compile(text, 'run_native.py', 'exec')
for path, raw in [
    (P/'run_native.py', text.encode()),
    (P/'native-runner.diff', ''.join(difflib.unified_diff(before.splitlines(True), text.splitlines(True), str(parent), 'run_native.py')).encode()),
]:
    with path.open('xb') as stream: stream.write(raw)
record = {'parent_sha256': hashlib.sha256(parent.read_bytes()).hexdigest(),
    'derived_sha256': hashlib.sha256(text.encode()).hexdigest(), 'changes': changes}
with (P/'runner-derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2)+'\n').encode())
with (P/'Checks.lean.fragment').open('xb') as stream:
    stream.write(b'\n-- New checks occur in the frozen authored fragment.\n')
print(json.dumps(record))
