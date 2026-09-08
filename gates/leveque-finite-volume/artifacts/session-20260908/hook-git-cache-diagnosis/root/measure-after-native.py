"""Measure the unchanged gate and file-stat cache without altering Git configuration."""
from pathlib import Path
import hashlib,json,os,subprocess,sys,time
P=Path(__file__).resolve();W=P.parents[3];R=W/'lean-computational-mathematics';D=P.parent/'after-native-diff'
assert os.name!='nt';D.mkdir(exist_ok=False)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
index=R/'.git/index';probe=R/'lakefile.toml';assert index.is_file() and probe.is_file()
stat=lambda p:{k:getattr(p.stat(),k) for k in ['st_size','st_mtime_ns','st_ctime_ns','st_ino','st_dev','st_uid','st_gid']}
start_index=sha(index)
debug=subprocess.run(['git','-C',str(R),'ls-files','--debug','--','lakefile.toml'],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
assert debug.returncode==0
(D/'index-debug-before.txt').write_bytes(debug.stdout)
before={'index_sha256':start_index,'index_stat':stat(index),'probe_stat':stat(probe),'runtime':sys.executable,'index_debug_sha256':sha(D/'index-debug-before.txt')}
(D/'before.json').write_text(json.dumps(before,indent=2)+'\n')
env=os.environ.copy();env['GIT_TRACE2_EVENT']=str(D/'git-trace.jsonl')
cmd=[sys.executable,str(W/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'),'check',str(R/'gates/leveque-finite-volume/chapter-01.json'),'--unit','1','--mode','default']
start=time.perf_counter();run=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE,env=env);elapsed=time.perf_counter()-start
(D/'stdout.txt').write_bytes(run.stdout);(D/'stderr.txt').write_bytes(run.stderr)
after={'index_sha256':sha(index),'index_stat':stat(index),'probe_stat':stat(probe)}
(D/'after.json').write_text(json.dumps(after,indent=2)+'\n')
rec={'kind':'unchanged-gate-index-cache-measurement','label':'after-native-diff','command':cmd,'elapsed_seconds':elapsed,'exit_code':run.returncode,'stdout_sha256':sha(D/'stdout.txt'),'stderr_sha256':sha(D/'stderr.txt'),'index_before_sha256':start_index,'index_after_sha256':sha(index),'git_trace_sha256':sha(D/'git-trace.jsonl'),'git_configuration_changed':False}
(D/'receipt.json').write_text(json.dumps(rec,indent=2)+'\n')
print(json.dumps(rec));raise SystemExit(run.returncode)
