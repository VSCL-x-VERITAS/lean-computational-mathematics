import hashlib,json,subprocess,sys
from pathlib import Path
import os
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

from datetime import datetime,timezone
task,role,stem,pages_arg=sys.argv[1:5]
assert task=='LEV-CH01-FV-LOCAL-FLUX-UPDATE-NORM-COMPLETE-PRODUCTION-20260908'
root=Path(r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics')
out=root/'gates/leveque-finite-volume/artifacts/session-20260908/audits'/task/'faithfulness'
out=Path(chr(92)*2+'?'+chr(92)+str(out))
kit=root/'.faithfulness-audit'
tr=out/'orchestration';tr.mkdir(exist_ok=True)
prompt_names={'blind-translation':'blind_translation','source-contract':'source_contract','direct-judge':'direct_judge','roundtrip-judge':'roundtrip_judge','adjudicator':'adjudicator'}
name=prompt_names[role]
parts=[]
records=[]
def add(label,path):
 data=path.read_bytes();parts.append(('\n\n'+label+' SHA256 '+hashlib.sha256(data).hexdigest()+'\n').encode()+data);records.append({'label':label,'path':str(path),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)})
add('Exact role prompt',kit/'prompts'/(name+'.md'))
add('Exact output schema',kit/'schemas'/(name+'.schema.json'))
images=[]
if role=='source-contract':
 parts.append(b'\nSource-only extraction: report the immutable book facts and their uncertainties. Do not infer any adopted interpretation or target content from this task name. No user convention or Lean evidence is supplied to this role.\n')
if role=='blind-translation':
 packet=(out/'inputs/blind_review_packet.md').read_bytes()
 parts.append(('\nDossier SHA256: '+hashlib.sha256(packet).hexdigest()+'\n\nComplete packet follows:\n').encode()+packet)
 records.append({'label':'blind packet','sha256':hashlib.sha256(packet).hexdigest(),'bytes':len(packet)})
else:
 assert pages_arg=='26,27'
 pinned_source_images={'26': 'de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257', '27': 'b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6'}
 locator=json.loads((out/'inputs/source_locator.json').read_text(encoding='utf-8'))
 pdf=root/locator['source_path']
 assert hashlib.sha256(pdf.read_bytes()).hexdigest()==locator['source_sha256']
 parts.append(('\nFresh isolated role. Return only schema JSON. Do not write files. Primary source PDF is '+str(pdf)+'. The attached PNG images render the indicated raw PDF pages. Independently inspect the primary source and necessary inherited context. The PDF is authoritative, the source contract supports extraction. If using tools, read only the allowed source and inline role evidence. Native Python with pypdf is available at C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe. Do not read other tasks or prior audit runs, task paraphrases, repository context notes, target proof, or conversation. Read only the role evidence supplied here and the primary source.').encode())
 add('Source locator',out/'inputs/source_locator.json')
 if role!='source-contract':
  add('Source contract',out/'agent_outputs/source_contract.json')
  add('Exact methodology',kit/'METHODOLOGY.md')
  add('Semantic checks C01-C12 first',kit/'checks/core.json')
  add('Semantic checks N01-N06 second',kit/'checks/numerical-analysis.json')
  interpretation=out.parent/'user-interpretation-packet.json'
  interpretation_manifest=json.loads((out/'manifest.json').read_bytes())
  interpretation_record=next(row for row in interpretation_manifest['lean_environment'] if row['path'].endswith('/'+task+'/user-interpretation-packet.json'))
  assert hashlib.sha256(interpretation.read_bytes()).hexdigest()==interpretation_record['sha256']
  add('Separate coordinator-selected source interpretation under the user goal; not a printed-source assertion',interpretation)
  parts.append(b'\nThe user requested that all nine rows be unblocked. The coordinator selected the documented convention for this row within that task. This is not a literal detailed user answer. Assess the exact source claim under this explicitly selected convention. The convention is separate from source evidence and supplies no requested verdict. Independently compare every exact target claim, hypothesis, and domain with the source under that convention. Preserve the original source-only ambiguity as such; do not attribute the convention to the book. Any acceptance and implication reasoning must explicitly be qualified as under the recorded coordinator-selected interpretation. The convention does not apply to other source rows.\n')
  inherited=out.parent/'inherited-source-interpretation-packet.json'
  inherited_record=next(row for row in interpretation_manifest['lean_environment'] if row['path'].endswith('/'+task+'/inherited-source-interpretation-packet.json'))
  assert hashlib.sha256(inherited.read_bytes()).hexdigest()==inherited_record['sha256']
  add('Separate exact inherited user interpretation; retain original authority and scope and assess applicability independently',inherited)
  parts.append(b'\nThis inherited receipt is distinct from the coordinator-selected convention. Its literal answer and scope must remain unchanged. Independently assess both implications under the applicable recorded conventions without importing prior judgments. Added source context does not add independently audited source rows.\n')
 if role in ('direct-judge','adjudicator'):
  add('Complete direct review packet; dossier_sha256 is this packet hash',out/'inputs/direct_review_packet.md')
  add('Complete dependency inventory',out/'inputs/dependency_inventory.json')
  supplement=out.parent/'dependency-environment-packet.json'
  if supplement.is_file():
   manifest=json.loads((out/'manifest.json').read_bytes())
   supplement_record=next(row for row in manifest['lean_environment'] if row['path'].endswith('/'+task+'/dependency-environment-packet.json'))
   assert hashlib.sha256(supplement.read_bytes()).hexdigest()==supplement_record['sha256']
   add('Exact proof-free native Lean environment supplement; independently inspect its declarations and provenance',supplement)
   parts.append(b'\nThis supplement contains exact native output spans and runtime/source hash provenance. It supplies no prior audit judgment. Treat declaration output as evidence to inspect independently, not a requested interpretation or classification. It is bound by the prepared manifest as Lean-environment evidence. Preserve any unresolved source or dependency meaning.\n')
  reuse=out/'inputs/dependency_reuse_direct.json'
  if reuse.exists(): add('Exact validated meaning reuse ledger; effects must be assessed freshly',reuse)
 if role in ('roundtrip-judge','adjudicator'):
  add('Complete blind translation; blind_translation_sha256 is this file hash',out/'agent_outputs/blind_translation.json')
 if role=='adjudicator':
  add('Complete direct declaration dossier',out/'inputs/declaration_dossier.md')
  add('Complete blind declaration dossier',out/'inputs/blind_dossier.md')
  reuse_blind=out/'inputs/dependency_reuse_blind.json'
  if reuse_blind.exists(): add('Blind dependency meaning reuse ledger',reuse_blind)
  add('Mechanical adjudication triggers',tr/'adjudication_triggers.json')
  add('Direct judgment',out/'agent_outputs/direct_judge.json')
  add('Roundtrip judgment',out/'agent_outputs/roundtrip_judge.json')
 if role=='roundtrip-judge':
  parts.append(b'\nRoundtrip isolation: do not read Lean, direct or blind input packets, declaration dossiers, dependency inventories, direct judgment, or any prior output other than the supplied source contract, blind translation, and separately labeled user interpretation.\n')
 if role=='direct-judge':
  parts.append(b'\nDirect isolation: do not read blind translation, roundtrip judgment, or prior judgments.\n')
 for page in pages_arg.split(','):
  if page:
   image=tr/('page-'+page.zfill(3)+'.png')
   if not image.is_file():
    original_image=root.parent/'workflow-v5.0.1-local/chapter01-source-review'/('page-'+page.zfill(3)+'.png')
    assert original_image.is_file(),original_image
    image.write_bytes(original_image.read_bytes())
   assert image.is_file(),image
   assert hashlib.sha256(image.read_bytes()).hexdigest()==pinned_source_images[page]
   images.append(image)
   parts.append(('\nAttached primary source rendering: raw PDF page '+page+'.\n').encode())
   records.append({'label':'primary source image page '+page,'path':str(image),'sha256':hashlib.sha256(image.read_bytes()).hexdigest(),'bytes':image.stat().st_size})
