"""Pure POSIX spec preflight using exact prospective helper loaders only."""
from pathlib import Path
from datetime import datetime, timezone
import ast
import hashlib
import json
import os
assert os.name == 'posix'
P = Path(__file__).resolve().parent
D = P.parent
S = D.parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
read = lambda p: json.loads(p.read_bytes())
out = P / 'spec-01'
assert not out.exists()
render_manifest = P/'suite/actual-render-01/manifest.json'
assert sha(render_manifest) == '8906052ebcd027fc8f473825f780e98f7647e22b4c68681b439e8014b913e5cb'
render = read(render_manifest)
record = render['derivations'][0]
helper = R / record['staged_file']['path']
assert ref(helper) == record['staged_file']
tree = ast.parse(helper.read_bytes())
names = {'load_additional_supplement','load_source_context','load_dim_module_roots',
         'merge_additional_supplement','apply_dim_module_roots','verify_dim_module_roots'}
nodes = []
for node in tree.body:
    if isinstance(node, ast.FunctionDef) and (node.name in names or node.name.startswith('package_') or node.name in
       {'load_package_compiler_command','apply_package_compiler_command','verify_package_compiler_command'}):
        nodes.append(node)
    elif isinstance(node, ast.Assign) and all(isinstance(t, ast.Name) and t.id.startswith(('DIM_MODULE_','PACKAGE_')) for t in node.targets):
        nodes.append(node)
namespace = {'Path': Path, 'json': json, 'hashlib': hashlib}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::read-only-loaders','exec'),namespace)
parent = D/'physical-dim-audit-preparation/spec-01/audit-spec.json'
assert sha(parent) == '3210def614922a0d3afa8a5d382be6bf7a7d2b42ac0465f6cd160ee52f872dc2'
old = read(parent)
spec = dict(old)
spec.update(task_id='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908',
            key='physical-high-resolution-package-command', compiler_command_extension=ref(P/'compiler-command-extension.json'))
assert not (S/'audits'/spec['task_id']).exists()
assert not (D/(spec['task_id']+'.config.json')).exists()
same = set(old)-{'task_id','key'}
assert all(old[key] == spec[key] for key in same)
root_plan = namespace['load_dim_module_roots'](R,spec)
compiler_plan = namespace['load_package_compiler_command'](R,spec)
prior = S/'audits'/spec['prior_task']
task = read(prior/'audit-task.json')
context = namespace['load_source_context'](R,spec['source_context_extension'],task['source'],spec['pages'],
                                         R.parent/'workflow-v5.0.1-local/chapter01-source-review')
packet, raw, native_refs = namespace['load_additional_supplement'](R,spec['additional_supplement'])
config = read(S/spec['prior_config'])
prior_manifest = read(prior/'faithfulness/manifest.json')
recorded = {x['path']:x['sha256'] for x in prior_manifest['lean_environment']}
for path in config['lean']['environment_files']:
    assert sha(R/path) == recorded[path]
config = namespace['apply_dim_module_roots'](config,root_plan)
config = namespace['apply_package_compiler_command'](config,compiler_plan)
compiler_refs = namespace['package_compiler_inputs'](spec['compiler_command_extension'],compiler_plan)
config['lean']['environment_files'] = list(dict.fromkeys(config['lean']['environment_files']+
    [x['path'] for x in [spec['module_source_root_extension'],*root_plan['environment_files'],*compiler_refs]]))
namespace['verify_dim_module_roots'](R,spec,config)
namespace['verify_package_compiler_command'](R,spec,config)
base_path = S/'audits'/spec['supplement_task']/'dependency-environment-packet.json'
base = read(base_path)
merged = namespace['merge_additional_supplement'](base_path.read_bytes(),base['native_output_spans'],packet,raw,spec['additional_supplement'])
assert len(merged)<1048576
target = R/spec['target']['path']
assert sha(target) == '192df235c8ec993ca6815c5cf2c0808c1ffc0087c6a87810f9e26be4fbcd704c'
out.mkdir()
def write(name,value):
    with (out/name).open('x',encoding='utf-8') as stream:
        stream.write(json.dumps(value,indent=2,ensure_ascii=False)+'\n')
    return ref(out/name)
spec_ref = write('audit-spec.json',spec)
receipt = write('preflight.json',{'status':'PASS_SPEC_ONLY_NO_OFFICIAL_PREPARATION',
    'utc':datetime.now(timezone.utc).isoformat(),'spec':spec_ref,'parent_spec':ref(parent),
    'prospective_preparer':record['proposed_installed_ref'],'review_copy':ref(helper),'render_manifest':ref(render_manifest),
    'unchanged_spec_keys':sorted(same),'source_primary_locations':task['source']['locations'],
    'source_context':spec['source_context_extension'],'additional_supplement':spec['additional_supplement'],
    'module_source_root_extension':spec['module_source_root_extension'],'compiler_command_extension':spec['compiler_command_extension'],
    'compiler_command':config['lean']['command'],'native_merged_packet_bytes':len(merged),
    'compiler_environment_refs':compiler_refs,'native_ref_count':len(native_refs),
    'official_preparation_invoked':False,'semantic_roles_invoked':False,
    'full_role_input_bytes':'Must be measured from actual new prepared r.py with adopted guard; native packet size alone is insufficient.'})
print(json.dumps({'spec':spec_ref,'preflight':receipt},indent=2))
