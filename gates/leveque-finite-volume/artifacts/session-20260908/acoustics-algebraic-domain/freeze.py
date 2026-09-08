from pathlib import Path
import hashlib
import json
import re

base = Path(__file__).resolve().parent
session = base.parent
repo = next(p for p in base.parents if (p / 'ComputationalMathematics').is_dir())
audit = session / 'audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def read(path):
    raw = path.read_bytes()
    return raw.decode('utf-16') if raw[:2] in (b'\xff\xfe', b'\xfe\xff') else raw.decode('utf-8-sig')

def write_once(path, obj):
    assert not path.exists(), path
    path.write_bytes((json.dumps(obj, indent=2) + '\n').encode('utf-8'))

source = session / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
assert sha(source) == 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
assert sha(audit / 'decision.json') == 'a6363aafd8ed62009ba884b91bcabc7d8af735da52d5894375a35344f8eecb28'
previous_inputs = json.loads(read(session / 'equation04-acoustic-model/input-receipt.json'))['inputs']
preserved_paths = [
    'ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsModes.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/LinearAcoustics.lean',
]
preserved = [item for item in previous_inputs if item['path'] in preserved_paths]
assert len(preserved) == 2
for item in preserved:
    assert sha(repo / item['path']) == item['sha256'], item['path']
eq4 = repo / 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation04AcousticModel.lean'
assert sha(eq4) == '05fe4d2f1cda9c311340c41e85830bc7a3873d99efc5d4261c5d754f58546843'
input_paths = [source, audit / 'decision.json', audit / 'agent_outputs/adjudicator.json',
               audit / 'orchestration/page-023.png', audit / 'orchestration/page-024.png',
               eq4, repo / 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation04.lean',
               repo / '.lake/packages/mathlib/Mathlib/Data/Real/Sqrt.lean',
               repo / '.lake/packages/mathlib/Mathlib/Algebra/GroupWithZero/Defs.lean',
               repo / 'lean-toolchain', repo / 'lake-manifest.json']
input_paths += [repo / item['path'] for item in preserved]
write_once(base / 'input-receipt.json', {
    'parent_reported_head': 'b05cc4a1a2125ddaef745bc394fe2138dea236d9',
    'git_read_or_mutation_by_this_task': False,
    'previous_producers_verified_unchanged': preserved,
    'equation04_acoustic_model_verified_unchanged_sha256': sha(eq4),
    'inputs': [{'path': path.relative_to(repo).as_posix(), 'sha256': sha(path)} for path in input_paths],
})
native_exit = json.loads(read(base / 'first-exit.json'))
assert native_exit['exit_code'] == 0
output = read(base / 'first-elaboration.txt')
assert not re.search(r'\bsorryAx\b|\berror:', output)
expected_declarations = [
    'Real.sq_sqrt', 'Real.sqrt_pos',
    'NumStability.linearAcousticsRightInvariant_isLinearAdvectionSolutionAt',
    'NumStability.leveque01_acousticsRightMode_of_pos_ratio',
]
axioms = re.findall(r"'([A-Za-z0-9_.]+)' depends on axioms: \[(.*?)\]", output, re.S)
assert [name for name, _ in axioms] == expected_declarations
for name, values in axioms:
    assert {a.strip() for a in values.split(',')} <= {'propext', 'Classical.choice', 'Quot.sound'}, name
draft = base / 'AcousticsRightModeAlgebraic.lean'
assert b'\r' not in draft.read_bytes()
assert (base / 'candidate.lean').read_bytes().startswith(draft.read_bytes())
assert not re.search(r'\b(sorry|admit|axiom|unsafe)\b', read(draft))
canonical = 'ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsRightModeAlgebraic.lean'
assert not (repo / canonical).exists()
evidence = ['AcousticsRightModeAlgebraic.lean', 'candidate.lean', 'first-elaboration.txt',
            'first-exit.json', 'input-receipt.json', 'reuse-searches.json',
            'source-reuse-domain-review.md', 'freeze.py']
receipt = {
    'status': 'scratch_checked_separate_canonical_draft_ready',
    'source_sha256': sha(source),
    'canonical_draft': {'path': canonical, 'draft': draft.name, 'sha256': sha(draft),
                        'lines': len(read(draft).splitlines()), 'line_endings': 'LF'},
    'new_declarations': [expected_declarations[-1]],
    'reused_exact_checked_declarations': expected_declarations[:-1],
    'actual_native_exit': native_exit,
    'proof_axioms': ['propext', 'Classical.choice', 'Quot.sound'],
    'canonical_import_status': 'three existing canonical imports elaborated in scratch; production placement/build pending root',
    'failed_lean_runs': [],
    'source_audit_status': 'not rerun; frozen nonaccepted undetermined original retained',
    'physical_negative_parameter_admissibility': 'not asserted',
    'production_mutations': [],
    'evidence': [{'path': path, 'sha256': sha(base / path)} for path in evidence],
}
write_once(base / 'final-verification.json', receipt)
print(json.dumps({'receipt_sha256': sha(base / 'final-verification.json'),
                  'draft_sha256': sha(draft), 'candidate_sha256': sha(base / 'candidate.lean'),
                  'output_sha256': sha(base / 'first-elaboration.txt'),
                  'review_sha256': sha(base / 'source-reuse-domain-review.md'),
                  'lines': receipt['canonical_draft']['lines'], 'native_lean_exit': native_exit['exit_code']}, indent=2))
