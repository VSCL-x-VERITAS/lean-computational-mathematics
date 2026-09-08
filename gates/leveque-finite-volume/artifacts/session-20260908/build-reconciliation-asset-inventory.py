"""Inventory a committed reconciliation input without asserting an epoch or semantic verdict.

All content hashes come from actual Git blobs. The output must be outside tracked
paths. Current gate selection controls source-audit selection; historical runs
remain explicit retained evidence. A preview may contain open rows.
"""
from pathlib import Path
import argparse,hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--head',default='HEAD');p.add_argument('--topology',type=Path,required=True)
p.add_argument('--fingerprints',action='append',required=True,help='Repository-relative committed fingerprint artifact')
p.add_argument('--output',type=Path,required=True);p.add_argument('--require-closed',action='store_true')
a=p.parse_args()
def git(*args,**kw):return subprocess.check_output(['git','-c','core.longpaths=true',*args],cwd=R,**kw)
def hashbytes(b):return hashlib.sha256(b).hexdigest()
def canonical(v):return json.dumps(v,sort_keys=True,separators=(',',':'),ensure_ascii=True).encode()
def identifier(prefix,key):return prefix+'-'+hashbytes(key.encode())[:24]
head=git('rev-parse',a.head+'^{commit}').decode().strip()
tree=git('rev-parse',head+'^{tree}').decode().strip()
topology_bytes=a.topology.read_bytes();topology=json.loads(topology_bytes)
instances={i['id']:i for i in topology['instances']}
lane=instances['leveque-ch01-work'];base=lane['anchor']
assert lane['head']==head, 'Inventory the exact pinned lane head; candidate merge mapping belongs in the final epoch.'
assert git('rev-parse',lane['ref']).decode().strip()==head
for i in instances.values():assert git('rev-parse',i['ref']).decode().strip()==i['head']
assert instances['reorganization-baseline-inspection']['head']==base
assert not git('diff','--name-only',base,instances['reorganization-baseline-inspection']['head']).strip()
def tree_entries(ref):
 out={}
 for record in git('ls-tree','-r','-z',ref).split(b'\0'):
  if not record:continue
  header,path=record.split(b'\t',1);mode,kind,oid=header.split()
  assert kind==b'blob', (path,kind)
  out[path.decode()]={'mode':mode.decode(),'oid':oid.decode()}
 return out
entries=tree_entries(head);baseline=tree_entries(base)
changed={k for k,v in entries.items() if k not in baseline or baseline[k]!=v}
deleted=set(baseline)-set(entries)
assert not deleted, 'Deletion needs separately reviewed transport/retention evidence.'
dest=a.output.resolve()
assert dest.is_relative_to(R/'.formalization/reconciliation/asset-inventories'),dest
assert not dest.exists()
assert not git('ls-files','--',str(dest)).strip()
blob_cache={};data_cache={}
proc=subprocess.Popen(['git','-c','core.longpaths=true','cat-file','--batch'],cwd=R,stdin=subprocess.PIPE,stdout=subprocess.PIPE)
def blob(path,content=False,old=False):
 mapping=baseline if old else entries;oid=mapping[path]['oid']
 if oid not in blob_cache or content and oid not in data_cache:
  assert proc.stdin and proc.stdout
  proc.stdin.write((oid+'\n').encode());proc.stdin.flush()
  actual,kind,size=proc.stdout.readline().decode().strip().split()
  assert actual==oid and kind=='blob'
  remaining=int(size);h=hashlib.sha256();chunks=[]
  while remaining:
   chunk=proc.stdout.read(min(1024*1024,remaining));assert chunk
   h.update(chunk);remaining-=len(chunk)
   if content:chunks.append(chunk)
  assert proc.stdout.read(1)==b'\n'
  blob_cache[oid]=h.hexdigest()
  if content:data_cache[oid]=b''.join(chunks)
 return data_cache[oid] if content else blob_cache[oid]
