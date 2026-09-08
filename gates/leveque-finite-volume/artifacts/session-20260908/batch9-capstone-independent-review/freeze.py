"""Freeze this additive review after verifying its real native replay evidence."""
from pathlib import Path
from hashlib import sha256
import datetime
import json
import verify

HERE = Path(__file__).resolve().parent
target = HERE / 'final-receipt.json'
assert not target.exists(), 'append-only receipt'
digest = lambda p: sha256(p.read_bytes()).hexdigest()
record = lambda p: dict(path=str(p), sha256=digest(p), bytes=p.stat().st_size)
verification = json.loads((HERE / 'verification.json').read_text(encoding='utf-8'))
for binding in verification['bindings']:
    assert digest(Path(binding['path'])) == binding['expected']
replays = []
for label, original, count in [
    ('cartesian', verify.CART / 'final03-output.txt', 48),
    ('capstones', verify.PROS / 'capstones-final-03.native.txt', 11),
    ('measure', verify.PROS / 'measure-final-02.native.txt', 8),
]:
    receipt_path = HERE / ('replay-' + label + '.receipt.json')
    receipt = json.loads(receipt_path.read_text(encoding='utf-8'))
    assert receipt['exit_code'] == 0 and receipt['source_unchanged']
    source, output = Path(receipt['source']), Path(receipt['output'])
    assert digest(source) == receipt['source_sha256_before'] == receipt['source_sha256_after']
    assert digest(output) == receipt['output_sha256']
    check = verify.check_native(source, output, count)
    assert output.read_bytes() == original.read_bytes(), label
    replays.append(dict(label=label, receipt=record(receipt_path), exit_code=0,
                        identical_to_frozen_output=True, axiom_report_count=count))
assert digest(HERE / 'verify-01.py') == json.loads((HERE / 'verify-01.receipt.json').read_text())['source_sha256_before']
assert json.loads((HERE / 'verify-01.receipt.json').read_text())['exit_code'] == 1
assert json.loads((HERE / 'verify-02.receipt.json').read_text())['exit_code'] == 0
files = sorted(p for p in HERE.iterdir() if p.is_file() and p.name != target.name)
result = dict(kind='independent-capstone-review-freeze', frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
              verification=record(HERE / 'verification.json'), review=record(HERE / 'REVIEW.md'),
              source_binding_occurrences=verification['binding_occurrences'], unique_source_paths=verification['unique_bound_paths'],
              independent_replays=replays, all_assertions_passed=True,
              actual_replay_exits=[0, 0, 0], total_axiom_reports=67, allowed_axioms=sorted(verify.ALLOWED),
              semantic_result='No required mathematical correction to stated draft scopes; see review for evidence and future target-bound nonvacuity limits.',
              source_faithfulness_judgment=None, interpretation_adopted=False,
              artifacts=[record(p) for p in files],
              writes='This new review folder only. Frozen inputs and existing canonical/gate/audit/Git state untouched.')
target.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(receipt=str(target), sha256=digest(target), artifacts=len(files), actual_replay_exits=[0,0,0], total_axiom_reports=67)))
