"""Read-only exact preflight of the reviewed spec; does not prepare or invoke an audit."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json
F=Path(__file__).resolve().parent;D=F.parent;R=F.parents[5];S=D.parent
sha=lambda raw:hashlib.sha256(raw).hexdigest()
helper=D/'prepare-successor-audit-with-source-context.py'
tree=ast.parse(helper.read_text(encoding='utf-8'))
functions=[node for node in tree.body if isinstance(node,ast.FunctionDef) and node.name in ('load_source_context','load_additional_supplement')]
scope={'Path':Path,'hashlib':hashlib,'json':json}
exec(compile(ast.Module(body=functions,type_ignores=[]),str(helper),'exec'),scope)
sp=D/'finite-volume-local-flux-update-audit-spec.json';spec=json.loads(sp.read_bytes())
prior=S/'audits'/spec['prior_task'];task=json.loads((prior/'audit-task.json').read_bytes())
source=scope['load_source_context'](R,spec['source_context_extension'],task['source'],spec['pages'],R.parent/'workflow-v5.0.1-local/chapter01-source-review')
packet,raw,pins=scope['load_additional_supplement'](R,spec['additional_supplement'])
cfg=json.loads((S/spec['prior_config']).read_bytes());manifest=json.loads((prior/'faithfulness/manifest.json').read_bytes())
recorded={item['path']:item['sha256'] for item in manifest['lean_environment']}
for rel in cfg['lean']['environment_files']:assert sha((R/rel).read_bytes())==recorded[rel],rel
assert not (S/'audits'/spec['task_id']).exists(),'A fresh task already exists; do not overwrite it.'
record={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'helper_sha256':sha(helper.read_bytes()),
 'spec_sha256':sha(sp.read_bytes()),'script_sha256':sha(Path(__file__).read_bytes()),'prior_environment_file_count':len(cfg['lean']['environment_files']),
 'source_context_pin_count':len(source['pins']),'additional_native_pin_count':len(pins),'native_output_span_count':len(packet['native_output_spans']),
 'all_exact_pin_checks':True,'fresh_task_absent':True,'released_commands_run':False,'roles_invoked':False}
with (F/'fresh-audit-input-preflight.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(record,f,indent=2);f.write('\n')
print(json.dumps(record))
