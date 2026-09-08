"""Place reviewed, compiled definition repairs; preserve all prior producers.

This creates Lean modules and a proof-check manifest, not audit acceptance.
Run through the prepared POSIX entry.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, re, subprocess

S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
def bind(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def write(p, text):
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open('x', encoding='utf-8', newline='\n') as f:
        f.write(text)
def writej(p, value):
    write(p, json.dumps(value, indent=2, ensure_ascii=True) + '\n')

draft = S / 'riemann-initial-value-hyperbolic-draft/GeneralFirstOrder.lean'
receipt = S / 'riemann-initial-value-hyperbolic-draft/final-evidence.json'
assert sha(draft) == '95729c14d90686a8a5cbbe67bea3ca62ab706c9c9bbc06f6499f84b5fe11ec6b'
assert sha(receipt) == '6a13b1cd5bfff65227422fe94b3527d457e03258b973431ca0342a3e0610ea7b'
e = read(receipt)
assert e['actual_exit_code'] == 0
for key in ['source', 'rejected_task', 'rejected_decision', 'rejected_report', 'draft', 'native_exit', 'native_output']:
    assert sha(R / e[key]['path']) == e[key]['sha256'], key
assert read(R / e['native_exit']['path'])['exit_code'] == 0
assert all(set(a) <= {'propext', 'Classical.choice', 'Quot.sound'} for a in e['checked_declarations'].values())
eqdraft = S / 'equation10-rectangle-draft/candidate.lean'
assert sha(eqdraft) == '275fea30369079d9324957387d70ba6eaacd980fd83ee736ca7be332270a7adb'
assert read(S / 'equation10-rectangle-draft-check-exit.json')['exit_code'] == 0
assert sha(S / 'user-discontinuity-interpretation-20260908.json') == 'b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
searches = []
for label, pattern, roots in [
    ('definition-repair-project-reuse', 'FirstOrderEquation|FirstOrderInitialValueProblem|structure InitialValueProblem|IsRealHyperbolicMatrix|hasDerivAt_mass_ae|isRiemannData_iff_exists_valueAtOrigin', ['ComputationalMathematics']),
    ('definition-repair-mathlib-reuse', 'FirstOrderEquation|FirstOrderInitialValueProblem|RiemannProblem|HyperbolicRiemann|hasDerivAt_primitive', ['.lake/packages/mathlib/Mathlib'])]:
    cmd = ['rg', '-n', pattern, *roots]
    p = subprocess.run(cmd, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    assert p.returncode in (0, 1)
    (S / (label + '-stdout.txt')).write_bytes(p.stdout)
    (S / (label + '-stderr.txt')).write_bytes(p.stderr)
    searches.append({'command': cmd, 'exit_code': p.returncode,
        'stdout': bind(S / (label + '-stdout.txt')), 'stderr': bind(S / (label + '-stderr.txt'))})
code = draft.read_text(encoding='utf-8')
first = code[code.index('/-- A concrete first-order'):code.index('/-- Existing differentiable conservation laws')]
first += 'end FirstOrderEquation\n\nend NumStability\n'
first_head = '''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# First-order quasilinear equations

An equation stores its admissible states, principal matrix and forcing.
Its residual expresses `q_t + A(x,t,q) q_x = b(x,t,q)`. Spectral hyperbolicity
uses that same matrix. The optional classical relation uses actual derivatives;
constant and spatially varying linear equations embed as special cases.
-/

namespace NumStability

variable {ι : Type*} [Fintype ι]

'''
initial = code[code.index('/-- An initial-value problem consists'):code.index('/-- An existing conservation-law problem embeds')]
initial = initial.replace('InitialValueProblem', 'FirstOrderInitialValueProblem')
initial += 'end NumStability\n'
initial_head = '''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann

/-!
# Riemann initial data for a first-order equation

A problem consists of its governing equation and initial field. The Riemann
data predicates require spectral hyperbolicity of the actual principal matrix
and admissible constant states on strict half-lines. The origin is free.
The broad two-state family and the distinct-jump family are separate predicates.
Problem classification does not assert existence or select a solution theory.
-/

namespace NumStability

variable {ι : Type*} [Fintype ι]

'''
eq = eqdraft.read_text(encoding='utf-8')
eq = eq[eq.index('theorem rectangleConservation_iff_integrated_and_ae_rate'):eq.index('end NumStability.Equation10RectangleDraft')]
eq = eq.replace('rectangleConservation_iff_integrated_and_ae_rate', 'leveque01_equation10_rectangleConservation_iff_integrated_and_ae_rate')
eq_head = '''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative

/-!
# LeVeque equation (1.10): rectangle conservation and the mass rate

The recorded user interpretation of the discontinuity discussion around (1.10)
uses rectangle conservation, with the displayed mass-rate identity almost
everywhere in time for each fixed spatial interval. The exceptional null set
may depend on that interval. The source does not explicitly state this analytic
convention; the interpretation receipt preserves that ambiguity.

The time-integrated balance is retained: an almost-everywhere derivative
identity alone does not imply rectangle conservation. This wrapper reuses the
general rectangle-law temporal derivative theorem for real finite vectors.
-/

open MeasureTheory

namespace NumStability

/-- Rectangle conservation with its integrated balance and intervalwise almost-everywhere mass rate. -/
'''
source = '''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann

/-!
# LeVeque Chapter 1: hyperbolic Riemann problem data

The governing object is a first-order equation with its actual principal matrix,
state domain and forcing. Its spectral condition concerns that same matrix.
Initial data are constant on each strict half-line, leaving the origin free.

The prose describes a jump while equation (1.11) does not require distinct
states. Both the broad two-state family and its distinct-jump subfamily are
displayed explicitly. This records the boundary without deciding which family
the source names a Riemann problem. No existence, uniqueness or solution
regularity theorem is asserted by this problem-data characterization.
-/

namespace NumStability

/-- Hyperbolic initial data, with the distinct-jump boundary made explicit. -/
theorem leveque01_riemannProblem_iff_hyperbolicInitialData
    {m : ℕ} (problem : FirstOrderInitialValueProblem (Fin m)) :
    (problem.IsRiemann ↔
      ∃ leftState rightState,
        (∀ x t state, state ∈ problem.governing.admissibleStates →
          ∃ (eigenvalues : Fin m → ℝ)
              (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
            ∀ p, (problem.governing.principal x t state).mulVec (eigenbasis p) =
              eigenvalues p • eigenbasis p) ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState)) ∧
    (problem.IsJumpRiemann ↔
      ∃ leftState rightState,
        problem.IsRiemannWithStates leftState rightState ∧ leftState ≠ rightState) :=
  ⟨problem.isRiemann_iff, Iff.rfl⟩

end NumStability
'''
files = {
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FirstOrderEquation.lean': first_head + first,
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/FirstOrderRiemann.lean': initial_head + initial,
 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation10RectangleConservation.lean': eq_head + eq + 'end NumStability\n',
 'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannHyperbolicProblem.lean': source}
for name in files:
    assert not (R / name).exists(), name
for name, text in files.items():
    assert 'Draft' not in text and '#check' not in text and '#print' not in text
    write(R / name, text)
aggregate = R / 'ComputationalMathematics/Source/LeVeque/Chapter01.lean'
before = aggregate.read_bytes()
old = aggregate.read_text(encoding='utf-8')
imports = re.findall(r'^import (\S+)$', old, re.M)
new_imports = [p[:-5].replace('/', '.') for p in files if '/Source/' in p]
assert not set(imports) & set(new_imports)
start = old.index('import ')
end = old.rindex('import ') + len('import ' + imports[-1])
updated = old[:start] + '\n'.join('import ' + name for name in sorted(imports + new_imports, key=str.casefold)) + old[end:]
(S / ('definition-aggregate-before-' + hashlib.sha256(before).hexdigest() + '.bin')).write_bytes(before)
aggregate.write_text(updated, encoding='utf-8', newline='\n')
decls = {
 list(files)[0]: ['NumStability.FirstOrderEquation.residual_eq_zero_iff', 'NumStability.FirstOrderEquation.constantLinear_classical_iff'],
 list(files)[1]: ['NumStability.FirstOrderInitialValueProblem.isRiemann_iff', 'NumStability.FirstOrderInitialValueProblem.isRiemannWithStates_iff_origin', 'NumStability.FirstOrderInitialValueProblem.fromEqualStates_not_isJumpRiemann'],
 list(files)[2]: ['NumStability.leveque01_equation10_rectangleConservation_iff_integrated_and_ae_rate'],
 list(files)[3]: ['NumStability.leveque01_riemannProblem_iff_hyperbolicInitialData']}
checks = ''.join('import ' + p[:-5].replace('/', '.') + '\n' for p in files) + '\n'
for names in decls.values():
    for name in names:
        checks += '#check ' + name + '\n#print axioms ' + name + '\n'
check = S / 'definition-repairs-production-checks.lean'
write(check, checks)
manifest = {'schema': 1, 'created_at_utc': datetime.now(timezone.utc).isoformat(),
    'input_commit': subprocess.check_output(['git', '-c', 'core.longpaths=true', 'rev-parse', 'HEAD'], cwd=R, text=True).strip(),
    'files': [{**bind(R / name), 'declarations': decls[name]} for name in files],
    'check_file_sha256': sha(check), 'aggregate': bind(aggregate), 'draft': bind(draft),
    'draft_receipt': bind(receipt), 'equation10_draft': bind(eqdraft), 'searches': searches,
    'reuse': ['IsRealHyperbolicMatrix', 'IsConstantCoefficientLinearSystemSolutionAt', 'IsRiemannData',
              'isRiemannData_iff_exists_valueAtOrigin', 'IsRectangleConservationLawSolution.hasDerivAt_mass_ae'],
    'rejected_candidates': ['Arbitrary equation predicate omits hyperbolicity',
         'Conservation-law problem type does not represent variable nonconservative first-order systems',
         'Every-time ordinary mass derivative excludes conservative moving jumps'],
    'disposition': 'Two reusable leaves and two thin source wrappers; existing declarations preserved. No semantic acceptance claimed.'}
writej(S / 'definition-repairs-production-inputs.json', manifest)
print(json.dumps({'manifest_sha256': sha(S / 'definition-repairs-production-inputs.json'), 'files': manifest['files']}))