if role!='blind-translation': parts.append(b'\nTools are forbidden in this fresh role session. Independently inspect the attached primary-source page images and the exact inline evidence. Do not access the filesystem, network, shell, or other tools. The orchestrator verified source bytes and rendering hashes; do not claim to have independently recomputed them.\n')
message=b''.join(parts)
inp=tr/(stem+'_input.txt');assert not inp.exists();inp.write_bytes(message)
events=tr/(stem+'_events.jsonl');stderr=tr/(stem+'_stderr.txt');final=tr/(stem+'_final.json')
cmd=[r'C:/Users/qed_s/AppData/Local/OpenAI/Codex/bin/02c7a9ff819938f0/codex.exe','exec','--ignore-user-config','--skip-git-repo-check','--json','--color','never','-C','C:/Windows/Temp','-s','read-only','-o',str(final)]
for image in images: cmd+=['-i',str(image)]
cmd+=['-']
meta={'transport':'fresh Codex CLI exec stdin','fork':False,'cwd':'C:/Windows/Temp','command':cmd,'stdin_sha256':hashlib.sha256(message).hexdigest(),'stdin_bytes':len(message),'inputs':records,'started_at':datetime.now(timezone.utc).isoformat()}
mp=tr/(stem+'_transport.json');mp.write_text(json.dumps(meta,indent=2)+'\n',encoding='utf-8',newline='')
print(json.dumps({'status':'launching','role':role,'stdin_bytes':len(message),'stdin_sha256':meta['stdin_sha256']}),flush=True)
with events.open('wb') as ev,stderr.open('wb') as err:
 r=subprocess.run(cmd,input=message,stdout=ev,stderr=err)
meta['completed_at']=datetime.now(timezone.utc).isoformat();meta['exit_code']=r.returncode
mp.write_text(json.dumps(meta,indent=2)+'\n',encoding='utf-8',newline='')
print(json.dumps({'role':role,'exit_code':r.returncode,'final_exists':final.exists(),'events_bytes':events.stat().st_size,'stderr_bytes':stderr.stat().st_size}),flush=True)
