"""Only CLI parser/help checks; no execution of app-server or debug operations."""
from pathlib import Path
import hashlib,json,subprocess,time
P=Path(__file__).resolve().parent
exe=Path('C:/Users/qed_s/AppData/Local/OpenAI/Codex/bin/02c7a9ff819938f0/codex.exe')
def ref(p):return {'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
results=[]
for label,args,success in [
 ('app-server-ignore-rejection',['app-server','--ignore-user-config','--help'],False),
 ('debug-send-help',['debug','app-server','send-message-v2','--help'],True),
 ('mcp-server-help',['mcp-server','--help'],True)]:
 command=[str(exe),*args];start=time.monotonic()
 with (P/(label+'-stdout.txt')).open('xb') as out,(P/(label+'-stderr.txt')).open('xb') as err:
  r=subprocess.run(command,cwd='C:/Windows/Temp',stdout=out,stderr=err)
 row={'argv':command,'cwd':'C:/Windows/Temp','exit_code':r.returncode,'elapsed_ms':round((time.monotonic()-start)*1000),
 'stdout':ref(P/(label+'-stdout.txt')),'stderr':ref(P/(label+'-stderr.txt')),'expected_success':success}
 with (P/(label+'-exit.json')).open('xb') as f:f.write((json.dumps(row,indent=2)+'\n').encode())
 results.append(row);assert (r.returncode==0)==success
with (P/'boundary-receipt.json').open('xb') as f:f.write((json.dumps({'schema':1,'commands':results,'no_server_thread_or_model_started':True},indent=2)+'\n').encode())
print(json.dumps({'receipt':ref(P/'boundary-receipt.json')}))
