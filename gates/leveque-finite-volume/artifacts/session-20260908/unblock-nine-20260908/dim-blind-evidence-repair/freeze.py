from pathlib import Path
import datetime,hashlib,json,subprocess,sys
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def ref(p):
 b=p.read_bytes();return {'path':p.relative_to(r).as_posix(),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def write(p,v):
 if p.exists():raise RuntimeError('Refusing overwrite')
 p.write_text(json.dumps(v,indent=2)+'\n',encoding='utf-8')
out=h/'final-validation-output.txt';receipt=h/'final-validation-receipt.json'
for p in [out,receipt,h/'manifest.json',h/'final-receipt.json']:
 if p.exists():raise SystemExit('Refusing overwrite')
script=h/'validate_final.py';launcher=r.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
cmd=[sys.executable,'-X','utf8','-B',str(launcher),'/c/'+script.as_posix()[3:]]
started=now();result=subprocess.run(cmd,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);finished=now()
out.write_bytes(result.stdout)
write(receipt,{'command':cmd,'cwd':str(r),'started_at_utc':started,'finished_at_utc':finished,
 'actual_exit_code':result.returncode,'script':ref(script),'output':ref(out),
 'runtime':'Windows Python through reviewed POSIX launcher for all released Python parsing/rendering.'})
if result.returncode:
 print(result.stdout.decode('utf-8',errors='replace'));raise SystemExit(result.returncode)
files=[ref(p) for p in sorted(h.rglob('*')) if p.is_file()]
write(h/'manifest.json',{'format':'artifact-only-blind-definition-repair-manifest-1','created_at_utc':now(),
 'files':files,'source_acceptance':False,'no_production_edits':True,'no_audit_roles_launched':True})
write(h/'final-receipt.json',{'format':'artifact-only-blind-definition-repair-receipt-1','created_at_utc':now(),
 'status':'FROZEN REVIEW PROPOSAL; actual final validation exit 0','manifest':ref(h/'manifest.json'),
 'validation':ref(receipt),'review':ref(h/'REVIEW.md'),'five_owner_map':ref(h/'five-owner-proposal.json'),
 'guards':ref(h/'guard-results.json'),'native_two_owner_receipt':ref(h/'primary-two-owner-04-receipt.json'),
 'native_rate_defeq_receipt':ref(h/'native-01-receipt.json'),
 'publication_exclusions':[ref(h/'Probe.olean')],
 'remaining':'Root-controlled five-owner repair, complete build/FP/organization refresh, fresh sealed task/config preparation and new independent judgments. Existing audit remains unchanged.'})
print(result.stdout.decode('utf-8'))
print(json.dumps({'receipt':ref(h/'final-receipt.json'),'manifest':ref(h/'manifest.json'),'proposal':ref(h/'five-owner-proposal.json')},indent=2))
