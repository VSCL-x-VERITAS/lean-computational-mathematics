"""Capture a native Lean check; no Git, audit, gate, or released-tool invocation."""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
assert os.name == 'nt'
label = sys.argv[1]
assert label.startswith('native-') and label[7:].isdigit()
out = D / label
out.mkdir()
core = R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformation.lean'
assert sha(core) == 'ba7190f2a87957bbe87ba2c095398cb56106a06f71e70480d89f98f4eff990ec'
project_modules = [
    'FiniteVolume/LocalRiemannInformation',
    'FiniteVolume/Examples/LeftStateInformationFlux',
    'FiniteVolume/Examples/StationaryRiemannField',
    'FiniteVolume/LinearRectangleRiemannInterface',
    'FiniteVolume/RiemannInformationFluxMethod',
    'FiniteVolume/RiemannFieldFluxMethodInformation',
    'FiniteVolume/RiemannInterface',
    'FiniteVolume/RiemannData',
    'FiniteVolume/CellVolumeAverage',
    'FiniteVolume/CellAverageTraceEstimate',
    'ConservationLaws/Hyperbolicity',
    'ConservationLaws/Rectangle',
]
paths = [D / 'Candidate.lean', R / 'lean-toolchain', R / 'lake-manifest.json', core]
for module in project_modules:
    rel = 'ComputationalMathematics/Analysis/PartialDifferentialEquations/' + module
    paths += [R / (rel + '.lean'), R / '.lake/build/lib/lean' / (rel + '.olean')]
for module in ['Analysis/Normed/Group/Constructions', 'Analysis/Normed/MulAction']:
    paths += [R / '.lake/packages/mathlib/Mathlib' / (module + '.lean'),
              R / '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib' / (module + '.olean')]
records = []
for p in sorted(set(paths)):
    assert p.is_file(), p
    records.append({'path': p.relative_to(R).as_posix(), 'sha256_before': sha(p)})
(out / 'Candidate.lean.snapshot').write_bytes((D / 'Candidate.lean').read_bytes())
lake = 'C:/Users/qed_s/.elan/bin/lake.EXE'
argv = [lake, 'env', 'lean', (D / 'Candidate.lean').relative_to(R).as_posix()]
started = datetime.now(timezone.utc).isoformat()
clock = time.monotonic()
with (out / 'output.txt').open('xb') as handle:
    result = subprocess.run(argv, cwd=R, stdout=handle, stderr=subprocess.STDOUT)
for record in records:
    record['sha256_after'] = sha(R / record['path'])
receipt = {'schema': 1, 'argv': argv, 'cwd': str(R), 'exit_code': result.returncode,
           'started_at_utc': started, 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
           'elapsed_seconds': time.monotonic() - clock,
           'output_sha256': sha(out / 'output.txt'),
           'input_snapshot_sha256': sha(out / 'Candidate.lean.snapshot'),
           'inputs': records, 'inputs_unchanged': all(r['sha256_before'] == r['sha256_after'] for r in records),
           'runner_sha256': sha(Path(__file__)), 'native_lake': lake,
           'git_invocations': 0, 'model_role_invocations': 0}
with (out / 'receipt.json').open('xb') as handle:
    handle.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps({k: v for k, v in receipt.items() if k != 'inputs'}, indent=2))
if result.returncode:
    sys.stdout.buffer.write((out / 'output.txt').read_bytes())
assert receipt['inputs_unchanged']
raise SystemExit(result.returncode)
