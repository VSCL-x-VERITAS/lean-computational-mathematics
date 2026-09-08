"""Read exact pinned Git blobs and print only the selected transport inputs."""
from pathlib import Path
import hashlib,json,subprocess,sys
sys.stdout.reconfigure(encoding='utf-8')
P=Path(__file__).resolve().parent; R=P.parents[4]
B='9e2225705fed906b1120d55105d607baabef57c9'; C='c4bfd6deb756ba46184c9418edc83bda33084719'
S='gates/leveque-finite-volume/artifacts/session-20260908/'
def git(*a):return subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
def blob(ref,p):return git('show',f'{ref}:{p}')
def obj(ref,p):return json.loads(blob(ref,p))
def describe(ref,p):return {'path':p,'blob_oid':git('rev-parse',f'{ref}:{p}').decode().strip(),'sha256':hashlib.sha256(blob(ref,p)).hexdigest()}
gate='gates/leveque-finite-volume/chapter-01.json'
for ref,label in ([] if '--fingerprints' in sys.argv else [(B,'baseline'),(C,'checkpoint')]):
 g=obj(ref,gate); row=next(r for r in g['rows'] if r['id']=='LEV-CH01-EQ-1.3-ADVECTED-PROFILE')
 task=obj(ref,row['faithfulness_task']);contract='gates/leveque-finite-volume/'+row['source_contract_artifact']
 print(json.dumps({'label':label,'commit':ref,'gate':describe(ref,gate),'gate_bindings':g.get('bindings'),
  'row':row,'task':task,'source_contract':obj(ref,contract)},indent=2))
 print('TARGET_TEXT '+label+'\n'+blob(ref,task['target']['path']).decode())
for path in ['baseline-equation03-expression-fingerprints.json','chapter01-current-expression-fingerprints-3239.json']:
 f=obj(C,S+path)
 rs=[r for r in f['records'] if r['name'].startswith('NumStability.leveque01_equation03_')]
 print(json.dumps({'fingerprint':describe(C,S+path),'metadata':{k:v for k,v in f.items() if k not in ['records','files','selected_modules']},
  'files':[x for x in f['files'] if 'Equation03' in x['path']],
  'records':[{k:v for k,v in r.items() if not isinstance(v,str) or len(v)<300} for r in rs],
  'record_keys':[list(r) for r in rs]},indent=2))
