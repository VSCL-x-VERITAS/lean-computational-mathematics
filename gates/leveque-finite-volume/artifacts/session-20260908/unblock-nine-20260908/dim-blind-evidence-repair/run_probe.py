from pathlib import Path
import hashlib, json, subprocess, time

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / 'lean-toolchain').is_file())
LAKE = Path('C:/Users/qed_s/.elan/bin/lake.EXE')
def ref(path):
    b = path.read_bytes()
    return {'path':str(path), 'sha256':hashlib.sha256(b).hexdigest(), 'bytes':len(b)}
owners = [
    ROOT/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RefiningLineMethod.lean',
    ROOT/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/LocalRectangleReference.lean',
    ROOT/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean',
    ROOT/'lean-toolchain', ROOT/'lake-manifest.json', HERE/'Probe.lean', LAKE,
]
before = [ref(p) for p in owners]
output = HERE/'native-01-output.txt'
receipt = HERE/'native-01-receipt.json'
if output.exists() or receipt.exists(): raise SystemExit('Refusing overwrite')
command = [str(LAKE), 'env', 'lean', str(HERE/'Probe.lean')]
start = time.time()
result = subprocess.run(command,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
output.write_bytes(result.stdout)
after = [ref(p) for p in owners]
payload = {'format':'proof-free-blind-evidence-diagnostic-1','command':command,'cwd':str(ROOT),
 'actual_exit_code':result.returncode,'elapsed_ms':round((time.time()-start)*1000),
 'inputs_before':before,'inputs_after':after,'inputs_unchanged':before==after,'output':ref(output),
 'scope':'Artifact-only native diagnostic; no audit launch or changed sealed packet.'}
receipt.write_text(json.dumps(payload,indent=2)+'\n',encoding='utf-8')
print(json.dumps(payload,indent=2))
raise SystemExit(result.returncode)
