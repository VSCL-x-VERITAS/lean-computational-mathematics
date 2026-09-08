"""Validate the three final canonical successor preparations with the sealed kit."""
from pathlib import Path
import hashlib, json, subprocess, sys
S = Path(__file__).resolve().parent
R = S.parents[3]
ids = [
    'LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908',
    'LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908',
    'LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908']
records = []
for ident in ids:
    path = S / 'audits' / ident / 'audit-task.json'
    command = [sys.executable, str(R / '.faithfulness-audit/scripts/validate_audit.py'), str(path), '--phase', 'prepared']
    output_path = S / ('prepared-final-' + ident + '-output.txt')
    assert not output_path.exists(), ident
    run = subprocess.run(command, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output_path.write_bytes(run.stdout)
    record = {'task_id': ident, 'command': command, 'exit_code': run.returncode,
        'task_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
        'raw_output_sha256': hashlib.sha256(run.stdout).hexdigest()}
    (S / ('prepared-final-' + ident + '-exit.json')).write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)
    if run.returncode:
        raise SystemExit(run.returncode)
    records.append(record)
(S / 'transport-prepared-validation.json').write_text(json.dumps(records, indent=2)+'\n')
