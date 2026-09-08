"""Scratch-only native checking; every attempt retains source and raw output."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, re, subprocess, sys, time
sys.stdout.reconfigure(encoding='utf-8')
assert os.name == 'nt'
P = Path(__file__).resolve().parent
R = P.parents[4]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
label, filename = sys.argv[1:3]
assert re.fullmatch('[a-z0-9-]+', label)
source = P / filename
assert source.parent == P and source.suffix == '.lean' and source.is_file()
out, receipt, snapshot = [P / (label + suffix) for suffix in ['-output.txt', '-exit.json', '-input.lean']]
assert not any(p.exists() for p in [out, receipt, snapshot])
snapshot.write_bytes(source.read_bytes())
relative_inputs = [
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean',
 '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/Average.lean',
 '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/Bochner/Set.lean',
 '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean',
 '.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean',
 '.lake/packages/mathlib/Mathlib/Analysis/SpecialFunctions/Integrals/Basic.lean',
 'lean-toolchain', 'lake-manifest.json']
inputs = [R / p for p in relative_inputs] + [source, P / 'run.py']
hashes = {p.relative_to(R).as_posix(): sha(p) for p in inputs}
assert (R/'lean-toolchain').read_text().strip() == 'leanprover/lean4:v4.29.0-rc3'
assert next(x for x in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if x['name']=='mathlib')['rev'] == 'e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
cmd = ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', str(source)]
start = datetime.now(timezone.utc).isoformat()
tick = time.monotonic()
with out.open('xb') as f:
 run = subprocess.run(cmd, cwd=R, stdout=f, stderr=subprocess.STDOUT)
unchanged = hashes == {p.relative_to(R).as_posix(): sha(p) for p in inputs}
record = dict(command=cmd, cwd=str(R), started_at_utc=start,
 completed_at_utc=datetime.now(timezone.utc).isoformat(), elapsed_ms=int(1000*(time.monotonic()-tick)),
 exit_code=run.returncode, input_sha256=hashes, inputs_unchanged=unchanged,
 snapshot_sha256=sha(snapshot), output_sha256=sha(out))
receipt.write_bytes((json.dumps(record, indent=2)+'\n').encode())
print(json.dumps(record), flush=True)
if run.returncode: print(out.read_text(encoding='utf-8'), flush=True)
assert unchanged
sys.exit(run.returncode)