def read(path,old=False):return json.loads(blob(path,True,old))
gatepath='gates/leveque-finite-volume/chapter-01.json';gate=read(gatepath)
oldgate=read(gatepath,True)
closed={'PROVED','REUSED'}
openrows=[r['id'] for r in gate['rows'] if r['status'] not in closed|{'SKIPPED'}]
if a.require_closed:assert not openrows
assets=[];used_ids=set();coverage={};module_assets={}
def add(asset,paths=()):
 assert asset['asset_id'] not in used_ids;used_ids.add(asset['asset_id']);assets.append(asset)
 for path in paths:
  if path in changed:
   assert path not in coverage,(path,coverage[path],asset['asset_id'])
   coverage[path]=asset['asset_id']
def make(kind,key,payload,unique,disposition='selected',**metadata):
 if metadata.get('source_hash',False) is None:metadata.pop('source_hash')
 return {'asset_id':identifier(kind,key),'concept_id':identifier('concept',kind+':'+key),
 'lane_id':'leveque-ch01-work','kind':kind,'unique':unique,'disposition':disposition,
 'content_sha256':hashbytes(canonical(payload)),**metadata}
sourcehash=gate['source_unit_sha256']
add(make('gate',gatepath,gate,gatepath in changed, 'retained-unresolved' if openrows else 'selected',
 path=gatepath,blob_sha256=blob(gatepath),source_hash=sourcehash,open_rows=openrows),[gatepath])
selected_tasks={r['faithfulness_task'].rsplit('/',1)[0]:r['id'] for r in gate['rows'] if r['status'] in closed}
for row in gate['rows']:
 old=next((r for r in oldgate['rows'] if r['id']==row['id']),None)
 add(make('source-row',row['id'],row,old!=row,'retained-unresolved' if row['id'] in openrows else 'selected',
 row=row['id'],status=row['status'],source_hash=sourcehash,source_locator={k:row.get(k) for k in ['printed_page','pdf_page','source_label']},
 declarations=row.get('lean_declarations',[]),faithfulness_task=row.get('faithfulness_task'),
 gate_blob_sha256=blob(gatepath),baseline_row_sha256=hashbytes(canonical(old)) if old else None))
records={};fingerprint_inputs=[];source_files={}
for path in a.fingerprints:
 assert path in entries,path
 f=read(path);fingerprint_inputs.append({'path':path,'sha256':blob(path),'normalization':f['normalization']})
 for src in f['files']:
  assert src['path'] in entries and blob(src['path'])==src['sha256'],src
  source_files[src['path']]=src
 for record in f['records']:
  assert record['name'] not in records,'Overlapping fingerprint inventories need explicit equality handling.'
  records[record['name']]=record
for row in gate['rows']:
 if row['status'] in closed:
  for name in row['lean_declarations']:assert name in records,('Missing exact selected declaration fingerprint',name)
modules=set(source_files)|{k for k in changed if k.endswith('.lean') and k.startswith(('ComputationalMathematics/','NumStability/'))}
for path in sorted(modules):
 data=blob(path,True);text=data.decode()
 imports=re.findall(r'^import\s+(\S+)',text,re.M)
 module=path[:-5].replace('/','.')
 payload={'module':module,'path':path,'source_sha256':blob(path),'imports':imports}
 asset=make('module',module,payload,path in changed,path=path,module=module,imports=imports,
 declaration_names=sorted(n for n,r in records.items() if r['module']==module),
 baseline_blob_sha256=blob(path,old=True) if path in baseline else None,**{'split_status':'none'})
 module_assets[module]=asset['asset_id'];add(asset,[path])
for name,record in sorted(records.items()):
 module=record['module'];path=module.replace('.','/')+'.lean'
 assert module in module_assets and path in entries
 assert path not in baseline or path not in changed, 'Changed existing declaration owners need a separately reviewed transport inventory.'
 linked=[r['id'] for r in gate['rows'] if name in r.get('lean_declarations',[]) and r['status'] in closed]
 add(make('declaration',name,record,path not in baseline,name=name,module=module,
 module_asset_id=module_assets[module],type_hash=record['type_sha256'],proof_hash=record['value_sha256'],
 recursor_values_sha256=record['recursor_values_sha256'],level_params_sha256=record['level_params_sha256'],
 selected_source_rows=linked,source_hash=sourcehash if linked else None,
 identity_scope='Alpha-canonical structural expression, not a claim of full definitional normal form.'))
