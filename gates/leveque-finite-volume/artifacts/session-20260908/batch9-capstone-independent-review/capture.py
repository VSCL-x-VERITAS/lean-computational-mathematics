"""Capture actual subprocess bytes/exits; all output stays in this review folder."""
from pathlib import Path
from hashlib import sha256
import datetime
import json
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
label, mode = sys.argv[1:]
choices = {
    'verify': [sys.executable, str(HERE / 'verify.py')],
    'cartesian': ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', str(SESSION / 'cartesian-coordinate-line-composition-draft/final03-input.lean')],
    'capstones': ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', str(SESSION / 'prospective-density-material-riemann-capstones-draft/Capstones.lean')],
    'measure': ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', str(SESSION / 'prospective-density-material-riemann-capstones-draft/MeasureSupplement.lean')],
}
command = choices[mode]
output, receipt = HERE / (label + '.output.txt'), HERE / (label + '.receipt.json')
assert not output.exists() and not receipt.exists(), 'append-only capture'
source = Path(command[-1])
digest = lambda p: sha256(p.read_bytes()).hexdigest()
before = digest(source)
started = datetime.datetime.now(datetime.timezone.utc).isoformat()
tick = time.monotonic()
run = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
output.write_bytes(run.stdout)
result = dict(command=command, cwd=str(REPO), started_utc=started,
              elapsed_seconds=round(time.monotonic() - tick, 3), exit_code=run.returncode,
              source=str(source), source_sha256_before=before, source_sha256_after=digest(source),
              output=str(output), output_sha256=digest(output),
              source_unchanged=before == digest(source),
              capture_sha256=digest(Path(__file__)),
              scope='Independent mechanical verification; no source-faithfulness judgment.')
receipt.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(receipt=str(receipt), sha256=digest(receipt), exit_code=run.returncode)))
if run.returncode:
    print(run.stdout.decode('utf-8', errors='replace'))
sys.exit(run.returncode)
