"""Verify completed native overlay receipts and exact axiom-report coverage."""
import hashlib,json,os,re
from pathlib import Path
R=Path(r"C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics")
P=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-five-owner-overlay'
native=lambda path:str(path) if str(path).startswith('\\\\?\\') else '\\\\?\\'+os.path.abspath(path)
def raw(path):
 with open(native(path),'rb') as stream:return stream.read()
def load(path):return json.loads(raw(path))
def ref(path):
 data=raw(path)
 try: name=Path(path).relative_to(R).as_posix()
 except ValueError:name=str(path)
 return {'path':name,'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
def put(name,data):
 with open(native(P/name),'xb') as stream:stream.write((json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode())
def bind(item):
 path=Path(item['path'])
 if not path.is_absolute():path=R/path
 actual=ref(path);assert actual['sha256']==item['sha256'],item
 return actual

plan=load(P/'plan.json')
complete=load(P/'completion-v3.json')
assert complete['status']=='OVERLAY_NATIVE_REPLAY_COMPLETE'
receipts=[]
for entry in sorted((P/'runs03').iterdir()):
 if not entry.is_dir():continue
 receipt=load(entry/'receipt.json')
 assert receipt['exit_code']==0,(entry.name,receipt['exit_code'])
 bind(receipt['stdout']);bind(receipt['stderr'])
 assert raw(R/receipt['stderr']['path'])==b'',entry.name
 receipts.append({'label':entry.name,'receipt':ref(entry/'receipt.json')})
for item in plan['all_read_inputs']:bind(item)
dependencies=load(P/'dependency-resolutions-v3.json')
for item in dependencies['direct']:
 for value in item['dependencies']:bind(value)
for item in dependencies['full_compiled_imports']:bind(item['file'])
copies=load(P/'unchanged-compiled-copies-v3.json')
assert copies['affected_old_oleans_copied']==0
for item in copies['copies']:
 bind(item['original']);bind(item['overlay'])
 assert item['original']['sha256']==item['overlay']['sha256']
canonical=set(plan['affected_modules_topological'])
selected={item['module']:item for item in dependencies['full_compiled_imports']}
for mod in canonical:
 item=selected[mod]
 assert item['overlay'] and '/overlay/lib03/' in item['file']['path'],mod

allowed={'propext','Classical.choice','Quot.sound'}
reports=[]
for label in ['IsolationProbe','SourceJoint','CanonicalChecks']:
 source=raw(P/'overlay'/(label+'.lean')).decode('utf-8')
 expected=re.findall(r'(?m)^#print axioms\s+(\S+)',source)
 output=raw(P/'runs03'/label/'output.txt').decode('utf-8')
 assert not re.search(r'\b(?:error|warning):',output),label
 found=re.findall(r"'([^']+)'\s+(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)",output)
 assert len(found)==len(expected),(label,len(found),len(expected))
 normalized=[]
 for name,axioms in found:
  normname=re.sub(r'\.\{[^}]*\}$','',name)
  values=[x.strip() for x in axioms.split(',') if x.strip()]
  assert set(values)<=allowed,(label,name,values)
  normalized.append(normname)
  reports.append({'input':label,'name':name,'normalized_name':normname,'axioms':values})
 assert normalized==expected,(label,normalized,expected)

isolation=raw(P/'runs03/IsolationProbe/output.txt').decode('utf-8')
resolution={name:path for name,path in re.findall(r'^RESOLVED (\S+) (.+)$',isolation,re.M)}
assert len(resolution)==16,len(resolution)
for owner in plan['owners']:
 path=resolution[owner['module']]
 assert '\\overlay\\lib03\\' in path or '/overlay/lib03/' in path,path

lean_path_source=Path(r'C:\Users\qed_s\.elan\toolchains\leanprover--lean4---v4.29.0-rc3\src\lean\Lean\Util\Path.lean')
regularity_definition_source=R/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean'
summary={'schema':1,'result':'PASS_OVERLAY_PROOF_REPLAY','source_acceptance':False,'canonical_placement':False,
 'proposal':plan['proposal'],'root_review':plan['root_review'],'native_runs':receipts,
 'affected_modules':plan['affected_modules_topological'],'copied_owner_sources':16,
 'project_import_closure_owners':len(plan['project_import_closure']),
 'unchanged_compiled_copy_modules':len({x['module'] for x in copies['copies']}),
 'unchanged_compiled_copy_files':len(copies['copies']),
 'full_compiled_import_modules':len(dependencies['full_compiled_imports']),
 'checked_axiom_reports':len(reports),'empty_axiom_reports':sum(not x['axioms'] for x in reports),
 'axiom_reports':reports,'Lean_search_path_implementation':ref(lean_path_source),
 'pinned_ContDiff_definition':ref(regularity_definition_source),
 'unchanged_sources_and_original_compiled_outputs':True,
 'limits':['Artifact-only canonical-name overlay; original production and audit remain unchanged.',
           'Changes C-infinity effective domain and preserves the selected stability rate by definitional equality.',
           'Does not settle source interpretation, geometry applicability, or source faithfulness.']}
put('verification.json',summary)
print(json.dumps({k:summary[k] for k in ['result','checked_axiom_reports','empty_axiom_reports','full_compiled_import_modules','unchanged_compiled_copy_files']}))
