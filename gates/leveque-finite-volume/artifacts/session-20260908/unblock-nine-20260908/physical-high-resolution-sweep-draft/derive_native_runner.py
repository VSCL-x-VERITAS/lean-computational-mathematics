"""Derive an input-pinned native check of the proposed complete source contract."""
from pathlib import Path
import hashlib, json, difflib
P = Path(__file__).resolve().parent
D = P.parent
parent = D/'physical-zero-quality-draft/run_native.py'
assert hashlib.sha256(parent.read_bytes()).hexdigest() == '7e02fcc51234ba7472f50f10b1bfbbb94d2b59371cd113433f260fbfc620f380'
before = parent.read_text(encoding='utf-8'); text = before
changes = [
    ("P=D/'physical-zero-quality-draft'", "P=D/'physical-high-resolution-sweep-draft'"),
    ("extra=D/'capacity-zero-flux-witness/native-01/Zero.lean.fragment'\nextra_ref=ref(extra);assert extra_ref['sha256']=='cd7714c46194d050edbd0b7ae0d3a25acc86139bcf653af2bf78c79fc09efb19'",
     "extra=D/'capacity-boundary-sweep-draft/Sweep.lean.fragment'\nextra_ref=ref(extra);assert extra_ref['sha256']=='59950e9bc6bfd8ee3f354804bf530b0235e42e56a40a0e2ef85e5eb77216901a'\nextra2=D/'capacity-boundary-sweep-draft/StageLaws.lean.fragment'\nextra2_ref=ref(extra2);assert extra2_ref['sha256']=='f593e3bef75959892c0a76ce11472b775d1258b6f406e9a0f05ec447ac78b48e'\nsource_target=P/'SourceTarget.lean.fragment'\nsource_target_ref=ref(source_target)"),
    ("source= b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates", "source= b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference\\nimport ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates"),
    ("+raw(extra)+b'\\n'+raw(P/'ZeroQuality.lean.fragment')", "+raw(extra)+b'\\n'+raw(extra2)+b'\\n'+raw(P/'ZeroQuality.lean.fragment')+b'\\n'+raw(source_target)"),
    ("pins=[bridge_ref,extra_ref,fragment_ref", "pins=[bridge_ref,extra_ref,extra2_ref,source_target_ref,fragment_ref"),
]
for old, new in changes:
    assert text.count(old) == 1, old
    text = text.replace(old, new)
assert text.count('ZeroQuality.lean.fragment') == 4
text = text.replace('ZeroQuality.lean.fragment', 'Sweep.lean.fragment')
compile(text, 'run_native.py', 'exec')
for path, raw in [
    (P/'run_native.py', text.encode()),
    (P/'native-runner.diff', ''.join(difflib.unified_diff(before.splitlines(True), text.splitlines(True), str(parent), 'run_native.py')).encode()),
]:
    with path.open('xb') as stream: stream.write(raw)
with (P/'Checks.lean.fragment').open('xb') as stream:
    stream.write(b'\n-- The six new checks occur in the two authored fragments.\n')
record = {'parent_sha256': hashlib.sha256(parent.read_bytes()).hexdigest(),
    'derived_sha256': hashlib.sha256(text.encode()).hexdigest(), 'changes': changes}
with (P/'runner-derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2)+'\n').encode())
print(json.dumps(record))
