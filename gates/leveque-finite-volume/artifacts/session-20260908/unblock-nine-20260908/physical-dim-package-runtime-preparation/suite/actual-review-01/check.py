"""Pure actual-input coherence review. No operational entry point is imported or invoked."""
from pathlib import Path
from datetime import datetime, timezone
import ast
import copy
import hashlib
import json
import os
import re

A = Path(__file__).resolve().parent
P = A.parent.parent
D = P.parent
S = D.parent
R = next(path for path in A.parents if (path / 'lean-toolchain').is_file())
if os.name == 'nt':
    exec(compile((D / 'fv-local-domain-review/native-long-path-io.py').read_bytes(),
                 'native-long-path-io.py', 'exec'), globals())
observed = {}
checks = []


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path, expected=None):
    raw = path.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if expected is not None:
        assert digest == expected
    observed[path.relative_to(R).as_posix()] = digest
    return raw


def load(path, expected=None):
    return json.loads(read(path, expected))


def check(name, fn, reject=False):
    try:
        fn()
    except (AssertionError, ValueError, KeyError, TypeError):
        if not reject:
            raise
    else:
        assert not reject, 'expected rejection: ' + name
    checks.append({'name': name, 'expected': 'reject' if reject else 'pass', 'passed': True})


def require_true(condition):
    assert condition


def pure_namespace(raw, functions, constants=()):
    tree = ast.parse(raw)
    body = []
    for node in tree.body:
        if isinstance(node, ast.FunctionDef) and node.name in functions:
            body.append(node)
        elif isinstance(node, ast.Assign) and len(node.targets) == 1 and isinstance(node.targets[0], ast.Name):
            if node.targets[0].id in constants:
                ast.literal_eval(node.value)
                body.append(node)
    namespace = {'Path': Path, 'json': json, 'hashlib': hashlib, 're': re, 'ROOT': R, 'sha': sha}
    assert len(body) == len(functions) + len(constants)
    exec(compile(ast.Module(body=body, type_ignores=[]), 'selected-pure-review-definitions', 'exec'), namespace)
    return namespace


manifest_path = P / 'suite/actual-render-01/manifest.json'
manifest = load(manifest_path, '8906052ebcd027fc8f473825f780e98f7647e22b4c68681b439e8014b913e5cb')
assert len(manifest['derivations']) == 7
rendered = {}
for record in manifest['derivations']:
    before = read(R / record['parent']['path'], record['parent']['sha256']).decode()
    after = before
    for replacement in record['replacements']:
        assert after.count(replacement['before']) == 1
        after = after.replace(replacement['before'], replacement['after'])
    raw = read(R / record['staged_file']['path'], record['staged_file']['sha256'])
    assert raw == after.encode()
    assert hashlib.sha256(raw).hexdigest() == record['proposed_installed_ref']['sha256']
    read(R / record['diff']['path'], record['diff']['sha256'])
    ast.parse(raw)
    rendered[Path(record['proposed_installed_ref']['path']).name] = raw
check('all seven actual helper derivations reconstruct exactly', lambda: require_true(len(rendered) == 7))

preparer = rendered['prepare-successor-audit-with-package-command-v1.py']
package_functions = {'package_require', 'package_json', 'package_bound_bytes', 'package_compiler_inputs',
                     'load_package_compiler_command', 'apply_package_compiler_command', 'verify_package_compiler_command'}
package_constants = {'PACKAGE_COMPILER_EXTENSION', 'PACKAGE_COMPILER_PLAN', 'PACKAGE_TASK_ID', 'PACKAGE_ROW_ID', 'PACKAGE_TARGET'}
root_functions = {'load_dim_module_roots', 'apply_dim_module_roots', 'verify_dim_module_roots'}
root_constants = {'DIM_MODULE_EXTENSION', 'DIM_MODULE_PLAN', 'DIM_MODULE_CONTEXT', 'DIM_MODULE_TARGET'}
ns = pure_namespace(preparer, package_functions | root_functions | {'load_additional_supplement'},
                    package_constants | root_constants)
old_spec_path = D / 'physical-dim-audit-preparation/spec-01/audit-spec.json'
old_spec = load(old_spec_path, '3210def614922a0d3afa8a5d382be6bf7a7d2b42ac0465f6cd160ee52f872dc2')
spec = copy.deepcopy(old_spec)
spec['task_id'] = ns['PACKAGE_TASK_ID']
spec['compiler_command_extension'] = manifest['compiler_command_extension']
changed_spec_keys = [key for key in spec if old_spec.get(key) != spec[key]]
assert changed_spec_keys == ['task_id', 'compiler_command_extension']
extension = load(R / spec['compiler_command_extension']['path'], spec['compiler_command_extension']['sha256'])
assert extension == ns['PACKAGE_COMPILER_PLAN']
for item in manifest['compiler_environment_inputs']:
    read(R / item['path'], item['sha256'])
