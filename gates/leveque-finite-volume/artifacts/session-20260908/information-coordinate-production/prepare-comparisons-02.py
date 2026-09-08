from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
plan=json.loads((P/'placement-map.json').read_bytes())
prior=json.loads((P/'comparison-plan.json').read_bytes())
body=(P/'Comparisons.lean.fragment').read_text(encoding='utf-8')
old='NumStability.InformationCoordinateSweepDraft';new='NumStability.RiemannInformationCoordinate'
line=f'theorem core_SweepAdmitted : @{old}.SweepAdmitted = @{new}.SweepAdmitted := rfl'
replacement=f'''theorem core_SweepAdmitted : @{old}.SweepAdmitted = @{new}.SweepAdmitted := by
  funext D inst m laws Result Information methods volume area fallback stages state
  induction stages generalizing state with
  | nil => rfl
  | cons step stages ih =>
    rcases step with ⟨d, dt⟩
    simpa only [{old}.SweepAdmitted, {new}.SweepAdmitted] using
      congrArg (fun p : Prop => {new}.StageAdmitted methods d dt state ∧ p) (ih _)

theorem proof_transport {{p q : Prop}} (h : p = q) (hp : p) (hq : q) : HEq hp hq := by
  cases h
  rfl'''
assert line in body;body=body.replace(line,replacement)
names=['sweepAdmitted_fallback_independent','sweep_fallback_independent','admission_at_prefix','executed_face_uses_selected_solve']
for n in names:
 line=f'theorem core_{n} : @{old}.{n} = @{new}.{n} := rfl'
 replacement=f'''theorem core_{n} : HEq (@{old}.{n}) (@{new}.{n}) := by
  apply proof_transport
  rw [core_SweepAdmitted]'''
 assert line in body;body=body.replace(line,replacement)
line=f'theorem example_left_sweep_admitted : @NumStability.LeftStateCoordinateSweep.left_sweep_admitted = @{old}.left_sweep_admitted := rfl'
replacement=f'''theorem example_left_sweep_admitted : HEq (@NumStability.LeftStateCoordinateSweep.left_sweep_admitted) (@{old}.left_sweep_admitted) := by
  apply proof_transport
  rw [core_SweepAdmitted]'''
assert line in body;body=body.replace(line,replacement)
body+='\n#check NumStability.InformationCoordinatePlacementChecks.proof_transport\n#print axioms NumStability.InformationCoordinatePlacementChecks.proof_transport\n'
frozen=S/'information-coordinate-sweep-draft/full04-input.lean'
assert sha(frozen)=='5dfbdec6ccfa0380cc17d4d609b1a616494aeb4cc41c9c2bfc641ade74db2dae'
fragment=P/'Comparisons02.lean.fragment';assert not fragment.exists();fragment.write_bytes(body.encode())
data=(''.join('import '+f['module']+'\n' for f in plan['files'])+'\n').encode()+frozen.read_bytes()+b'\n\n'+body.encode()
data+=('\n'+ '\n'.join('#check '+n+'\n#print axioms '+n for f in plan['files'] for n in f['declarations'])+'\n').encode()
target=P/'Comparisons02.lean';assert not target.exists();target.write_bytes(data)
for c in prior['comparisons']:
 if c['name'].endswith('core_SweepAdmitted'):c['kind']='propositional function equality proved by induction on the exact ordered stages; not definitional equality'
 if c['name'].split('.')[-1] in ['core_'+n for n in names]+['example_left_sweep_admitted']:c['kind']='heterogeneous proof equality via explicit full proposition-type equality transported by core_SweepAdmitted'
prior.update(comparison_input=dict(path=target.relative_to(R).as_posix(),sha256=sha(target)),prior_plan=dict(path=(P/'comparison-plan.json').relative_to(R).as_posix(),sha256=sha(P/'comparison-plan.json')),support_declarations=['NumStability.InformationCoordinatePlacementChecks.proof_transport'],expected_reports=199)
out=P/'comparison-plan-02.json';assert not out.exists();out.write_bytes((json.dumps(prior,indent=2)+'\n').encode())
print(json.dumps(dict(path=target.relative_to(R).as_posix(),sha256=sha(target))))
