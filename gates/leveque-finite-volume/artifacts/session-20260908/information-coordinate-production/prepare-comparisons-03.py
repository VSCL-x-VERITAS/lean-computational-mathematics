from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
body=(P/'Comparisons02.lean.fragment').read_text(encoding='utf-8')
body=body.replace('open NumStability\n','open NumStability\n\nuniverse u v w\n',1)
names=['sweepAdmitted_fallback_independent','sweep_fallback_independent','admission_at_prefix','executed_face_uses_selected_solve']
for n in names:
 for ns in ['InformationCoordinateSweepDraft','RiemannInformationCoordinate']:
  a=f'(@NumStability.{ns}.{n})';b=f'(@NumStability.{ns}.{n}.{{u, v, w}})'
  assert a in body;body=body.replace(a,b)
assert body.count('  rw [core_SweepAdmitted]')==5
body=body.replace('  rw [core_SweepAdmitted]','  rw [core_SweepAdmitted] <;> rfl')
fragment=P/'Comparisons03.lean.fragment';assert not fragment.exists();fragment.write_bytes(body.encode())
prior=(P/'Comparisons02.lean').read_bytes();old=(P/'Comparisons02.lean.fragment').read_bytes();assert prior.count(old)==1
target=P/'Comparisons03.lean';assert not target.exists();target.write_bytes(prior.replace(old,body.encode()))
plan=json.loads((P/'comparison-plan-02.json').read_bytes());plan['comparison_input']=dict(path=target.relative_to(R).as_posix(),sha256=sha(target));plan['universe_alignment']='The four fully polymorphic heterogeneous proof comparisons instantiate old/new declarations at the same explicit universe levels u,v,w. Definitional aliases are reduced after predicate transport.'
plan['prior_plan']=dict(path=(P/'comparison-plan-02.json').relative_to(R).as_posix(),sha256=sha(P/'comparison-plan-02.json'))
out=P/'comparison-plan-03.json';assert not out.exists();out.write_bytes((json.dumps(plan,indent=2)+'\n').encode())
runner=P/'run-preservation-03.py';assert not runner.exists();runner.write_bytes((P/'run-preservation.py').read_bytes().replace(b"P/'run-preservation.py'",b"P/'run-preservation-03.py'").replace(b"P/'comparison-plan-02.json'",b"P/'comparison-plan-03.json'"))
print(json.dumps(dict(input_sha256=sha(target),plan_sha256=sha(out))))
