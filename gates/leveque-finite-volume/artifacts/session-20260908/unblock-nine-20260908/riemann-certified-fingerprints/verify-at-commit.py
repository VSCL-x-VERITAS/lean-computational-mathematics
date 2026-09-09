"""Optional later read-only committed-blob verification; never changes a ref."""
from pathlib import Path
import argparse,hashlib,json,os,re,subprocess
F=Path(__file__).resolve().parent;R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name!='nt','Use the POSIX launcher.'
ap=argparse.ArgumentParser();ap.add_argument('--commit',required=True);ap.add_argument('--label',required=True);args=ap.parse_args()
assert re.fullmatch('[0-9a-f]{40}',args.commit);assert re.fullmatch('[a-zA-Z0-9_-]+',args.label)
sha=lambda b:hashlib.sha256(b).hexdigest()
receipt=json.loads((F/'fingerprint-receipt.json').read_bytes());fpref=receipt['fingerprints']
assert sha((R/fpref['path']).read_bytes())==fpref['sha256']
fp=json.loads((R/fpref['path']).read_bytes())
git=lambda *a:subprocess.check_output(['git','--no-replace-objects','-c','core.longpaths=true',*a],cwd=R)
assert git('rev-parse',args.commit+'^{commit}').decode().strip()==args.commit
ancestor=subprocess.run(['git','--no-replace-objects','merge-base','--is-ancestor',fp['input_commit'],args.commit],cwd=R)
assert ancestor.returncode==0
pins={x['path']:x['sha256'] for x in fp['files']+fp['prior_fingerprints']+[fpref,fp['input_manifest'],fp['native_receipt'],fp['native_output'],fp['native_raw_archive']]}
for old in fp['prior_fingerprints']:
 obj=json.loads((R/old['path']).read_bytes())
 for x in obj['files']:
  assert x['path'] not in pins or pins[x['path']]==x['sha256'];pins[x['path']]=x['sha256']
for p,h in pins.items():assert sha(git('show',args.commit+':'+p))==h,p
out=F/('committed-verification-'+args.label+'.json')
record=dict(status='PASS-COMMITTED-BYTES-ONLY',commit=args.commit,tree=git('rev-parse',args.commit+'^{tree}').decode().strip(),native_input_commit_preserved=fp['input_commit'],fingerprints=fpref,verified_blob_count=len(pins),source_owner_count=171,pins=[dict(path=p,sha256=h) for p,h in sorted(pins.items())],scope='Actual committed blob identity and ancestry only. No candidate, source verdict, ref change, integration admission or promotion receipt.')
with out.open('x',encoding='utf-8',newline='\n') as f:json.dump(record,f,indent=2);f.write('\n')
print(json.dumps(dict(path=out.relative_to(R).as_posix(),sha256=sha(out.read_bytes()),verified_blobs=len(pins))))
