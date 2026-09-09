"""Freeze proof-free native evidence and a fresh Info successor spec; no audit execution."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,re
I=Path(__file__).resolve().parent;D=I.parent;R=I.parents[5];S=D.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def writej(path,value):
 raw=(json.dumps(value,indent=2,ensure_ascii=False)+'\n').encode()
 if path.exists():assert path.read_bytes()==raw
 else:
  with path.open('xb') as f:f.write(raw)
helper=D/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
nodes=[node for node in ast.parse(helper.read_text()).body if isinstance(node,ast.FunctionDef) and node.name in ('install_native_long_path_io','load_source_context','load_additional_supplement')]
env={'Path':Path,'os':os,'hashlib':hashlib,'json':json}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper),'exec'),env)
env['install_native_long_path_io']()
manifest=json.loads((I/'native-inputs.json').read_bytes())
record=json.loads((I/'native-types-receipt.json').read_bytes())
assert record['exit_code']==0 and record['inputs_unchanged']
assert record['manifest_sha256']==sha(I/'native-inputs.json')
output=I/'native-types-output.txt';assert record['output_sha256']==sha(output)
pins={}
def add(reference):
 assert sha(R/reference['path'])==reference['sha256'],reference['path']
 if reference['path'] in pins:assert pins[reference['path']]==reference['sha256']
 pins[reference['path']]=reference['sha256']
for item in record['inputs']:add(item)
for path in (I/'native-inputs.json',I/'native-types-receipt.json',output):add(ref(path))
def span(path):
 raw=path.read_bytes()
 return {'source_path':path.relative_to(R).as_posix(),'source_sha256':hashlib.sha256(raw).hexdigest(),
  'start_byte':0,'end_byte_exclusive':len(raw),'span_sha256':hashlib.sha256(raw).hexdigest(),
  'exact_text':raw.decode('utf-8'),'first_line':1,'last_line':raw.count(b'\n')}
def reports(path,expected):
 text=path.read_text(encoding='utf-8')
 found=re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",text)
 # Lean can print no-axiom reports in prose rather than with an empty bracket list.
 found.extend((name,'') for name in re.findall(r"'([^']+)' does not depend on any axioms",text))
 assert len(found)==expected,(path,len(found),expected)
 result=[]
 for name,items in found:
  values=[item.strip() for item in items.split(',') if item.strip()]
  assert all(re.fullmatch(r'(propext|Classical\.choice|Quot\.sound)(?:\.\{[A-Za-z0-9_ ]+\})?',item) for item in values),(name,values)
  result.append({'declaration':name,'exact_axiom_names':values,'axioms':[item.split('.{')[0] for item in values]})
 assert 'error:' not in text and 'warning:' not in text
 return result
canonical_reports=reports(output,34)
witness=D/'local-riemann-witness';wrecpath=witness/'native-02/receipt.json';wout=witness/'native-02/output.txt'
wrec=json.loads(wrecpath.read_bytes())
assert sha(wrecpath)=='ebe575a3845b94cae5b2436eccff77c5fbc43728f14cfe497e049e44beb82aee'
assert wrec['exit_code']==0 and wrec['inputs_unchanged'] and wrec['output_sha256']==sha(wout)=='d2276994b5bbdf49b104a9a6b6c65f391cec8d18791889f2197879ecd3c9c37a'
assert wrec['input_snapshot_sha256']==sha(witness/'native-02/Candidate.lean.snapshot')==sha(witness/'Candidate.lean')
for item in wrec['inputs']:
 assert item['sha256_before']==item['sha256_after']
 add({'path':item['path'],'sha256':item['sha256_before']})
for path in (wrecpath,wout,witness/'Candidate.lean',witness/'native-02/Candidate.lean.snapshot'):add(ref(path))
witness_reports=reports(wout,17)
packet={'format':'proof-free-lean-environment-evidence-1',
 'scope':'Exact canonical type/constructor/axiom output for the selected local Riemann-information source target and its dependencies, plus separately labeled native applicability witnesses. Witnesses support applicability and do not add source rows. No proof bodies, source verdict or prior judge output is supplied.',
 'runtime':{'canonical':{'receipt':ref(I/'native-types-receipt.json'),'exit_code':0,'input_commit':record['input_commit'],'input_tree':record['input_tree'],'source_and_olean_pins':manifest['files']},
 'separate_witness':{'receipt':ref(wrecpath),'exit_code':0,'source':ref(witness/'Candidate.lean'),'frozen_snapshot':ref(witness/'native-02/Candidate.lean.snapshot')}},
 'native_output_spans':[{'evidence_role':'canonical target and dependency types',**span(output)},
 {'evidence_role':'separate exact and nonexact information-only applicability witnesses',**span(wout)}],
 'probe_commands':[record['command'],' '.join(wrec['argv'])],
 'omissions':['No Lean proof bodies are reproduced.','No prior audit decisions or review conclusions are supplied.','No witness type is an independent selected source claim.','Entropy, uniqueness, convergence and unconditional quantitative accuracy are not supplied by this evidence packet.']}
packet_path=I/'native-environment-packet.json';writej(packet_path,packet)
config_path=I/'native-environment-config.json';writej(config_path,{'format':'pinned-audit-environment-extension-1','environment_files':[{'path':path,'sha256':digest} for path,digest in pins.items()]})
spec=json.loads((D/'riemann-information-interface-audit-spec.json').read_bytes())
spec.update(key='local-riemann-information-interface',
 task_id='LEV-CH01-LOCAL-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908',
 prior_task='LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908',
 prior_config='unblock-nine-20260908/LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908.config.json',
 target={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalInformationInterface.lean',
 'declaration':'NumStability.leveque01_localRiemannInformationInterface_sourceContract'},
 source_context_extension=ref(I/'source-context-extension.json'),
 additional_supplement={'packet':ref(packet_path),'environment_config':ref(config_path)})
spec_path=D/'local-riemann-information-interface-audit-spec.json';writej(spec_path,spec)
prior=S/'audits'/spec['prior_task'];oldtask=json.loads((prior/'audit-task.json').read_bytes())
context=env['load_source_context'](R,spec['source_context_extension'],oldtask['source'],spec['pages'],R.parent/'workflow-v5.0.1-local/chapter01-source-review')
env['load_additional_supplement'](R,spec['additional_supplement'])
cfg=json.loads((S/spec['prior_config']).read_bytes());oldmanifest=json.loads((prior/'faithfulness/manifest.json').read_bytes())
priorpins={item['path']:item['sha256'] for item in oldmanifest['lean_environment']}
for rel in cfg['lean']['environment_files']:assert sha(R/rel)==priorpins[rel],rel
assert not (S/'audits'/spec['task_id']).exists()
writej(I/'preparation-checks.json',{'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'helper':ref(helper),'spec':ref(spec_path),'native_receipt':ref(I/'native-types-receipt.json'),
 'canonical_axiom_reports':canonical_reports,'witness_axiom_reports':witness_reports,
 'additional_environment_file_count':len(pins),'prior_environment_file_count':len(cfg['lean']['environment_files']),
 'source_context_pin_count':len(context['pins']),'all_exact_pins_verified':True,
 'source_target_sha256':sha(R/spec['target']['path']),'audit_prepared':False,'roles_invoked':False,
 'source_verdict_supplied':False})
print(json.dumps({'spec':ref(spec_path),'packet':ref(packet_path),'checks':ref(I/'preparation-checks.json'),
 'canonical_reports':len(canonical_reports),'witness_reports':len(witness_reports)}))
