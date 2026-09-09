import json,sys,subprocess,os,hashlib
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

task,stem,role,filename=sys.argv[1:5]
assert task=='LEV-CH01-FV-LOCAL-FLUX-UPDATE-NORM-COMPLETE-PRODUCTION-20260908'
root=Path(r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics')
out=root/'gates/leveque-finite-volume/artifacts/session-20260908/audits'/task/'faithfulness'
out=Path(chr(92)*2+'?'+chr(92)+str(out))
tr=out/'orchestration'
events_path=tr/(stem+'_events.jsonl')
events=[json.loads(l) for l in events_path.read_text(encoding='utf-8').splitlines()]
threads=[e for e in events if e.get('type')=='thread.started']
assert len(threads)==1
uid=threads[0]['thread_id']
assert sum(e.get('type')=='turn.started' for e in events)==1
assert sum(e.get('type')=='turn.completed' for e in events)==1
assert not any(e.get('type') in ('error','turn.failed') for e in events)
assert all(e['item']['type']=='agent_message' for e in events if e.get('type')=='item.completed'), 'Unexpected completed tool or other item'
paths=list(Path(r'C:/Users/qed_s/.codex/sessions').glob('2026/09/08/*'+uid+'*.jsonl'))
assert len(paths)==1,paths
rows=[json.loads(l) for l in paths[0].read_text(encoding='utf-8').splitlines()]
metas=[r for r in rows if r['type']=='session_meta']
contexts=[r for r in rows if r['type']=='turn_context']
finals=[r for r in rows if r['type']=='response_item' and r['payload'].get('type')=='message' and r['payload'].get('role')=='assistant' and r['payload'].get('phase')=='final_answer']
assert len(metas)==len(contexts)==len(finals)==1
meta=metas[0]['payload'];ctx=contexts[0];final=finals[0]
assert meta['id']==uid
calls=[r for r in rows if r['type']=='response_item' and r['payload'].get('type') in ('function_call','custom_tool_call')]
assert not calls, 'Tool use violates clean inline-only role instruction'
raw_final=(tr/(stem+'_final.json')).read_bytes()
raw_text=''.join(x['text'] for x in final['payload']['content'] if x.get('type')=='output_text')
data=json.loads(raw_final)
assert data==json.loads(raw_text)
assert data['role']==role
if role!='blind-translation': assert data['task_id']==task
dest=out/'agent_outputs'/filename
assert not dest.exists()
dest.write_bytes(raw_final)
transport_path=tr/(stem+'_transport.json')
transport=json.loads(transport_path.read_text(encoding='utf-8'))
assert transport['exit_code']==0
inp=tr/(stem+'_input.txt')
assert hashlib.sha256(inp.read_bytes()).hexdigest()==transport['stdin_sha256']
if role=='blind-translation':
 packet=(out/'inputs/blind_review_packet.md').read_bytes()
 assert inp.read_bytes().endswith(packet)
 assert data['dossier_sha256']==hashlib.sha256(packet).hexdigest()
runtime_evidence={'agent_id':uid,'session_file':str(paths[0]),'session_meta':{'id':meta['id'],'cwd':meta.get('cwd'),'originator':meta.get('originator'),'cli_version':meta.get('cli_version'),'source':meta.get('source'),'thread_source':meta.get('thread_source'),'history_mode':meta.get('history_mode')},'turn_context':ctx,'final_timestamp':final['timestamp'],'tool_calls':len(calls),'events_sha256':hashlib.sha256(events_path.read_bytes()).hexdigest(),'stdin_sha256':transport['stdin_sha256'],'raw_final_sha256':hashlib.sha256(raw_final).hexdigest(),'transport_sha256':hashlib.sha256(transport_path.read_bytes()).hexdigest()}
runtime_path=tr/(stem+'_runtime.json')
runtime_path.write_text(json.dumps(runtime_evidence,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='')
notes='Fresh separate clean Codex CLI exec session with the same stateless role boundaries specified by the sealed methodology. Neutral cwd C:/Windows/Temp, ignore-user-config, no fork/resume or inherited history. Input assembled mechanically. Actual metadata copied from runtime session_meta/turn_context/final. Runtime evidence SHA256 '+hashlib.sha256(runtime_path.read_bytes()).hexdigest()+'. Stdin SHA256 '+transport['stdin_sha256']+'. Events SHA256 '+runtime_evidence['events_sha256']+'. Raw final SHA256 '+runtime_evidence['raw_final_sha256']+'. Tool calls '+str(len(calls))+'.'
if not ctx['payload'].get('effort'): notes+=' Reasoning effort not exposed by runtime; recorded null, not inferred.'
args=[sys.executable,'-B',r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py','.faithfulness-audit/scripts/record_agent_run.py',task,role,'--agent-id',uid,'--runtime','Codex CLI exec fresh clean session','--started-at',ctx['timestamp'],'--completed-at',final['timestamp'],'--notes',notes]
if ctx['payload'].get('model'): args+=['--model',ctx['payload']['model']]
if ctx['payload'].get('effort'): args+=['--reasoning-effort',ctx['payload']['effort']]
env=os.environ.copy()
env['FAITHFULNESS_AUDIT_CONFIG']='/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/LEV-CH01-FV-LOCAL-FLUX-UPDATE-NORM-COMPLETE-PRODUCTION-20260908.config.json'
subprocess.run(args,cwd=root,env=env,check=True)
subprocess.run([sys.executable,'-B',r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py','.faithfulness-audit/scripts/validate_agent_output.py',task,role],cwd=root,env=env,check=True)
print(json.dumps({'role':role,'agent_id':uid,'model':ctx['payload'].get('model'),'effort':ctx['payload'].get('effort'),'classification':data.get('classification'),'tool_calls':len(calls),'validated':True,'output_sha256':hashlib.sha256(raw_final).hexdigest()}))
