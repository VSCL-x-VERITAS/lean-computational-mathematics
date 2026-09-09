"""Prepare a new v1 audit with separate, accurately attributed interpretation evidence."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,subprocess,sys
assert os.name=='nt','Use native Python; released commands are delegated through the POSIX launcher.'
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];W=R.parent
SR=S.relative_to(R).as_posix();DR=D.relative_to(R).as_posix()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def create(p,data):
 p.parent.mkdir(parents=True,exist_ok=True)
 with p.open('xb') as f:f.write(data)
def writej(p,data):create(p,(json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode())
def load_additional_supplement(root, extension):
 """Read exact native spans and an explicit pinned file allowlist; no judgments."""
 assert isinstance(extension,dict) and set(extension)=={'packet','environment_config'}
 def unique(pairs):
  result={}
  for key,value in pairs:
   assert key not in result,('duplicate JSON key',key)
   result[key]=value
  return result
 def load_ref(reference):
  assert isinstance(reference,dict) and set(reference)=={'path','sha256'}
  rel=reference['path'];digest=reference['sha256']
  assert isinstance(rel,str) and rel and '\\' not in rel and ':' not in rel
  assert all(part not in ('','.','..') for part in rel.split('/'))
  assert not Path(rel).is_absolute()
  assert isinstance(digest,str) and len(digest)==64 and all(c in '0123456789abcdef' for c in digest)
  path=root/rel
  assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(root.resolve())
  data=path.read_bytes();assert hashlib.sha256(data).hexdigest()==digest,(rel,'hash changed')
  return data
 config=json.loads(load_ref(extension['environment_config']),object_pairs_hook=unique)
 assert set(config)=={'format','environment_files'} and config['format']=='pinned-audit-environment-extension-1'
 assert isinstance(config['environment_files'],list) and config['environment_files']
 pins={}
 for reference in config['environment_files']:
  load_ref(reference)
  assert reference['path'] not in pins,('duplicate environment path',reference['path'])
  pins[reference['path']]=reference['sha256']
 raw=load_ref(extension['packet']);packet=json.loads(raw,object_pairs_hook=unique)
 assert set(packet)=={'format','scope','runtime','native_output_spans','probe_commands','omissions'}
 assert packet['format']=='proof-free-lean-environment-evidence-1'
 assert isinstance(packet['scope'],str) and isinstance(packet['runtime'],dict)
 assert isinstance(packet['probe_commands'],list) and isinstance(packet['omissions'],list)
 assert isinstance(packet['native_output_spans'],list) and packet['native_output_spans']
 for span in packet['native_output_spans']:
  needed={'source_path','source_sha256','start_byte','end_byte_exclusive','span_sha256','exact_text'}
  assert isinstance(span,dict) and needed <= set(span)
  assert pins.get(span['source_path'])==span['source_sha256'],('span source absent from pinned environment',span['source_path'])
  data=load_ref({'path':span['source_path'],'sha256':span['source_sha256']})
  start=span['start_byte'];end=span['end_byte_exclusive']
  assert type(start) is int and type(end) is int and 0<=start<end<=len(data)
  exact=data[start:end]
  assert isinstance(span['exact_text'],str) and exact==span['exact_text'].encode('utf-8')
  assert hashlib.sha256(exact).hexdigest()==span['span_sha256']
  if 'first_line' in span:assert span['first_line']==data[:start].count(b'\n')+1
  if 'last_line' in span:assert span['last_line']==data[:end].count(b'\n')
 return packet,raw,[extension['packet'],extension['environment_config'],*config['environment_files']]

def merge_additional_supplement(base_bytes, base_spans, extra_packet, extra_bytes, extension):
 if base_bytes is None:return extra_bytes
 base=json.loads(base_bytes);merged=json.loads(base_bytes)
 merged['native_output_spans']=[*base_spans,*extra_packet['native_output_spans']]
 merged['additional_environment_packets']=[*base.get('additional_environment_packets',[]),
  {'packet':extension['packet'],'environment_config':extension['environment_config'],
   'metadata':{key:value for key,value in extra_packet.items() if key!='native_output_spans'}}]
 return (json.dumps(merged,indent=2,ensure_ascii=False)+'\n').encode('utf-8')

def load_source_context(root, reference, source, pages_arg, render_root):
 """Validate explicit source context before sealing a fresh task; no source verdict."""
 def unique(pairs):
  result={}
  for key,value in pairs:
   assert key not in result,('duplicate JSON key',key)
   result[key]=value
  return result
 def load_ref(ref):
  assert isinstance(ref,dict) and set(ref)=={'path','sha256'}
  rel=ref['path'];digest=ref['sha256']
  assert isinstance(rel,str) and rel and '\\' not in rel and ':' not in rel
  assert all(part not in ('','.','..') for part in rel.split('/')) and not Path(rel).is_absolute()
  assert isinstance(digest,str) and len(digest)==64 and all(c in '0123456789abcdef' for c in digest)
  path=root/rel
  assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(root.resolve())
  raw=path.read_bytes();assert hashlib.sha256(raw).hexdigest()==digest,(rel,'hash changed')
  return raw
 extension=json.loads(load_ref(reference),object_pairs_hook=unique)
 assert set(extension)=={'format','source','primary_locations','inherited_locations','pages','images','interpretation_receipts'}
 assert extension['format']=='pinned-source-context-extension-1'
 assert extension['source']=={'path':source['path'],'sha256':source['sha256']}
 load_ref(extension['source'])
 assert extension['primary_locations']==source['locations'], 'Primary locator must remain exact.'
 def locations(items):
  assert isinstance(items,list) and items
  for item in items:
   assert isinstance(item,dict) and set(item)=={'location','anchor'}
   assert all(isinstance(value,str) and value.strip() for value in item.values())
 locations(extension['primary_locations']);locations(extension['inherited_locations'])
 selected=extension['primary_locations']+extension['inherited_locations']
 assert len({json.dumps(item,sort_keys=True) for item in selected})==len(selected)
 pages=extension['pages']
 assert isinstance(pages,list) and pages and all(type(page) is int and page>0 for page in pages)
 assert len(set(pages))==len(pages) and pages_arg==','.join(map(str,pages))
 assert isinstance(extension['images'],list) and len(extension['images'])==len(pages)
 hashes={};pins=[reference,extension['source']]
 for page,item in zip(pages,extension['images']):
  assert isinstance(item,dict) and set(item)=={'page','path','sha256'} and item['page']==page
  image_ref={key:item[key] for key in ('path','sha256')}
  raw=load_ref(image_ref)
  assert raw.startswith(b'\x89PNG\r\n\x1a\n')
  assert (render_root/('page-'+str(page).zfill(3)+'.png')).read_bytes()==raw,'Rendering differs from pinned source transport.'
  hashes[str(page)]=item['sha256'];pins.append(image_ref)
 receipts=extension['interpretation_receipts']
 assert isinstance(receipts,list) and receipts
 assert len({item['path'] for item in receipts})==len(receipts)
 exact=[]
 for ref in receipts:
  raw=load_ref(ref);receipt=json.loads(raw,object_pairs_hook=unique)
  assert receipt['kind']=='explicit user-adopted source interpretation'
  assert receipt['source_sha256']==source['sha256']
  for key in ('question','answer','scope','authority_limit'):
   assert isinstance(receipt[key],str) and receipt[key].strip()
  assert isinstance(receipt['adopted_interpretation'],list) and receipt['adopted_interpretation']
  assert all(isinstance(item,str) and item.strip() for item in receipt['adopted_interpretation'])
  assert isinstance(receipt['preservation'],list) and receipt['preservation']
  question=receipt['question_item_id']
  assert isinstance(question,list) and len(question)==3 and question[0]=='request_user_input_async'
  assert isinstance(question[1],str) and question[1] and type(question[2]) is int and question[2]>=0
  exact.append({'receipt':ref,'exact_receipt_bytes_utf8':raw.decode('utf-8'),'exact_fields':receipt});pins.append(ref)
 assert len({item['path'] for item in pins})==len(pins)
 packet={'format':'inherited-source-interpretation-evidence-1','source':extension['source'],
  'source_context_extension':reference,'primary_locations':extension['primary_locations'],
  'inherited_locations':extension['inherited_locations'],'interpretation_receipts':exact,
  'scope_rule':'The primary claim remains the original selection. Added locations supply explicitly identified inherited context. Preserve each exact user receipt and its original scope; independently assess whether and how that scope applies to the primary claim. Do not enlarge a user answer, attribute it to the printed source, or infer global solution extensions or pointwise representative conventions. The coordinator Q-choice is separately supplied with its different authority. No prior judgment or requested verdict is supplied.'}
 return {'locations':selected,'packet':packet,'pins':pins,'image_hashes':hashes,'pages_arg':pages_arg}


def bind_source_context_role(code, context):
 """Add exact receipt evidence only to judges, and pinned pages to source-facing roles."""
 needle=" locator=json.loads((out/'inputs/source_locator.json').read_text(encoding='utf-8'))"
 assert code.count(needle)==1
 code=code.replace(needle," assert pages_arg=="+repr(context['pages_arg'])+"\n pinned_source_images="+repr(context['image_hashes'])+"\n"+needle)
 needle=" if role in ('direct-judge','adjudicator'):"
 assert code.count(needle)==1
 extra="""  inherited=out.parent/'inherited-source-interpretation-packet.json'
  inherited_record=next(row for row in interpretation_manifest['lean_environment'] if row['path'].endswith('/'+task+'/inherited-source-interpretation-packet.json'))
  assert hashlib.sha256(inherited.read_bytes()).hexdigest()==inherited_record['sha256']
  add('Separate exact inherited user interpretation; retain original authority and scope and assess applicability independently',inherited)
  parts.append(b'\\nThis inherited receipt is distinct from the coordinator-selected convention. Its literal answer and scope must remain unchanged. Independently assess both implications under the applicable recorded conventions without importing prior judgments. Added source context does not add independently audited source rows.\\n')
