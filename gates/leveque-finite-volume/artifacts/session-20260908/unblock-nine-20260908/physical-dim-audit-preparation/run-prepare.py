from pathlib import Path
import datetime,hashlib,json,subprocess,sys
P=Path(__file__).resolve().parent
tag=sys.argv[1]
out=P/(tag+'-prepare-output.txt');err=P/(tag+'-prepare-stderr.txt');receipt=P/(tag+'-prepare-receipt.json')
assert not out.exists() and not err.exists() and not receipt.exists()
now=lambda:datetime.datetime.now(datetime.timezone.utc).isoformat()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
cmd=[sys.executable,'-X','utf8','-B',str(P/'prepare-probes.py'),tag]
start=now();result=subprocess.run(cmd,cwd=P,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out.write_bytes(result.stdout);err.write_bytes(result.stderr)
receipt.write_text(json.dumps({'command':cmd,'started_at_utc':start,'finished_at_utc':now(),
 'actual_exit_code':result.returncode,'generator_sha256':sha(P/'prepare-probes.py'),
 'output_sha256':sha(out),'stderr_sha256':sha(err)},indent=2)+'\n',encoding='utf-8')
print(result.stdout.decode(errors='replace'));print(result.stderr.decode(errors='replace'))
raise SystemExit(result.returncode)
