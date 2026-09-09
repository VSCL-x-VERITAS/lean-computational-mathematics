"""Render prospective helpers only; never install or run any operational helper.

The explicit finalized extension ref is an input, not a fabricated future pin.
All output writes are exclusive and confined to a new child of this directory.
"""
from pathlib import Path
import argparse
import ast
import difflib
import hashlib
import json
import os

P = Path(__file__).resolve().parent
D = P.parent.parent
H = D / 'gate-helpers'
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
if os.name == 'nt':
    exec(compile((D / 'fv-local-domain-review/native-long-path-io.py').read_bytes(),
                 'native-long-path-io.py', 'exec'), globals())

PARENTS = {
    'prepare-successor-audit-with-dim-module-roots-v2.py': 'ca25290925de0bb5f8d135c82b380077f7ee0e1a015fca7e6f00031d138f8b54',
    'gate-helpers/qualified_row_support_dim_roots_v2.py': 'a593d38ed66d7e09804c5ecaadb2e436b22f699e6c8d0f94853999e52e1ea73e',
    'gate-helpers/bind-qualified-row-dim-roots-v2.py': '59aae8c3d7bd684a9051ead06afd596ca2a180b6b3a1fc9343d28669fbba471a',
    'gate-helpers/validate-closed-row-audits-dim-roots-v2.py': 'a4d03497a9541364189c55478fcf4aa1bcd76a4c17551cc16e6a598cb9582c81',
    'gate-helpers/validate-closed-row-audits-rebind-dim-roots-v2.py': '2359c63feef200aff9831b0554fc7029dfa7b496667065c53709ace4044b40e7',
    'gate-helpers/rebind-accepted-row-batch-dim-roots-v2.py': '3c2765ab7dc84555f7021497403d12fc71b4c0bfc45cdd79fbf307e65771db73',
    'gate-helpers/bind-final-global-evidence-dim-roots-v2.py': '6f611d8822fbd389a44a0345a9ed0c9b36585961dcce612911eca0eca7d57eb9',
    'gate-helpers/source-context-dim-roots-v2-validator-dependencies.json': '9e6a000dfbfaf5739e3c5b8480e351fa48a23179eff680efe49dbbea323457e1',
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def ref(path):
    return {'path': path.resolve().relative_to(R.resolve()).as_posix(), 'sha256': sha(path)}


def encode(value):
    return (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode()


def assignment(text, name):
    nodes = [node for node in ast.parse(text).body if isinstance(node, ast.Assign)
             and len(node.targets) == 1 and isinstance(node.targets[0], ast.Name) and node.targets[0].id == name]
    assert len(nodes) == 1, name
    return nodes[0]


def render(output, extension_ref):
    output = output.resolve()
    assert output.parent == P.resolve() and not output.exists(), 'Use a new direct child of suite only'
    before = {name: (D / name).read_bytes() for name in PARENTS}
    assert all(hashlib.sha256(before[name]).hexdigest() == digest for name, digest in PARENTS.items())
    guard = (P / 'compiler_guard.py.fragment').read_text(encoding='utf-8')
    qualified_guard = (P / 'qualified_guard.py.fragment').read_text(encoding='utf-8')
    namespace = {'Path': Path, 'hashlib': hashlib, 'json': json}
    exec(compile(guard, 'prospective-pure-compiler-guard', 'exec'), namespace)
    raw = namespace['package_bound_bytes'](R, extension_ref)
    plan = namespace['package_json'](raw)
    namespace.update(PACKAGE_COMPILER_EXTENSION=extension_ref, PACKAGE_COMPILER_PLAN=plan)
    exact_spec = {'task_id': namespace['PACKAGE_TASK_ID'], 'row_id': namespace['PACKAGE_ROW_ID'],
                  'target': namespace['PACKAGE_TARGET'], 'compiler_command_extension': extension_ref}
    namespace['load_package_compiler_command'](R, exact_spec)
    compiler_inputs = namespace['package_compiler_inputs'](extension_ref, plan)
    output.mkdir()
    records = []

    def put(relative, data):
        path = output / relative
        assert path.resolve().is_relative_to(output)
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open('xb') as stream:
            stream.write(data if isinstance(data, bytes) else encode(data))
        return ref(path)

    def planned(relative, raw):
        return {'path': (D / relative).relative_to(R).as_posix(), 'sha256': hashlib.sha256(raw).hexdigest()}

    def derive(old, new, changes):
        prior = before[old].decode('utf-8')
        current = prior
        for find, replacement in changes:
            assert current.count(find) == 1, (old, 'exact replacement count', find[:100])
            current = current.replace(find, replacement)
        ast.parse(current)
        raw = current.encode('utf-8')
        staged = put('prospective/' + new, raw)
        delta = ''.join(difflib.unified_diff(prior.splitlines(True), current.splitlines(True), old, new))
        diff = put('diffs/' + Path(new).name + '.diff', delta.encode())
        result = planned(new, raw)
        records.append({'parent': ref(D / old), 'staged_file': staged, 'proposed_installed_ref': result,
                        'diff': diff, 'replacements': [{'before': a, 'after': b} for a, b in changes]})
        return result

    constants = 'PACKAGE_COMPILER_EXTENSION = ' + repr(extension_ref) + '\nPACKAGE_COMPILER_PLAN = ' + repr(plan) + '\n\n'
    preparer_name = 'prepare-successor-audit-with-package-command-v1.py'
    preparer = derive('prepare-successor-audit-with-dim-module-roots-v2.py', preparer_name, [
        ('assert len(sys.argv) in (2,6)', constants + guard + '\nassert len(sys.argv) in (2,6)'),
        ('module_root_plan=load_dim_module_roots(R,spec)',
         'module_root_plan=load_dim_module_roots(R,spec)\ncompiler_plan=load_package_compiler_command(R,spec)'),
        ('cfg=apply_dim_module_roots(cfg,module_root_plan)',
         'cfg=apply_dim_module_roots(cfg,module_root_plan)\ncfg=apply_package_compiler_command(cfg,compiler_plan)'),
        ("cfg['lean']['environment_files']=list(dict.fromkeys(envfiles))",
         "envfiles.extend(x['path'] for x in package_compiler_inputs(PACKAGE_COMPILER_EXTENSION,compiler_plan))\ncfg['lean']['environment_files']=list(dict.fromkeys(envfiles))"),
        ('verify_dim_module_roots(R,spec,cfg)\nfor rel',
         'verify_dim_module_roots(R,spec,cfg)\nverify_package_compiler_command(R,spec,cfg)\nfor rel'),
        ("'module_source_root_extension':spec['module_source_root_extension']",
         "'compiler_command_extension':spec['compiler_command_extension'],'compiler_command':compiler_plan['command'],'prior_compiler_command':['lake','env','lean'],'compiler_environment_inputs':package_compiler_inputs(PACKAGE_COMPILER_EXTENSION,compiler_plan),'module_source_root_extension':spec['module_source_root_extension']"),
        ('def released(label,script,args,cwd):\n',
         'def released(label,script,args,cwd):\n verify_package_compiler_command(R,spec,cfg,lineage=json.loads((T/\'preparation-lineage.json\').read_bytes()))\n'),
        ("parent_id='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'",
         "verify_package_compiler_command(R,spec,cfg,json.loads((T/'faithfulness/manifest.json').read_bytes()),json.loads((T/'preparation-lineage.json').read_bytes()))\nparent_id='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'"),
        ("if recovery_pins:verify_partial_recovery(T,recovery_pins)\nprint(json.dumps({'prepared':",
         "verify_package_compiler_command(R,spec,cfg,json.loads((T/'faithfulness/manifest.json').read_bytes()),json.loads((T/'preparation-lineage.json').read_bytes()))\nif recovery_pins:verify_partial_recovery(T,recovery_pins)\nprint(json.dumps({'prepared':"),
    ])
    old_support = 'gate-helpers/qualified_row_support_dim_roots_v2.py'
    support_text = before[old_support].decode()
    preparers_node = assignment(support_text, 'SOURCE_CONTEXT_PREPARERS')
    preparers = ast.literal_eval(preparers_node.value)
    preparers[preparer['sha256']] = preparer_name
    new_support_name = 'qualified_row_support_package_command_v1.py'
    support = derive(old_support, 'gate-helpers/' + new_support_name, [
        (ast.get_source_segment(support_text, preparers_node), 'SOURCE_CONTEXT_PREPARERS = ' + repr(preparers)),
        ('def validate_exact_dim_module_root_lineage(request, lineage, config, manifest):',
         'PACKAGE_PREPARER = ' + repr(preparer) + '\n' + constants + guard + '\n' + qualified_guard +
         'def validate_exact_dim_module_root_lineage(request, lineage, config, manifest):'),
        ("if lineage['preparer_sha256'] != DIM_ROOT_PREPARER['sha256']:",
         "if lineage['preparer_sha256'] not in (DIM_ROOT_PREPARER['sha256'], PACKAGE_PREPARER['sha256']):"),
        ('module_root_provenance = validate_exact_dim_module_root_lineage(request, lineage, config, manifest)',
         'module_root_provenance = validate_exact_dim_module_root_lineage(request, lineage, config, manifest)\n    compiler_provenance = validate_exact_package_compiler_lineage(request, task, lineage, config, manifest)'),
        ('provenance += module_root_provenance', 'provenance += module_root_provenance + compiler_provenance'),
    ])
    single = derive('gate-helpers/bind-qualified-row-dim-roots-v2.py', 'gate-helpers/bind-qualified-row-package-command-v1.py', [
        ('import qualified_row_support_dim_roots_v2 as q', 'import qualified_row_support_package_command_v1 as q')])
    validator = derive('gate-helpers/validate-closed-row-audits-dim-roots-v2.py',
                       'gate-helpers/validate-closed-row-audits-package-command-v1.py', [
        ('import qualified_row_support_dim_roots_v2 as qualified', 'import qualified_row_support_package_command_v1 as qualified')])
    proposal_validator = derive('gate-helpers/validate-closed-row-audits-rebind-dim-roots-v2.py',
                                'gate-helpers/validate-closed-row-audits-rebind-package-command-v1.py', [
        ('import qualified_row_support_dim_roots_v2 as qualified', 'import qualified_row_support_package_command_v1 as qualified')])
    old_deps_name = 'gate-helpers/source-context-dim-roots-v2-validator-dependencies.json'
    deps = json.loads(before[old_deps_name])
    original_dependencies = json.loads(before[old_deps_name])
    deps['audit_validator'] = validator
    deps['validator_dependencies'] = [support, *deps['validator_dependencies']]
    deps['producer'] = ref(Path(__file__))
    deps['source_context_protocol_inputs'] += [ref(D / old_deps_name), original_dependencies['audit_validator'], preparer,
                                               *compiler_inputs]
    unique = {}
    for item in deps['source_context_protocol_inputs']:
        assert item['path'] not in unique or unique[item['path']] == item, 'conflicting protocol pin'
        unique[item['path']] = item
    deps['source_context_protocol_inputs'] = list(unique.values())
    deps_name = 'gate-helpers/source-context-package-command-v1-validator-dependencies.json'
    deps_raw = encode(deps)
    deps_staged = put('prospective/' + deps_name, deps_raw)
    deps_ref = planned(deps_name, deps_raw)
    deps_diff = put('diffs/' + Path(deps_name).name + '.diff', ''.join(difflib.unified_diff(
        before[old_deps_name].decode().splitlines(True), deps_raw.decode().splitlines(True), old_deps_name, deps_name)).encode())
    old_batch = 'gate-helpers/rebind-accepted-row-batch-dim-roots-v2.py'
    changes = []
    for old, new in [('qualified_row_support_dim_roots_v2.py', support),
                     ('validate-closed-row-audits-rebind-dim-roots-v2.py', proposal_validator),
                     ('source-context-dim-roots-v2-validator-dependencies.json', deps_ref)]:
        changes.append((repr(old) + ': ' + repr(PARENTS['gate-helpers/' + old]),
                        repr(Path(new['path']).name) + ': ' + repr(new['sha256'])))
    changes += [
        ("q = load('batch_qualified_support_dim_roots_v2', 'qualified_row_support_dim_roots_v2.py')",
         "q = load('batch_qualified_support_package_command_v1', 'qualified_row_support_package_command_v1.py')"),
        ("deps = parse(reader.read(H / 'source-context-dim-roots-v2-validator-dependencies.json'))",
         "deps = parse(reader.read(H / 'source-context-package-command-v1-validator-dependencies.json'))"),
        ("str(H/'validate-closed-row-audits-rebind-dim-roots-v2.py'), '--validate'",
         "str(H/'validate-closed-row-audits-rebind-package-command-v1.py'), '--validate'"),
    ]
    batch = derive(old_batch, 'gate-helpers/rebind-accepted-row-batch-package-command-v1.py', changes)
    old_global = 'gate-helpers/bind-final-global-evidence-dim-roots-v2.py'
    text = before[old_global].decode()
    validator_node = assignment(text, 'FINAL_VALIDATOR_PIN')
    dependencies_node = assignment(text, 'FINAL_VALIDATOR_DEPENDENCIES')
    dependencies = [support, *ast.literal_eval(dependencies_node.value)]
    global_binder = derive(old_global, 'gate-helpers/bind-final-global-evidence-package-command-v1.py', [
        (ast.get_source_segment(text, validator_node), 'FINAL_VALIDATOR_PIN = ' + repr(validator)),
        (ast.get_source_segment(text, dependencies_node), 'FINAL_VALIDATOR_DEPENDENCIES = ' + repr(dependencies)),
        ("endswith('/qualified_row_support_dim_roots_v2.py')", "endswith('/qualified_row_support_package_command_v1.py')"),
        ("spec_from_file_location('final_global_qualified_dim_roots_v2', path)",
         "spec_from_file_location('final_global_qualified_package_command_v1', path)"),
    ])
    assert all((D / name).read_bytes() == raw for name, raw in before.items()), 'historical parent changed during render'
    namespace['load_package_compiler_command'](R, exact_spec)
    manifest = {
        'format': 'prospective-package-command-helper-suite-1', 'status': 'REVIEW_COPIES_ONLY_NOT_INSTALLED',
        'renderer': ref(Path(__file__)), 'guard': ref(P / 'compiler_guard.py.fragment'),
        'qualified_guard': ref(P / 'qualified_guard.py.fragment'), 'compiler_command_extension': extension_ref,
        'compiler_environment_inputs': compiler_inputs, 'derivations': records,
        'dependency_derivation': {'parent': ref(D / old_deps_name), 'staged_file': deps_staged,
                                  'proposed_installed_ref': deps_ref, 'diff': deps_diff,
                                  'all_prior_validator_dependencies_retained': True,
                                  'all_prior_protocol_inputs_retained': True},
        'entry_points': {'preparer': preparer, 'support': support, 'single_binder': single,
                         'validator': validator, 'proposal_validator': proposal_validator,
                         'batch': batch, 'global_binder': global_binder, 'dependencies': deps_ref},
        'operational_preparations': 0, 'model_roles': 0, 'gate_mutations': 0,
        'source_acceptance': False,
    }
    put('manifest.json', manifest)
    put('spec-extension.json', {'compiler_command_extension': extension_ref})
    return ref(output / 'manifest.json')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--extension', required=True, help='Finalized repository-relative compiler extension JSON')
    parser.add_argument('--extension-sha256', required=True)
    parser.add_argument('--output-name', required=True, help='New direct child of this suite directory')
    args = parser.parse_args()
    assert args.output_name and all(c.isalnum() or c in '-_' for c in args.output_name), 'invalid output name'
    result = render(P / args.output_name, {'path': args.extension, 'sha256': args.extension_sha256})
    print(json.dumps({'prospective_manifest': result, 'installed': False, 'operational_runs': 0}, indent=2))


if __name__ == '__main__':
    main()
