"""Prepare a new v1 audit with separate, accurately attributed interpretation evidence."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,subprocess,sys
assert os.name=='nt','Use native Python; released commands are delegated through the POSIX launcher.'
def install_native_long_path_io():
 """Use extended Windows paths only at I/O; preserve all logical Path strings."""
 import io
 if getattr(Path,'_audit_extended_io_installed',False):return
 assert os.name=='nt'
 def native_path(path):
  value=os.path.abspath(os.fspath(path))
  if value.startswith('\\\\?\\'):return value
  if value.startswith('\\\\'):return '\\\\?\\UNC\\'+value[2:]
  return '\\\\?\\'+value
 def normal_path(value):
  if value.startswith('\\\\?\\UNC\\'):return '\\\\'+value[8:]
  if value.startswith('\\\\?\\'):return value[4:]
  return value
 def path_open(self,mode='r',buffering=-1,encoding=None,errors=None,newline=None):
  return io.open(native_path(self),mode,buffering,encoding,errors,newline)
 def path_stat(self,*,follow_symlinks=True):return os.stat(native_path(self),follow_symlinks=follow_symlinks)
 def path_mkdir(self,mode=0o777,parents=False,exist_ok=False):
  try:os.mkdir(native_path(self),mode)
  except FileNotFoundError:
   if not parents or self.parent==self:raise
   self.parent.mkdir(parents=True,exist_ok=True)
   self.mkdir(mode,parents=False,exist_ok=exist_ok)
  except OSError:
   if not exist_ok or not self.is_dir():raise
 def path_iterdir(self):
  for name in os.listdir(native_path(self)):yield self/name
 def path_resolve(self,strict=False):return type(self)(normal_path(os.path.realpath(native_path(self),strict=strict)))
 Path.open=path_open;Path.stat=path_stat;Path.mkdir=path_mkdir;Path.iterdir=path_iterdir;Path.resolve=path_resolve
 Path._audit_extended_io_installed=True

install_native_long_path_io()

D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];W=R.parent
SR=S.relative_to(R).as_posix();DR=D.relative_to(R).as_posix()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
recovery_pins={};recovery_started=False
def create(p,data):
 global recovery_started
 if recovery_pins and p.parent==T and p.name in recovery_pins:
  assert hashlib.sha256(data).hexdigest()==recovery_pins[p.name]
  assert p.read_bytes()==data
  return
 if recovery_pins and not recovery_started:
  verify_partial_recovery(T,recovery_pins,True);recovery_started=True
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


def load_partial_recovery(root, task_dir, spec_path, manifest_path, expected_digest):
 """Accept only the exact two-file failure before any released command ran."""
 raw=manifest_path.read_bytes();assert hashlib.sha256(raw).hexdigest()==expected_digest
 manifest=json.loads(raw)
 assert set(manifest)=={'format','task_path','spec','preparer_parent','existing_files','failure_stage'}
 assert manifest['format']=='two-file-unsealed-audit-preparation-recovery-1'
 assert manifest['failure_stage']=='before-released-route'
 assert task_dir.relative_to(root).as_posix()==manifest['task_path']
 assert manifest['spec']['path']==spec_path.resolve().relative_to(root).as_posix()
 assert manifest['spec']['sha256']==hashlib.sha256(spec_path.read_bytes()).hexdigest()
 assert manifest['preparer_parent']=={'path':D.relative_to(root).as_posix()+'/prepare-successor-audit-with-source-context.py','sha256':'f0f27bc5757411a7363fcc70a18c78b2d5bf8011920f9e7c9ee2ebc2013f4ce2'}
 assert hashlib.sha256((root/manifest['preparer_parent']['path']).read_bytes()).hexdigest()==manifest['preparer_parent']['sha256']
 expected_names={'audit-task.json','user-interpretation-packet.json'}
 assert isinstance(manifest['existing_files'],list) and len(manifest['existing_files'])==2
 pins={}
 for item in manifest['existing_files']:
  assert set(item)=={'path','sha256'}
  name=Path(item['path']).name
  assert name in expected_names and item['path']==(task_dir/name).relative_to(root).as_posix()
  assert name not in pins
  pins[name]=item['sha256']
 assert set(pins)==expected_names
 verify_partial_recovery(task_dir,pins,True)
 return pins


def verify_partial_recovery(task_dir,pins,initial=False):
 assert task_dir.is_dir() and not task_dir.is_symlink()
 if initial:assert {p.name for p in task_dir.iterdir()}==set(pins),'Unexpected partial-task entry.'
 for name,digest in pins.items():
  path=task_dir/name
  assert path.is_file() and not path.is_symlink()
  assert hashlib.sha256(path.read_bytes()).hexdigest()==digest,(name,'partial input changed')

DIM_MODULE_EXTENSION = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-module-root-preparation/module-root-extension.json', 'sha256': 'dab9569be722bf01499657069396e5f7dd63bccdd29b0f493c3fb94ac6aa881d'}
DIM_MODULE_PLAN = {'format': 'exact-dim-mathlib-module-roots-1', 'proposal': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/five-owner-proposal.json', 'sha256': '7326cc0da682528a8e79630ed1d527a8f5079a640b06a444639549e4254bba8b'}, 'roots': ['.', 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m'], 'modules': [{'module': 'Mathlib.Analysis.Calculus.ContDiff.Defs', 'mirror': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, 'upstream': {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, 'compiled': {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/Defs.olean', 'sha256': 'a66883bdc48c62933798e9de83fe3f9e34cd425866620a273b0d8fa9163f91fa'}, 'bytes': 64851}, {'module': 'Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries', 'mirror': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, 'upstream': {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, 'compiled': {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.olean', 'sha256': 'd46029388be2edef659aae84e84fcbf4a1fadbc1d9e1798b4d499c82988ea28a'}, 'bytes': 50681}], 'literal_receipt': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/user-high-resolution-interpretation-20260908.json', 'sha256': '5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a'}, 'environment_files': [{'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/five-owner-proposal.json', 'sha256': '7326cc0da682528a8e79630ed1d527a8f5079a640b06a444639549e4254bba8b'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/user-high-resolution-interpretation-20260908.json', 'sha256': '5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/Defs.olean', 'sha256': 'a66883bdc48c62933798e9de83fe3f9e34cd425866620a273b0d8fa9163f91fa'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.olean', 'sha256': 'd46029388be2edef659aae84e84fcbf4a1fadbc1d9e1798b4d499c82988ea28a'}]}
DIM_MODULE_CONTEXT = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-inherited-hyperbolicity-context/source-context-v3.json', 'sha256': 'd7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206'}
DIM_MODULE_TARGET = {'path': 'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean', 'declaration': 'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'}

def load_dim_module_roots(root, spec):
 """Exact genuine upstream mirrors, only for the reviewed DIM context/target."""
 def unique(pairs):
  result={}
  for k,v in pairs:
   assert k not in result,('duplicate module-root key',k)
   result[k]=v
  return result
 def pinned(reference):
  assert isinstance(reference,dict) and set(reference)=={'path','sha256'}
  rel=reference['path'];digest=reference['sha256']
  assert isinstance(rel,str) and rel and '\\' not in rel and ':' not in rel
  assert all(x not in ('','.','..') for x in rel.split('/')) and not Path(rel).is_absolute()
  assert isinstance(digest,str) and len(digest)==64 and all(c in '0123456789abcdef' for c in digest)
  p=root/rel
  assert p.is_file() and not p.is_symlink() and p.resolve().is_relative_to(root.resolve())
  b=p.read_bytes();assert hashlib.sha256(b).hexdigest()==digest,(rel,'module-root pin changed')
  return b
 assert spec.get('choice_id')=='Q10' and spec.get('row_id')=='LEV-CH01-DIMENSIONAL-SPLITTING'
 assert isinstance(spec.get('task_id'),str) and spec['task_id'].startswith('LEV-CH01-') and spec['task_id'].endswith('-PRODUCTION-20260908')
 assert spec.get('target')==DIM_MODULE_TARGET,'Exact DIM target required; native bytes remain independently validated.'
 assert spec.get('source_context_extension')==DIM_MODULE_CONTEXT
 assert spec.get('module_source_root_extension')==DIM_MODULE_EXTENSION
 plan=json.loads(pinned(DIM_MODULE_EXTENSION),object_pairs_hook=unique)
 assert plan==DIM_MODULE_PLAN,'Unreviewed module-root plan'
 for reference in plan['environment_files']:pinned(reference)
 proposal=json.loads(pinned(plan['proposal']),object_pairs_hook=unique)
 assert proposal['blind_config_extension']['lean.module_source_roots']==plan['roots']
 assert proposal['blind_config_extension']['exact_upstream_mirrors']==[
  dict(item['mirror'],bytes=item['bytes']) for item in plan['modules']]
 for item in plan['modules']:
  assert pinned(item['mirror'])==pinned(item['upstream'])
  assert len(pinned(item['mirror']))==item['bytes']
 context=json.loads(pinned(DIM_MODULE_CONTEXT),object_pairs_hook=unique)
 assert plan['literal_receipt'] in context['interpretation_receipts']
 receipt=json.loads(pinned(plan['literal_receipt']),object_pairs_hook=unique)
 assert receipt['answer']=='Adopt this explicit convention'
 assert receipt['question_item_id']==['request_user_input_async','call_1OyqIuAHK4eJ8CPSAKCpAt08',0]
 mirror_root=root/plan['roots'][1]
 actual=[]
 def scan(directory):
  assert not directory.is_symlink() and not directory.is_junction()
  assert directory.resolve().is_relative_to(mirror_root.resolve())
  for child in directory.iterdir():
   assert not child.is_symlink() and not child.is_junction()
   if child.is_dir():scan(child)
   else:
    assert child.is_file()
    actual.append(child.relative_to(root).as_posix())
 scan(mirror_root)
 assert sorted(actual)==sorted(x['mirror']['path'] for x in plan['modules']),'Unexpected file in exact mirror root'
 return plan


def apply_dim_module_roots(config, plan):
 assert config['lean']['module_source_roots']==['.'],'Prior roots must remain exact before append'
 result=json.loads(json.dumps(config))
 result['lean']['module_source_roots']=list(plan['roots'])
 return result


def verify_dim_module_roots(root, spec, config, manifested=None):
 plan=load_dim_module_roots(root,spec)
 assert config['lean']['module_source_roots']==plan['roots']
 expected=[DIM_MODULE_EXTENSION,*plan['environment_files']]
 for reference in expected:
  assert config['lean']['environment_files'].count(reference['path'])==1
  if manifested is not None:
   found=[x for x in manifested['lean_environment'] if x['path']==reference['path']]
   assert len(found)==1 and found[0]['sha256']==reference['sha256']


assert len(sys.argv) in (2,6)
if len(sys.argv)==6:assert sys.argv[2]=='--recover-partial' and sys.argv[4]=='--recovery-sha256'
spec=json.loads(Path(sys.argv[1]).read_bytes())
module_root_plan=load_dim_module_roots(R,spec)
additional_data=load_additional_supplement(R,spec['additional_supplement']) if spec.get('additional_supplement') else None
taskid=spec['task_id'];prior=S/'audits'/spec['prior_task'];T=S/'audits'/taskid
if len(sys.argv)==6:
 recovery_pins=load_partial_recovery(R,T,Path(sys.argv[1]),Path(sys.argv[3]),sys.argv[5])
 assert not (D/(taskid+'.config.json')).exists(),'Unexpected successor configuration.'
else:assert not T.exists(),T
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
if not recovery_pins:T.mkdir()
writej(T/'audit-task.json',task)
interpretation={'format':'coordinator-selected-source-interpretation-1','authority':selections['authority'],'exact_user_objective':selections['exact_user_objective'],'goal_observation_sha256':selections['goal_observation_sha256'],'selection_receipt':{'path':receipt.relative_to(R).as_posix(),'sha256':sha(receipt)},'scope_row':spec['row_id'],'choice':choice,'source_sha256':task['source']['sha256'],'preservation':selections['preservation'],'comparison_rule':'Assess the exact selected claim under this explicit coordinator-selected interpretation. This is authorized task work, not a literal detailed user answer or a printed-source assertion. Independently decide both implications; any acceptance must be interpretation-qualified and preserve source ambiguity. No requested verdict is supplied.'}
writej(T/'user-interpretation-packet.json',interpretation)
if context_data is not None:writej(T/'inherited-source-interpretation-packet.json',context_data['packet'])
cfgpath=S/spec['prior_config'];cfg=json.loads(cfgpath.read_bytes())
cfg=apply_dim_module_roots(cfg,module_root_plan)
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
envfiles.extend(x['path'] for x in [DIM_MODULE_EXTENSION,*module_root_plan['environment_files']])
cfg['lean']['environment_files']=list(dict.fromkeys(envfiles))
verify_dim_module_roots(R,spec,cfg)
for rel in cfg['lean']['environment_files']:assert (R/rel).is_file(),rel
config=D/(taskid+'.config.json');writej(config,cfg)
writej(T/'preparation-lineage.json',{'prior_task':spec['prior_task'],'prior_manifest_sha256':sha(prior/'faithfulness/manifest.json'),'prior_config_sha256':sha(cfgpath),'environment_byte_checks':verified,'target_sha256':sha(R/task['target']['path']),'selected_interpretation_sha256':sha(T/'user-interpretation-packet.json'),'prior_decisions_reused':False,'additional_supplement':spec.get('additional_supplement'),'spec_sha256':sha(Path(sys.argv[1])),'source_context_extension':spec.get('source_context_extension'),'inherited_interpretation_sha256':sha(T/'inherited-source-interpretation-packet.json') if context_data is not None else None,'preparer_sha256':sha(Path(__file__)),'module_source_root_extension':spec['module_source_root_extension'],'module_source_roots':module_root_plan['roots'],'partial_recovery_manifest':{'path':Path(sys.argv[3]).resolve().relative_to(R).as_posix(),'sha256':sys.argv[5]} if recovery_pins else None})
wrapper=str(W/'workflow-v5.0.1-local/run_workflow_posix.py')
env=os.environ.copy();env['FAITHFULNESS_AUDIT_CONFIG']='/c/'+config.as_posix()[3:]
def released(label,script,args,cwd):
 verify_dim_module_roots(R,spec,cfg)
 if recovery_pins:verify_partial_recovery(T,recovery_pins)
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
verify_dim_module_roots(R,spec,cfg,json.loads((T/'faithfulness/manifest.json').read_bytes()))
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
 code=code.replace('from pathlib import Path','from pathlib import Path\nimport os\n'+'def install_native_long_path_io():\n """Use extended Windows paths only at I/O; preserve all logical Path strings."""\n import io\n if getattr(Path,\'_audit_extended_io_installed\',False):return\n assert os.name==\'nt\'\n def native_path(path):\n  value=os.path.abspath(os.fspath(path))\n  if value.startswith(\'\\\\\\\\?\\\\\'):return value\n  if value.startswith(\'\\\\\\\\\'):return \'\\\\\\\\?\\\\UNC\\\\\'+value[2:]\n  return \'\\\\\\\\?\\\\\'+value\n def normal_path(value):\n  if value.startswith(\'\\\\\\\\?\\\\UNC\\\\\'):return \'\\\\\\\\\'+value[8:]\n  if value.startswith(\'\\\\\\\\?\\\\\'):return value[4:]\n  return value\n def path_open(self,mode=\'r\',buffering=-1,encoding=None,errors=None,newline=None):\n  return io.open(native_path(self),mode,buffering,encoding,errors,newline)\n def path_stat(self,*,follow_symlinks=True):return os.stat(native_path(self),follow_symlinks=follow_symlinks)\n def path_mkdir(self,mode=0o777,parents=False,exist_ok=False):\n  try:os.mkdir(native_path(self),mode)\n  except FileNotFoundError:\n   if not parents or self.parent==self:raise\n   self.parent.mkdir(parents=True,exist_ok=True)\n   self.mkdir(mode,parents=False,exist_ok=exist_ok)\n  except OSError:\n   if not exist_ok or not self.is_dir():raise\n def path_iterdir(self):\n  for name in os.listdir(native_path(self)):yield self/name\n def path_resolve(self,strict=False):return type(self)(normal_path(os.path.realpath(native_path(self),strict=strict)))\n Path.open=path_open;Path.stat=path_stat;Path.mkdir=path_mkdir;Path.iterdir=path_iterdir;Path.resolve=path_resolve\n Path._audit_extended_io_installed=True\n\ninstall_native_long_path_io()\n')
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
verify_dim_module_roots(R,spec,cfg,json.loads((T/'faithfulness/manifest.json').read_bytes()))
if recovery_pins:verify_partial_recovery(T,recovery_pins)
print(json.dumps({'prepared':taskid,'config':str(config),'runner':str(tr/'q.py'),'pages':spec['pages'],'blind_bytes':len(packet)}),flush=True)
