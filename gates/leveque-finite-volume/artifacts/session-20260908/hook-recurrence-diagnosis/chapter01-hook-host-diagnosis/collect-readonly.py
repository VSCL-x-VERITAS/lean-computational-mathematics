"""Narrow root hook evidence only. No environment dump, operational subprocess or database write."""
import datetime
import hashlib
import json
from pathlib import Path
import sqlite3

D = Path(__file__).resolve().parent
W = D.parents[1]
root_id = '01a07fae-4a67-7770-98b0-b95c4e393705'
transcript = Path('C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-' + root_id + '.jsonl')
selected = []
prefix = hashlib.sha256()
line_count = 0
with transcript.open('rb') as stream:
    for line_count, line in enumerate(stream, 1):
        prefix.update(line)
        value = json.loads(line)
        payload = value.get('payload', {})
        stamp = value.get('timestamp', '')
        if stamp < '2026-09-08T15:00:00':
            continue
        if payload.get('type') in ['hook_started', 'hook_completed']:
            selected.append({'line': line_count, 'sha256': hashlib.sha256(line).hexdigest(), 'record': value})
        if value.get('type') == 'response_item' and payload.get('type') == 'message' and payload.get('role') == 'user':
            texts = [x.get('text', '') for x in payload.get('content', []) if x.get('type') == 'input_text']
            if any(x.startswith('<hook_prompt ') for x in texts):
                selected.append({'line': line_count, 'sha256': hashlib.sha256(line).hexdigest(), 'record': value})

database = Path('C:/Users/qed_s/.codex/logs_2.sqlite')
connection = sqlite3.connect(database.as_uri() + '?mode=ro', uri=True, timeout=10)
connection.execute('PRAGMA query_only = ON')
schema = connection.execute("SELECT sql FROM sqlite_master WHERE type='table' AND name='logs'").fetchone()[0]
targets = connection.execute('SELECT target,count(*) FROM logs WHERE thread_id=? GROUP BY target', (root_id,)).fetchall()
query = '''SELECT id,ts,level,target,module_path,file,line,feedback_log_body
FROM logs WHERE thread_id=? AND ts>=? AND target != 'feedback_tags'
AND (target LIKE '%hook%' OR feedback_log_body LIKE '%hook_executor%'
OR feedback_log_body LIKE '%run_hook%' OR feedback_log_body LIKE '%Stop hook%'
OR feedback_log_body LIKE '%closure checker could not complete%')
AND feedback_log_body NOT LIKE '%ToolCall:%'
ORDER BY id DESC LIMIT 100'''
matches = connection.execute(query, (root_id, 1788879600)).fetchall()
recent_hook_targets = connection.execute("SELECT DISTINCT target FROM logs WHERE ts>=? AND target LIKE '%hook%'", (1788879600,)).fetchall()
connection.close()

schema_path = W / 'workflow-v5.0.1-local/provider-guard-evidence/codex-protocol-schema/codex_app_server_protocol.v2.schemas.json'
protocol = json.loads(schema_path.read_bytes())
names = ['HookExecutionMode', 'HookRunSummary', 'HookOutputEntry', 'HookRunStatus', 'HookCompletedNotification', 'HookStartedNotification']
protocol_excerpt = {name: protocol['definitions'][name] for name in names}

def ref(p):
    b = p.read_bytes()
    return {'path': str(p), 'sha256': hashlib.sha256(b).hexdigest(), 'bytes': len(b)}

evidence = {
    'kind': 'read-only-host-hook-evidence', 'root_thread_id': root_id,
    'captured_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'transcript': {'path': str(transcript), 'prefix_lines': line_count, 'prefix_sha256': prefix.hexdigest(),
                   'note': 'Only actual user hook_prompt and structured hook events since 15:00 UTC are selected; no other prompts are exported.'},
    'selected_hook_records': selected,
    'sqlite': {'path': str(database), 'mode': 'ro; PRAGMA query_only=ON', 'schema': schema, 'root_target_counts': targets,
               'query': query, 'parameters': [root_id,1788879600], 'matching_rows': matches,
               'recent_hook_targets': recent_hook_targets,
               'limitation': 'A bounded query miss does not establish that the host never recorded diagnostics elsewhere. Feedback feature lists and echoed ToolCall text are excluded.'},
    'protocol_schema': ref(schema_path), 'protocol_excerpt': protocol_excerpt,
    'relevant_source_bindings': [ref(p) for p in [
        Path('C:/Users/qed_s/.codex/runtimes/formalization-hook-bridge.py'),
        Path('C:/Users/qed_s/.codex/skills/book-formalization/scripts/formalization_session_guard.py'),
        W / 'workflow-v5.0.1-local/run_workflow_posix.py',
        W / 'workflow-v5.0.1-local/posix_exec.py',
        W / 'workflow-v5.0.1-local/chapter01-hook-timeout-diagnosis/stop-final-replay-exit.json',
        W / 'workflow-v5.0.1-local/chapter01-hook-timeout-diagnosis/replay-configured-stop-final.py',
    ]],
    'operational_mutations': [], 'new_hook_or_gate_runs': 0,
}
destination = D / 'host-evidence.json'
with destination.open('x', encoding='utf-8', newline='\n') as handle:
    handle.write(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'hook_records': len(selected), 'hook_query_matches': len(matches),
                  'evidence_sha256': hashlib.sha256(destination.read_bytes()).hexdigest(),
                  'selected_events': [{'line': x['line'], 'timestamp': x['record'].get('timestamp'),
                                       'type': x['record']['payload'].get('type')} for x in selected]}))
