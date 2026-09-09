"""Native Lean declaration probe with exact source/compiled-input provenance."""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p/'lean-toolchain').is_file())
M = R/'.lake/packages/mathlib'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
label = sys.argv[1]
assert os.name == 'nt' and label.startswith('native-') and label[7:].isdigit()
out = D/label
out.mkdir()
modules = [
    'MeasureTheory/Measure/Restrict',
    'MeasureTheory/Measure/Real',
    'MeasureTheory/Integral/IntegrableOn',
    'MeasureTheory/Function/L1Space/Integrable',
    'MeasureTheory/Function/L1Space/HasFiniteIntegral',
    'MeasureTheory/Function/L1Space/AEEqFun',
    'MeasureTheory/Function/StronglyMeasurable/AEStronglyMeasurable',
    'MeasureTheory/Function/StronglyMeasurable/Basic',
    'MeasureTheory/Function/SimpleFunc',
    'MeasureTheory/Function/SimpleFuncDenseLp',
    'MeasureTheory/Integral/Lebesgue/Basic',
    'MeasureTheory/Integral/Bochner/L1',
    'MeasureTheory/Integral/Bochner/Basic',
    'Analysis/Normed/Operator/Extend',
]
paths = [D/'Operators.lean', R/'lean-toolchain', R/'lake-manifest.json']
for module in modules:
    source = M/'Mathlib'/(module + '.lean')
    compiled = M/'.lake/build/lib/lean/Mathlib'/(module + '.olean')
    assert source.is_file() and compiled.is_file()
    paths += [source, compiled]
    for suffix in ('.private', '.server'):
        extra = Path(str(compiled) + suffix)
        if extra.exists():
            paths.append(extra)
records = [{'path': p.relative_to(R).as_posix(), 'sha256_before': sha(p)} for p in paths]
with (out/'Operators.lean.snapshot').open('xb') as handle:
    handle.write((D/'Operators.lean').read_bytes())
lake = shutil.which('lake')
assert lake and lake.lower().endswith('lake.exe')
command = [lake, 'env', 'lean', (D/'Operators.lean').relative_to(R).as_posix()]
started = datetime.now(timezone.utc).isoformat()
clock = time.monotonic()
with (out/'output.txt').open('xb') as handle:
    result = subprocess.run(command, cwd=R, stdout=handle, stderr=subprocess.STDOUT)
for record in records:
    record['sha256_after'] = sha(R/record['path'])
receipt = {'schema': 1, 'command': command, 'cwd': str(R), 'exit_code': result.returncode,
           'started_at_utc': started, 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
           'elapsed_seconds': time.monotonic()-clock, 'output_sha256': sha(out/'output.txt'),
           'input_snapshot_sha256': sha(out/'Operators.lean.snapshot'), 'inputs': records,
           'inputs_unchanged': all(x['sha256_before'] == x['sha256_after'] for x in records),
           'runner_sha256': sha(Path(__file__)), 'native_lake': lake,
           'git_invocations': 0, 'model_role_invocations': 0}
with (out/'receipt.json').open('xb') as handle:
    handle.write((json.dumps(receipt, indent=2)+'\n').encode())
print(json.dumps(receipt, indent=2))
if result.returncode:
    sys.stdout.buffer.write((out/'output.txt').read_bytes())
assert receipt['inputs_unchanged']
raise SystemExit(result.returncode)
