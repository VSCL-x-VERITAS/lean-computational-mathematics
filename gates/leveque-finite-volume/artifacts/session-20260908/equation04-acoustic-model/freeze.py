from pathlib import Path
import hashlib
import json
import re

base = Path(__file__).resolve().parent
repo = next(p for p in base.parents if (p / 'ComputationalMathematics').is_dir())
session = base.parent
audit = session / 'audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def read(path):
    raw = path.read_bytes()
    return raw.decode('utf-16') if raw[:2] in (b'\xff\xfe', b'\xfe\xff') else raw.decode('utf-8-sig')

def write_once(path, obj):
    assert not path.exists(), path
    path.write_bytes((json.dumps(obj, indent=2) + '\n').encode('utf-8'))

pins = {
    audit / 'faithfulness/manifest.json': '799c562abb982126b4a300df7f2bb9157cc64c7eb1b0ba97dcc2227bfea4a741',
    audit / 'faithfulness/decision.json': '77601b25183ffff2ec98185b1cafe3103e0968a94e151d7ef78d00a7f88fbaee',
    audit / 'faithfulness/report.md': '7f1020fa672f40b3f6c180de1bf9dd6cf6ac83db2ab5994aaaea5e4668cb326e',
    session / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf':
        'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5',
    repo / 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation04Model.lean':
        '6c8a8809067f4ea87aa82e1a4e0e52275aeb9a9c2b7390a7b78a99b634fd102f',
}
for path, expected in pins.items():
    assert sha(path) == expected, (path, sha(path), expected)
input_paths = list(pins) + [
    audit / 'audit-task.json',
    audit / 'faithfulness/agent_outputs/direct_judge.json',
    audit / 'faithfulness/agent_outputs/roundtrip_judge.json',
    audit / 'faithfulness/agent_outputs/source_contract.json',
    audit / 'faithfulness/orchestration/page-024.png',
    session / 'audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/page-025.png',
    repo / 'ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsModes.lean',
    repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/LinearAcoustics.lean',
    repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/EigenmodeWaves.lean',
    repo / 'lean-toolchain', repo / 'lake-manifest.json',
]
inputs = [{'path': path.relative_to(repo).as_posix(), 'sha256': sha(path)} for path in input_paths]
write_once(base / 'input-receipt.json', {'verified_pins_match': True, 'inputs': inputs})
native_exit = json.loads(read(base / 'first-exit.json'))
assert native_exit['exit_code'] == 0
output = read(base / 'first-elaboration.txt')
assert not re.search(r'\bsorryAx\b|\berror:', output)
axioms = re.findall(r"'(NumStability\.[A-Za-z0-9_]+)' depends on axioms: \[(.*?)\]", output, re.S)
expected_declarations = [
    'NumStability.leveque01_equation04_scalarHyperbolicOneWayModel',
    'NumStability.leveque01_acousticsRightMode',
    'NumStability.linearAcousticsRightInvariant_isLinearAdvectionSolutionAt',
    'NumStability.leveque01_equation04_acousticOneWayModel',
]
assert [name for name, _ in axioms] == expected_declarations
for name, values in axioms:
    assert {a.strip() for a in values.split(',')} <= {'propext', 'Classical.choice', 'Quot.sound'}, name
draft = base / 'Equation04AcousticModel.lean'
assert b'\r' not in draft.read_bytes()
assert (base / 'candidate.lean').read_bytes().startswith(draft.read_bytes())
assert not re.search(r'\b(sorry|admit|axiom|unsafe)\b', read(draft))
canonical = 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation04AcousticModel.lean'
assert not (repo / canonical).exists()
evidence = ['Equation04AcousticModel.lean', 'candidate.lean', 'first-elaboration.txt',
            'first-exit.json', 'input-receipt.json', 'reuse-searches.json', 'source-reuse-review.md', 'freeze.py']
receipt = {
    'status': 'scratch_checked_canonical_draft_ready',
    'source_sha256': pins[session / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'],
    'canonical_draft': {'path': canonical, 'draft': draft.name, 'sha256': sha(draft),
                        'lines': len(read(draft).splitlines()), 'line_endings': 'LF'},
    'new_declarations': [expected_declarations[-1]],
    'reused_exact_checked_declarations': expected_declarations[:-1],
    'actual_native_exit': native_exit,
    'proof_axioms': ['propext', 'Classical.choice', 'Quot.sound'],
    'canonical_import_status': 'two unchanged canonical source imports elaborated in the scratch candidate; production placement/build pending root',
    'failed_lean_runs': [],
    'source_audit_status': 'not rerun; original frozen rejected audit preserved',
    'production_mutations': [],
    'evidence': [{'path': path, 'sha256': sha(base / path)} for path in evidence],
}
write_once(base / 'final-verification.json', receipt)
print(json.dumps({'receipt_sha256': sha(base / 'final-verification.json'),
                  'draft_sha256': sha(draft), 'candidate_sha256': sha(base / 'candidate.lean'),
                  'output_sha256': sha(base / 'first-elaboration.txt'),
                  'review_sha256': sha(base / 'source-reuse-review.md'),
                  'lines': receipt['canonical_draft']['lines']}, indent=2))
