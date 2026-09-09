"""Prepare the generic update and its same-law local-field specialization."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
tail = (D / 'ScopedRiemannCapstoneTail.lean.txt').read_text(encoding='utf-8')
tail = tail[:tail.index('\n#check ScopedRiemannInformationDraft.local_interface_contract')]
tail = tail.replace('ScopedRiemannInformationDraft', 'NumStability.LocalRiemannInformation')
imports = ('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformation\n'
           'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds\n'
           '\nopen MeasureTheory\n')
generic = imports + tail + '\n#check NumStability.LocalRiemannInformation.local_interface_contract\n#print axioms NumStability.LocalRiemannInformation.local_interface_contract\n'
destination = D / 'LocalRiemannUpdateDraft.lean'
with destination.open('x', encoding='utf-8', newline='\n') as f:
    f.write(generic)
statement = tail[tail.index('theorem local_interface_contract'):tail.index(' := by\n')]
statement = statement.replace('theorem local_interface_contract', 'theorem leveque01_localRiemannInformationInterface_sourceContract')
original_inputs = '''    (oldDensity newDensity : ℝ → Fin m → ℝ) (physicalFlux : Face → ℝ → Fin m → ℝ)
    (holdDensity : IntervalIntegrable oldDensity volume a b)
    (hnewDensity : IntervalIntegrable newDensity volume a b)
    (hleftFlux : IntervalIntegrable (physicalFlux leftFace) volume s t)
    (hrightFlux : IntervalIntegrable (physicalFlux rightFace) volume s t)
    (hphysicalBalance : (∫ x in a..b, newDensity x) - (∫ x in a..b, oldDensity x) =
      ∫ τ in s..t, (physicalFlux leftFace τ - physicalFlux rightFace τ)) :'''
new_inputs = '''    (q : ℝ → ℝ → Fin m → ℝ) (faceLocation : Face → ℝ)
    (hleftLocation : faceLocation leftFace = a) (hrightLocation : faceLocation rightFace = b)
    (holdDensity : IntervalIntegrable (fun x => q x s) volume a b)
    (hnewDensity : IntervalIntegrable (fun x => q x t) volume a b)
    (hleftFlux : IntervalIntegrable (fun τ => law.flux (q a τ)) volume s t)
    (hrightFlux : IntervalIntegrable (fun τ => law.flux (q b τ)) volume s t)
    (hphysicalBalance : (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, (law.flux (q a τ) - law.flux (q b τ))) :'''
assert statement.count(original_inputs) == 1
statement = statement.replace(original_inputs, new_inputs)
statement = statement.replace('oldDensity', '(fun x => q x s)').replace('newDensity', '(fun x => q x t)')
# The replacements must affect expressions only, not the local evidence names.
statement = statement.replace('h(fun x => q x s)', 'holdDensity').replace('h(fun x => q x t)', 'hnewDensity')
statement = statement.replace('(physicalFlux leftFace)', '(fun τ => law.flux (q a τ))')
statement = statement.replace('(physicalFlux rightFace)', '(fun τ => law.flux (q b τ))')
proof = ''' := by
  simpa only [hleftLocation, hrightLocation] using
    (LocalRiemannInformation.local_interface_contract law method leftCell rightCell old hstates
      cell leftFace rightFace hleftCell hrightCell hab hst hdomain
      (fun x => q x s) (fun x => q x t) (fun face τ => law.flux (q (faceLocation face) τ))
      holdDensity hnewDensity
      (by simpa only [hleftLocation] using hleftFlux)
      (by simpa only [hrightLocation] using hrightFlux)
      (by simpa only [hleftLocation, hrightLocation] using hphysicalBalance))
'''
source = ('\nnamespace NumStability\nopen LocalRiemannInformation\n\n'
          '/-- Source-facing specialization: one physical law, actual ordered numerical inputs,\n'
          'and only the selected cell and finite time slab. Riemann flux accuracy is a\n'
          'conditional method specification; no entropy, uniqueness or convergence is claimed. -/\n'
          + statement + proof + '\nend NumStability\n'
          '#check NumStability.leveque01_localRiemannInformationInterface_sourceContract\n'
          '#print axioms NumStability.leveque01_localRiemannInformationInterface_sourceContract\n')
with (D / 'LocalRiemannSourceDraft.lean').open('x', encoding='utf-8', newline='\n') as f:
    f.write(imports + tail + source)
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
print(json.dumps({name: sha(D / name) for name in ('LocalRiemannUpdateDraft.lean', 'LocalRiemannSourceDraft.lean')}))
