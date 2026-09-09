"""Bounded read-only imports/native evidence inspection; no Lean or audit run."""
from pathlib import Path
from datetime import datetime, timezone
import ast
import hashlib
import json
import os
import re
assert os.name=='posix'
P=Path(__file__).resolve().parent
D=P.parent
S=D.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
observed={}
def observe(p):
    observed[p]=sha(p)
    return p
released=observe(R/'.faithfulness-audit/scripts/prepare_audit.py')
tree=ast.parse(released.read_bytes())
names={'direct_imports','local_module_source','collect_local_imports'}
nodes=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in names]
assert len(nodes)==3
namespace={'Path':Path,'re':re,'Any':object,'PreparationError':RuntimeError}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(released)+'::read-only-import-inspection','exec'),namespace)
target=observe(R/'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannCertifiedRoutineInterface.lean')
config_path=observe(D/'LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908.config.json')
config=read(config_path)
assert config['lean']['command']==['lake','env','lean'] and config['lean']['module_source_roots']==['.']
local_order,graph,external=namespace['collect_local_imports'](target.read_text(),{'_module_source_roots':[R]})
assert local_order and all(x.startswith('ComputationalMathematics.') for x in local_order)
sources=[]
for module in local_order:
    p=observe(R/(module.replace('.','/')+'.lean'))
    sources.append({'module':module,'source':ref(p),'direct_imports':graph[module],
                    'contains_public_import':bool(re.search(r'^\s*public\s+import\s',p.read_text(),re.M))})
helper=observe(D/'prepare-successor-audit-with-source-context-long-paths.py')
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
tree=ast.parse(helper.read_bytes())
loader=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='load_additional_supplement')
scope={'Path':Path,'json':json,'hashlib':hashlib}
exec(compile(ast.Module(body=[loader],type_ignores=[]),str(helper)+'::read-only-native-pin-inspection','exec'),scope)
extension=observe(D/'riemann-certified-native-refresh/additional-supplement.json')
packet,raw,pins=scope['load_additional_supplement'](R,read(extension))
for item in pins:
    p=observe(R/item['path'])
    assert observed[p]==item['sha256']
native_receipt=observe(D/'riemann-certified-native-refresh/final-receipt.json')
native=read(native_receipt)
assert native['actual_native_exit']==0 and native['source_target']==ref(target)
assert native['native_output_bytes_identical_to_prior'] and native['environment_pins']==307
sources_with_regularities=[{'module':x['module'],'terms':[term for term in ('ContDiffOn','ContDiffWithinAt','FTaylorSeries')
    if term in (R/x['source']['path']).read_text()]} for x in sources]
sources_with_regularities=[x for x in sources_with_regularities if x['terms']]
support=observe(D/'gate-helpers/qualified_row_support_package_command_v1.py')
pkg_preparer=observe(D/'prepare-successor-audit-with-package-command-v1.py')
for path in [D/'riemann-certified-context-successor-preparation/receipt.json',
             D/'riemann-certified-context-successor-preparation/audit-spec.template.json',
             D/'riemann-certified-context-successor-preparation/helper-extension-proposal.json',
             D/'physical-dim-package-runtime-preparation/runtime-receipt.json',
             D/'physical-dim-package-runtime-preparation/installation-01/receipt.json']:
    observe(path)
for p,h in observed.items():assert sha(p)==h
result={'status':'READ_ONLY_READINESS_NOT_SOURCE_ACCEPTANCE','utc':datetime.now(timezone.utc).isoformat(),
    'target':ref(target),'prior_config':ref(config_path),'lean_command':config['lean']['command'],
    'module_source_roots':['.'],'released_import_inspection':ref(released),'local_order':local_order,
    'local_module_count':len(local_order),'expected_total_with_AuditTarget':len(local_order)+1,
    'source_import_graph':graph,'external_direct_imports':sorted(external),'local_sources':sources,
    'local_regularity_terms':sources_with_regularities,'Mathlib_snapshot_compilations':0,
    'current_native_extension':ref(extension),'native_refs_verified':len(pins),
    'native_span_count':len(packet['native_output_spans']),'native_output_bytes':native['bytes'],
    'native_refresh_receipt':ref(native_receipt),'current_support':ref(support),'dim_only_preparer':ref(pkg_preparer),
    'files':[ref(p) for p in sorted(observed)],'operational_preparation':False,'native_execution':False,
    'literal_reply_created':False,'gate_or_source_changed':False}
with (P/'inspection.json').open('x',encoding='utf-8') as stream:stream.write(json.dumps(result,indent=2)+'\n')
print(json.dumps({'inspection':ref(P/'inspection.json'),'local_modules':len(local_order),
                  'Mathlib_snapshot_compilations':0,'native_refs_verified':len(pins),
                  'regularity_terms':sources_with_regularities}))
