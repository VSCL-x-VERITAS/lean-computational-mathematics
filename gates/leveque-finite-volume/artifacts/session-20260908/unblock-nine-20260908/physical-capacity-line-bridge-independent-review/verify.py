"""Read-only source/native evidence verification for the reviewed bridge."""
import hashlib,json,os,re,subprocess
from pathlib import Path
R=Path(r'\\?\C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
D=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908'
P=D/'physical-capacity-line-bridge-independent-review'
def ref(path,expected=None):
 data=path.read_bytes();item={'path':path.relative_to(R).as_posix(),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
 if expected is not None:assert item['sha256']==expected,item
 return item
def read(path):return json.loads(path.read_text(encoding='utf-8'))
def put(name,data):
 with (P/name).open('xb') as stream:stream.write((json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode())
manifest_ref=ref(D/'physical-capacity-line-bridge/manifest.json','39a08aa44e0241d08a6c85c7ae57f10ee3f88623d062906554c0d3f184dc7c62')
manifest=read(R/manifest_ref['path']);pins=[manifest_ref]
for key in ['source','native','native_output','failed_source','failed_native','reuse','review']:
 value=manifest[key];pins.append(ref(R/value['path'],value['sha256']))
actual_input=ref(D/'PhysicalCapacityBridge.lean',manifest['source']['sha256'])
pins.append(actual_input)
native=read(R/manifest['native']['path']);assert native['exit_code']==0
assert native['output_sha256']==manifest['native_output']['sha256']
assert native['argv'][-1].replace('\\','/').endswith('/unblock-nine-20260908/PhysicalCapacityBridge.lean')
output=(R/manifest['native_output']['path']).read_text(encoding='utf-8')
found=re.findall(r"'([^']+)'\s+(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)",output)
assert [name for name,_ in found]==manifest['theorems']
reports=[]
for name,axioms in found:
 values=[x.strip() for x in axioms.split(',') if x.strip()]
 assert set(values)<={'propext','Classical.choice','Quot.sound'}
 reports.append({'name':name,'axioms':values})
assert not re.search(r'\b(?:error|warning):',output)
reuse=read(R/manifest['reuse']['path'])
for value in reuse['observed_source_owners']:pins.append(ref(R/value['path'],value['sha256']))
for path in ['ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FinitePhysicalReferenceError.lean',
             'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RefiningLineMethod.lean',
             'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalCellErrorBounds.lean']:
 pins.append(ref(R/path))
queries=[
 ['rg','-n','cellVolume_smul_finiteVolumeCellAverageUpdate|finite_mass_balance|norm_le_of_weighted_error_balance|theorem advance_error_le',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'],
 ['rg','-n','theorem norm_sub_le|theorem norm_smul|norm_smul_le',
  '.lake/packages/mathlib/Mathlib/Analysis/Normed/Module/Basic.lean',
  '.lake/packages/mathlib/Mathlib/Analysis/Normed/Group/Basic.lean']]
searches=[]
for number,argv in enumerate(queries,1):
 result=subprocess.run(argv,cwd=str(R).removeprefix('\\\\?\\'),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert result.returncode in (0,1)
 for suffix,data in [('output',result.stdout),('stderr',result.stderr)]:
  with (P/f'search-{number:02}-{suffix}.txt').open('xb') as stream:stream.write(data)
 searches.append({'command':argv,'exit_code':result.returncode,'stdout':ref(P/f'search-{number:02}-output.txt'),
                  'stderr':ref(P/f'search-{number:02}-stderr.txt')})
put('verification.json',{'schema':1,'status':'PASS_SCOPED_BINDING_REVIEW','source_acceptance':False,
 'manifest':manifest_ref,'verified_inputs':pins,'actual_native_exit':native['exit_code'],'axiom_reports':reports,
 'source_runtime_limit':'The original native receipt records the input path, exit and output SHA, but no input-source SHA. The current command-path bytes and frozen manifest copy agree exactly; this is not a newly rerun Lean check or a reconstructed pre-execution input pin.',
 'searches':searches,'search_limit':'Specific current project and pinned Mathlib searches only; no exhaustive semantic absence claim.'})
print(json.dumps({'status':'PASS_SCOPED_BINDING_REVIEW','native_exit':0,'axiom_reports':len(reports),'bound_inputs':len(pins)}))
