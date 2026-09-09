"""Native export with source/olean/tool pins and actual POSIX HEAD identity."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,shutil,subprocess,sys,time
F=Path(__file__).resolve().parent;R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name=='nt'
xp=lambda p:Path('\\\\?\\'+str(p)) if not str(p).startswith('\\\\?\\') else p
raw=lambda p:xp(p).read_bytes()
sha=lambda p:hashlib.sha256(raw(p)).hexdigest()
launcher=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
data=raw(F/'inputs.json');inputs=json.loads(data)
assert hashlib.sha256(data).hexdigest()=='6fa0a8a7f6a0a090023c2e2fb417fdcbae3e9ed60f136b2f812e198eae5ccede'
def identity(label):
 argv=[sys.executable,'-B',str(launcher),str(F/'head.py')]
 p=subprocess.run(argv,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 with xp(F/(label+'-head-output.json')).open('xb') as f:f.write(p.stdout)
 with xp(F/(label+'-head-stderr.txt')).open('xb') as f:f.write(p.stderr)
 assert p.returncode==0,p.stderr
 return json.loads(p.stdout),dict(command=argv,actual_exit_code=p.returncode,stdout_sha256=hashlib.sha256(p.stdout).hexdigest(),stderr_sha256=hashlib.sha256(p.stderr).hexdigest())
before,before_receipt=identity('before')
assert before=={'head':inputs['input_commit'],'tree':inputs['input_commit_tree']}
pins=inputs['files']+inputs['lean_environment']+inputs['prior_owners']+inputs['prior_fingerprints']+inputs['input_manifests']
for item in pins:assert sha(R/item['path'])==item['sha256'],item['path']
assert sha(R/inputs['exporter_path'])==inputs['exporter_sha256']
lake=shutil.which('lake');assert lake
toolchain=raw(R/'lean-toolchain').decode().strip().replace('/','--').replace(':','---')
lean=Path(os.environ['USERPROFILE'])/'.elan/toolchains'/toolchain/'bin/lean.exe';assert lean.is_file(),lean
tools=[dict(path=str(p),sha256=sha(p)) for p in (Path(lake),lean,Path(sys.executable),launcher)]
out=F/'native-output.txt';receipt=F/'native-exit.json'
assert not xp(out).exists() and not xp(receipt).exists() and not xp(R/inputs['raw_stream_path']).exists()
argv=[lake,'env','lean',inputs['exporter_path']]
start=datetime.now(timezone.utc).isoformat();timer=time.monotonic()
with xp(out).open('xb') as f:p=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
elapsed=round((time.monotonic()-timer)*1000);after,after_receipt=identity('after')
unchanged=before==after and raw(F/'inputs.json')==data and all(sha(R/x['path'])==x['sha256'] for x in pins) and all(sha(Path(x['path']))==x['sha256'] for x in tools) and sha(R/inputs['exporter_path'])==inputs['exporter_sha256']
record=dict(schema=1,command='lake env lean '+inputs['exporter_path'],argv=['lake','env','lean',inputs['exporter_path']],native_argv=argv,exit_code=p.returncode,started_at_utc=start,completed_at_utc=datetime.now(timezone.utc).isoformat(),elapsed_ms=elapsed,output_sha256=sha(out),input_commit=before['head'],input_commit_tree=before['tree'],identity_after=after,input_manifest_sha256=hashlib.sha256(data).hexdigest(),input_bytes_and_head_unchanged=unchanged,tools=tools,posix_before=before_receipt,posix_after=after_receipt,native_git_invoked=False,runner_sha256=sha(Path(__file__)),head_script_sha256=sha(F/'head.py'))
with xp(receipt).open('x',encoding='utf-8',newline='\n') as f:json.dump(record,f,indent=2);f.write('\n')
print(json.dumps(record));print(raw(out).decode('utf-8'))
assert unchanged,'Input source, compiled owner, tool or HEAD changed'
raise SystemExit(p.returncode)
