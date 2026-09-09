"""Append actual direct findings and the independently observed capacity failure."""
from pathlib import Path
import hashlib, json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
T = S / 'audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
O = T / 'faithfulness'
P = O / 'orchestration'
recovery_path = D / 'direct-transport-recovery-v1/dim-d2-01/execution-receipt.json'
recovery = read(recovery_path)
assert recovery['exit_code'] == 0 and recovery['audit_completed'] is False
assert recovery['adjudication_required'] is True
direct = read(O / 'agent_outputs/direct_judge.json')
assert not direct['accepted'] and direct['classification'] == 'undetermined'
continuation_path = D / 'dim-original-adjudication-continuation-01/receipt.json'
continuation = read(continuation_path)
assert continuation['exit_code'] == 1 and continuation['original_four_roles_unchanged']
prompt = (P / 'a_input.txt').read_text(encoding='utf-8')
assert len(prompt) == 2740284
assert sha(P / 'a_input.txt') == '095cd9d4e4fea185e53bad591727277922c544705f83ca45986d5920e356390c'
events = [json.loads(x) for x in (P / 'a_events.jsonl').read_text(encoding='utf-8').splitlines() if x.strip()]
assert not any(e.get('type') == 'turn.started' for e in events)
assert not (P / 'a_final.json').exists() and not (O / 'decision.json').exists()
out = D / 'dim-direct-and-adjudication-capacity-diagnosis'
out.mkdir()
record = {
    'format': 'dim-direct-and-adjudication-capacity-diagnosis-1',
    'original_wrapper': ref(T / 'role-run-receipt.json'),
    'direct_recovery': ref(recovery_path), 'direct_recovery_exit_code': 0,
    'direct_output': ref(O / 'agent_outputs/direct_judge.json'),
    'direct_classification': 'undetermined', 'direct_accepted': False,
    'direct_findings': direct['findings'],
    'roundtrip_output': ref(O / 'agent_outputs/roundtrip_judge.json'),
    'continuation': ref(continuation_path), 'continuation_exit_code': 1,
    'adjudicator_prompt': ref(P / 'a_input.txt'), 'adjudicator_input_characters': len(prompt),
    'adjudicator_input_bytes': (P / 'a_input.txt').stat().st_size,
    'adjudicator_events': ref(P / 'a_events.jsonl'), 'adjudicator_stderr': ref(P / 'a_stderr.txt'),
    'adjudicator_turn_started': False, 'native_limit_characters': 1048576,
    'startup_observation_limit': 'Earlier zero-byte live log observations did not establish an unstarted direct process. The completed stderr includes a 20:40:04.071927Z shell-snapshot warning shortly after launch; direct ultimately exited 0 after 688.688 seconds with no intervention. The reason for delayed visible output is not established.',
    'capacity_bridge_source': ref(D / 'PhysicalCapacityBridge.lean'),
    'capacity_bridge_native': ref(S / 'unblock-nine-capacity-line-bridge-native-02-exit.json'),
    'capacity_bridge_scope': 'Artifact-only equality of actual measured-capacity line and finite physical updates, projection, locality, and reused weighted mass balance. No quality, source acceptance, or full geometry-domain closure follows.',
    'source_acceptance': False, 'gate_rows_closed_by_this_record': 0,
}
assert read(S / 'unblock-nine-capacity-line-bridge-native-02-exit.json')['exit_code'] == 0
with (out / 'diagnosis.json').open('xb') as f:
    f.write((json.dumps(record, indent=2, ensure_ascii=False) + '\n').encode())
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == 'ec9b561cabd1d8f3dbac2ce8f6cad56cd1384f958bd88303e0150e5aaca860aa'
assert sha(process) == '5c5fc9cdd7404cfc0429e10cb1888da61f20e5c03d500875f5da17e17437b18e'
loc = (out / 'diagnosis.json').relative_to(R).as_posix() + ' SHA256 ' + sha(out / 'diagnosis.json')
entries = {
    book: '| LEV-C1-HIGH-RESOLUTION-QUALITY-DOMAIN-111 | LEV-CH01-DIMENSIONAL-SPLITTING | direct audit of current target | Direct review is undetermined and finds unrestricted discontinuity admission, a vacuous fixed-level threshold, extra stability and realization conditions, and unresolved smoothness semantics | Separate intrinsic quality from conditional stability, repair admission and threshold meaning, and finish the actual independent adjudication before a successor audit | IN_PROGRESS; two original-nine rows still open | ' + loc + ' | The accepted literal convention is preserved. These are formalization coverage issues; the two-direction joint example proves satisfiability but does not repair the universal statement. |',
    process: '| LEV-SKILL-DIM-ADJUDICATOR-INPUT-CAPACITY-096 | codex-start-1-v5-0-1-20260908 | direct recovery and original adjudication continuation | Reviewed lossless direct recovery actually exited 0; unchanged q continuation then exited 1 because the native adjudicator input has 2740284 characters above the 1048576 limit, with no adjudicator turn | Preserve original wrapper and all four collected roles; prepare an independently reviewed exact-reconstruction adjudicator transport | Recovery preparation remains open; no decision or acceptance inferred | ' + loc + ' | Original wrapper exit 1 is unchanged. The direct run finished after delayed visible logs without intervention; the earlier zero-byte observations were not a demonstrated startup failure. The separate prelaunch metadata guard failure is retained. |'
}
receipt = {'diagnosis': ref(out / 'diagnosis.json'), 'ledgers': []}
for path, entry in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and entry.split('|')[1].strip().encode() not in raw
    with path.open('ab') as f:
        f.write((entry + '\n').encode())
    assert path.read_bytes().startswith(raw)
    receipt['ledgers'].append({'before_sha256': hashlib.sha256(raw).hexdigest(), 'after': ref(path)})
with (out / 'receipt.json').open('xb') as f:
    f.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
