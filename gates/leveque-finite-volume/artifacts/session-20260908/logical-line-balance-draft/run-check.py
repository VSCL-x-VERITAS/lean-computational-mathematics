"""Capture native Lean output and exact scratch input; unique labels are mandatory."""
from pathlib import Path
import argparse, hashlib, json, os, shutil, subprocess, time

assert os.name == 'nt'
task = Path(__file__).resolve().parent
repo = task.parents[4]
p = argparse.ArgumentParser(description=__doc__)
p.add_argument('label'); p.add_argument('file', nargs='?', default='candidate.lean')
a = p.parse_args()
assert a.label.replace('-', '').isalnum()
source = task / a.file
snapshot, out, exitfile = [task / (a.label + s) for s in ['-input.lean', '-output.txt', '-exit.json']]
assert not any(p.exists() for p in [snapshot, out, exitfile])
snapshot.write_bytes(source.read_bytes())
argv = [shutil.which('lake'), 'env', 'lean', str(snapshot.relative_to(repo))]
head = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'rev-parse', 'HEAD'], cwd=repo).decode().strip()
start = time.monotonic()
with out.open('wb') as stream:
    result = subprocess.run(argv, cwd=repo, stdout=stream, stderr=subprocess.STDOUT)
receipt = {'argv': argv, 'working_directory': str(repo), 'input_commit': head,
           'input': str(snapshot), 'input_sha256': hashlib.sha256(snapshot.read_bytes()).hexdigest(),
           'output': str(out), 'output_sha256': hashlib.sha256(out.read_bytes()).hexdigest(),
           'exit_code': result.returncode, 'elapsed_ms': int((time.monotonic() - start) * 1000)}
exitfile.write_bytes((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
raise SystemExit(result.returncode)
