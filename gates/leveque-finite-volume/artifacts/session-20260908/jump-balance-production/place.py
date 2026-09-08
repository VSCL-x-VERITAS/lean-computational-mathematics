"""Create the six reviewed canonical leaves from exact frozen drafts, once only."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(b):return hashlib.sha256(b).hexdigest()
def load(p,h):
 b=p.read_bytes();assert sha(b)==h;return b.decode().replace('\r\n','\n')
mi=load(S/'material-interface-general-draft/candidate.lean','6f4ff70e5aa05fb68f1d68dc8a809468cd4de25fb0bacec83d17d020ffb99957')
ba=load(S/'nonconservation-integral-source-draft/RectangleBalance.lean','991452bbf04ad34dfafada3782e9c21085db5721ca14e97dfbebcad8e7e601cd')
def between(s,a,b):return s[s.index(a):s.index(b)].rstrip()+'\n'
def header(imports,title,doc,namespace,opens=''):
 return '/-\nSPDX-License-Identifier: MIT\n-/\n\n'+''.join('import '+i+'\n' for i in sorted(imports))+'\n/-!\n# '+title+'\n\n'+doc+'\n-/\n\n'+opens+'namespace '+namespace+'\n\n'
def finish(text,ns):return text.rstrip()+'\n\nend '+ns+'\n'
base='ComputationalMathematics.Analysis.PartialDifferentialEquations.'
files={}
jump=header(['Mathlib.Topology.Instances.Real.Lemmas','Mathlib.Topology.Constructions.SumProd'],
 'Distinct one-sided traces on the real line',
 'A jump records distinct left and right limits, independently of the value at the point.\nBoth component inequalities are retained when pairing two jumps.',
 'NumStability','open Filter Set\nopen scoped Topology\n\n')
jump+=between(mi,'/-- A jump has existing','theorem hasJumpAt_of_isRiemannData')
prod=between(mi,'theorem materialStateInterface_iff_product_traces','theorem HasMaterialStateInterfaceAt.discontinuous')
prod=prod.replace('materialStateInterface_iff_product_traces','hasJumpAt_and_iff_product_traces')
prod=prod.replace('    HasMaterialStateInterfaceAt medium initialState a\n        leftMaterial rightMaterial leftState rightState ↔',
 '    (HasJumpAt medium a leftMaterial rightMaterial ∧\n      HasJumpAt initialState a leftState rightState) ↔')
jump+='/-- Pairing one-sided traces preserves both component jumps, not only pair inequality. -/\n'+prod
files['ComputationalMathematics.Topology.Order.Jump']=finish(jump,'NumStability')
bridge=header([base+'FiniteVolume.RiemannDataRegularity','ComputationalMathematics.Topology.Order.Jump'],
 'Jumps of Riemann data','Distinct constant-side data has a jump at zero. The origin value remains free.', 'NumStability')
bridge+='/-- The existing one-sided Riemann limits give a jump when the states differ. -/\n'
bridge+=between(mi,'theorem hasJumpAt_of_isRiemannData','/-- Both components jump').replace('hasJumpAt_of_isRiemannData','IsRiemannData.hasJumpAt')
files[base+'FiniteVolume.RiemannDataJump']=finish(bridge,'NumStability')
ex=header([base+'FiniteVolume.RiemannDataJump','Mathlib.Analysis.Calculus.Deriv.Basic'],
 'Local interfaces without global material constancy',
 'These examples distinguish two component jumps from a single product jump.\nThey impose no material law or wave dynamics.',
 'NumStability.LocalMaterialInterface','open Filter Set\nopen scoped Topology\n\n')
ex+=between(mi,'/-- A varying medium','/-- Substantive instance')
witness=between(mi,'/-- Substantive instance','/-- A jump of the pair alone')
witness=witness.replace('    HasMaterialStateInterfaceAt (varyingMedium originMaterial)\n        (riemannData (2 : ℝ) originState 3) 0 0 1 2 3 ∧',
 '    (HasJumpAt (varyingMedium originMaterial) 0 0 1 ∧\n+      HasJumpAt (riemannData (2 : ℝ) originState 3) 0 2 3) ∧'.replace('\n+','\n'))
witness=witness[:witness.index('  have hm :=')]+'''  have hm := varyingMedium_hasJumpAt originMaterial
  have hq := riemannData_isRiemannData (2 : ℝ) originState 3
  have hj := hq.hasJumpAt (by norm_num)
  exact ⟨⟨hm, hj⟩, hq, hm.not_continuousAt, hj.not_continuousAt,
    varyingMedium_not_isRiemannData originMaterial,
    by simp [varyingMedium], by simp⟩
'''
ex+=witness
counter=between(mi,'/-- A jump of the pair alone','end NumStability.MaterialInterfaceDraft')
counter=counter.replace('      ¬ HasMaterialStateInterfaceAt (fun _ => (0 : ℝ))\n        (riemannData (0 : ℝ) originState 1) 0 0 0 0 1 := by',
 '      ¬ (HasJumpAt (fun _ => (0 : ℝ)) 0 0 0 ∧\n        HasJumpAt (riemannData (0 : ℝ) originState 1) 0 0 1) := by')
ex+=counter
files[base+'InitialValue.Examples.LocalMaterialInterface']=finish(ex,'NumStability.LocalMaterialInterface')
core=header([base+'ConservationLaws.Rectangle'], 'Rectangle balance with internal production',
 'Only bounded-interval integrability is required. Internal production has no sign\nconstraint. The defining identity uses time-integrated production and boundary exchange.',
 'NumStability','open MeasureTheory\n\n')
core+=between(ba,'variable {E : Type*}','/-- The a.e. mass-rate statement')
core=core.replace('theorem zero_source_iff_conservation','theorem isRectangleBalanceLawSolution_zero_iff')
files[base+'ConservationLaws.RectangleBalance']=finish(core,'NumStability')
deriv=header([base+'ConservationLaws.RectangleBalance',
 'ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation'],
 'Temporal mass derivatives with internal production',
 'For finite real vectors, rectangle balance gives the mass-rate identity almost\neverywhere in time. The exceptional null set may depend on the fixed spatial interval.',
 'NumStability','open MeasureTheory\n\n')
deriv+=between(ba,'/-- The a.e. mass-rate statement','section Examples')
files[base+'ConservationLaws.RectangleBalanceTemporalDerivative']=finish(deriv,'NumStability')
pex=header([base+'ConservationLaws.RectangleBalance',base+'ConservationLaws.BalanceLaw',
 base+'FiniteVolume.RiemannDataRegularity',base+'FiniteVolume.LinearRiemannSolution'],
 'Linear production with discontinuous spatial profiles',
 'Arbitrary locally integrable profiles admit linear growth or depletion with zero\nflux. A stationary spatial step supplies nonzero integrated production without\nrequiring spatial state differentiability.', 'NumStability','open MeasureTheory\n\n')
pex+='variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n'
pex+=between(ba,'section Examples','noncomputable def stationaryStep')
tail=between(ba,'theorem stationaryStep_unitCell','end NumStability.IntegralSourceDraft')
tail=tail.replace('linear_amplitude_balance stationaryStep stationaryStep_integrable 1',
 'linear_amplitude_balance (riemannData (0 : ℝ) 0 1)\n      (riemannData_intervalIntegrable 0 0 1) 1')
tail=tail.replace('[one_mul, stationaryStep]','[one_mul]')
tail=tail.replace('stationaryStep_unitCell','riemannStep_unitCell').replace('stationaryStep_signed_source_integral','riemannStep_signed_source_integral').replace('stationaryStep_source_nonvacuity','riemannStep_source_nonvacuity')
tail=tail.replace('stationaryStep','(riemannData (0 : ℝ) 0 1)')
pex+=tail
renames={'linear_amplitude_balance':'linearAmplitude_isRectangleBalanceLawSolution',
 'linear_amplitude_mass_derivative':'linearAmplitude_hasDerivAt_mass',
 'linear_amplitude_classical_balance':'linearAmplitude_isBalanceLawSolutionAt'}
for a,b in renames.items():pex=pex.replace(a,b)
files[base+'ConservationLaws.Examples.LinearProduction']=finish(pex,'NumStability')
assert len(files)==6
for module,text in files.items():
 path=R/(module.replace('.','/')+'.lean');assert not path.exists(),path
 path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(text.encode('utf-8'))
manifest={'input_commit':'1039d1b103f71c63052002803e46e779776b067d',
 'frozen_inputs':{'material-interface-general-draft/candidate.lean':sha((S/'material-interface-general-draft/candidate.lean').read_bytes()),
 'nonconservation-integral-source-draft/RectangleBalance.lean':sha((S/'nonconservation-integral-source-draft/RectangleBalance.lean').read_bytes())},
 'created':[{'module':m,'path':m.replace('.','/')+'.lean','initial_sha256':sha(s.encode())} for m,s in files.items()]}
(P/'initial-placement.json').write_bytes((json.dumps(manifest,indent=2)+'\n').encode())
print(json.dumps(manifest,indent=2))
