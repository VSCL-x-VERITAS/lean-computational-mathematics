"""Prepare a thin Eq. (1.10) draft under the already recorded discontinuity convention."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];D=S/'equation10-rectangle-draft'
assert not D.exists();D.mkdir()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
user=S/'user-discontinuity-interpretation-20260908.json'
assert sha(user)=='b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
old=S/'audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908'
assert sha(old/'faithfulness/decision.json')=='be89b5bf7e066c64e3b24292d96d997d879ddb5c5342de79936263cf9ce9a052'
assert sha(old/'root-recovery-verification.json')=='3ed3022f187ca9a64d2c12f8dea7ae279a556c13c1c4cfede15cc3a72d9dbf53'
searches=[]
for label,cmd in [
 ('project',['rg','-n','hasDerivAt_mass_ae|rectangleConservation.*iff|Equation10Rectangle|exists_discontinuous_rectangle_field','ComputationalMathematics/Analysis','ComputationalMathematics/Source/LeVeque/Chapter01']),
 ('mathlib',['rg','-n','ae_hasDerivAt_integral|hasDerivAt_integral_of_tendsto_ae|intervalIntegral.*ae','\\.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral'.lstrip('\\')])]:
 p=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 (D/(label+'-search-output.txt')).write_bytes(p.stdout)
 (D/(label+'-search-stderr.txt')).write_bytes(p.stderr)
 assert p.returncode in (0,1),(cmd,p.returncode,p.stderr)
 searches.append({'label':label,'command':cmd,'actual_exit_code':p.returncode,'stdout_sha256':hashlib.sha256(p.stdout).hexdigest(),'stderr_sha256':hashlib.sha256(p.stderr).hexdigest()})
code='''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump

/-!
# Draft: equation (1.10) with the recorded discontinuity interpretation

Rectangle conservation is the adopted solution predicate. Its finite-interval
integrability and time-integrated balance imply the displayed mass-rate identity
almost everywhere for each fixed spatial interval. The exceptional set may
depend on the interval. This draft does not assert a source-audit verdict.
-/

open MeasureTheory

namespace NumStability.Equation10RectangleDraft

theorem rectangleConservation_iff_integrated_and_ae_rate
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) :
    IsRectangleConservationLawSolution q flux ↔
      (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
      (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
      (∀ a b s t,
        (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
          ∫ τ in s..t, (flux (q a τ) - flux (q b τ))) ∧
      (∀ a b, ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
        (flux (q a t) - flux (q b t)) t) := by
  constructor
  · intro h
    exact ⟨h.1, h.2.1, h.2.2, h.hasDerivAt_mass_ae⟩
  · intro h
    exact ⟨h.1, h.2.1, h.2.2.1⟩

end NumStability.Equation10RectangleDraft
'''
candidate=D/'candidate.lean';candidate.write_text(code,encoding='utf-8',newline='\n')
names=['NumStability.Equation10RectangleDraft.rectangleConservation_iff_integrated_and_ae_rate','NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae','NumStability.exists_discontinuous_rectangle_field']
checks=code+'\n'+''.join('#check '+n+'\n#print axioms '+n+'\n' for n in names)
(D/'checks.lean').write_text(checks,encoding='utf-8',newline='\n')
paths=['ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TemporalDerivative.lean','ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean','ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiation.lean','ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/MovingRiemannJump.lean']
record={'schema':1,'candidate_sha256':sha(candidate),'checks_sha256':sha(D/'checks.lean'),'declarations_checked':names,'searches':searches,'reused_producers':[{'path':p,'sha256':sha(R/p)} for p in paths],'source_sha256':'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5','user_receipt_sha256':sha(user),'original_decision_sha256':sha(old/'faithfulness/decision.json'),'interpretation_scope':'The actual user adopted rectangle conservation and an almost-everywhere mass-rate identity for Chapter 1 discontinuity discussion around (1.10), particularly the separate discontinuity row. This source wrapper uses those exact conventions for (1.10); it introduces no additional user choice.','selection':'Reuse the checked general temporal derivative producer; no duplicate differentiation theorem. Keep integrated balance explicitly because an a.e. derivative identity alone does not imply absolute continuity or conservation.','limitations':['Not a claim that arbitrary q is conserved.','No every-time derivative or common exceptional set for all spatial intervals.','No classical-state regularity conclusion.','No new source-faithfulness decision; old pointwise predicate and audit remain unchanged.']}
(D/'inputs.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'candidate_sha256':sha(candidate),'inputs_sha256':sha(D/'inputs.json'),'search_exits':[r['actual_exit_code'] for r in searches]}))

