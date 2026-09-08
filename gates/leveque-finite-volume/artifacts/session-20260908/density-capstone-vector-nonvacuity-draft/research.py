from pathlib import Path
from hashlib import sha256
import json
import subprocess

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
assert not (HERE / 'reuse.json').exists()
searches = [
    ['rg', '-n', 'linearAmplitude_isRectangleBalanceLawSolution|riemannStep_signed_source_integral|riemannStep_unitCell',
     'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/LinearProduction.lean'],
    ['rg', '-n', 'theorem riemannData_intervalIntegrable|def riemannData|def IsRiemannData',
     'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean',
     'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean'],
    ['rg', '-n', 'theorem integral_smul_const|theorem integral_smul|theorem integral_const',
     '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean'],
]
records = []
for index, command in enumerate(searches, 1):
    run = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = HERE / f'search-{index:02}.txt'
    output.write_bytes(run.stdout)
    records.append(dict(command=command, cwd=str(REPO), exit_code=run.returncode,
                        output=str(output), output_sha256=sha256(run.stdout).hexdigest()))
inputs = [SESSION / 'prospective-density-material-riemann-capstones-draft/Capstones.lean',
          SESSION / 'prospective-density-material-riemann-capstones-draft/MeasureSupplement.lean',
          SESSION / 'prospective-density-material-riemann-capstones-draft/evidence-manifest.json',
          SESSION / 'batch9-capstone-independent-review/final-receipt.json',
          SESSION / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf',
          REPO / 'lean-toolchain', REPO / 'lake-manifest.json']
for command in searches:
    inputs += [REPO / item for item in command[3:]]
data = dict(scope='Narrow finite-vector instantiation of the exact frozen prospective target; no source interpretation.',
            searches=records,
            inputs=[dict(path=str(p), sha256=sha256(p.read_bytes()).hexdigest()) for p in dict.fromkeys(inputs)],
            selected=['Existing generic linearAmplitude producer supplies all actual rectangle-balance hypotheses.',
                      'Existing generic riemannData_intervalIntegrable supplies the Fin 1 profile integrability.',
                      'Existing scalar signed rectangle integral plus Mathlib integral_smul_const supplies vector normalization.'],
            rejected=['Scalar-only fixtures are not literal Fin 1 instances of the positive-dimensional target.',
                      'No duplicate rectangle-balance or scalar step integral proof is needed.',
                      'A new source wrapper, singular-density convention or adoption is outside this task.'],
            limits='These named searches are scoped reuse evidence, not a global absence claim.')
(HERE / 'reuse.json').write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(output=str(HERE / 'reuse.json'), sha256=sha256((HERE / 'reuse.json').read_bytes()).hexdigest())))
