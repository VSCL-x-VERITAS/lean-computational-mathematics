"""Supported hooks/list only; no model turn, hook execution or configuration write."""
import datetime
import hashlib
import json
import queue
from pathlib import Path
import subprocess
import threading
import time
import tomllib

D = Path(__file__).resolve().parent
W = D.parents[1]
R = W / 'lean-computational-mathematics'
binary = Path('C:/Users/qed_s/AppData/Local/OpenAI/Codex/bin/02c7a9ff819938f0/codex.exe')
userdir = Path('C:/Users/qed_s/.codex')
inputs = [userdir / 'hooks.json', userdir / 'config.toml']
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
before = {str(p): sha(p) for p in inputs}
start = time.perf_counter()
with (D / 'effective-stop-appserver-stderr.txt').open('xb') as err:
    process = subprocess.Popen([str(binary), 'app-server', '--listen', 'stdio://'],
                               stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=err,
                               text=True, encoding='utf-8', cwd=W, creationflags=subprocess.CREATE_NO_WINDOW)
    replies = queue.Queue()
    def reader():
        for line in process.stdout:
            try:
                replies.put(json.loads(line))
            except ValueError:
                replies.put({'non_json': True})
    threading.Thread(target=reader, daemon=True).start()
    sent = []
    def send(message):
        sent.append(message)
        process.stdin.write(json.dumps(message) + '\n')
        process.stdin.flush()
    def receive(message_id):
        while True:
            message = replies.get(timeout=30)
            if message.get('id') == message_id:
                if 'error' in message:
                    raise RuntimeError(message['error'])
                return message['result']
    try:
        send({'id': 1, 'method': 'initialize', 'params': {'clientInfo': {'name': 'readonly_stop_layer_review', 'version': '1.0'}, 'capabilities': {'experimentalApi': True}}})
        initialization = receive(1)
        send({'method': 'initialized', 'params': {}})
        send({'id': 2, 'method': 'hooks/list', 'params': {'cwds': [str(W), str(R)]}})
        listing = receive(2)
    finally:
        process.stdin.close()
        try:
            process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            process.terminate()
            process.wait(timeout=5)

def command_view(command):
    if not command:
        return command
    if 'formalization_session_guard.py' in command and 'formalization-hook-bridge.py' in command:
        return command
    return {'redacted_nonmatching_command_sha256': hashlib.sha256(command.encode()).hexdigest()}

entries = []
for entry in listing['data']:
    item = {key: value for key, value in entry.items() if key != 'hooks'}
    stops = []
    for hook in entry.get('hooks', []):
        if hook.get('eventName', '').lower() != 'stop':
            continue
        copied = dict(hook)
        for field in ['command', 'commandWindows']:
            if field in copied:
                copied[field] = command_view(copied[field])
        stops.append(copied)
    item['stop_hooks'] = stops
    item['stop_count'] = len(stops)
    item['active_trusted_stop_count'] = sum(bool(h.get('enabled')) and h.get('trustStatus') in ['trusted', 'managed'] for h in stops)
    entries.append(item)

# Presence/hook definitions only for directly relevant local layers; no unrelated config fields.
layers = []
locations = {userdir, W / '.codex', R / '.codex'}
locations.update(parent / '.codex' for parent in W.parents)
for directory in sorted(locations):
    for name in ['hooks.json', 'config.toml']:
        path = directory / name
        item = {'path': str(path), 'exists': path.is_file()}
        if path.is_file():
            item['sha256'] = sha(path)
            parsed = json.loads(path.read_bytes()) if name.endswith('.json') else tomllib.loads(path.read_text(encoding='utf-8'))
            hooks = parsed.get('hooks', {})
            stops = hooks.get('Stop', hooks.get('stop', []))
            item['stop_matcher_groups'] = stops
            item['hook_keys'] = sorted(hooks)
            for group in item['stop_matcher_groups']:
                for hook in group.get('hooks', []):
                    for field in ['command', 'commandWindows', 'command_windows']:
                        if field in hook:
                            # The known POSIX guard command is also safe exact data.
                            command = hook[field]
                            if command == 'python3 /c/Users/qed_s/.codex/skills/book-formalization/scripts/formalization_session_guard.py':
                                continue
                            hook[field] = command_view(command)
        layers.append(item)
after = {str(p): sha(p) for p in inputs}
assert before == after
schema_path = W / 'workflow-v5.0.1-local/provider-guard-evidence/codex-protocol-schema/codex_app_server_protocol.v2.schemas.json'
schema = json.loads(schema_path.read_bytes())
hook_methods = sorted(set(__import__('re').findall(r'"(hooks/[^\"]+)"', schema_path.read_text(encoding='utf-8'))))
record = {'kind': 'supported-readonly-effective-stop-list', 'captured_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'elapsed_seconds': time.perf_counter() - start, 'appserver_exit_code': process.returncode,
          'new_tasks': 0, 'model_turns': 0, 'hook_runs': 0, 'gate_runs': 0,
          'sent_messages': sent, 'entries': entries, 'inspected_local_layers': layers,
          'before_config_hashes': before, 'after_config_hashes': after,
          'local_protocol_hook_request_methods': hook_methods, 'protocol_schema_sha256': sha(schema_path),
          'interpretation': 'Each cwd is an independent effective list; the same global hook returned for two cwds is not two hooks in one event.',
          'limits': 'Read-only new app-server metadata loading uses installed code/config; it is not an observation of an actual Stop dispatch in the already-running host.'}
target = D / 'effective-stop-list.json'
with target.open('x', encoding='utf-8', newline='\n') as handle:
    handle.write(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'sha256': sha(target), 'appserver_exit_code': process.returncode,
                  'entries': entries, 'protocol_hook_methods': hook_methods}, ensure_ascii=True))
