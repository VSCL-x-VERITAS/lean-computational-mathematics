"""Read-only scoped prerequisite searches; no audit/Git invocation."""
from pathlib import Path
import hashlib
import json
import subprocess

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p/'lean-toolchain').is_file())
M = R/'.lake/packages/mathlib/Mathlib'
searches = [
    ['rg', '-n', 'Measure.restrict|Integrable|integral_def|L1.integral',
     str(R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellVolumeAverage.lean')],
    ['rg', '-n', 'def Integrable|def HasFiniteIntegral|def AEStronglyMeasurable|def StronglyMeasurable|def toL1|theorem coeFn_toL1',
     str(M/'MeasureTheory/Function/L1Space/Integrable.lean'), str(M/'MeasureTheory/Function/L1Space/HasFiniteIntegral.lean'),
     str(M/'MeasureTheory/Function/L1Space/AEEqFun.lean'), str(M/'MeasureTheory/Function/StronglyMeasurable/AEStronglyMeasurable.lean'),
     str(M/'MeasureTheory/Function/StronglyMeasurable/Basic.lean')],
    ['rg', '-n', 'def integral|integral_eq_sum|integral_def|def restrict|theorem restrict_apply|def Measure.real|theorem extend_unique|theorem denseRange',
     str(M/'MeasureTheory/Measure/Restrict.lean'), str(M/'MeasureTheory/Measure/MeasureSpaceDef.lean'),
     str(M/'MeasureTheory/Integral/Bochner/Basic.lean'), str(M/'MeasureTheory/Integral/Bochner/L1.lean'),
     str(M/'Analysis/Normed/Operator/Extend.lean'), str(M/'MeasureTheory/Function/SimpleFuncDenseLp.lean')],
]
records = []
for index, command in enumerate(searches, 1):
    run = subprocess.run(command, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = D/f'search-{index:02}-output.txt', D/f'search-{index:02}-stderr.txt'
    with out.open('xb') as handle:
        handle.write(run.stdout)
    with err.open('xb') as handle:
        handle.write(run.stderr)
    records.append({'command': command, 'exit_code': run.returncode,
                    'stdout': {'path': out.relative_to(R).as_posix(), 'sha256': hashlib.sha256(run.stdout).hexdigest()},
                    'stderr': {'path': err.relative_to(R).as_posix(), 'sha256': hashlib.sha256(run.stderr).hexdigest()}})
    assert run.returncode in (0, 1) and not run.stderr
with (D/'searches.json').open('xb') as handle:
    handle.write((json.dumps({'scope': 'Listed producer and pinned Mathlib files only; no global absence claim.', 'searches': records}, indent=2)+'\n').encode())
print(json.dumps({'searches': len(records), 'exits': [row['exit_code'] for row in records]}))
