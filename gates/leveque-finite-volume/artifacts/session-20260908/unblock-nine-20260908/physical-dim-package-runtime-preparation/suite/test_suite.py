"""Pure filesystem/AST fixtures; no Lean, released preparation, model, or gate invocation."""
from pathlib import Path
from datetime import datetime, timezone
import ast
import copy
import hashlib
import importlib.util
import json
import os

P = Path(__file__).resolve().parent
D = P.parent.parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
if os.name == 'nt':
    exec(compile((D / 'fv-local-domain-review/native-long-path-io.py').read_bytes(),
                 'native-long-path-io.py', 'exec'), globals())
F = P / 'synthetic-fixture-01'
F.mkdir()
results = []
started = datetime.now(timezone.utc).isoformat()


def put(name, data):
    p = F / name
    p.parent.mkdir(parents=True, exist_ok=True)
    raw = data if isinstance(data, bytes) else (json.dumps(data, indent=2) + '\n').encode()
    with p.open('xb') as stream:
        stream.write(raw)
    return {'path': p.relative_to(R).as_posix(), 'sha256': hashlib.sha256(raw).hexdigest()}


def check(name, operation, reject=False):
    try:
        operation()
    except (ValueError, AssertionError, KeyError, TypeError, FileNotFoundError):
        if not reject:
            raise
    else:
        assert not reject, 'expected rejection: ' + name
    results.append({'name': name, 'expected': 'reject' if reject else 'pass', 'passed': True})


guard_raw = (P / 'compiler_guard.py.fragment').read_bytes()
ns = {'Path': Path, 'json': json, 'hashlib': hashlib}
exec(compile(guard_raw, 'synthetic-compiler-guard', 'exec'), ns)
adapter = put('fake-adapter.py', b'# Synthetic only; no executable runtime body.\n')
descriptor = put('fake-descriptor.json', {'format': 'SYNTHETIC_ONLY_NOT_A_RUNTIME_DESCRIPTOR'})
environment = put('fake-environment.txt', b'Synthetic environment input.\n')
plan = {'format': 'exact-package-command-extension-1', 'task_id': ns['PACKAGE_TASK_ID'],
        'row_id': ns['PACKAGE_ROW_ID'], 'target_file': ns['PACKAGE_TARGET']['path'],
        'target_declaration': ns['PACKAGE_TARGET']['declaration'], 'adapter': adapter,
        'descriptor': descriptor, 'environment_files': [environment],
        'command': ['python3', '-B', adapter['path'], '--descriptor', descriptor['path'],
                    '--descriptor-sha256', descriptor['sha256']]}
extension = put('fake-extension.json', plan)
ns.update(PACKAGE_COMPILER_EXTENSION=extension, PACKAGE_COMPILER_PLAN=plan)
spec = {'task_id': ns['PACKAGE_TASK_ID'], 'row_id': ns['PACKAGE_ROW_ID'],
        'target': ns['PACKAGE_TARGET'], 'compiler_command_extension': extension}
load = ns['load_package_compiler_command']
apply = ns['apply_package_compiler_command']
verify = ns['verify_package_compiler_command']
pins = ns['package_compiler_inputs'](extension, plan)
base = {'lean': {'command': ['lake', 'env', 'lean'], 'module_source_roots': ['.', 'unchanged-mirror'],
                 'environment_files': ['unrelated-existing-input']}, 'unchanged': {'value': 123}}
config = apply(base, plan)
config['lean']['environment_files'] += [p['path'] for p in pins]
manifest = {'lean_environment': copy.deepcopy(pins)}
lineage = {'compiler_command_extension': extension, 'compiler_command': plan['command'],
           'prior_compiler_command': ['lake', 'env', 'lean'], 'compiler_environment_inputs': pins}

check('valid exact extension load', lambda: load(R, spec))
check('valid config and manifest and lineage', lambda: verify(R, spec, config, manifest, lineage))
check('apply preserves caller and all unrelated fields', lambda: (
    apply(base, plan) == dict(base, lean=dict(base['lean'], command=plan['command']))
    and base['lean']['command'] == ['lake', 'env', 'lean']) or (_ for _ in ()).throw(AssertionError()))
for key, value in [('task_id', 'OTHER-PRODUCTION-20260908'), ('row_id', 'LEV-CH01-FV-FLUX-UPDATE'),
                   ('target', dict(ns['PACKAGE_TARGET'], declaration='Wrong.target')),
                   ('compiler_command_extension', dict(extension, sha256='0' * 64))]:
    check('reject changed spec ' + key, lambda k=key, v=value: load(R, dict(spec, **{k: v})), True)
