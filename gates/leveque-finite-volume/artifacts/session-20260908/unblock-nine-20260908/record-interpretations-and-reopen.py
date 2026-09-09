"""Record coordinator choices authorized by the explicit goal, then resume all nine rows."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess,sys
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];W=R.parent
assert os.name!='nt'
sha=lambda b:hashlib.sha256(b).hexdigest()
goal=json.loads((D/'goal-observation.json').read_bytes())['goal']
assert goal['objective']=='I want you to unblock all nine of them.' and goal['status']=='active'
G=R/'gates/leveque-finite-volume/chapter-01.json';before=G.read_bytes();g=json.loads(before)
assert sha(before)=='e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0'
specs=[
 ('Q3',['ACOUSTICS-LEFT-MODE'],'For positive physical material parameters, retain the actual acoustic left invariant at speed -c. For arbitrary real profiles distinguish geometric translation, classical solutionhood for differentiable profiles, and rectangle conservation for locally integrable profiles. Preserve the printed w2/q2 symbol switch.'),
 ('Q4',['EIGENVALUES-WAVE-SPEEDS'],'Use the global jointly differentiable classical solution class for a real constant system with a complete real eigenbasis; retain all component waves, their eigenvalue speeds, and propagation/reconstruction.'),
 ('Q5',['MATERIAL-INTERFACE-RIEMANN-DATA'],'Use distinct one-sided local material traces at the same interface as distinct initial-state traces. Retain two constant strict-half-line initial states without requiring the material itself to be globally constant on each half-line.'),
 ('Q6',['NONCONSERVATION-SOURCE-TERMS'],'Use signed locally integrable production densities and finite interval mass/face-flux integrals. Retain rectangle balance and the previously adopted almost-everywhere mass-rate identity for each fixed spatial interval. General singular production measures are outside this selected convention.'),
 ('Q7',['FINITE-VOLUME-FLUX-UPDATE','RIEMANN-INTERFACE-FLUX'],'Interpret qualitative accuracy by explicit independent old-cell-average and time-averaged physical face-flux error bounds yielding a next-step error bound. Allow information-only exact or approximate Riemann routines; impose no compulsory complete returned field. Do not infer an unconditional accuracy theorem or a tolerance, norm/order chosen by the book.'),
 ('Q8',['HETEROGENEOUS-CELL-AVERAGING'],'Select normalized integration over each physical cell volume, with the relevant integrability and positive finite volume conditions. Preserve the possibility of other model-dependent averaging rules. Heterogeneous inputs need not yield unequal cell averages.'),
 ('Q9',['RIEMANN-INITIAL-VALUE-DEFINITION'],'Use positive-dimensional first-order hyperbolic governing-equation/problem-data classification, explicitly linking the equation and principal matrix. Include the equal-state degenerate case and preserve unspecified interface value. Do not assert existence of a solution.'),
 ('Q10',['DIMENSIONAL-SPLITTING'],'Represent the selected logical grid by coordinate connectivity, supplied physical cell volumes and shared normal face fluxes, and successive conservative coordinate-line updates. Retain a measured Cartesian specialization. This is an explicit geometry convention and does not claim the book supplies a chart or Jacobian definition.')]
choices=[{'choice_id':q,'rows':['LEV-CH01-'+x for x in rows],'selected_interpretation':t} for q,rows,t in specs]
blocked={x['id'] for x in g['rows'] if x['status']=='HARD_BLOCKED'}
assert blocked=={x for c in choices for x in c['rows']} and len(blocked)==9
record={'format':'coordinator-selected-source-interpretations-1','recorded_at_utc':datetime.now(timezone.utc).isoformat(),'authority':'The user explicitly requested that all nine remaining rows be unblocked. The coordinator selects the documented conventions within that requested scope. This is not a verbatim user answer selecting each detailed convention.','exact_user_objective':goal['objective'],'goal_observation_sha256':sha((D/'goal-observation.json').read_bytes()),'source_sha256':g['source_unit_sha256'],'prior_gate_sha256':sha(before),'choices':choices,'preservation':['Original PDF bytes, printed wording and ambiguities remain unchanged.','Prior source-only extractions and rejected/undetermined audits remain historical evidence.','Any acceptance must explicitly be qualified by the selected interpretation, never attributed to an explicit printed hypothesis.','Source extraction remains blind to these choices; target translation remains blind to source and choice identity.','Selection authorizes fresh target preparation, proof work and independent audits; it does not prescribe an audit verdict or certify any row complete.']}
def create(p,data):
 with p.open('xb') as f:f.write(data);f.flush();os.fsync(f.fileno())
create(D/'selected-interpretations.json',(json.dumps(record,indent=2)+'\n').encode())
create(D/'prior-blocked-gate.json',before)
byrow={rid:c for c in choices for rid in c['rows']}
for row in g['rows']:
 if row['id'] not in blocked:continue
 for key in ('blocker_kind','obstruction','attempted_routes','blocking_evidence','resume_condition'):row.pop(key,None)
 row.update(status='IN_PROGRESS',current_target='Prepare the full source-facing statement under '+byrow[row['id']]['choice_id']+' and complete fresh independent statement/proof validation.',next_action='Use selected-interpretations.json, verify existing canonical producers, assemble only necessary source wrappers, then run fresh source/blind/direct/round-trip and triggered adjudication. Preserve all source ambiguity and historical audits.')
g['chapter_gate']='ACTIVE'
candidate=D/'active-gate-candidate.json';create(candidate,(json.dumps(g,indent=2,ensure_ascii=False)+'\n').encode())
# Validation uses the canonical gate path so its repository-relative context remains exact.
tmp=G.with_name('chapter-01-unblock-nine.tmp');create(tmp,candidate.read_bytes());assert G.read_bytes()==before;os.replace(tmp,G)
command=[sys.executable,str(W/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'),'check',str(G),'--unit','1','--mode','default']
p=subprocess.run(command,capture_output=True)
create(D/'reopened-gate-output.txt',p.stdout+p.stderr)
result={'command':command,'exit_code':p.returncode,'prior_gate_sha256':sha(before),'active_gate_sha256':sha(G.read_bytes()),'output_sha256':sha(p.stdout+p.stderr),'reopened_row_ids':sorted(blocked),'selected_interpretations_sha256':sha((D/'selected-interpretations.json').read_bytes())}
create(D/'reopened-gate-receipt.json',(json.dumps(result,indent=2)+'\n').encode())
print((p.stdout+p.stderr).decode());print(json.dumps(result));raise SystemExit(p.returncode)
