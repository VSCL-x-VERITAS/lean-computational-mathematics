"""Local CLI help/schema extraction only: no server, thread or model invocation."""
from pathlib import Path
import hashlib,json,subprocess,time
P=Path(__file__).resolve().parent
EXE=Path('C:/Users/qed_s/AppData/Local/OpenAI/Codex/bin/02c7a9ff819938f0/codex.exe')
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
def ref(p):return {'path':str(p),'sha256':sha(p),'bytes':p.stat().st_size}
before=ref(EXE);records=[]
commands=[('version',['--version']),('app-server-help',['app-server','--help']),
 ('exec-help',['exec','--ignore-user-config','--help']),
 ('schema-help',['app-server','generate-json-schema','--help']),
 ('debug-help',['debug','--help']),
 ('schema',['app-server','generate-json-schema','--experimental','--out',str(P/'s')])]
for label,args in commands:
 start=time.monotonic();command=[str(EXE),*args]
 with (P/(label+'-stdout.txt')).open('xb') as out,(P/(label+'-stderr.txt')).open('xb') as err:
  result=subprocess.run(command,cwd='C:/Windows/Temp',stdout=out,stderr=err)
 record={'argv':command,'cwd':'C:/Windows/Temp','exit_code':result.returncode,
  'elapsed_ms':round((time.monotonic()-start)*1000),'stdout':ref(P/(label+'-stdout.txt')),
  'stderr':ref(P/(label+'-stderr.txt'))}
 with (P/(label+'-exit.json')).open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
 records.append(record)
 print(json.dumps({'label':label,'exit_code':result.returncode}),flush=True)
 assert result.returncode==0
assert ref(EXE)==before
receipt={'schema':1,'kind':'help-and-schema-only','native_cli':before,'commands':records,
 'schema_files':[ref(p) for p in sorted((P/'s').rglob('*')) if p.is_file()],
 'model_started':False,'thread_created_or_resumed':False,'server_started':False}
with (P/'capture-receipt.json').open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps({'receipt':ref(P/'capture-receipt.json')}),flush=True)