for command in [['lean'], ['lake', 'env', 'lean', '--quiet'], ['python3', '-B', 'different.py']]:
    bad = copy.deepcopy(base); bad['lean']['command'] = command
    check('reject prior command ' + repr(command), lambda c=bad: apply(c, plan), True)

counter = 0


def mutated_plan(mutator, raw=None):
    global counter
    counter += 1
    value = copy.deepcopy(plan)
    mutator(value)
    pointer = put('mutation-' + str(counter) + '.json', raw if raw is not None else value)
    old_ref, old_plan = ns['PACKAGE_COMPILER_EXTENSION'], ns['PACKAGE_COMPILER_PLAN']
    ns.update(PACKAGE_COMPILER_EXTENSION=pointer, PACKAGE_COMPILER_PLAN=value)
    try:
        return load(R, dict(spec, compiler_command_extension=pointer))
    finally:
        ns.update(PACKAGE_COMPILER_EXTENSION=old_ref, PACKAGE_COMPILER_PLAN=old_plan)


check('reject extra closed schema key', lambda: mutated_plan(lambda p: p.update(unreviewed=True)), True)
check('reject missing schema key', lambda: mutated_plan(lambda p: p.pop('format')), True)
check('reject wrong extension format', lambda: mutated_plan(lambda p: p.update(format='different')), True)
check('reject wrong extension task', lambda: mutated_plan(lambda p: p.update(task_id='wrong')), True)
check('reject wrong extension row', lambda: mutated_plan(lambda p: p.update(row_id='wrong')), True)
check('reject wrong extension target file', lambda: mutated_plan(lambda p: p.update(target_file='wrong.lean')), True)
check('reject wrong extension target declaration', lambda: mutated_plan(lambda p: p.update(target_declaration='wrong')), True)
check('reject empty environment', lambda: mutated_plan(lambda p: p.update(environment_files=[])), True)
check('reject repeated environment input', lambda: mutated_plan(lambda p: p['environment_files'].append(environment)), True)
check('reject changed adapter bytes pin', lambda: mutated_plan(lambda p: p['adapter'].update(sha256='0' * 64)), True)
check('reject changed descriptor bytes pin', lambda: mutated_plan(lambda p: p['descriptor'].update(sha256='0' * 64)), True)
check('reject changed extra environment bytes pin', lambda: mutated_plan(lambda p: p['environment_files'][0].update(sha256='0' * 64)), True)
check('reject command extra argument', lambda: mutated_plan(lambda p: p['command'].append('--unreviewed')), True)
check('reject command executable', lambda: mutated_plan(lambda p: p['command'].__setitem__(0, 'python')), True)
check('reject command adapter mismatch', lambda: mutated_plan(lambda p: p['command'].__setitem__(2, 'different.py')), True)
check('reject command descriptor mismatch', lambda: mutated_plan(lambda p: p['command'].__setitem__(4, 'different.json')), True)
check('reject command descriptor digest mismatch', lambda: mutated_plan(lambda p: p['command'].__setitem__(6, '0' * 64)), True)
for path in ['../escape', '/absolute', 'C:/absolute', 'relative\\backslash', 'empty//segment']:
    check('reject unsafe reference ' + path,
          lambda path=path: mutated_plan(lambda p: p['adapter'].update(path=path)), True)
for digest in ['A' * 64, '0' * 63, 123]:
    check('reject invalid digest ' + str(digest),
          lambda digest=digest: mutated_plan(lambda p: p['adapter'].update(sha256=digest)), True)
check('reject duplicate JSON key', lambda: mutated_plan(lambda p: None,
      b'{"format":"x","format":"y"}'), True)
check('reject changed plan despite valid file pin', lambda: (
      ns.update(PACKAGE_COMPILER_PLAN=dict(plan, format='altered')), load(R, spec)), True)
ns['PACKAGE_COMPILER_PLAN'] = plan
for field in ['compiler_command_extension', 'compiler_command', 'prior_compiler_command', 'compiler_environment_inputs']:
    bad = copy.deepcopy(lineage); del bad[field]
    check('reject missing lineage ' + field, lambda bad=bad: verify(R, spec, config, manifest, bad), True)
for alteration in ['missing', 'duplicate', 'hash']:
    bad = copy.deepcopy(manifest)
    if alteration == 'missing': bad['lean_environment'].pop()
    elif alteration == 'duplicate': bad['lean_environment'].append(copy.deepcopy(pins[0]))
    else: bad['lean_environment'][0]['sha256'] = '0' * 64
    check('reject manifest ' + alteration, lambda bad=bad: verify(R, spec, config, bad, lineage), True)
