"""Read-only verification of the final certified-routine scratch bindings."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, re

F = Path(__file__).resolve().parent
R = next(p for p in F.parents if (p / 'lean-toolchain').is_file())
D = F.parent
exec(compile((D / 'fv-local-domain-review/native-long-path-io.py').read_bytes(), 'native-long-path-io.py', 'exec'), globals())
C = D / 'riemann-certified-draft'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: dict(path=p.relative_to(R).as_posix(), sha256=sha(p))
expected = {
    'receipt.json': '7a291b00a243b121edb2bf2e14c7918b0f901dbc2363f24385f7540c581258b3',
    'manifest.json': '7afd2370efe84507169556e2817f714ba03fd96c358d9e43ac7f2db29b4218d2',
    'native07/receipt.json': 'b025d8f7f67964dbf66023952fb98a8ccb748f8b935fbbd246716ce12c30a8aa',
}
for path, digest in expected.items():
    assert sha(C / path) == digest, path
bindings = []
def check(entry):
    path = R / entry['path']
    assert path.is_file() and not path.is_symlink(), entry
    assert sha(path) == entry['sha256'], entry
    bindings.append(entry)

manifest = read(C / 'manifest.json')
for key in ('files', 'unchanged_producers', 'source_boundary_inputs'):
    for entry in manifest[key]: check(entry)
check(manifest['repair_decision'])
receipt = read(C / 'receipt.json')
for key in ('manifest', 'review', 'native', 'native_types', 'axioms'):
    check(receipt[key])
for entry in receipt['fragments']: check(entry)
native = read(C / 'native07/receipt.json')
assert native['exit_code'] == 0 and native['inputs_unchanged'] is True
for entry in native['input_pins']: check(entry)
assert sha(C / 'check.py') == native['runner_sha256']
assert native['command'][1:3] == ['env', 'lean']
assert native['command'][3] == (C / 'native07/Check.lean').relative_to(R).as_posix()
output = (C / 'native07/output.txt').read_text(encoding='utf-8')
assert sha(C / 'native07/output.txt') == native['output_sha256']
assert sha(C / 'native07/stderr.txt') == native['stderr_sha256']
assert (C / 'native07/stderr.txt').stat().st_size == 0
assert not any(word in output for word in ('error:', 'warning:', 'sorryAx'))
reports = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", output, re.S)
assert [name for name, _ in reports] == native['authored_declarations']
assert len(reports) == 14
parsed = []
for name, raw in reports:
    used = [v.strip() for v in raw.split(',') if v.strip()]
    assert set(used) <= {'propext', 'Classical.choice', 'Quot.sound'}, (name, used)
    parsed.append({'declaration': name, 'axioms': used})
assert parsed == read(C / 'axioms.json')
full = (C / 'native07/Check.lean').read_text(encoding='utf-8')
for entry in receipt['fragments']:
    assert (R / entry['path']).read_text(encoding='utf-8') in full
result = {
    'format': 'certified-riemann-routine-independent-review-1',
    'completed_at_utc': datetime.now(timezone.utc).isoformat(),
    'status': 'PASS_MECHANICAL_BINDINGS',
    'review': ref(F / 'REVIEW.md'), 'verifier': ref(Path(__file__)),
    'scratch_receipt': ref(C / 'receipt.json'), 'scratch_manifest': ref(C / 'manifest.json'),
    'native_receipt': ref(C / 'native07/receipt.json'),
    'native_output': ref(C / 'native07/output.txt'),
    'native_actual_exit_code': native['exit_code'],
    'checked_binding_occurrences': len(bindings),
    'unique_bound_files': len({v['path'] for v in bindings}),
    'axiom_reports': parsed,
    'substantive_correction_requested': False,
    'faithfulness_action': 'new-audit-required',
    'source_acceptance': False,
    'historical_attempt_scope': 'Frozen historical file bytes checked; only native07 is asserted successful and current.',
    'review_method': 'Independent direct code and contract review under parent-assigned output scope; no sealed semantic role or released review workflow was invoked.',
    'production_edits': False, 'gate_edits': False, 'git_invocations': 0,
}
with (F / 'verification.json').open('xb') as out:
    out.write((json.dumps(result, indent=2) + '\n').encode())
print(json.dumps({'verification': ref(F / 'verification.json'), 'actual_exit_code': 0,
                  'reports': len(parsed), 'bindings': len(bindings)}, indent=2))