module_plan = ns['load_dim_module_roots'](R, spec)
compiler_plan = ns['load_package_compiler_command'](R, spec)
check('actual spec target shape accepted by both root and compiler loaders', lambda: require_true(spec['target'] == ns['PACKAGE_TARGET']))
check('exact new task identity is required', lambda: ns['load_package_compiler_command'](R, old_spec), True)
check('valid target uses path/declaration without extra task-level fields', lambda: require_true(set(spec['target']) == {'path', 'declaration'}))

prior_config_path = S / spec['prior_config']
prior_config = load(prior_config_path)
prior_manifest_path = S / 'audits' / spec['prior_task'] / 'faithfulness/manifest.json'
prior_manifest = load(prior_manifest_path)
recorded = {item['path']: item['sha256'] for item in prior_manifest['lean_environment']}
for path in prior_config['lean']['environment_files']:
    read(R / path, recorded[path])
check('all exact prior configured environment files still match sealed predecessor', lambda: require_true(True))
config = ns['apply_dim_module_roots'](prior_config, module_plan)
config = ns['apply_package_compiler_command'](config, compiler_plan)
additional_packet, additional_raw, additional_pins = ns['load_additional_supplement'](R, spec['additional_supplement'])
check('unchanged real additional supplement passes exact native span/input guards', lambda: require_true(bool(additional_packet['native_output_spans'])))
root_pins = [ns['DIM_MODULE_EXTENSION'], *module_plan['environment_files']]
compiler_pins = ns['package_compiler_inputs'](ns['PACKAGE_COMPILER_EXTENSION'], compiler_plan)
assert compiler_pins == manifest['compiler_environment_inputs']
config['lean']['environment_files'] = list(dict.fromkeys([*config['lean']['environment_files'],
    *[item['path'] for item in root_pins + compiler_pins + additional_pins]]))
# This in-memory object tests guards only. It is not a prepared or released manifest.
model_manifest = {'lean_environment': []}
for path in config['lean']['environment_files']:
    model_manifest['lean_environment'].append({'path': path, 'sha256': sha(R / path)})
lineage = {'preparer_sha256': manifest['entry_points']['preparer']['sha256'],
           'module_source_root_extension': ns['DIM_MODULE_EXTENSION'], 'module_source_roots': module_plan['roots'],
           'compiler_command_extension': ns['PACKAGE_COMPILER_EXTENSION'], 'compiler_command': compiler_plan['command'],
           'prior_compiler_command': ['lake', 'env', 'lean'], 'compiler_environment_inputs': compiler_pins}
ns['verify_dim_module_roots'](R, spec, config, model_manifest)
ns['verify_package_compiler_command'](R, spec, config, model_manifest, lineage)
check('actual root and compiler inputs coexist without conflicting pins', lambda: require_true(True))

support = rendered['qualified_row_support_package_command_v1.py']
q_functions = package_functions | {'require', 'repo_path', 'bound', 'source_context_ref', 'source_context_json',
    'source_context_environment', 'validate_exact_dim_module_root_lineage', 'validate_exact_package_compiler_lineage'}
q_constants = package_constants | {'DIM_ROOT_PREPARER', 'DIM_ROOT_EXTENSION', 'DIM_ROOT_PLAN', 'DIM_ROOT_CONTEXT',
                                  'PACKAGE_PREPARER', 'SOURCE_CONTEXT_PREPARERS'}
q = pure_namespace(support, q_functions, q_constants)
request = {'row': spec['row_id'], 'source_context_extension': spec['source_context_extension']}
task = {'task_id': spec['task_id'], 'target': copy.deepcopy(spec['target'])}
root_result = q['validate_exact_dim_module_root_lineage'](request, lineage, config, model_manifest)
compiler_result = q['validate_exact_package_compiler_lineage'](request, task, lineage, config, model_manifest)
check('new exact preparer activates support root-lineage branch', lambda: require_true(root_result == root_pins))
check('new exact preparer activates support compiler-lineage branch', lambda: require_true(compiler_result == compiler_pins))
check('support whitelist resolves exact new preparer file/hash', lambda: require_true(
    q['SOURCE_CONTEXT_PREPARERS'][lineage['preparer_sha256']] == Path(manifest['entry_points']['preparer']['path']).name
    and q['PACKAGE_PREPARER'] == manifest['entry_points']['preparer']))
