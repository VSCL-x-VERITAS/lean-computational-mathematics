"""Bounded direct-native-Lean package overlay diagnostic; no official audit.

The complete actual imported Mathlib compiled closure is hardlinked read-only.
Before compiling a selected module every output artifact is detached by unlinking
only its temporary directory entry. No compiler writes through a cache hardlink.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import os
import subprocess
import sys
import time

assert os.name == 'nt' and len(sys.argv) == 2
P = Path(__file__).resolve().parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
O = P / sys.argv[1]
O.mkdir(exist_ok=False)
BUILD = (R / '.lake' / ('physical-dim-' + sys.argv[1])).resolve()
assert BUILD.parent == (R / '.lake').resolve() and not BUILD.exists()
BUILD.mkdir()
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: {'path': str(path), 'sha256': sha(path), 'bytes': path.stat().st_size}
read = lambda path: json.loads(path.read_bytes())


def write(path, data):
    with path.open('x', encoding='utf-8') as stream:
        stream.write(json.dumps(data, indent=2) + '\n')


closure = read(P / 'closure01/receipt.json')
assert closure['official_prepare'] is False and all(item['exit_code'] == 0 for item in closure['commands'])
private_path = P / 'closure01/environment-stdout.txt'
assert sha(private_path) == closure['commands'][0]['stdout']['sha256']
captured = read(private_path)
environment = captured['environment']
lean = Path(captured['lean'])
assert lean.is_file() and 'v4.29.0-rc3' in str(lean)
base_search = environment['LEAN_PATH']
environment = dict(environment, LEAN_PATH=str(BUILD) + ';' + base_search)
package = R / '.lake/packages/mathlib/.lake/build/lib/lean'
suffixes = ('.olean', '.olean.private', '.olean.server', '.ir')
selected = ('Mathlib/Analysis/Calculus/ContDiff/Defs', 'Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries')
pins = [ref(P / 'Closure.lean'), ref(P / 'AuditTarget.lean'), ref(Path(__file__)),
        ref(R / 'lean-toolchain'), ref(R / 'lake-manifest.json'), ref(lean),
        ref(R / '.lake/packages/mathlib/lakefile.lean'),
        ref(R / '.faithfulness-audit/scripts/declaration_dossier.lean')]
assert pins[-2]['sha256'] == '25966b1899a1aab3fa530abf39360189eb48ccc6e048f0bf9a1725f4c38346c4'
write(O / 'runtime.json', {'lean': ref(lean), 'LEAN_PATH': environment['LEAN_PATH'],
    'relevant_base_environment': {key: environment.get(key) for key in
        ('LEAN_SRC_PATH', 'LEAN_SYSROOT', 'PATH', 'LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH')},
    'private_environment_capture': {'sha256': sha(private_path), 'publication': 'EXCLUDE exact private raw environment file'},
    'closure_receipt': ref(P / 'closure01/receipt.json'), 'inputs': pins, 'build_root': str(BUILD)})

links = []
for item in closure['artifacts']:
    source = Path(item['path'])
    assert source.resolve().is_relative_to(package.resolve()) and sha(source) == item['sha256']
    rel = source.relative_to(package)
    destination = BUILD / rel
    assert destination.resolve().is_relative_to(BUILD)
    destination.parent.mkdir(parents=True, exist_ok=True)
    os.link(source, destination)
    assert os.path.samefile(source, destination)
    links.append({'source': item, 'overlay_path': str(destination)})
write(O / 'links.json', {'links': links, 'count': len(links), 'bytes': closure['artifact_bytes'],
                       'write_policy': 'No compiler output may remain linked to an original cached artifact.'})
for relative in selected:
    source = R / '.lake/packages/mathlib' / (relative + '.lean')
    dest = BUILD / (relative + '.lean')
    dest.write_bytes(source.read_bytes())
    pins.append(ref(source))
assert sha(BUILD / (selected[0] + '.lean')) == '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'
assert sha(BUILD / (selected[1] + '.lean')) == 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'
records, detached = [], []
flags = ['-DautoImplicit=false', '-DmaxSynthPendingDepth=3', '-Dpp.unicode.fun=true']


def run(label, args, expected=0):
    command = [str(lean), *args]
    start, at = time.monotonic(), datetime.now(timezone.utc).isoformat()
    with (O / (label + '-stdout.txt')).open('xb') as out, (O / (label + '-stderr.txt')).open('xb') as err:
        result = subprocess.run(command, cwd=R, env=environment, stdout=out, stderr=err)
    record = {'command': command, 'cwd': str(R), 'started_at': at,
              'elapsed_ms': int((time.monotonic() - start) * 1000), 'exit_code': result.returncode,
              'stdout': ref(O / (label + '-stdout.txt')), 'stderr': ref(O / (label + '-stderr.txt'))}
    write(O / (label + '-exit.json'), record)
    records.append(record)
    assert result.returncode == expected, label


# Match the actual released parser's Defs-then-FTaylor order exactly.
for relative in selected:
    for suffix in suffixes:
        output = BUILD / (relative + suffix)
        if output.exists():
            original = package / (relative + suffix)
            assert output.resolve().is_relative_to(BUILD) and original.resolve().is_relative_to(package.resolve())
            assert os.path.samefile(output, original)
            detached.append({'temporary': str(output), 'original': ref(original)})
            output.unlink()  # Removes only our new temporary hardlink entry.
    write(O / (Path(relative).name + '-detached.json'), {'detached_so_far': detached})
    run(Path(relative).name, [*flags, '--root', str(BUILD), '-o', str(BUILD / (relative + '.olean')),
                             str(BUILD / (relative + '.lean'))])
    for suffix in suffixes:
        output, original = BUILD / (relative + suffix), package / (relative + suffix)
        if output.exists() and original.exists():
            assert not os.path.samefile(output, original)

target = BUILD / 'AuditTarget.lean'
target.write_bytes((P / 'AuditTarget.lean').read_bytes())
run('consumer', ['--root', str(BUILD), '-o', str(BUILD / 'AuditTarget.olean'), str(target)])
modules = BUILD / 'local-modules.txt'
modules.write_text('AuditTarget\n' + '\n'.join(name.replace('/', '.') for name in selected) + '\n', encoding='utf-8')
dossier = R / '.faithfulness-audit/scripts/declaration_dossier.lean'
arguments = ['--run', str(dossier), 'AuditTarget', 'auditOverlayFixture', str(modules)]
run('dossier-positive', arguments)
for relative in selected:
    artifact = BUILD / (relative + '.olean')
    hidden = BUILD / (relative + '.olean.negative-hold')
    assert artifact.resolve().is_relative_to(BUILD) and hidden.resolve().is_relative_to(BUILD)
    digest = sha(artifact)
    artifact.rename(hidden)
    try:
        run('dossier-missing-' + Path(relative).name, arguments, expected=1)
    finally:
        hidden.rename(artifact)
    assert sha(artifact) == digest
assert all(sha(Path(item['path'])) == item['sha256'] for item in pins)
assert all(sha(Path(item['path'])) == item['sha256'] for item in closure['artifacts'])
write(O / 'receipt.json', {'format': 'native-direct-lean-complete-overlay-diagnostic-1', 'records': records,
      'pins': pins, 'closure': ref(P / 'closure01/receipt.json'), 'runtime': ref(O / 'runtime.json'),
      'links': ref(O / 'links.json'), 'canonical_pins_unchanged': True,
      'fresh_artifacts': [ref(BUILD / (relative + suffix)) for relative in selected for suffix in suffixes
                          if (BUILD / (relative + suffix)).exists()],
      'compile_order': list(selected), 'dossier_helper_unchanged': True,
      'official_preparation': False, 'audit_roles': False, 'source_acceptance': False})
print(json.dumps({'receipt': ref(O / 'receipt.json'), 'actual_commands': len(records)}))
