"""Native capture, existing POSIX launcher, one gate invocation, 180s limit."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

folder = Path(__file__).resolve().parent
workspace = folder.parents[2]
launcher = workspace / 'workflow-v5.0.1-local/run_workflow_posix.py'
gate = workspace / 'lean-computational-mathematics/gates/leveque-finite-volume/chapter-01.json'
release = workspace / 'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
paths = [launcher, gate, release, folder / 'profile-gate.py', Path(__file__)]
def hashes():
    return {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
before = hashes()
assert before[str(gate)] == 'e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0'
command = [sys.executable, '-B', str(launcher), str(folder / 'profile-gate.py'), str(release), str(gate)]
start = time.perf_counter()
with (folder / 'stdout.txt').open('xb') as out, (folder / 'stderr.txt').open('xb') as err:
    result = subprocess.run(command, stdout=out, stderr=err, timeout=180, check=False, cwd=workspace)
elapsed = time.perf_counter() - start
after = hashes()
receipt = {'command': command, 'diagnostic_limit_seconds': 180, 'exit_code': result.returncode,
           'elapsed_seconds_including_launcher': elapsed, 'before': before, 'after': after,
           'all_selected_inputs_unchanged': before == after,
           'stdout_sha256': hashlib.sha256((folder / 'stdout.txt').read_bytes()).hexdigest(),
           'stderr_sha256': hashlib.sha256((folder / 'stderr.txt').read_bytes()).hexdigest(),
           'scope': 'One read-only released gate check with cProfile and runtime Git trace2; no gate/config/release writes.'}
(folder / 'run-exit.json').write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
print(json.dumps(receipt))
raise SystemExit(result.returncode)
