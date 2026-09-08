"""Extract the already checked construction into new semantic owners."""
from pathlib import Path
import hashlib
import json
import re

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[4]
source = HERE.parent / 'shock-continuation/candidate.lean'
assert hashlib.sha256(source.read_bytes()).hexdigest() == 'ba18e8fc4caadc0d6e46128bb09d1e4a34cf873d59e25676241f4b5389854027'
text = source.read_text(encoding='utf-8-sig').split('\n#check')[0].rstrip()
matches = list(re.finditer(r'^(def|theorem) ([A-Za-z0-9_]+)', text, re.MULTILINE))
starts = []
for m in matches:
    start = m.start()
    doc = text.rfind('/--', 0, start)
    if doc >= 0 and re.fullmatch(r'/--[\s\S]*?-/\s*', text[doc:start]):
        if text.find('-/', doc) == text[doc:start].rfind('-/') + doc:
            start = doc
    starts.append(start)
blocks = {}
for i,m in enumerate(matches):
    stop = starts[i+1] if i+1<len(starts) else len(text)
    blocks[m.group(2)] = text[starts[i]:stop].strip()
modules = []
mapping = {}

def write(path, title, doc, imports, names, namespace='NumStability.HuberShock', extra=''):
    target=REPO/(path+'.lean')
    assert not target.exists(), target
    body='\n\n'.join(blocks[n] for n in names)
    header='/-\nSPDX-License-Identifier: MIT\n-/\n\n'
    header+='\n'.join('import '+i for i in imports)+'\n\n'
    header+=f'/-!\n# {title}\n\n{doc}\n-/\n\n'
    header+='open MeasureTheory Set Filter\nopen scoped Topology\n\n'
    header+=f'namespace {namespace}\n\nnoncomputable section\n\n'
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_text(header+body+'\n\n'+extra+f'\nend\n\nend {namespace}\n',encoding='utf-8')
    modules.append(path.replace('/','.'))
    for n in names:
        mapping['NumStability.ShockContinuation.'+n]={'producer':namespace+'.'+n,'module':modules[-1]}

flux = ['huberSlope','huberFlux','huberSlope_continuous','huberSlope_of_abs_le','huberSlope_of_ge','huberSlope_of_le','hasDerivAt_huberFlux','huberFlux_contDiff_one','huberFlux_of_abs_le','huberFlux_of_ge','huberFlux_of_le','huberFlux_formula','huberFlux_not_linear','huberFlux_convex']
write('ComputationalMathematics/Analysis/SpecialFunctions/Huber','The normalized Huber function and its derivative',
      'The primitive of the clipped identity is convex and C1, with a quadratic core\nand affine outer branches. Both clipping points have the asserted derivative.',
      ['Mathlib.Analysis.Convex.Deriv','Mathlib.Analysis.SpecialFunctions.Integrals.Basic','Mathlib.Analysis.Calculus.ContDiff.Deriv','Mathlib.Tactic'],flux,'NumStability',
      '''/-- The Huber function is not affine, so its conservation law is nonlinear. -/
theorem huberFlux_not_affine : ¬ ∃ a b : ℝ, ∀ q, huberFlux q = a * q + b := by
  rintro ⟨a, b, h⟩
  have hb : b = 0 := by simpa [huberFlux] using (h 0).symm
  apply huberFlux_not_linear
  exact ⟨a, fun q => by simpa [hb] using h q⟩
''')
write('ComputationalMathematics/Analysis/Calculus/Piecewise','Calculus for real piecewise functions',
      'One-sided derivatives at thresholds and matching derivative germs support\ncalculus for continuous piecewise formulas.',
      ['Mathlib.Analysis.Calculus.Deriv.Basic','Mathlib.Topology.Order.OrderClosed','Mathlib.Tactic'],
      ['hasDerivWithinAt_if_lt_right','hasDerivAt_if_of_eq','continuous_if_lt_of_closed'],'NumStability')
write('ComputationalMathematics/Analysis/Calculus/Deriv/Abs','The right derivative of absolute value',
      'The right derivative includes the value +1 at the origin.',
      ['Mathlib.Analysis.Calculus.Deriv.Abs','Mathlib.Tactic'],['hasDerivWithinAt_abs_right'],'NumStability')
write('ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/Piecewise','Interval integrability of piecewise functions',
      'Measurable pasting preserves integrability on every finite oriented interval.',
      ['Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic'],['intervalIntegrable_piecewise'],'NumStability')
base='ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw/Examples/HuberShock/'
mb=base.replace('/','.')
write(base+'Basic','A scalar shock profile for the Huber flux',
      'The central region contracts to the origin at time one. The initial field is\nthe smooth, unbounded function −x. The right trace is selected at the later shock.',
      ['ComputationalMathematics.Analysis.SpecialFunctions.Huber'],
      ['centralPotential','outerPotential','outerState','shockPotential','shockState','shockState_initial','shockState_initial_smooth','shockState_after','central_flux','outer_flux','potential_match','central_outer_state_match'])
