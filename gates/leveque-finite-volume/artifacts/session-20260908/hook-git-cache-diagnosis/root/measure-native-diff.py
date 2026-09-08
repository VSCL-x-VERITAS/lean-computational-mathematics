"""Reproduce the exact native finalizer Git diff and capture only file-status cache effects."""
from pathlib import Path
import hashlib,json,subprocess,time
P=Path(__file__).resolve();W=P.parents[3];R=W/'lean-computational-mathematics';D=P.parent/'native-diff-after-warm'
D.mkdir(exist_ok=False);index=R/'.git/index';probe=R/'lakefile.toml'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
stat=lambda p:{k:getattr(p.stat(),k) for k in ['st_size','st_mtime_ns','st_ctime_ns','st_ino','st_dev','st_uid','st_gid']}
before={'index_sha256':sha(index),'index_stat':stat(index),'probe_stat':stat(probe)}
(D/'before.json').write_bytes((json.dumps(before,indent=2)+'\n').encode())
cmd=['git','-c','core.longpaths=true','diff','--name-only','HEAD']
start=time.perf_counter();r=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);elapsed=time.perf_counter()-start
(D/'stdout.txt').write_bytes(r.stdout);(D/'stderr.txt').write_bytes(r.stderr)
after={'index_sha256':sha(index),'index_stat':stat(index),'probe_stat':stat(probe)}
debug=subprocess.run(['git','-c','core.longpaths=true','ls-files','--debug','--','lakefile.toml'],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);assert debug.returncode==0
(D/'index-debug-after.txt').write_bytes(debug.stdout)
(D/'after.json').write_bytes((json.dumps(after,indent=2)+'\n').encode())
rec={'kind':'exact-native-finalizer-diff-cache-effect','command':cmd,'elapsed_seconds':elapsed,'exit_code':r.returncode,'stdout_sha256':sha(D/'stdout.txt'),'stderr_sha256':sha(D/'stderr.txt'),'index_before_sha256':before['index_sha256'],'index_after_sha256':after['index_sha256'],'working_tree_diff_empty':not r.stdout,'git_config_changed':False}
(D/'receipt.json').write_bytes((json.dumps(rec,indent=2)+'\n').encode())
print(json.dumps(rec));raise SystemExit(r.returncode)
