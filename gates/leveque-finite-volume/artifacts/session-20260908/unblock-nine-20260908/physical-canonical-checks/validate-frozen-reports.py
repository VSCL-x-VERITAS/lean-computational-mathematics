"""Validate existing native outputs, retaining universe displays and prior parser failures."""
from pathlib import Path
import datetime, hashlib, json, os, re, sys

P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
native = lambda p: '\\\\?\\' + os.path.abspath(p) if os.name == 'nt' else str(p)
def raw(p):
    with open(native(p), 'rb') as stream:
        return stream.read()
def sha(p):
    return hashlib.sha256(raw(p)).hexdigest()
def pin(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def resolve(item):
    p = R / item['path']
    assert p.resolve().is_relative_to(R.resolve()) and sha(p) == item['sha256']
    return p
def normalize(name):
    return re.sub(r'\.\{[^}]*\}', '', name)

label = sys.argv[1]
assert re.fullmatch('[a-z0-9-]+', label)
destination = P / label
assert not destination.exists()
checks = []
for index, expected_count in enumerate((169, 14, 10, 18), 1):
    receipt_path = P / ('check-' + str(index) + '-01') / 'receipt.json'
    receipt = json.loads(raw(receipt_path))
    assert receipt['actual_exit_code'] == 0 and receipt['inputs_unchanged']
    for item in receipt['input_pins']:
        resolve(item)
    input_path = resolve(receipt['input'])
    assert raw(resolve(receipt['input_snapshot'])) == raw(input_path)
    output = raw(resolve(receipt['stdout'])).decode('utf-8')
    assert not raw(resolve(receipt['stderr']))
    assert not re.search(r'\b(?:error|warning):|sorryAx', output)
    expected = re.findall(r'^#print axioms (\S+)', raw(input_path).decode('utf-8'), re.M)
    assert len(expected) == len(set(expected)) == expected_count
    reports = []
    pattern = r"^'([^']+)' (does not depend on any axioms|depends on axioms:\s*\[([^\]]*)\])"
    for match in re.finditer(pattern, output, re.M):
        displayed = match[3] or ''
        names = [x.strip() for x in normalize(displayed).split(',') if x.strip()]
        assert set(names) <= {'propext', 'Classical.choice', 'Quot.sound'}
        reports.append({'declaration_display': match[1], 'declaration': normalize(match[1]),
                        'axiom_display': displayed, 'axiom_constants': names})
    assert sorted(r['declaration'] for r in reports) == sorted(expected)
    checks.append({'native_receipt': pin(receipt_path), 'actual_native_exit': 0,
                   'verified_count': len(reports), 'reports': reports,
                   'current_source_and_compiled_pins_unchanged': True,
                   'prior_capture_parser_passed': receipt['axioms_allowed']})
record = {'format': 'physical-native-axiom-report-revalidation-1',
    'completed_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'reason': 'The initial capture parser compared universe-decorated axiom displays to undecorated constant names. This separate validation removes only universe display suffixes for constant identity; complete original output and every previous result remain unchanged.',
    'checks': checks, 'all_reports_permitted': True, 'native_invocations': 0,
    'source_acceptance': False, 'validator': pin(Path(__file__))}
destination.mkdir()
with open(native(destination / 'receipt.json'), 'xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'receipt': pin(destination / 'receipt.json'),
    'counts': [c['verified_count'] for c in checks], 'all_reports_permitted': True}, indent=2))
