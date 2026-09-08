"""Summarize existing timing artifacts; no external commands or operational writes."""
import hashlib
import json
from pathlib import Path

folder = Path(__file__).resolve().parent
capture = json.loads((folder / 'run-exit.json').read_text(encoding='utf-8'))
profile = json.loads((folder / 'profile-run.json').read_text(encoding='utf-8'))
starts = {}
commands = []
for line in (folder / 'git-trace2.jsonl').read_text(encoding='utf-8').splitlines():
    value = json.loads(line)
    if value.get('event') == 'start':
        starts[value['sid']] = value['argv']
    if value.get('event') == 'exit':
        commands.append({'argv': starts[value['sid']], 'git_elapsed_seconds': value['t_abs'], 'exit_code': value['code']})
assert len(commands) == 7 and all(x['exit_code'] == 0 for x in commands)
assert capture['exit_code'] == profile['gate_exit_code'] == 0
assert capture['all_selected_inputs_unchanged']
files = []
for path in sorted(folder.iterdir()):
    if path.is_file() and path.name != 'final-receipt.json':
        payload = path.read_bytes()
        files.append({'path': str(path), 'sha256': hashlib.sha256(payload).hexdigest(), 'bytes': len(payload)})
receipt = {'kind': 'unchanged-gate-timing-diagnosis', 'actual_gate_invocations': 1,
           'actual_exit_code': 0, 'elapsed_seconds_including_launcher': capture['elapsed_seconds_including_launcher'],
           'profiled_gate_elapsed_seconds': profile['profiled_gate_elapsed_seconds'],
           'diagnostic_timeout_seconds': 180, 'profiling_overhead_included': True,
           'hook_timeout_reproduced': False, 'hook_completion_asserted': False,
           'all_selected_inputs_unchanged': True, 'git_commands': commands, 'files': files}
target = folder / 'final-receipt.json'
with target.open('x', encoding='utf-8', newline='\n') as handle:
    handle.write(json.dumps(receipt, indent=2) + '\n')
print(json.dumps({'receipt_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                  'run_exit_sha256': hashlib.sha256((folder / 'run-exit.json').read_bytes()).hexdigest(),
                  'review_sha256': hashlib.sha256((folder / 'REVIEW.md').read_bytes()).hexdigest()}))
