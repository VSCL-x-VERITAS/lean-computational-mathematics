"""Native focused Lake/Lean capture for this bounded placement, with source snapshots."""
from pathlib import Path
import argparse, hashlib, json, os, shutil, subprocess, sys, time

assert os.name == 'nt'
task = Path(__file__).resolve().parent
repo = task.parents[4]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('label')
parser.add_argument('arguments', nargs='+')
args = parser.parse_args()
assert args.label.replace('-', '').isalnum()
assert args.arguments[0] == 'build' or args.arguments[:2] == ['env', 'lean']
out, receipt = task / (args.label + '-output.txt'), task / (args.label + '-exit.json')
assert not out.exists() and not receipt.exists()
placement = json.loads((task / 'placement-initial.json').read_bytes())
snapshots = task / 'snapshots'
snapshots.mkdir(exist_ok=True)
inputs = []
paths = [Path(item['path']) for item in placement['new_files']]
if args.arguments[:2] == ['env', 'lean']:
    lean_input = Path(args.arguments[-1]).resolve()
    if lean_input.is_file():
        paths.append(lean_input)
for path in paths:
    data = path.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    snapshot = snapshots / (digest + '.lean')
    if snapshot.exists():
        assert snapshot.read_bytes() == data
    else:
        snapshot.write_bytes(data)
    inputs.append({'path': str(path), 'sha256': digest, 'snapshot': str(snapshot)})
argv = [shutil.which('lake'), *args.arguments]
assert argv[0]
start = time.monotonic()
with out.open('wb') as stream:
    result = subprocess.run(argv, cwd=repo, stdout=stream, stderr=subprocess.STDOUT)
record = {'argv': argv, 'working_directory': str(repo), 'exit_code': result.returncode,
          'inputs': inputs, 'output_sha256': hashlib.sha256(out.read_bytes()).hexdigest(),
          'elapsed_ms': int(1000 * (time.monotonic() - start))}
receipt.write_bytes((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
if result.returncode:
    sys.stdout.flush()
    sys.stdout.buffer.write(out.read_bytes())
raise SystemExit(result.returncode)
