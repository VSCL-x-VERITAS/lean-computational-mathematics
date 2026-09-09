"""Freeze this artifact-only proof attempt; never changes production or gate files."""
import hashlib, json, os, re, subprocess
from pathlib import Path

R = Path(r'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
D = R / 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908'
P = D / 'capacity-net-reference-error-draft'
def native(p): return '\\\\?\\' + os.path.abspath(p)
def raw(p):
    with open(native(p), 'rb') as f: return f.read()
def ref(p):
    b = raw(p)
    try: name = Path(p).relative_to(R).as_posix()
    except ValueError: name = str(p)
    return dict(path=name, sha256=hashlib.sha256(b).hexdigest(), bytes=len(b))
def load(p): return json.loads(raw(p))
def put(p, value):
    b = value if isinstance(value, bytes) else (json.dumps(value, indent=2, ensure_ascii=False)+'\n').encode()
    with open(native(p), 'xb') as f: f.write(b)
    return ref(p)
def resolved(item):
    p=Path(item['path'])
    return p if p.is_absolute() else R/p

# Scoped, reproducible reuse searches; an exit 1 is a documented scoped miss.
queries = [
 ['rg','-n','norm_le_of_weighted_error_balance|advance_error_le|advance_error_balance|netFluxDefect|netDefectBound|cellWidth_smul_oneDimensionalCellAverage',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'],
 ['rg','-n','theorem integral_sub|theorem norm_smul|lemma norm_smul|theorem norm_sub_le|lemma norm_sub_le',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral',
  '.lake/packages/mathlib/Mathlib/Analysis/Normed'],
 ['rg','-n','theorem advance_mass_balance|theorem finite_mass_balance|def ReferenceOn|def cellMean|def cellVolume',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FinitePhysicalReferenceError.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FinitePhysicalUpdate.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FinitePhysicalGeometry.lean']
]
searches=[]
for i,command in enumerate(queries,1):
    proc=subprocess.run(command,cwd=R,capture_output=True)
    assert proc.returncode in (0,1), (command,proc.stderr)
    searches.append(dict(command=command,cwd=str(R),exit_code=proc.returncode,
      stdout=put(P/f'search-{i:02}-output.txt',proc.stdout),stderr=put(P/f'search-{i:02}-stderr.txt',proc.stderr)))
put(P/'search-receipts.json',searches)

attempts=[]
for label,expected in [('native-01',1),('native-02',0)]:
    A=P/label
    for name in ['lake-receipt.json','lean-receipt.json','receipt.json']:
        assert load(A/name)['exit_code']==expected
    assert load(A/'deps-receipt.json')['exit_code']==0
    pins=load(A/'input-pins.json')['inputs']
    resolution=[]
    for item in pins:
        p=resolved(item)
        if label=='native-01' and p==P/'NetError.lean.fragment':
            p=A/'NetError.lean.fragment'
            resolution.append({'original_ref':item,'historical_snapshot':ref(p)})
        assert ref(p)['sha256']==item['sha256'],str(p)
    attempts.append({'label':label,'receipt':ref(A/'receipt.json'),
      'lake_receipt':ref(A/'lake-receipt.json'),'lean_receipt':ref(A/'lean-receipt.json'),
      'actual_exit':expected,'input_bindings':len(pins),'historical_resolution':resolution})

final=P/'native-02'; text=raw(final/'lean-output.txt').decode('utf-8')
assert not re.search(r'\b(error|warning):',text)
reports=re.findall(r"'([^']+)' depends on axioms:\s*\[([^]]*)\]",text,re.S)
allowed={'propext','Classical.choice','Quot.sound'}
assert len(reports)==12
for name,axioms in reports:
    assert set(re.findall(r'[A-Za-z_][\w.]*',axioms))<=allowed,(name,axioms)
names=['netFluxDefect','advance_error_balance','advance_error_le_net',
       'capacity_line_error_balance','capacity_line_error_le_net','scalar_nonzero_net_example']
assert {n for n,_ in reports if n.startswith('CapacityNetReferenceError.')}=={
    'CapacityNetReferenceError.'+n for n in names}
bridge=D/'physical-capacity-line-bridge/PhysicalCapacityBridge.lean'
assert ref(bridge)['sha256']=='c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc'
assert raw(final/'Candidate.lean').count(raw(bridge))==1
assert raw(final/'Candidate.lean').endswith(raw(P/'NetError.lean.fragment'))

mathlib_sources=[]
for line in raw(P/'search-02-output.txt').decode('utf-8').splitlines():
    path=re.split(r':\d+:',line,maxsplit=1)[0]
    if path not in mathlib_sources: mathlib_sources.append(path)
mathlib_pins=[]
for path in mathlib_sources:
    p=R/path; mathlib_pins.append(ref(p))
    relative=p.relative_to(R/'.lake/packages/mathlib').with_suffix('.olean')
    compiled=R/'.lake/packages/mathlib/.lake/build/lib/lean'/relative
    if compiled.is_file(): mathlib_pins.append(ref(compiled))

verification={'schema':1,'status':'PASS','artifact_only':True,'source_acceptance':False,
  'production_modified':False,'quality_instance_claim':False,'attempts':attempts,
  'final_input':ref(final/'Candidate.lean'),'fragment':ref(P/'NetError.lean.fragment'),
  'bridge':ref(bridge),'bridge_embedded_byte_exact':True,
  'authored_declarations':['CapacityNetReferenceError.'+n for n in names],
  'axiom_reports':[{'name':n,'axioms':re.findall(r'[A-Za-z_][\w.]*',a)} for n,a in reports],
  'selected_mathlib_search_source_and_compiled_pins':mathlib_pins,
  'search_receipts':ref(P/'search-receipts.json'),
  'limits':['The scalar example is a local real-valued arithmetic/integral witness, not a separately instantiated complete PhysicalData.',
    'The generic results retain every PhysicalData.ReferenceOn hypothesis and assume s<t.',
    'Incidence compatibility is supplied; no construction for arbitrary geometry or ghost accuracy is asserted.',
    'No convergence order, timestep availability, full quality family, or source interpretation is proved.']}
put(P/'verification.json',verification)
files=[]
for directory,_,filenames in os.walk(native(P)):
    for filename in sorted(filenames):
        path=Path(directory.removeprefix('\\\\?\\'))/filename
        if filename not in {'manifest.json','receipt.json'} or path.parent!=P:
            assert '__pycache__' not in path.parts
            files.append(ref(path))
files.sort(key=lambda item:item['path'])
manifest=put(P/'manifest.json',{'schema':1,'artifact_only':True,'source_acceptance':False,'files':files})
receipt=put(P/'receipt.json',{'schema':1,'status':'PASS','artifact_only':True,'source_acceptance':False,
  'manifest':manifest,'verification':ref(P/'verification.json'),'review':ref(P/'REVIEW.md'),
  'final_input':ref(final/'Candidate.lean'),'final_native_receipt':ref(final/'lean-receipt.json'),
  'actual_exit':0,'authored_declarations':6,'axiom_reports':12,'warnings':0})
print(json.dumps({'receipt':receipt,'manifest':manifest,'verification':ref(P/'verification.json')},indent=2))
