"""Freeze native nonvacuity and independently adjudicated stronger decisions.

This preparation does not accept an audit, write a gate, or manufacture a role.
"""
from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_bytes())
def rel(p):return p.relative_to(R).as_posix()
def bind(p):return {'path':rel(p),'sha256':sha(p)}
def write(p,v):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(v,indent=2)+'\n')
check=S/'stronger-production-witnesses-v2.lean'
log=S/'stronger-production-witnesses-v2-output.txt'
exitpath=S/'stronger-production-witnesses-v2-exit.json'
receipt=read(exitpath)
assert receipt['exit_code']==0 and type(receipt['exit_code']) is int
assert receipt['command']=='lake env lean '+rel(check)
assert receipt['output_sha256']==sha(log)
assert not re.search(r'\b(?:error|warning):|sorryAx',log.read_text(encoding='utf-8-sig'))
queries=[
 ['rg','-n','leveque01_scalarEquation_isHyperbolic|linearRiemannSolution_isRectangleSolution|shockState_initial_smooth|shockState_jump_traces|shockState_isRectangleConservationLawSolution','ComputationalMathematics','-g','*.lean'],
 ['rg','-n','shockState|linearRiemannSolution|IsRealHyperbolicMatrix',' .lake/packages/mathlib/Mathlib'.strip(),'-g','*.lean'],
]
searches=[]
for i,cmd in enumerate(queries,1):
 result=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert result.returncode in (0,1)
 out=S/f'stronger-production-search-{i}-output.txt';err=S/f'stronger-production-search-{i}-stderr.txt'
 with out.open('xb') as f:f.write(result.stdout)
 with err.open('xb') as f:f.write(result.stderr)
 assert not result.stderr
 searches.append({'argv':cmd,'exit_code':result.returncode,'stdout':bind(out),'stderr':bind(err)})
items=[
 ('LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION','LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908','d1725ddbd6c0f2013969af9fc50529a4cf50552002d9e1fb5bb285cdcb068edb','NumStability.Chapter01Evidence.linearRiemann_nonvacuous_instance','The coefficient is the one-by-one matrix with speed 1; its established scalar eigenbasis theorem discharges the only premise. Initial states 0 and 1 differ, and the freely selected origin state is 3. The full conclusion includes rectangle conservation for every real time interval and a selected spectral representative. No source case is lost.'),
 ('LEV-CH01-NONLINEAR-SHOCK-FORMATION','LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908','44edb527ee90075daac4ed1ce93e91388f2e064838757954678fe04fbdee0648','NumStability.Chapter01Evidence.huberShock_nonvacuous_instance','The explicit Huber flux and shockState jointly satisfy nonaffinity, C1 flux regularity, rectangle conservation on all real temporal intervals, smooth initial data, continuity before time 1, and left/right traces 1 and -1 at time 1. These are compatible witness properties with no additional antecedent; the jump size is 2. No equivalence with an everywhere classical mass derivative or entropy uniqueness is claimed.'),
]
files=[];pins=[]
for row,taskid,decision_sha,witness,scope in items:
 taskpath=S/'audits'/taskid/'audit-task.json';task=read(taskpath);out=R/task['audit_output'];decision=read(out/'decision.json')
 assert sha(out/'decision.json')==decision_sha
 assert decision['accepted'] is True and decision['adjudicated'] is True
 assert decision['classification']=='faithful-stronger'
 assert [decision['implications'][d]['verdict'] for d in ('lean_implies_source','source_implies_lean')]==['yes','no']
 target=R/task['target']['path'];manifest=read(out/'manifest.json')
 assert manifest['target']['sha256']==sha(target)
 files.append({**bind(target),'declarations':[task['target']['declaration']]})
 evidence={'schema':1,'row':row,'task_id':taskid,'classification':'faithful-stronger',
  'task':bind(taskpath),'manifest':bind(out/'manifest.json'),'decision':bind(out/'decision.json'),
  'target':task['target'],'target_sha256':sha(target),
  'applicability_audit':decision['implications']['lean_implies_source']['reasoning'],
  'genuine_strengthening':decision['implications']['source_implies_lean']['reasoning'],
  'remaining_source_uncertainties':decision['remaining_uncertainties'],
  'formal_nonvacuity_declaration':witness,'formal_nonvacuity_scope':scope,
  'native_check':bind(check),'native_output':bind(log),'native_exit':bind(exitpath),
  'native_receipt':receipt,'reuse_searches':searches,
  'reuse_review':'Selected current scalar hyperbolicity, spectral rectangle conservation, and explicit Huber initial/continuity/conservation/jump producers. These match the needed instances and are reused; no duplicate PDE proofs were authored. The scoped Mathlib name search is not a claim of global semantic absence.',
  'semantic_evidence_scope':'The independent sealed decision supplies source faithfulness; the actual native instance check only verifies applicability and nonvacuity of the stated extra properties.'}
 path=S/(row.lower()+'-strengthening-evidence.json');write(path,evidence)
 pins.append({'row':row,'task_id':taskid,'target':task['target'],'evidence':bind(path),'manifest_sha256':sha(out/'manifest.json'),'decision_sha256':decision_sha})
proof=S/'stronger-production-proof-inputs.json'
write(proof,{'schema':1,'input_commit':receipt['input_commit'],'files':files,'check_file':rel(check),'check_file_sha256':sha(check),'scope':'Native declaration and explicit instance checks; semantic judgment remains the separate sealed audit.'})
pinpath=S/'stronger-production-binding-pins.json'
write(pinpath,{'schema':1,'rows':pins,'proof_manifest':bind(proof),'native_check':bind(check),'native_output':bind(log),'native_exit':bind(exitpath)})
print(json.dumps({'pins':bind(pinpath),'proof_manifest':bind(proof),'rows':pins}))
