"""Native focused build/check capture with exact snapshots of this placement's inputs."""
from pathlib import Path
import argparse, hashlib, json, os, shutil, subprocess, time
assert os.name == 'nt'
task = Path(__file__).resolve().parent
repo = task.parents[4]
p = argparse.ArgumentParser(description=__doc__)
p.add_argument('label'); p.add_argument('arguments', nargs='+')
a = p.parse_args()
assert a.label.replace('-', '').isalnum()
assert a.arguments[0] == 'build' or a.arguments[:2] == ['env', 'lean']
out, exitfile = task / (a.label + '-output.txt'), task / (a.label + '-exit.json')
assert not out.exists() and not exitfile.exists()
paths = [Path(r['path']) for r in json.loads((task / 'placement-initial.json').read_bytes())['new_files']]
if a.arguments[:2] == ['env', 'lean']: paths.append(repo / a.arguments[-1])
snapshots = task / 'snapshots'; snapshots.mkdir(exist_ok=True)
inputs = []
for path in paths:
    data = path.read_bytes(); digest = hashlib.sha256(data).hexdigest()
    snapshot = snapshots / (digest + '.lean')
    if snapshot.exists(): assert snapshot.read_bytes() == data
    else: snapshot.write_bytes(data)
    inputs.append({'path': str(path), 'sha256': digest, 'snapshot': str(snapshot)})
head = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'rev-parse', 'HEAD'], cwd=repo).decode().strip()
argv = [shutil.which('lake'), *a.arguments]
start = time.monotonic()
with out.open('wb') as stream:
    result = subprocess.run(argv, cwd=repo, stdout=stream, stderr=subprocess.STDOUT)
record = {'argv': argv, 'working_directory': str(repo), 'input_commit': head, 'inputs': inputs,
  'exit_code': result.returncode, 'elapsed_ms': int((time.monotonic() - start) * 1000),
  'output_sha256': hashlib.sha256(out.read_bytes()).hexdigest()}
exitfile.write_bytes((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
raise SystemExit(result.returncode)
