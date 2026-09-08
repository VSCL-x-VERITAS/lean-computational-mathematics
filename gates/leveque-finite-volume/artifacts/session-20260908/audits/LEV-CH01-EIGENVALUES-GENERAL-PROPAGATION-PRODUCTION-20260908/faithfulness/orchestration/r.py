import hashlib,json,subprocess,sys
from pathlib import Path
from datetime import datetime,timezone
task,role,stem,pages_arg=sys.argv[1:5]
assert task=='LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908'
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
if role=='blind-translation':
 packet=(out/'inputs/blind_review_packet.md').read_bytes()
 parts.append(('\nDossier SHA256: '+hashlib.sha256(packet).hexdigest()+'\n\nComplete packet follows:\n').encode()+packet)
 records.append({'label':'blind packet','sha256':hashlib.sha256(packet).hexdigest(),'bytes':len(packet)})
else:
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
 if role in ('direct-judge','adjudicator'):
  add('Complete direct review packet; dossier_sha256 is this packet hash',out/'inputs/direct_review_packet.md')
  add('Complete dependency inventory',out/'inputs/dependency_inventory.json')
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
  parts.append(b'\nRoundtrip isolation: do not read Lean, direct or blind input packets, declaration dossiers, dependency inventories, direct judgment, or any prior output other than the supplied source contract and blind translation.\n')
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
