"""Task-local native Lean capture, with immutable unique-label outputs."""
from pathlib import Path
import argparse, hashlib, json, os, shutil, subprocess, sys, time

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('label')
parser.add_argument('file')
args = parser.parse_args()
assert os.name == 'nt' and args.label.replace('-', '').isalnum()
directory = Path(__file__).resolve().parent
root = directory.parents[4]
source = directory / args.file
assert source.resolve().parent == directory
output = directory / (args.label + '-output.txt')
receipt = directory / (args.label + '-exit.json')
assert not output.exists() and not receipt.exists()
lake = shutil.which('lake')
assert lake
argv = [lake, 'env', 'lean', str(source)]
start = time.monotonic()
with output.open('wb') as stream:
    run = subprocess.run(argv, cwd=root, stdout=stream, stderr=subprocess.STDOUT)
record = {'argv': argv, 'working_directory': str(root), 'exit_code': run.returncode,
          'source': str(source), 'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
          'output_sha256': hashlib.sha256(output.read_bytes()).hexdigest(),
          'elapsed_ms': int(1000 * (time.monotonic() - start))}
receipt.write_bytes((json.dumps(record, indent=2) + '\n').encode('utf-8'))
print(json.dumps(record))
if run.returncode:
    sys.stdout.flush()
    sys.stdout.buffer.write(output.read_bytes())
raise SystemExit(run.returncode)