audit_roots=sorted({path.rsplit('/',1)[0] for path in entries if path.endswith('/audit-task.json') and path.startswith('gates/leveque-finite-volume/artifacts/')})
for directory in audit_roots:
 members=sorted(k for k in entries if k.startswith(directory+'/'))
 if not set(members)&changed and directory not in selected_tasks and directory!=next(r['faithfulness_task'].rsplit('/',1)[0] for r in oldgate['rows'] if r['status']=='PROVED'):continue
 task=read(directory+'/audit-task.json')
 manifestpath=task['audit_output']+'/manifest.json'
 decisionpath=task['audit_output']+'/decision.json'
 decision=read(decisionpath) if decisionpath in entries else None
 selected=directory in selected_tasks
 if selected:assert decision and decision.get('accepted') is True
 file_records=[{'path':k,'sha256':blob(k)} for k in members]
 add(make('audit',task['task_id'],file_records,bool(set(members)&changed),
 'selected' if selected else 'retained-unresolved',
 task_id=task['task_id'],selected_source_row=selected_tasks.get(directory),files=file_records,
 source_hash=task['source']['sha256'],target=task['target'],
 recorded_classification=decision.get('classification') if decision else None,
 recorded_accepted=decision.get('accepted') if decision else None,
 current_source_certificate=selected,
 purpose='Current selected source audit' if selected else 'Historical or unfinished evidence retained; not counted as a current source acceptance.'),
 members)
misc=sorted(changed-set(coverage))
if misc:
 file_records=[{'path':k,'sha256':blob(k)} for k in misc]
 add(make('proof','retained-session-and-organization-evidence',file_records,True,
 'selected',files=file_records,purpose='Retain every remaining changed tracked file, including proof checks, search records, raw failures, ledgers, and organization evidence.'),misc)
assert set(coverage)==changed
baseline_changes=[]
for old in oldgate['rows']:
 if old['status']!='PROVED':continue
 current=next(r for r in gate['rows'] if r['id']==old['id'])
 oldtask=read(old['faithfulness_task'],old=True);newtask=read(current['faithfulness_task'])
 if oldtask['target']!=newtask['target']:
  oldname=oldtask['target']['declaration'];newname=newtask['target']['declaration']
  assert oldname in records and newname in records
  baseline_changes.append({'row':old['id'],'old_target':oldtask['target'],'new_target':newtask['target'],
   'old_type_sha256':records[oldname]['type_sha256'],'new_type_sha256':records[newname]['type_sha256'],
   'old_proof_sha256':records[oldname]['value_sha256'],'new_proof_sha256':records[newname]['value_sha256'],
   'old_audit_task_sha256':blob(old['faithfulness_task'],old=True),'new_audit_task_sha256':blob(current['faithfulness_task']),
   'required_transport_class':'producer','required_faithfulness':'full-reaudit',
   'note':'A separately reviewed policy-domain fingerprint and exact current audit are required in the final transport entry.'})
if proc.stdin:proc.stdin.close()
assert proc.wait()==0
result={'schema':1,'purpose':'Committed input asset inventory, not a reconciliation epoch or validation verdict.',
 'head':head,'tree':tree,'anchor':base,'topology_sha256':hashbytes(topology_bytes),
 'lane_heads':[{'instance_id':i['id'],'head':i['head']} for i in topology['instances']],
 'profile_sha256':gate['bindings']['module_profile_sha256'],'source_sha256':sourcehash,
 'fingerprint_inputs':fingerprint_inputs,'changed_file_count':len(changed),'deleted_files':sorted(deleted),
 'file_coverage':coverage,'assets':assets,'required_baseline_producer_transports':baseline_changes,
 'branches':[{'instance_id':i['id'],'ref':i['ref'],'unique_assets':[x['asset_id'] for x in assets if x['lane_id']==i['id'] and x['unique']],'disposition':'retain'} for i in topology['instances'] if i['role'] in ['formalization','reorganization']],
 'inspection_lane_evidence':{'head':base,'anchor':base,'exact_git_delta_empty':True},
 'open_source_rows':openrows,'semantic_selection_basis':'Only the current committed gate selects an audit; reachability, timestamps, and archived acceptance do not.'}
dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'path':str(dest),'sha256':hashbytes(dest.read_bytes()),'assets':len(assets),'changed_files_covered':len(coverage),'open_rows':len(openrows),'required_baseline_producer_transports':len(baseline_changes)}))
