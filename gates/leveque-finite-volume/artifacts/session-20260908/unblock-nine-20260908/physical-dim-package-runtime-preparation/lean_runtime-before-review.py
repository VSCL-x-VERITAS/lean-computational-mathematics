"""Supported POSIX lean.command: direct pinned Lean with complete package overlay.

No released code changes. All requested Lean argv are retained. Exact selected
Mathlib source compilations alone receive the three pinned package options.
The released caller already combines stdout/stderr; this adapter preserves that
combined byte stream while recording actual command/output/exit evidence.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import os
import shutil
import subprocess
import sys
import uuid

R = next(path for path in Path(__file__).resolve().parents if (path / 'lean-toolchain').is_file())
SUFFIXES = ('.olean', '.olean.private', '.olean.server', '.ir')
SAFE_ENV = ('PATH', 'LEAN_PATH', 'LEAN_SRC_PATH', 'LEAN_SYSROOT', 'LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH')


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads(path.read_bytes())


def encode(value):
    return (json.dumps(value, indent=2) + '\n').encode()


def write_new(path, value):
    with path.open('xb') as stream:
        stream.write(encode(value))


def native(path):
    return subprocess.check_output(['cygpath', '-w', str(path)], text=True).strip()


def posix(value):
    return Path(subprocess.check_output(['cygpath', '-u', value], text=True).strip())


def bound(item):
    path = (R / item['path']).resolve()
    require(path.is_relative_to(R.resolve()) and sha(path) == item['sha256'], 'Changed runtime input: ' + item['path'])
    return path


def check_closure(descriptor):
    for item in descriptor['artifacts']:
        bound({'path': item['path'], 'sha256': item['sha256']})
    for item in descriptor['expected_compiles']:
        bound(item['source'])


def capture_environment(descriptor_args):
    result = subprocess.run(['lake', 'env', 'python3', '-B', str(Path(__file__)), *descriptor_args, '--capture-environment'],
                            cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    require(result.returncode == 0 and not result.stderr, 'Canonical Lake environment capture failed')
    data = json.loads(result.stdout)
    require(set(data['environment']) <= set(SAFE_ENV) and data['environment'].get('LEAN_PATH'), 'Invalid path environment')
    return data


def infer_build(arguments, environment):
    if arguments == ['--version']:
        return None
    supplied = environment.get('LEAN_PATH', '')
    first = supplied.split(':', 1)[0] if supplied.startswith('/') else ''
    build = Path(first).resolve() if first else None
    if '--root' in arguments:
        index = arguments.index('--root')
        require(index + 1 < len(arguments), 'Missing --root argument')
        declared = Path(arguments[index + 1]).resolve()
        require(build == declared, 'Compile root differs from first released LEAN_PATH entry')
    if '--run' in arguments:
        require(build is not None, 'Dossier needs the first released temporary LEAN_PATH root')
    if build is not None:
        require(build.is_dir() and build != R and not build.is_relative_to(R / '.lake/build'), 'Invalid temporary root')
    return build


def initialization(build, descriptor, descriptor_ref, descriptor_args, adapter_sha):
    check_closure(descriptor)
    captured = capture_environment(descriptor_args)
    binary = posix(captured['lean']).resolve()
    require(sha(binary) == descriptor['native_lean']['sha256'], 'Lake-selected Lean binary differs')
    events = (R / descriptor['runtime_records']).resolve()
    require(events.is_relative_to(R.resolve()), 'Runtime records escape repository')
    events.mkdir(parents=True, exist_ok=True)
    events = events / uuid.uuid4().hex
    events.mkdir()
    for item in descriptor['artifacts']:
        destination = (build / item['overlay']).resolve()
        require(destination.is_relative_to(build) and not destination.exists(), 'Overlay destination conflict')
        destination.parent.mkdir(parents=True, exist_ok=True)
        os.link(R / item['path'], destination)
        require(os.path.samefile(destination, R / item['path']), 'Hardlink initialization differs')
    state = {'format': 'exact-package-runtime-state-1', 'descriptor': descriptor_ref, 'adapter_sha256': adapter_sha,
             'build': str(build), 'native_build': native(build), 'base_environment': captured['environment'],
             'lean': str(binary), 'records_directory': str(events), 'compiled': []}
    write_new(events / 'initialized.json', state)
    return state


def save_state(path, state):
    temporary = path.with_name(path.name + '.next')
    write_new(temporary, state)
    os.replace(temporary, path)


def compile_input(arguments, build, descriptor, state):
    if '-o' not in arguments or '--run' in arguments:
        return None
    index = arguments.index('-o')
    require(index + 1 < len(arguments), 'Missing output argument')
    source, output = Path(arguments[-1]).resolve(), Path(arguments[index + 1]).resolve()
    require(source.is_relative_to(build) and output.is_relative_to(build)
            and output == source.with_suffix('.olean'), 'Compile source/output escape or mismatch')
    position = len(state['compiled'])
    require(position < len(descriptor['expected_compiles']), 'Unexpected extra source compilation')
    expected = descriptor['expected_compiles'][position]
    require(source.relative_to(build).as_posix() == expected['relative_source'], 'Released compile order changed')
    bound(expected['source'])
    require(sha(source) == expected['source']['sha256'], 'Snapshot source changed')
    options = []
    if expected['module'].startswith('Mathlib.'):
        require(expected['module'] in ('Mathlib.Analysis.Calculus.ContDiff.Defs', 'Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries'),
                'Unapproved Mathlib source compilation')
        upstream = next(item for item in descriptor['mathlib_sources'] if item['path'].endswith('/' + expected['relative_source']))
        bound(upstream)
        require(upstream['sha256'] == expected['source']['sha256'], 'Mirror/upstream source differs')
        options = descriptor['mathlib_options']
    artifacts = {item['overlay']: item for item in descriptor['artifacts']}
    for suffix in SUFFIXES:
        target = source.with_suffix(suffix)
        if target.exists():
            relative = target.relative_to(build).as_posix()
            require(relative in artifacts and os.path.samefile(target, R / artifacts[relative]['path']),
                    'Existing output is not our initial cache hardlink')
            target.unlink()  # Only this new temporary hardlink entry is removed.
        require(not target.exists(), 'Output not detached')
    return {'expected': expected, 'source': source, 'output': output, 'options': options}


def verify_fresh(state, descriptor, build):
    require([item['module'] for item in state['compiled']] == [item['module'] for item in descriptor['expected_compiles']],
            'Dossier cannot run with missing fresh snapshot compilations')
    for item in state['compiled']:
        for output in item['outputs']:
            path = Path(output['path'])
            require(path.is_relative_to(build) and sha(path) == output['sha256'], 'Fresh snapshot output changed')


def main():
    require(os.name != 'nt' and Path.cwd().resolve() == R.resolve(), 'Use supported POSIX config command at repository root')
    arguments = sys.argv[1:]
    require(len(arguments) >= 5 and arguments[0] == '--descriptor' and arguments[2] == '--descriptor-sha256', 'Missing pinned descriptor')
    descriptor_args, arguments = arguments[:4], arguments[4:]
    descriptor_path = Path(descriptor_args[1]).resolve()
    descriptor_ref = {'path': descriptor_path.relative_to(R).as_posix(), 'sha256': descriptor_args[3]}
    descriptor = read(bound(descriptor_ref))
    for key in ('lean_toolchain', 'lake_manifest', 'mathlib_package'):
        bound(descriptor[key])
    require(descriptor['format'] == 'exact-direct-lean-package-overlay-1', 'Wrong descriptor format')
    require(descriptor['mathlib_options'] == ['-DautoImplicit=false', '-DmaxSynthPendingDepth=3', '-Dpp.unicode.fun=true'], 'Package options changed')
    if arguments == ['--capture-environment']:
        print(json.dumps({'environment': {key: os.environ[key] for key in SAFE_ENV if key in os.environ},
                          'lean': shutil.which('lean')}))
        return 0
    build = infer_build(arguments, os.environ)
    adapter_sha = sha(Path(__file__))
    state_path = build / '.exact-lean-runtime.json' if build is not None else None
    if state_path is None:
        captured = capture_environment(descriptor_args)
        binary = posix(captured['lean']).resolve()
        require(sha(binary) == descriptor['native_lean']['sha256'], 'Lean binary changed')
        environment = dict(os.environ, **captured['environment'])
        return subprocess.run([str(binary), *arguments], cwd=R, env=environment).returncode
    if state_path.exists():
        state = read(state_path)
        require(state['descriptor'] == descriptor_ref and state['adapter_sha256'] == adapter_sha
                and state['build'] == str(build), 'Runtime state changed')
    else:
        state = initialization(build, descriptor, descriptor_ref, descriptor_args, adapter_sha)
        save_state(state_path, state)
    binary = Path(state['lean'])
    require(sha(binary) == descriptor['native_lean']['sha256'], 'Lean binary changed')
    operation = compile_input(arguments, build, descriptor, state)
    is_dossier = '--run' in arguments
    if is_dossier:
        verify_fresh(state, descriptor, build)
    environment = dict(os.environ, **state['base_environment'])
    environment['LEAN_PATH'] = state['native_build'] + ';' + state['base_environment']['LEAN_PATH']
    command = [str(binary), *(operation['options'] if operation else []), *arguments]
    started = datetime.now(timezone.utc).isoformat()
    result = subprocess.run(command, cwd=R, env=environment, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    events = Path(state['records_directory'])
    name = uuid.uuid4().hex
    (events / (name + '-output.txt')).write_bytes(result.stdout)
    record = {'command': command, 'started_at': started, 'finished_at': datetime.now(timezone.utc).isoformat(),
              'exit_code': result.returncode, 'output_sha256': hashlib.sha256(result.stdout).hexdigest(),
              'output': str(events / (name + '-output.txt')), 'LEAN_PATH': environment['LEAN_PATH'],
              'source': operation['expected'] if operation else None, 'descriptor': descriptor_ref}
    if result.returncode == 0 and operation:
        outputs = []
        for suffix in SUFFIXES:
            path = operation['source'].with_suffix(suffix)
            if path.exists():
                for item in descriptor['artifacts']:
                    if item['overlay'] == path.relative_to(build).as_posix():
                        require(not os.path.samefile(path, R / item['path']), 'Fresh output still aliases original cache')
                outputs.append({'path': str(path), 'sha256': sha(path)})
        require(any(item['path'].endswith('.olean') for item in outputs), 'Lean produced no .olean')
        state['compiled'].append({'module': operation['expected']['module'], 'outputs': outputs, 'command_record': name + '.json'})
        save_state(state_path, state)
        record['outputs'] = outputs
    if result.returncode == 0 and is_dossier:
        verify_fresh(state, descriptor, build)
        check_closure(descriptor)
        record['final_original_pins_unchanged'] = True
        record['all_expected_snapshots_fresh'] = len(state['compiled'])
    write_new(events / (name + '.json'), record)
    sys.stdout.buffer.write(result.stdout)
    sys.stdout.buffer.flush()
    return result.returncode


if __name__ == '__main__':
    raise SystemExit(main())
