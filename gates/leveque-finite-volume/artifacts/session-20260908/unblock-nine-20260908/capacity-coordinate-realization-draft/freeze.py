"""Freeze native results and scoped reuse evidence only."""
from pathlib import Path
import hashlib,json,os,re,subprocess
P=Path(__file__).resolve().parent;D=P.parent;R=D.parents[4]
assert (R/'lean-toolchain').is_file()
def n(p):return '\\\\?\\'+str(p)
def raw(p):
    with open(n(p),'rb') as f:return f.read()
def ref(p):
    b=raw(p);name=p.relative_to(R).as_posix() if p.is_relative_to(R) else str(p)
    return {'path':name,'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def read(p):return json.loads(raw(p))
def put(p,obj):
    b=obj if isinstance(obj,bytes) else (json.dumps(obj,indent=2)+'\n').encode()
    with open(n(p),'xb') as f:f.write(b)
def resolve(item):
    p=Path(item['path']);return p if p.is_absolute() else R/p
attempts=[]
for label,exitcode in [('native-01',1),('native-02',0)]:
    A=P/label;resolutions=[]
    for name in ['lake-receipt.json','lean-receipt.json','receipt.json']:
        assert read(A/name)['exit_code']==exitcode
    for item in read(A/'input-pins.json')['inputs']:
        path=resolve(item)
        if label=='native-01' and path==P/'Realization.lean.fragment':
            path=A/'Realization.lean.fragment';resolutions.append({'original':item,'snapshot':ref(path)})
        assert ref(path)['sha256']==item['sha256'],str(path)
    attempts.append({'label':label,'actual_exit':exitcode,'receipt':ref(A/'receipt.json'),
                     'input_pins':ref(A/'input-pins.json'),'historical_resolutions':resolutions})
final=P/'native-02';output=raw(final/'lean-output.txt').decode('utf-8')
assert not re.search(r'\b(error|warning):',output)
reports=re.findall(r"'([^']+)' depends on axioms:\s*\[([^]]*)\]",output,re.S)
assert len(reports)==32,len(reports)
allowed={'propext','Classical.choice','Quot.sound'}
for name,axioms in reports:assert set(re.findall(r'[A-Za-z_][\w.]*',axioms))<=allowed,(name,axioms)
declarations=read(P/'declarations.json')
assert len(declarations)==20 and set(declarations)<={x[0] for x in reports}
base=D/'capacity-net-reference-error-draft/native-03/Candidate.lean'
assert ref(base)['sha256']=='f0991e78e85488c00d4a30a9ad4d3a8cc7f2bcc2a2f033319784b57ee5a5955b'
assert raw(final/'Candidate.lean').count(raw(base))==1
queries=[
 ['rg','-n','LineRealization|extract_error_le|coordinateExecution_physical_error|advance_error_le|mesh_pos',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume',
  '-g','CoordinateLine*.lean','-g','FinitePhysical*.lean','-g','RefiningLineMethod.lean'],
 ['rg','-n','execution_error_le_upto|def execution|def errorBudget',
  'ComputationalMathematics/Analysis/Normed/Group/SequentialError.lean'],
 ['rg','-n',"theorem le_sup'|theorem sup'_le_iff|theorem exists_mem_eq_sup'|def sup'",
  '.lake/packages/mathlib/Mathlib/Data/Finset/Lattice/Fold.lean'],
 ['rg','-n','theorem diam_nonneg|theorem dist_le_diam_of_mem|theorem diam_eq_zero_of_unbounded|def diam',
  '.lake/packages/mathlib/Mathlib/Topology/MetricSpace/Bounded.lean']]
searches=[]
for i,command in enumerate(queries,1):
    result=subprocess.run(command,cwd=R,capture_output=True)
    assert result.returncode in (0,1)
    put(P/f'search-{i:02}-stdout.txt',result.stdout);put(P/f'search-{i:02}-stderr.txt',result.stderr)
    searches.append({'command':command,'cwd':str(R),'actual_exit':result.returncode,
      'stdout':ref(P/f'search-{i:02}-stdout.txt'),'stderr':ref(P/f'search-{i:02}-stderr.txt')})
put(P/'search-receipts.json',searches)
selected=[]
for rel in ['.lake/packages/mathlib/Mathlib/Data/Finset/Lattice/Fold.lean',
            '.lake/packages/mathlib/Mathlib/Topology/MetricSpace/Bounded.lean']:
    selected.append(ref(R/rel))
    module=Path(rel).relative_to('.lake/packages/mathlib').with_suffix('.olean')
    selected.append(ref(R/'.lake/packages/mathlib/.lake/build/lib/lean'/module))
verification={'schema':1,'status':'PASS','source_acceptance':False,'production_modified':False,
 'attempts':attempts,'final_input':ref(final/'Candidate.lean'),'frozen_base':ref(base),
 'exact_base_containment':True,'declarations':declarations,
 'reports':[{'name':name,'axioms':re.findall(r'[A-Za-z_][\w.]*',a)} for name,a in reports],
 'mathlib_source_compiled_pins':selected,'searches':ref(P/'search-receipts.json'),
 'quality_instance_claim':False,'mesh_warning':'Metric.diam on unbounded sets is totalized; actual distance bounds require cell boundedness.'}
put(P/'verification.json',verification)
files=[]
for directory,dirs,names in os.walk(n(P)):
    assert '__pycache__' not in dirs
    for name in names:files.append(ref(Path(directory.removeprefix('\\\\?\\'))/name))
put(P/'manifest.json',{'schema':1,'files':sorted(files,key=lambda x:x['path']),
 'artifact_only':True,'source_acceptance':False})
put(P/'receipt.json',{'schema':1,'status':'PASS','actual_native_exit':0,'authored_declarations':20,
 'axiom_reports':32,'warnings':0,'manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md'),
 'verification':ref(P/'verification.json'),'final_input':ref(final/'Candidate.lean'),
 'actual_native_receipt':ref(final/'lean-receipt.json'),'source_acceptance':False,'quality_instance_claim':False})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),
 'input':ref(final/'Candidate.lean'),'verification':ref(P/'verification.json')},indent=2))