for alteration in ['missing', 'duplicate', 'command']:
    bad = copy.deepcopy(config)
    if alteration == 'missing': bad['lean']['environment_files'].pop()
    elif alteration == 'duplicate': bad['lean']['environment_files'].append(pins[0]['path'])
    else: bad['lean']['command'].append('--extra')
    check('reject config ' + alteration, lambda bad=bad: verify(R, spec, bad, manifest, lineage), True)

ns.update(ROOT=R, PACKAGE_PREPARER={'sha256': 'a' * 64})
exec(compile((P / 'qualified_guard.py.fragment').read_bytes(), 'synthetic-qualified-guard', 'exec'), ns)
qualified = ns['validate_exact_package_compiler_lineage']
request, task = {'row': spec['row_id']}, {'task_id': spec['task_id'], 'target': spec['target']}
new_lineage = dict(lineage, preparer_sha256='a' * 64)
check('qualified new compiler branch', lambda: qualified(request, task, new_lineage, config, manifest))
check('old preparer branch remains untouched', lambda: qualified({}, {}, {'preparer_sha256': 'b' * 64}, {}, {}) == []
      or (_ for _ in ()).throw(AssertionError()))
check('qualified rejects wrong task', lambda: qualified(request, dict(task, task_id='wrong'), new_lineage, config, manifest), True)
check('qualified rejects missing compiler lineage', lambda: qualified(request, task, {'preparer_sha256': 'a' * 64}, config, manifest), True)

loader = importlib.util.spec_from_file_location('synthetic_suite_renderer', P / 'render_suite.py')
renderer = importlib.util.module_from_spec(loader)
loader.loader.exec_module(renderer)
render_ref = renderer.render(P / 'synthetic-render-01', extension)
render_manifest = json.loads((R / render_ref['path']).read_bytes())
check('seven prospective Python files plus dependency JSON', lambda:
      len(render_manifest['derivations']) == 7 or (_ for _ in ()).throw(AssertionError()))
for record in render_manifest['derivations']:
    staged = R / record['staged_file']['path']
    check('syntax ' + staged.name, lambda staged=staged: ast.parse(staged.read_bytes()))
    assert hashlib.sha256(staged.read_bytes()).hexdigest() == record['proposed_installed_ref']['sha256']
    assert not (R / record['proposed_installed_ref']['path']).exists(), 'unexpected installed successor'
new_preparer = R / render_manifest['derivations'][0]['staged_file']['path']
new_support = R / render_manifest['derivations'][1]['staged_file']['path']


def functions(path):
    text = path.read_text()
    return {n.name: ast.dump(n, include_attributes=False) for n in ast.parse(text).body if isinstance(n, ast.FunctionDef)}


old_functions = functions(D / 'prepare-successor-audit-with-dim-module-roots-v2.py')
new_functions = functions(new_preparer)
for name in old_functions:
    if name != 'released':
        check('unchanged original preparer function ' + name, lambda name=name:
              old_functions[name] == new_functions[name] or (_ for _ in ()).throw(AssertionError()))
old_functions = functions(D / 'gate-helpers/qualified_row_support_dim_roots_v2.py')
new_functions = functions(new_support)
for name in old_functions:
    if name not in ('validate_exact_dim_module_root_lineage', 'validate_source_context'):
        check('unchanged original support function ' + name, lambda name=name:
              old_functions[name] == new_functions[name] or (_ for _ in ()).throw(AssertionError()))
old_deps = json.loads((D / 'gate-helpers/source-context-dim-roots-v2-validator-dependencies.json').read_bytes())
new_deps = json.loads((R / render_manifest['dependency_derivation']['staged_file']['path']).read_bytes())
for key in ('validator_dependencies', 'source_context_protocol_inputs'):
    check('all old ' + key + ' retained', lambda key=key:
          all(item in new_deps[key] for item in old_deps[key]) or (_ for _ in ()).throw(AssertionError()))
check('renderer refuses overwrite', lambda: renderer.render(P / 'synthetic-render-01', extension), True)
check('renderer refuses outside scope', lambda: renderer.render(D / 'forbidden-test-output', extension), True)
assert not (D / 'forbidden-test-output').exists()
receipt = {'format': 'pure-package-suite-fixtures-1', 'started_at': started,
           'finished_at': datetime.now(timezone.utc).isoformat(), 'checks': results,
           'passed': len(results), 'fixture_render_manifest': render_ref,
           'synthetic_runtime_only': True, 'actual_runtime_compiles': 0,
           'released_preparations': 0, 'model_roles': 0, 'gate_mutations': 0,
           'source_acceptance': False}
print(json.dumps(receipt, indent=2))
put('receipt.json', receipt)
