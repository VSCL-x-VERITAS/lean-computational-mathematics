"""Native declaration/import checks with actual source and compiled dependency pins."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, re, subprocess, sys, time

P = Path(__file__).resolve().parent
D = P.parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
native = lambda p: '\\\\?\\' + os.path.abspath(p) if os.name == 'nt' else str(p)
def raw(p):
    with open(native(p), 'rb') as stream:
        return stream.read()
def sha(p):
    return hashlib.sha256(raw(p)).hexdigest()
def pin(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def put(p, data):
    with open(native(p), 'xb') as stream:
        stream.write(data)
def text(p):
    return raw(p).decode('utf-8')

name, label, build_name, build_sha = sys.argv[1:]
assert name in ('AllCurrentDeclarations', 'SourceImportSmoke', 'LookupImportSmoke', 'LegacyLookupImportSmoke')
assert re.fullmatch('[a-z0-9-]+', label)
source = D / 'physical-canonical-check-preparation' / (name + '.lean')
build_path = D / 'physical-production-promotion' / build_name
assert build_path.resolve().is_relative_to((D / 'physical-production-promotion').resolve())
assert sha(build_path) == build_sha
build = json.loads(raw(build_path))
assert build['actual_exit_code'] == 0 and build['sources_unchanged']
for item in build['input_sources']:
    assert sha(R / item['path']) == item['sha256']
expected = re.findall(r'^#print axioms (\S+)', text(source), re.M)
assert len(expected) == len(set(expected)) == {'AllCurrentDeclarations': 169, 'SourceImportSmoke': 14, 'LookupImportSmoke': 10, 'LegacyLookupImportSmoke': 18}[name]
assert re.findall(r'^#check (\S+)', text(source), re.M) == expected
out = P / label
out.mkdir(exist_ok=False)
put(out / source.name, raw(source))
inputs = {str(p): pin(p) for p in (source, Path(__file__), build_path, R / 'lean-toolchain', R / 'lake-manifest.json')}
queue = re.findall(r'^(?:public )?import\s+(\S+)', text(source), re.M)
seen = set()
while queue:
    module = queue.pop()
    if module in seen:
        continue
    seen.add(module)
    if module.startswith(('ComputationalMathematics.', 'NumStability.')):
        owner = R / (module.replace('.', '/') + '.lean')
        queue.extend(re.findall(r'^(?:public )?import\s+(\S+)', text(owner), re.M))
        bases = [owner, R / '.lake/build/lib/lean' / (module.replace('.', '/') + '.olean')]
    elif module.startswith('Mathlib.'):
        bases = [R / '.lake/packages/mathlib' / (module.replace('.', '/') + '.lean'),
                 R / '.lake/packages/mathlib/.lake/build/lib/lean' / (module.replace('.', '/') + '.olean')]
    else:
        continue
    for path in bases:
        inputs[str(path)] = pin(path)
        if path.suffix == '.olean':
            for suffix in ('.private', '.server'):
                side = Path(str(path) + suffix)
                if os.path.isfile(native(side)):
                    inputs[str(side)] = pin(side)
command = ['C:/Users/qed_s/.elan/bin/lake.EXE', 'env', 'lean', source.relative_to(R).as_posix()]
started = datetime.now(timezone.utc).isoformat()
timer = time.monotonic()
with open(native(out / 'stdout.txt'), 'xb') as stdout, open(native(out / 'stderr.txt'), 'xb') as stderr:
    result = subprocess.run(command, cwd=R, stdout=stdout, stderr=stderr)
elapsed = int((time.monotonic() - timer) * 1000)
unchanged = all(sha(Path(p)) == item['sha256'] for p, item in inputs.items())
reports = []
for match in re.finditer(r"'([^']+)'(?:\.{[^}]*})? (does not depend on any axioms|depends on axioms: \[([^\]]*)\])", text(out / 'stdout.txt')):
    reports.append({'name': match[1].split('.{')[0], 'axioms': [x.strip() for x in (match[3] or '').split(',') if x.strip()]})
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
names_match = sorted(r['name'] for r in reports) == sorted(expected)
axioms_allowed = all(set(r['axioms']) <= allowed for r in reports)
diagnostics_absent = not re.search(r'(?m)^.*(?:error|warning):', text(out / 'stdout.txt') + text(out / 'stderr.txt'))
record = {'format': 'physical-canonical-declaration-check-1', 'started_at_utc': started,
    'completed_at_utc': datetime.now(timezone.utc).isoformat(), 'command': command,
    'actual_exit_code': result.returncode, 'elapsed_ms': elapsed, 'input': pin(source),
    'input_snapshot': pin(out / source.name), 'input_pins': list(inputs.values()),
    'inputs_unchanged': unchanged, 'stdout': pin(out / 'stdout.txt'), 'stderr': pin(out / 'stderr.txt'),
    'expected_reports': len(expected), 'actual_reports': reports, 'report_names_match': names_match,
    'axioms_allowed': axioms_allowed, 'diagnostics_absent': diagnostics_absent,
    'source_acceptance': False, 'runner': pin(Path(__file__))}
put(out / 'receipt.json', (json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'receipt': pin(out / 'receipt.json'), 'actual_exit_code': result.returncode,
    'inputs_unchanged': unchanged, 'actual_report_count': len(reports), 'report_names_match': names_match,
    'axioms_allowed': axioms_allowed, 'diagnostics_absent': diagnostics_absent}, indent=2), flush=True)
if result.returncode or not names_match:
    print(text(out / 'stdout.txt')[-16000:])
assert unchanged and names_match and axioms_allowed and diagnostics_absent
raise SystemExit(result.returncode)
