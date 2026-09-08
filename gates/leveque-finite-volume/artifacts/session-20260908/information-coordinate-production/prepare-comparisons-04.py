from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
body=(P/'Comparisons03.lean.fragment').read_text(encoding='utf-8')
assert body.count('  rw [core_SweepAdmitted] <;> rfl')==5
body=body.replace('  rw [core_SweepAdmitted] <;> rfl','  rw [core_SweepAdmitted]',1)
body=body.replace('  rw [core_SweepAdmitted] <;> rfl','  rw [core_SweepAdmitted]\n  rfl')
fragment=P/'Comparisons04.lean.fragment';assert not fragment.exists();fragment.write_bytes(body.encode())
prior=(P/'Comparisons03.lean').read_bytes();old=(P/'Comparisons03.lean.fragment').read_bytes();assert prior.count(old)==1
target=P/'Comparisons04.lean';assert not target.exists();target.write_bytes(prior.replace(old,body.encode()))
plan=json.loads((P/'comparison-plan-03.json').read_bytes());plan['comparison_input']=dict(path=target.relative_to(R).as_posix(),sha256=sha(target));plan['warning_cleanup']='Remove one unreachable rfl and use ordinary tactic sequencing on the remaining four transport equalities; no comparison type or production source changes.'
plan['prior_plan']=dict(path=(P/'comparison-plan-03.json').relative_to(R).as_posix(),sha256=sha(P/'comparison-plan-03.json'))
out=P/'comparison-plan-04.json';assert not out.exists();out.write_bytes((json.dumps(plan,indent=2)+'\n').encode())
runner=P/'run-preservation-04.py';assert not runner.exists();runner.write_bytes((P/'run-preservation-03.py').read_bytes().replace(b"P/'run-preservation-03.py'",b"P/'run-preservation-04.py'").replace(b"P/'comparison-plan-03.json'",b"P/'comparison-plan-04.json'"))
print(json.dumps(dict(input_sha256=sha(target),plan_sha256=sha(out))))