write(base+'Potential','Temporal calculus for the Huber shock potential',
      'The continuous potential has right time derivative equal to minus the actual\ncomposed flux, including collapse and stationary-interface values.',
      [mb+'Basic','ComputationalMathematics.Analysis.Calculus.Piecewise','ComputationalMathematics.Analysis.Calculus.Deriv.Abs'],
      ['centralPotential_space_deriv','centralPotential_time_deriv','outerPotential_time_deriv','outerPotential_space_right_deriv','outerPotential_space_deriv','centralPotential_time_continuousOn','shockPotential_time_continuous','shockPotential_time_right_deriv'])
write(base+'Regularity','Spatial regularity of the Huber shock',
      'The state is continuous before collapse. The continuous potential has the\nstate as its right spatial derivative at every point and time.',
      [mb+'Potential'],
      ['shockPotential_space_continuous','outerState_space_continuousAt','shockState_continuous_before','shockPotential_space_right_deriv'])
write(base+'Jump','Jump traces and local admissibility of the Huber shock',
      'Distinct one-sided limits give a genuine jump. Equal fluxes, inward speeds,\nand the Oleinik chord inequality are local facts; no full spacetime entropy\ninequality or entropy uniqueness theorem is asserted here.',
      [mb+'Basic','Mathlib.Analysis.Convex.Jensen'],
      ['stationary_shock_flux_and_speeds','shockState_jump_traces','shockState_not_continuous_after','stationary_shock_oleinik'])
write(base+'Conservation','Rectangle conservation for the Huber shock',
      'Spatial and temporal integrability are proved independently. Applying FTC\nto the displayed potential then gives balance on every oriented rectangle.',
      [mb+'Regularity','ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.Piecewise','ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.Rectangle'],
      ['shockState_space_intervalIntegrable','clippedCentralState_continuous','shockState_flux_time_intervalIntegrable','shockState_mass_potential','shockState_flux_potential','shockState_rectangle_balance'],
      extra='''/-- The explicit field satisfies the shared conservation predicate. -/
theorem shockState_isRectangleConservationLawSolution :
    IsRectangleConservationLawSolution shockState huberFlux :=
  ⟨shockState_space_intervalIntegrable, shockState_flux_time_intervalIntegrable,
    shockState_rectangle_balance⟩
''')

sourcepath='ComputationalMathematics/Source/LeVeque/Chapter01/NonlinearShockFormation'
write(sourcepath,'LeVeque Chapter 1: shocks from smooth initial data',
      '''Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, printed
pages 4–5 (raw PDF pages 26–27). A nonlinear conservation law can develop a
discontinuity from smooth initial data. The proof uses a convex C1 Huber flux
and unbounded smooth initial data; these choices are not a displayed source example.
Conservation is expressed by the time-integrated rectangle law. No full entropy
test-function inequality is part of this statement.''',
      [mb+'Conservation',mb+'Jump'],[],'NumStability',
      '''/-- A nonlinear C1 flux admits a conserved field that starts smoothly, remains
spatially continuous before a positive time, and has distinct shock traces then. -/
theorem leveque01_nonlinear_shock_formation :
    ∃ (flux : ℝ → ℝ) (q : ℝ → ℝ → ℝ) (T ξ qL qR : ℝ),
      ContDiff ℝ 1 flux ∧
      (¬ ∃ a b : ℝ, ∀ u, flux u = a * u + b) ∧
      IsRectangleConservationLawSolution q flux ∧
      ContDiff ℝ ⊤ (fun x => q x 0) ∧
      0 < T ∧
      (∀ t, 0 ≤ t → t < T → Continuous (fun x => q x t)) ∧
      Tendsto (fun x => q x T) (𝓝[<] ξ) (𝓝 qL) ∧
      Tendsto (fun x => q x T) (𝓝[>] ξ) (𝓝 qR) ∧ qR < qL := by
  refine ⟨huberFlux, HuberShock.shockState, 1, 0, 1, -1,
    huberFlux_contDiff_one, huberFlux_not_affine,
    HuberShock.shockState_isRectangleConservationLawSolution,
    HuberShock.shockState_initial_smooth, by norm_num, ?_, ?_⟩
  · intro t _ ht
    exact HuberShock.shockState_continuous_before ht
  · exact HuberShock.shockState_jump_traces (by norm_num)
''')
mapping['NumStability.ShockContinuation.smooth_data_shock_example']={
    'producer':'NumStability.leveque01_nonlinear_shock_formation',
    'module':sourcepath.replace('/','.'),
    'disposition':'Existential source wrapper assembled from the concrete producers; no duplicated conjunction wrapper.'}
(HERE/'candidate-producer-map.json').write_text(json.dumps(mapping,indent=2)+'\n',encoding='utf-8')
(HERE/'modules.json').write_text(json.dumps(modules,indent=2)+'\n',encoding='utf-8')
print(json.dumps({m:len((REPO/(m.replace('.','/')+'.lean')).read_text(encoding='utf-8').splitlines()) for m in modules},indent=2))
