import hashlib
import json
from pathlib import Path
D = Path(__file__).resolve().parent
def ref(name):
    p = D / name
    b = p.read_bytes()
    return {'path': str(p), 'sha256': hashlib.sha256(b).hexdigest(), 'bytes': len(b)}
v = json.loads((D / 'effective-stop-list.json').read_bytes())
assert v['appserver_exit_code'] == 0
assert all(e['stop_count'] == e['active_trusted_stop_count'] == 1 for e in v['entries'])
assert v['before_config_hashes'] == v['after_config_hashes']
r = {'kind': 'additive-effective-stop-layer-review', 'metadata_process_actual_exit': 0,
     'hooks_invoked': 0, 'gates_invoked': 0, 'model_turns': 0,
     'duplicate_local_stops_found': False, 'live_host_remote_plugin_snapshot_certified': False,
     'manual_host_stop_api_found': False,
     'files': [ref(n) for n in ['list-effective-stop.py', 'effective-stop-list.json', 'effective-stop-appserver-stderr.txt', 'STOP-LAYERS-ADDENDUM.md', 'freeze-stop-layers.py']],
     'official_reference': 'https://learn.chatgpt.com/docs/hooks'}
p = D / 'stop-layers-receipt.json'
with p.open('x', encoding='utf-8', newline='\n') as f:
    f.write(json.dumps(r, indent=2) + '\n')
print(json.dumps({'receipt_sha256': hashlib.sha256(p.read_bytes()).hexdigest()}))
