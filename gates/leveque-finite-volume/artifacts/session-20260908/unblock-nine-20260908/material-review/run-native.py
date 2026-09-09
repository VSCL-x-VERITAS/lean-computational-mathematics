"""Capture native Lean/Lake with exact input snapshots, without invoking Git."""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lean-toolchain').is_file())
FILES = [R / ('ComputationalMathematics/Source/LeVeque/Chapter01/' + name + '.lean')
         for name in ('SourceTermsRectangleBalance', 'MaterialInterfaceLocalRiemannData',
                      'MaterialCellVolumeAveraging')]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('label')
parser.add_argument('arguments', nargs=argparse.REMAINDER)
args = parser.parse_args()
assert os.name == 'nt' and args.arguments and args.label.replace('-', '').isalnum()
run_dir = D / args.label
run_dir.mkdir(exist_ok=False)
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
inputs = FILES + [R/'lean-toolchain', R/'lake-manifest.json', D.parent/'selected-interpretations.json']
if (D/'Checks.lean').exists():
    inputs.append(D/'Checks.lean')
bindings = []
for index, path in enumerate(inputs):
    snapshot = run_dir / (str(index) + '-' + path.name + '.snapshot')
    with snapshot.open('xb') as output:
        output.write(path.read_bytes())
    bindings.append({'path': str(path), 'sha256_before': sha(path),
                     'snapshot': str(snapshot), 'snapshot_sha256': sha(snapshot)})
lake = shutil.which('lake')
assert lake
command = [lake, *args.arguments]
started = time.monotonic()
started_utc = datetime.datetime.now(datetime.timezone.utc).isoformat()
output_path = run_dir/'output.txt'
with output_path.open('xb') as output:
    result = subprocess.run(command, cwd=R, stdout=output, stderr=subprocess.STDOUT)
for entry in bindings:
    entry['sha256_after'] = sha(Path(entry['path']))
receipt = {'schema': 1, 'command': command, 'cwd': str(R), 'exit_code': result.returncode,
           'started_utc': started_utc, 'elapsed_seconds': time.monotonic()-started,
           'output': str(output_path), 'output_sha256': sha(output_path), 'inputs': bindings,
           'inputs_unchanged': all(b['sha256_before']==b['sha256_after'] for b in bindings),
           'runner_sha256': sha(Path(__file__)), 'git_invoked_by_runner': False,
           'head_context_reported_by_root': '5e3f63594aa964263469ada134aee2809559d50d'}
with (run_dir/'receipt.json').open('x', encoding='utf-8', newline='\n') as output:
    output.write(json.dumps(receipt, indent=2)+'\n')
print(json.dumps(receipt, indent=2))
if result.returncode:
    sys.stdout.buffer.write(output_path.read_bytes())
raise SystemExit(result.returncode)
