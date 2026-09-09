"""Freeze final local-law source and prepare a fresh-audit spec, without invoking roles."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re
F=Path(__file__).resolve().parent;D=F.parent;R=F.parents[5];S=D.parent
sha=lambda data:hashlib.sha256(data).hexdigest()
def ref(path):return {'path':path.relative_to(R).as_posix(),'sha256':sha(path.read_bytes())}
def writej(path,value):
 raw=(json.dumps(value,indent=2,ensure_ascii=False)+'\n').encode('utf-8')
 if path.exists():assert path.read_bytes()==raw
 else:
  with path.open('xb') as f:f.write(raw)
old=F/'source-context-extension.json';design=json.loads(old.read_bytes())
extension={'format':'pinned-source-context-extension-1',
 'source':{key:design['source'][key] for key in ('path','sha256')},
 'primary_locations':design['primary_selection'],'inherited_locations':design['proposed_source_locations'][1:],
 'pages':[26,27],'images':[{'page':item['raw_pdf_page'],'path':item['path'],'sha256':item['sha256']} for item in design['images']],
 'interpretation_receipts':[design['existing_inherited_equation10_interpretation']['receipt']]}
extension_path=F/'source-context-extension-pinned.json';writej(extension_path,extension)
manifest=json.loads((F/'production-inputs-local-law.json').read_bytes())
inputs=manifest['files']+[manifest['consumer_check']]
for item in inputs:assert sha((R/item['path']).read_bytes())==item['sha256']
receipts=[]
for mode in ('build','declarations'):
 rp=F/('production-local-law-'+mode+'-exit.json');record=json.loads(rp.read_bytes())
 assert record['exit_code']==0 and record['sources_unchanged'] and record['source_inputs']==inputs
 assert record['manifest_sha256']==sha((F/'production-inputs-local-law.json').read_bytes())
 op=F/('production-local-law-'+mode+'-output.txt');assert record['output_sha256']==sha(op.read_bytes())
 receipts.extend([ref(rp),ref(op)])
output=F/'production-local-law-declarations-output.txt';raw=output.read_bytes();text=raw.decode('utf-8')
axioms=re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",text)
assert len(axioms)==8
axioms=[(name,[item.strip() for item in items.split(',')]) for name,items in axioms]
for name,items in axioms:assert set(items)<={'propext','Classical.choice','Quot.sound'},(name,items)
assert 'error:' not in text and 'warning:' not in text
packet={'format':'proof-free-lean-environment-evidence-1',
 'scope':'Exact native types and axiom reports for the local physical-law source wrapper, its generic selected-cell producer, and separate applicability consumers. The primary source target remains the selected wrapper. These are dependency/applicability evidence, not extra source rows or source judgments.',
 'runtime':{'input_commit':record['input_commit'],'input_tree':record['input_tree'],'native_exit_code':0,
 'receipt':ref(F/'production-local-law-declarations-exit.json'),'source_inputs':inputs},
 'native_output_spans':[{'source_path':ref(output)['path'],'source_sha256':sha(raw),'start_byte':0,'end_byte_exclusive':len(raw),
 'span_sha256':sha(raw),'exact_text':text,'first_line':1,'last_line':raw.count(b'\n')}],
 'probe_commands':[record['command']],
 'omissions':['No Lean proof bodies are included in this packet.','No prior audit judgments or requested verdict are included.','The local source target does not assume the scratch global-solution consumer hypothesis.']}
packet_path=F/'local-law-native-environment-packet.json';writej(packet_path,packet)
pins=[ref(output),ref(F/'production-local-law-declarations-exit.json'),ref(F/'production-inputs-local-law.json')]
pins.extend({'path':item['path'],'sha256':item['sha256']} for item in inputs)
for item in manifest['files']:pins.append(ref(R/('.lake/build/lib/lean/'+item['path'][:-5]+'.olean')))
config_path=F/'local-law-native-environment-config.json'
writej(config_path,{'format':'pinned-audit-environment-extension-1','environment_files':pins})
spec=json.loads((D/'finite-volume-update-audit-spec.json').read_bytes())
spec.update(key='finite-volume-local-flux-update',
 task_id='LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908',
 prior_task='LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908',
 prior_config='unblock-nine-20260908/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908.config.json',
 pages='26,27',target={'path':manifest['files'][1]['path'],'declaration':manifest['files'][1]['declarations'][0]},
 source_context_extension=ref(extension_path),additional_supplement={'packet':ref(packet_path),'environment_config':ref(config_path)})
spec_path=D/'finite-volume-local-flux-update-audit-spec.json';writej(spec_path,spec)
oldglobal=R/'ComputationalMathematics/Source/LeVeque/Chapter01/FiniteVolumeUpdateError.lean'
assert sha(oldglobal.read_bytes())=='708ca50422dda84313cfb6f6ab6f9983b5da88c09b5f45298aa77dad3133426f'
receipt={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'source_inputs':inputs,
 'production_manifest':ref(F/'production-inputs-local-law.json'),'native_evidence':receipts,
 'axiom_reports':[{'declaration':name,'axioms':items} for name,items in axioms],
 'old_global_source_unchanged':ref(oldglobal),'superseded_prospective_wrapper':ref(F/'FiniteVolumeLocalFluxUpdate-generic-superseded.lean.fragment'),
 'source_context_design':ref(old),'source_context_extension':ref(extension_path),'audit_spec':ref(spec_path),
 'native_environment_packet':ref(packet_path),'native_environment_config':ref(config_path),
 'source_scope':'One selected spatial cell and positive time slab, actual q slices and flux(q) histories, four local integrabilities and the selected rectangle identity. Conditional old-average/face-flux bounds only.',
 'roles_invoked':False,'source_verdict_supplied':False,'organization_gate_git_mutations':False}
writej(F/'local-law-production-freeze.json',receipt)
print(json.dumps({'freeze':ref(F/'local-law-production-freeze.json'),'spec':ref(spec_path),'extension':ref(extension_path)}))
