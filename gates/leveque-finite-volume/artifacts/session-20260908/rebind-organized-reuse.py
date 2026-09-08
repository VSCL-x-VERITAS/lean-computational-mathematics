"""Revalidate the accepted reused rows against the casefold-corrected tree."""
from pathlib import Path
import json, subprocess, sys
S = Path(__file__).resolve().parent
R = S.parents[3]
G = R / 'gates/leveque-finite-volume/chapter-01.json'
C = R.parent / 'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
rows = [r for r in json.loads(G.read_text())['rows'] if r['status'] == 'REUSED']
assert len(rows) == 4
records = []
label = sys.argv[1] if len(sys.argv) > 1 else 'organized'
for row in rows:
    cmd = [sys.executable, str(S / 'rebind-reused-row.py'), '--gate-checker', str(C),
        '--gate', str(G), '--task', str(R / row['faithfulness_task']), '--row', row['id'],
        '--resolution-log', str(S / 'chapter01-all-declaration-output.txt')]
    run = subprocess.run(cmd, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    name = label + '-rebind-' + row['id']
    assert not (S / (name + '-output.txt')).exists()
    (S / (name + '-output.txt')).write_bytes(run.stdout)
    receipt = {'row': row['id'], 'command': cmd, 'exit_code': run.returncode}
    (S / (name + '-exit.json')).write_text(json.dumps(receipt, indent=2)+'\n')
    print(run.stdout.decode('utf-8'), flush=True)
    if run.returncode:
        raise SystemExit(run.returncode)
    records.append(receipt)
(S / (label + '-rebinding-receipt.json')).write_text(json.dumps(records, indent=2)+'\n')
