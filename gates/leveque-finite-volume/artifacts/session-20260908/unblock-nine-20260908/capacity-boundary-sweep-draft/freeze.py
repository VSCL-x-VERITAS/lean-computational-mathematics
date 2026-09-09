"""Freeze successful dependent-coordinate sweep and actual old-API rejection."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
D=P.parent
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
def ref(p):
 b=p.read_bytes()
 try: name=p.relative_to(R).as_posix()
 except ValueError: name=str(p)
 return {'path':name,'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def put(p,x):
 b=x if isinstance(x,bytes) else (json.dumps(x,indent=2,ensure_ascii=False)+'\n').encode()
 with p.open('xb') as f:f.write(b)
 return ref(p)
assert not (P/'manifest.json').exists() and not (P/'receipt.json').exists()
basis=D/'capacity-ghost-boundary-draft/native-01/Candidate.lean'
assert ref(basis)['sha256']=='f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2'
assert basis.read_bytes()==(P/'Basis.lean.snapshot').read_bytes()
der=json.loads((P/'derivation.json').read_text())
assert der['binder_replacements']==5
assert hashlib.sha256(der['old_segment'].encode()).hexdigest()==der['old_fixed_coordinate_segment_sha256']
replacement=der['old_segment'].replace('(method : ℕ → Method data coord)',der['replacement'])
assert replacement in (P/'Sweep.lean.fragment').read_text(encoding='utf-8')
assert ref(P/'Sweep.lean.fragment')==der['generated_fragment']
allowed={'propext','Classical.choice','Quot.sound'}
attempts=[]
for name,expected in [('native-01',0),('rejection-01',1)]:
 A=P/name
 receipt=json.loads((A/'receipt.json').read_text())
 assert receipt['exit_code']==expected and receipt['inputs_unchanged'] and receipt['canonical_imports']
 assert receipt['expected_rejection']==bool(expected)
 for label in ('lake','deps','lean'):
  r=json.loads((A/(label+'-receipt.json')).read_text())
  assert r['exit_code']==(0 if label=='deps' else expected)
  for field in ('stdout','stderr'):
   rr=ref(Path(r[field]['path']));assert rr['sha256']==r[field]['sha256'] and rr['bytes']==r[field]['bytes']
  assert Path(r['stderr']['path']).read_bytes()==b''
 pins=json.loads((A/'input-pins.json').read_text())['inputs']
 for item in pins:assert ref(Path(item['path']))['sha256']==item['sha256']
 assert (A/'Candidate.lean').read_bytes().startswith(basis.read_bytes()+b'\n')
 output=(A/'lean-output.txt').read_bytes()
 if expected==0:
  assert b'error:' not in output and b'warning:' not in output and b'sorryAx' not in output
  reports=re.findall(rb"'([^']+)' depends on axioms: \[([^\]]*)\]",output)
  assert len(reports)==55
  for _,axioms in reports:assert {x.strip().decode() for x in axioms.split(b',')}<=allowed
  names=[n.decode() for n,_ in reports if n.startswith(b'CapacityBoundarySweep.')]
  assert len(names)==12
  start=output.index(b'CapacityBoundarySweep.step.')
  snippet=put(P/'new-declarations.txt',output[start:])
  statement_span={'source':ref(A/'lean-output.txt'),'byte_offset':start,'byte_length':len(output)-start,'copy':snippet}
 else:
  assert output.count(b'error:')==1 and b'error: Type mismatch' in output
  assert b'(method k).withGhost (ghost k)' in output
  assert b'Method data (base.withGhost (ghost k))' in output
  assert b'but is expected to have type' in output
 attempts.append({'name':name,'actual_exit_code':expected,'input_pin_count':len(pins),
  'files':[ref(p) for p in sorted(A.iterdir()) if p.is_file()]})
search_paths=[basis,R/'ComputationalMathematics/Analysis/Normed/Group/SequentialError.lean',
 R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FinitePhysicalUpdate.lean']
cmd=['rg','-n','noncomputable def step|noncomputable def run|theorem run_physical_error|def withGhost|theorem advance_withGhost_eq|execution_error_le_upto|def errorBudget|theorem finite_mass_balance']+[str(p) for p in search_paths]
r=subprocess.run(cmd,cwd=R,capture_output=True)
assert r.returncode==0 and not r.stderr
put(P/'search-output.txt',r.stdout)
put(P/'search-receipt.json',{'command':cmd,'exit_code':r.returncode,'stdout':ref(P/'search-output.txt'),
 'inputs':[ref(p) for p in search_paths]})
put(P/'declarations.json',{'declarations':names,'new_authored_count':12,'new_theorems':10,'new_definitions':2,
 'statement_span':statement_span})
inputs=[ref(D/'capacity-ghost-boundary-draft'/n) for n in ('manifest.json','receipt.json','native-01/Candidate.lean')]
inputs += [ref(p) for p in search_paths[1:]]
files=[ref(p) for p in sorted(P.iterdir()) if p.is_file() and p.name not in ('manifest.json','receipt.json')]
m=put(P/'manifest.json',{'schema_version':1,'purpose':'Stage-dependent coordinate execution on unchanged PhysicalData',
 'files':files,'external_inputs':inputs,'native_attempts':attempts,'new_declarations':names,
 'proof_bodies_of_five_generalized_declarations_unchanged':True,
 'source_judgment':False,'production_changes':False})
receipt=put(P/'receipt.json',{'schema_version':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'manifest':m,'actual_native_exit':0,'actual_expected_rejection_exit':1,'new_axiom_reports':12,
 'all_axiom_reports':55,'allowed_axioms':sorted(allowed),'warnings':0,
 'old_inputs_preserved':True,'source_judgment':False,'production_changes':False})
print(json.dumps({'manifest':m,'receipt':receipt,'sweep':ref(P/'Sweep.lean.fragment'),
 'stage_laws':ref(P/'StageLaws.lean.fragment'),'compiled_input':ref(P/'native-01/Candidate.lean'),
 'native_output':ref(P/'native-01/lean-output.txt'),'statements':ref(P/'new-declarations.txt')},indent=2))