"""
 code=code.replace(needle,extra+needle)
 needle="   assert image.is_file(),image\n   images.append(image)"
 assert code.count(needle)==1
 code=code.replace(needle,"   assert image.is_file(),image\n   assert hashlib.sha256(image.read_bytes()).hexdigest()==pinned_source_images[page]\n   images.append(image)")
 return code


spec=json.loads(Path(sys.argv[1]).read_bytes())
additional_data=load_additional_supplement(R,spec['additional_supplement']) if spec.get('additional_supplement') else None
taskid=spec['task_id'];prior=S/'audits'/spec['prior_task'];T=S/'audits'/taskid
assert not T.exists(),T
oldtask=json.loads((prior/'audit-task.json').read_bytes());task=json.loads(json.dumps(oldtask))
task.update(task_id=taskid,audit_output=SR+'/audits/'+taskid+'/faithfulness',source_group=taskid.lower())
task['target']=spec.get('target',task['target'])
context_data=load_source_context(R,spec['source_context_extension'],task['source'],spec['pages'],W/'workflow-v5.0.1-local/chapter01-source-review') if spec.get('source_context_extension') else None
if context_data is not None:task['source']['locations']=context_data['locations']
assert sha(R/task['source']['path'])==task['source']['sha256']
assert (R/task['target']['path']).is_file()
receipt=D/'selected-interpretations.json'
assert sha(receipt)=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
selections=json.loads(receipt.read_bytes())
choice=next(x for x in selections['choices'] if x['choice_id']==spec['choice_id'])
assert spec['row_id'] in choice['rows']
T.mkdir();writej(T/'audit-task.json',task)
interpretation={'format':'coordinator-selected-source-interpretation-1','authority':selections['authority'],'exact_user_objective':selections['exact_user_objective'],'goal_observation_sha256':selections['goal_observation_sha256'],'selection_receipt':{'path':receipt.relative_to(R).as_posix(),'sha256':sha(receipt)},'scope_row':spec['row_id'],'choice':choice,'source_sha256':task['source']['sha256'],'preservation':selections['preservation'],'comparison_rule':'Assess the exact selected claim under this explicit coordinator-selected interpretation. This is authorized task work, not a literal detailed user answer or a printed-source assertion. Independently decide both implications; any acceptance must be interpretation-qualified and preserve source ambiguity. No requested verdict is supplied.'}
writej(T/'user-interpretation-packet.json',interpretation)
if context_data is not None:writej(T/'inherited-source-interpretation-packet.json',context_data['packet'])
cfgpath=S/spec['prior_config'];cfg=json.loads(cfgpath.read_bytes())
prior_manifest=json.loads((prior/'faithfulness/manifest.json').read_bytes())
recorded={x['path']:x['sha256'] for x in prior_manifest['lean_environment']}
verified=[]
for rel in cfg['lean']['environment_files']:
 assert rel in recorded,(rel,'not bound by prior manifest')
 assert sha(R/rel)==recorded[rel],(rel,'changed environment input')
 verified.append({'path':rel,'sha256':recorded[rel]})
envfiles=list(cfg['lean']['environment_files'])
supp=prior/'dependency-environment-packet.json'
if spec.get('supplement_task'):supp=S/'audits'/spec['supplement_task']/'dependency-environment-packet.json'
supplement_bytes=None
spans=[]
if supp.is_file():
 packet=json.loads(supp.read_bytes())
 spans=packet.get('native_output_spans',packet.get('declaration_output_spans',packet.get('exact_native_output_spans')))
 if spans is None:
  spans=next((v for v in packet.values() if isinstance(v,list) and v and isinstance(v[0],dict) and 'exact_text' in v[0]),[])
 assert spans,'A supplement must expose exact native declaration spans.'
 for span in spans:
  raw=(R/span['source_path']).read_bytes();assert hashlib.sha256(raw).hexdigest()==span['source_sha256']
  exact=raw[span['start_byte']:span['end_byte_exclusive']]
  assert exact==span['exact_text'].encode('utf-8') and hashlib.sha256(exact).hexdigest()==span['span_sha256']
 # Existing complete packet is copied without semantic rewriting or inherited judgments.
 supplement_bytes=supp.read_bytes()
 envfiles.append((T/'dependency-environment-packet.json').relative_to(R).as_posix())
 cfg_extra=spec.get('supplement_config')
 if cfg_extra:
  extra=json.loads((S/cfg_extra).read_bytes())
  for rel in extra['lean']['environment_files']:
   if not any(x in rel for x in ('real-measure-dependency/','real-measure-root-verification.json','.lake/packages/mathlib/')):continue
   assert (R/rel).is_file(),rel
   envfiles.append(rel)
if additional_data is not None:
 extra_packet,extra_bytes,extra_pins=additional_data
 supplement_bytes=merge_additional_supplement(supplement_bytes,spans,extra_packet,extra_bytes,spec['additional_supplement'])
 envfiles.extend(reference['path'] for reference in extra_pins)
 envfiles.append((T/'dependency-environment-packet.json').relative_to(R).as_posix())
if supplement_bytes is not None:create(T/'dependency-environment-packet.json',supplement_bytes)
cfg['task_metadata_glob']=(T/'audit-task.json').relative_to(R).as_posix()
envfiles += [task['target']['path'],'.lake/build/lib/lean/'+task['target']['path'].removesuffix('.lean')+'.olean',receipt.relative_to(R).as_posix(),(T/'user-interpretation-packet.json').relative_to(R).as_posix()]
if context_data is not None:
 envfiles.extend(reference['path'] for reference in context_data['pins'])
 envfiles.append((T/'inherited-source-interpretation-packet.json').relative_to(R).as_posix())
cfg['lean']['environment_files']=list(dict.fromkeys(envfiles))
for rel in cfg['lean']['environment_files']:assert (R/rel).is_file(),rel
config=D/(taskid+'.config.json');writej(config,cfg)
writej(T/'preparation-lineage.json',{'prior_task':spec['prior_task'],'prior_manifest_sha256':sha(prior/'faithfulness/manifest.json'),'prior_config_sha256':sha(cfgpath),'environment_byte_checks':verified,'target_sha256':sha(R/task['target']['path']),'selected_interpretation_sha256':sha(T/'user-interpretation-packet.json'),'prior_decisions_reused':False,'additional_supplement':spec.get('additional_supplement'),'spec_sha256':sha(Path(sys.argv[1])),'source_context_extension':spec.get('source_context_extension'),'inherited_interpretation_sha256':sha(T/'inherited-source-interpretation-packet.json') if context_data is not None else None,'preparer_sha256':sha(Path(__file__))})
wrapper=str(W/'workflow-v5.0.1-local/run_workflow_posix.py')
env=os.environ.copy();env['FAITHFULNESS_AUDIT_CONFIG']='/c/'+config.as_posix()[3:]
def released(label,script,args,cwd):
 if context_data is not None:
  for reference in context_data['pins']:assert sha(R/reference['path'])==reference['sha256']
 cmd=[sys.executable,'-B',wrapper,script,*args];start=datetime.now(timezone.utc).isoformat()
 with (T/(label+'-output.txt')).open('xb') as out,(T/(label+'-stderr.txt')).open('xb') as err:p=subprocess.run(cmd,cwd=cwd,env=env,stdout=out,stderr=err)
 rec={'command':cmd,'config':env['FAITHFULNESS_AUDIT_CONFIG'],'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':p.returncode,'stdout_sha256':sha(T/(label+'-output.txt')),'stderr_sha256':sha(T/(label+'-stderr.txt'))}
 writej(T/(label+'-exit.json'),rec);print(json.dumps({'stage':label,**rec}),flush=True)
 if p.returncode:
  print((T/(label+'-output.txt')).read_text(errors='replace'));print((T/(label+'-stderr.txt')).read_text(errors='replace'));raise SystemExit(p.returncode)
released('route',str(W/'formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/scripts/route_audit.py'),[str(T/'audit-task.json')],W)
released('prepare','.faithfulness-audit/scripts/prepare_audit.py',[taskid],R)
released('prepared-validation','.faithfulness-audit/scripts/validate_audit.py',[taskid,'--phase','prepared'],R)
if context_data is not None:
 prepared_manifest=json.loads((T/'faithfulness/manifest.json').read_bytes())
 prepared_pins={item['path']:item['sha256'] for item in prepared_manifest['lean_environment']}
 for reference in context_data['pins']:
  assert sha(R/reference['path'])==reference['sha256']
  assert prepared_pins[reference['path']]==reference['sha256']
parent_id='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'
parent=S/'audits'/parent_id/'faithfulness/orchestration';out=T/'faithfulness';tr=out/'orchestration';tr.mkdir()
lineage=[]
for name in ('r.py','c.py','q.py'):
 source=parent/name;code=source.read_text(encoding='utf-8')
 code=code.replace(parent_id,taskid).replace('audit-equation10-interpreted-rectangle.config.json','unblock-nine-20260908/'+config.name)
 if name=='r.py':
  code=code.replace('Separate explicit user-adopted source interpretation; not a printed-source assertion','Separate coordinator-selected source interpretation under the user goal; not a printed-source assertion')
  code=code.replace('The user explicitly instructed these fresh audits to assess the selected source claim under this recorded convention. This instruction is separate from source evidence and supplies no requested verdict.','The user requested that all nine rows be unblocked. The coordinator selected the documented convention for this row within that task. This is not a literal detailed user answer. Assess the exact source claim under this explicitly selected convention. The convention is separate from source evidence and supplies no requested verdict.')
  code=code.replace('recorded user-adopted interpretation','recorded coordinator-selected interpretation')
  begin=code.index("  supplement=out.parent/'dependency-environment-packet.json'")
  end=code.index("  reuse=out/'inputs/dependency_reuse_direct.json'",begin)
  block=code[begin:end].splitlines()
  code=code[:begin]+block[0]+'\n  if supplement.is_file():\n'+'\n'.join(' '+line for line in block[1:])+'\n'+code[end:]
  if context_data is not None:code=bind_source_context_role(code,context_data)
 if name=='c.py':
  code=code.replace('Fresh separate clean Codex CLI exec session allowed by sealed README after collaboration thread-limit failure.','Fresh separate clean Codex CLI exec session with the same stateless role boundaries specified by the sealed methodology.')
 if name=='q.py':
  code=code.replace('assert workers == 1','assert workers in (1,2)')
 ast.parse(code);create(tr/name,code.encode());lineage.append({'file':name,'parent_sha256':sha(source),'successor_sha256':sha(tr/name)})
for page in spec['pages'].split(','):
 src=W/'workflow-v5.0.1-local/chapter01-source-review'/('page-'+page.zfill(3)+'.png')
 assert src.is_file()
 if context_data is not None:assert sha(src)==context_data['image_hashes'][page]
 create(tr/src.name,src.read_bytes())
out=Path(chr(92)*2+'?'+chr(92)+str(out.resolve()))
tr=out/'orchestration'
prefix=(tr/'r.py').read_text().split("inp=tr/(stem+'_input.txt')")[0]
assert 'subprocess.run' not in prefix
saved=sys.argv;sys.argv=['r.py',taskid,'blind-translation','b',''];ns={}
try:exec(compile(prefix,'blind_isolation_preflight','exec'),ns)
finally:sys.argv=saved
packet=(out/'inputs/blind_review_packet.md').read_bytes();message=ns['message']
assert message.endswith(packet) and message.count(packet)==1 and not ns['images']
assert taskid.encode() not in message and b'LeVeque' not in message and b'user-interpretation' not in message
writej(T/'role-transport-preflight.json',{'helpers':lineage,'blind_packet_sha256':sha(out/'inputs/blind_review_packet.md'),'blind_stdin_sha256':hashlib.sha256(message).hexdigest(),'blind_isolation_verified':True,'source_context_extension':spec.get('source_context_extension'),'roles_invoked':False,'images':[{'page':p,'sha256':sha(tr/('page-'+p.zfill(3)+'.png'))} for p in spec['pages'].split(',')],'config_path':config.relative_to(R).as_posix()})
print(json.dumps({'prepared':taskid,'config':str(config),'runner':str(tr/'q.py'),'pages':spec['pages'],'blind_bytes':len(packet)}),flush=True)
