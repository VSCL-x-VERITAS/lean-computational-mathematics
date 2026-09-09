"""Capture pure local catalogue generation, not operational reconciliation."""
from pathlib import Path
import json
import subprocess
import sys
import time
import prepare_mapping_catalogue as p

HERE = Path(__file__).resolve().parent
R = HERE.parent.parents[4]


def main():
    directory = HERE/'catalogue-attempt-01'; directory.mkdir()
    helper = HERE/'prepare_mapping_catalogue.py'
    spec = HERE/'baseline-spec.json'
    command = [sys.executable, '-B', str(helper), '--root', str(R), '--spec', str(spec),
               '--spec-sha256', p.sha(spec.read_bytes()), '--output', str(HERE/'baseline-catalogue.json')]
    (directory/'helper.py.snapshot').write_bytes(helper.read_bytes())
    start = time.perf_counter()
    run = subprocess.run(command, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (directory/'stdout.txt').write_bytes(run.stdout); (directory/'stderr.txt').write_bytes(run.stderr)
    receipt = {'schema': 1, 'command': command, 'cwd': str(R), 'elapsed_seconds': time.perf_counter() - start,
               'exit_code': run.returncode, 'helper_sha256': p.sha(helper.read_bytes()),
               'spec': p.reference(R, spec), 'stdout': p.reference(R, directory/'stdout.txt'),
               'stderr': p.reference(R, directory/'stderr.txt'), 'source_acceptance': False}
    p.create(directory/'receipt.json', receipt)
    print(json.dumps(receipt, indent=2))
    if run.returncode:
        sys.stderr.buffer.write(run.stderr)
    return run.returncode


if __name__ == '__main__':
    raise SystemExit(main())