check('qualified compiler rejects wrong row', lambda: q['validate_exact_package_compiler_lineage'](
      dict(request, row='wrong'), task, lineage, config, model_manifest), True)
check('qualified root rejects omitted inherited roots', lambda: q['validate_exact_dim_module_root_lineage'](
      request, dict(lineage, module_source_roots=['.']), config, model_manifest), True)
check('qualified compiler rejects missing lineage', lambda: q['validate_exact_package_compiler_lineage'](
      request, task, {'preparer_sha256': lineage['preparer_sha256']}, config, model_manifest), True)

descriptor = load(R / extension['descriptor']['path'], extension['descriptor']['sha256'])
order = load(R / descriptor['released_order']['path'], descriptor['released_order']['sha256'])
assert descriptor['task_id'] == spec['task_id'] and len(descriptor['expected_compiles']) == 42
assert [item['module'] for item in descriptor['expected_compiles']] == order['ordered_modules'] + ['AuditTarget']
assert len(order['ordered_modules']) == 41
assert len({item['module'] for item in descriptor['expected_compiles']}) == 42
for item in descriptor['expected_compiles']:
    read(R / item['source']['path'], item['source']['sha256'])
assert descriptor['expected_compiles'][-1]['source']['path'] == spec['target']['path']
assert len({item['overlay'] for item in descriptor['artifacts']}) == len(descriptor['artifacts']) == 9547
check('production descriptor remains 41 source modules plus distinct AuditTarget', lambda: require_true(True))
check('runtime output directory is not a source compile or configured environment input', lambda: require_true(
    not any(item['source']['path'].startswith(descriptor['runtime_records']) for item in descriptor['expected_compiles'])
    and not any(path.startswith(descriptor['runtime_records']) for path in config['lean']['environment_files'])))
fixture = load(P / 'fixture-03/receipt.json')
fixture_descriptor = load(R / fixture['descriptor']['path'], fixture['descriptor']['sha256'])
assert len(fixture_descriptor['expected_compiles']) == 3 and fixture['descriptor'] != extension['descriptor']
check('three-source diagnostic is distinct from the required 42-compile production descriptor', lambda: require_true(True))

dep_record = manifest['dependency_derivation']
new_deps = load(R / dep_record['staged_file']['path'], dep_record['staged_file']['sha256'])
old_deps = load(R / dep_record['parent']['path'], dep_record['parent']['sha256'])
for key in ('validator_dependencies', 'source_context_protocol_inputs'):
    assert all(item in new_deps[key] for item in old_deps[key])
assert new_deps['audit_validator'] == manifest['entry_points']['validator']
assert new_deps['validator_dependencies'][0] == manifest['entry_points']['support']
check('actual dependency cascade preserves every old v2 entry and pins the new validator/support', lambda: require_true(True))
for relative, digest in observed.items():
    assert sha(R / relative) == digest, 'input changed during pure review: ' + relative
result = {'format': 'actual-package-suite-independent-coherence-review-1',
          'reviewed_at': datetime.now(timezone.utc).isoformat(), 'checks': checks, 'passed': len(checks),
          'old_spec_sha256': observed[old_spec_path.relative_to(R).as_posix()], 'substituted_spec_keys': changed_spec_keys,
          'actual_render_manifest_sha256': observed[manifest_path.relative_to(R).as_posix()],
          'prior_configured_environment_files': len(prior_config['lean']['environment_files']),
          'compiler_environment_inputs_after_dedup': len(compiler_pins), 'root_environment_inputs': len(root_pins),
          'native_supplement_spans': len(additional_packet['native_output_spans']),
          'source_module_compiles_required': 41, 'audit_target_compiles_required': 1,
          'production_compiles_executed_by_review': 0, 'diagnostic_compiles_distinguished': 3,
          'binding_guard_manifest_is_in_memory_model_only': True,
          'observed_inputs': [{'path': path, 'sha256': digest} for path, digest in sorted(observed.items())],
          'released_preparations': 0, 'model_roles': 0, 'gate_mutations': 0, 'source_acceptance': False}
with (A / 'result.json').open('xb') as stream:
    stream.write((json.dumps(result, indent=2) + '\n').encode())
print(json.dumps({'passed': len(checks), 'result_sha256': sha(A / 'result.json'), 'operational_runs': 0}))
