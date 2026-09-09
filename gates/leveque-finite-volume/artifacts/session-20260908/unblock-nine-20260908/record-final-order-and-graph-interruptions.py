"""Record interrupted graph attempts and the actual import-order repair."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
read = lambda p: json.loads(p.read_bytes())
old = S / 'architecture-graphs/unblock-nine-final-source.json'
old_md = old.with_suffix('.md')
assert sha(old) == 'ad238da37ea505757fcefc3a18006dbfbb6aefaa13d606224f317ceafef7a9b3'
assert sha(old_md) == 'b3c1a6ece38a827bede2934827634a6799aabcf6e71c3721060bc51531cf2ca7'
attempts = []
for label, pids, reason in [
    ('unblock-nine-final-current-source-graphs', [2216], 'Root noticed the selected graph basename already existed; stopped the verified worker before any graph output was replaced.'),
    ('unblock-nine-final-current-source-graphs-02', [11256, 15476], 'The actual layout failure required an import-order repair; root stopped the obsolete pre-repair graph workers before mutating Analysis.')]:
    receipt = S / (label + '-exit.json')
    output = S / (label + '-output.txt')
    actual = read(receipt)
    assert actual['exit_code'] == 0 and actual['output_sha256'] == sha(output)
    assert output.read_bytes() == b''
    attempts.append({'receipt': ref(receipt), 'output': ref(output),
        'actual_process_exit_code': actual['exit_code'],
        'classification': 'INTENTIONALLY_INTERRUPTED_NOT_A_SUCCESSFUL_GRAPH_CAPTURE',
        'root_action': 'Native PowerShell Stop-Process after exact PID/name/command-line identity inspection',
        'verified_native_process_ids': pids, 'reason': reason,
        'interpretation': 'The Windows forced termination surfaced as exit zero. This receipt must not be used as positive graph evidence.'})
assert not (S / 'architecture-graphs/unblock-nine-certified-high-resolution-final-source.json').exists()
assert not (S / 'architecture-graphs/unblock-nine-certified-high-resolution-final-source.md').exists()
repair = D / 'analysis-casefold-order-repair/receipt.json'
assert read(repair)['after']['sha256'] == sha(R / 'ComputationalMathematics/Analysis.lean')
assert read(repair)['same_import_set'] and read(repair)['casefold_sorted']
record = {'format': 'graph-interruption-and-order-repair-record-1',
    'recorder': ref(Path(__file__)), 'preserved_historical_graph': [ref(old), ref(old_md)],
    'attempts': attempts, 'import_order_repair': ref(repair),
    'next_graph_basename': 'unblock-nine-certified-high-resolution-sorted-source',
    'new_graph_success_claimed': False}
path = D / 'final-order-and-graph-interruptions.json'
with path.open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(process) == 'b62069246f368018f890c2caa4fc1cf43d202ab31c8f6b8b2bc87663284f0911'
raw = process.read_bytes()
entry = '| LEV-SKILL-FINAL-IMPORT-ORDER-AND-GRAPH-093 | codex-start-1-v5-0-1-20260908 | final current organization checks | Case-sensitive insertion placed CFLUnitShift before CellVolumeAverage, violating the existing casefold sort; the initial graph name also referred to an existing preserved capture | Swap only the two import lines, preserve the old graph hashes and both intentionally interrupted attempts, then run fresh sorted layout/build/graph checks | Exact import-set repair passed; final sorted checks remain in progress | ' + path.relative_to(R).as_posix() + ' SHA256 ' + sha(path) + ' | Native forced termination surfaced as exit zero with empty output for both stopped graph processes; neither receipt is valid positive graph evidence. No old graph was overwritten, no source theorem changed, and no checker was weakened. |\n'
assert b'LEV-SKILL-FINAL-IMPORT-ORDER-AND-GRAPH-093' not in raw and raw.endswith(b'\n')
with process.open('ab') as stream:
    stream.write(entry.encode())
assert process.read_bytes().startswith(raw)
receipt = {'record': ref(path), 'ledger': ref(process),
           'ledger_before_sha256': hashlib.sha256(raw).hexdigest(), 'entries_appended': 1}
with (D / 'final-order-and-graph-interruptions-ledger-receipt.json').open('xb') as stream:
    stream.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
