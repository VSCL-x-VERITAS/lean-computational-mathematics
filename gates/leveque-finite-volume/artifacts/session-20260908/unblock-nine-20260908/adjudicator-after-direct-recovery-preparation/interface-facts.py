"""Read-only interface documentation/source fetch and native schema generation; no thread or turn."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess,sys,urllib.request,urllib.error
D=Path(__file__).resolve().parent;F=D/'interface-facts';F.mkdir()
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
def ref(p):return {'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size}
def create(p,b):
 with p.open('xb') as f:f.write(b)
rows=[]
for path in ['codex-rs/protocol/src/user_input.rs','codex-rs/core/src/input_validation.rs','codex-rs/app-server/src/codex_message_processor.rs']:
 url='https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v0.153.4/'+path
 try:
  with urllib.request.urlopen(url,timeout=20) as response:raw=response.read()
  p=F/path.replace('/','__');create(p,raw);rows.append({'url':url,'status':200,'file':ref(p)})
 except urllib.error.HTTPError as error:rows.append({'url':url,'status':error.code})
exe=Path('C:/Users/qed_s/AppData/Local/OpenAI/Codex/bin/02c7a9ff819938f0/codex.exe')
command=[str(exe),'app-server','generate-json-schema','--out',str(F/'schema')]
started=datetime.now(timezone.utc).isoformat()
with (F/'schema-output.txt').open('xb') as out,(F/'schema-stderr.txt').open('xb') as err:
 p=subprocess.run(command,cwd=R,stdout=out,stderr=err)
record={'command':command,'started_at_utc':started,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'exit_code':p.returncode,'stdout':ref(F/'schema-output.txt'),'stderr':ref(F/'schema-stderr.txt'),
 'executable':ref(exe),'public_tag':'rust-v0.153.4','public_source_binary_identity_proven':False,
 'fetched_sources':rows,'native_roles_invoked':False,'threads_created':False}
create(F/'receipt.json',(json.dumps(record,indent=2)+'\n').encode());print(json.dumps(record,indent=2))
