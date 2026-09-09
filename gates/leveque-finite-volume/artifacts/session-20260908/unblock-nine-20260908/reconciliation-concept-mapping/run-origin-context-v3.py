"""Capture the read-only origin context command and actual exit."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
R = HERE.parent.parents[4]
W = R.parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    lane = sys.argv[1]
    assert lane in ('leveque-ch01-work', 'reorganization-baseline-inspection')
    directory = HERE/lane
    inv = directory/'inventory.json'
    output = directory/'origin-context-v3.json'
    cmd = [sys.executable, '-B', str(W/'workflow-v5.0.1-local/run_workflow_posix.py'),
           str(HERE/'capture-origin-context-v2.py'), '--inventory', str(inv), '--inventory-sha256', sha(inv),
           '--topology', str(HERE.parent/'linear-review/pass-checkpoint-review/topology.observed.json'),
           '--output', str(output)]
    start = time.perf_counter()
    began = datetime.now(timezone.utc).isoformat()
    run = subprocess.run(cmd, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    for suffix, payload in [('stdout.txt', run.stdout), ('stderr.txt', run.stderr)]:
        with (directory/('context-v3-' + suffix)).open('xb') as stream:
            stream.write(payload)
    receipt = {'schema': 1, 'command': cmd, 'cwd': str(R), 'started_at_utc': began,
               'elapsed_seconds': time.perf_counter() - start, 'exit_code': run.returncode,
               'stdout_sha256': sha(directory/'context-v3-stdout.txt'), 'stderr_sha256': sha(directory/'context-v3-stderr.txt'),
               'helper_sha256': sha(HERE/'capture-origin-context-v2.py'), 'runner_sha256': sha(Path(__file__)),
               'output_sha256': sha(output) if output.exists() else None}
    with (directory/'context-v3-receipt.json').open('x') as stream:
        json.dump(receipt, stream, indent=2); stream.write('\n')
    print(json.dumps(receipt, indent=2))
    return run.returncode


if __name__ == '__main__':
    raise SystemExit(main())
