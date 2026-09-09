"""Verify actual native ghost-lemma output and freeze only this artifact folder."""
from pathlib import Path
import hashlib,json,os,re,subprocess
P=Path(__file__).resolve().parent;D=P.parent;R=D.parents[4]
def n(p):return '\\\\?\\'+str(p)
def raw(p):
    with open(n(p),'rb') as f:return f.read()
def ref(p):
    b=raw(p);return {'path':p.relative_to(R).as_posix() if p.is_relative_to(R) else str(p),
                    'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def read(p):return json.loads(raw(p))
def put(p,obj):
    b=obj if isinstance(obj,bytes) else (json.dumps(obj,indent=2)+'\n').encode()
    with open(n(p),'xb') as f:f.write(b)
def resolve(item):
    p=Path(item['path']);return p if p.is_absolute() else R/p
A=P/'native-01'
for name in ['lake-receipt.json','lean-receipt.json','receipt.json']:
    assert read(A/name)['exit_code']==0
pins=read(A/'input-pins.json')['inputs']
for item in pins:assert ref(resolve(item))['sha256']==item['sha256'],item['path']
output=raw(A/'lean-output.txt').decode('utf-8')
assert not re.search(r'\b(error|warning):',output)
reports=[{'name':name,'axioms':re.findall(r'[A-Za-z_][\w.]*',axioms)}
    for name,axioms in re.findall(r"'([^']+)' depends on axioms:\s*\[([^]]*)\]",output,re.S)]
reports += [{'name':name,'axioms':[]} for name in re.findall(r"'([^']+)' does not depend on any axioms",output)]
assert len(reports)==58,len(reports)
assert len({r['name'] for r in reports})==58
allowed={'propext','Classical.choice','Quot.sound'}
for report in reports:assert set(report['axioms'])<=allowed,report
names=read(P/'declarations.json');assert len(names)==15
assert set(names)<={r['name'] for r in reports}
base=D/'capacity-ghost-boundary-draft/native-01/Candidate.lean'
assert ref(base)['sha256']=='f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2'
assert raw(A/'Candidate.lean').count(raw(base))==1
command=['rg','-n','zero.*flux|zero.*Method|cellMean.*const|ReferenceOn.*zero|zero.*ReferenceOn|windowVariation',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume','-g','*.lean']
proc=subprocess.run(command,cwd=R,capture_output=True)
assert proc.returncode in (0,1)
put(P/'search-stdout.txt',proc.stdout);put(P/'search-stderr.txt',proc.stderr)
put(P/'search-receipt.json',{'command':command,'cwd':str(R),'actual_exit':proc.returncode,
 'stdout':ref(P/'search-stdout.txt'),'stderr':ref(P/'search-stderr.txt'),
 'scope_limit':'Only the named current finite-volume subtree; no whole-library absence claim.'})
put(P/'verification.json',{'schema':1,'status':'PASS','input_bindings':len(pins),
 'final_input':ref(A/'Candidate.lean'),'base':ref(base),'exact_base_containment':True,
 'declarations':names,'axiom_reports':reports,'actual_exit':0,'source_acceptance':False,
 'quality_or_boundary_geometry_claim':False})
files=[]
for directory,dirs,filenames in os.walk(n(P)):
    assert '__pycache__' not in dirs
    for filename in filenames:files.append(ref(Path(directory.removeprefix('\\\\?\\'))/filename))
put(P/'manifest.json',{'schema':1,'files':sorted(files,key=lambda x:x['path']),
                     'source_acceptance':False,'artifact_only':True})
put(P/'receipt.json',{'schema':1,'status':'PASS','manifest':ref(P/'manifest.json'),
 'review':ref(P/'REVIEW.md'),'verification':ref(P/'verification.json'),
 'final_input':ref(A/'Candidate.lean'),'actual_native_receipt':ref(A/'lean-receipt.json'),
 'actual_exit':0,'new_declarations':15,'axiom_reports':58,
 'empty_axiom_reports':sum(not x['axioms'] for x in reports),'warnings':0,'source_acceptance':False})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),
 'input':ref(A/'Candidate.lean'),'verification':ref(P/'verification.json')},indent=2))
