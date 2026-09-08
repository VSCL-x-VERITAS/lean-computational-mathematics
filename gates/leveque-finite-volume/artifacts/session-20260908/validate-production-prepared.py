"""Record actual released prepared validation for each selected production task."""
from pathlib import Path
import datetime, hashlib, json, subprocess, sys
S = Path(__file__).resolve().parent
R = S.parents[3]
tasks = json.loads((S / 'new-producer-audit-inputs.json').read_text())['tasks']
ids = [item['task_id'] for item in tasks] + ['LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908']
selected = ids[int(sys.argv[1])::2]
records = []
for ident in selected:
    task = S / 'audits' / ident / 'audit-task.json'
    cmd = [sys.executable, str(R / '.faithfulness-audit/scripts/validate_audit.py'), str(task), '--phase', 'prepared']
    run = subprocess.run(cmd, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out = S / ('prepared-final-' + ident + '-output.txt')
    assert not out.exists(), out
    out.write_bytes(run.stdout)
    receipt = {'task_id': ident, 'command': cmd, 'exit_code': run.returncode,
        'task_sha256': hashlib.sha256(task.read_bytes()).hexdigest(),
        'raw_output_sha256': hashlib.sha256(run.stdout).hexdigest(),
        'time': datetime.datetime.now(datetime.timezone.utc).isoformat()}
    (S / ('prepared-final-' + ident + '-exit.json')).write_text(json.dumps(receipt, indent=2)+'\n')
    print(json.dumps(receipt), flush=True)
    records.append(receipt)
    if run.returncode:
        raise SystemExit(run.returncode)
(S / ('production-prepared-validation-' + sys.argv[1] + '.json')).write_text(json.dumps(records, indent=2)+'\n')
