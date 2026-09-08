"""Native Lean checks with exact frozen prerequisite bytes and immutable attempts."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess,sys,time
assert os.name=='nt'
P=Path(__file__).resolve().parent; R=P.parents[4]; S=P.parent
label=sys.argv[1]; assert re.fullmatch(r'[a-z0-9-]+',label)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
source=P/(label+'-input.lean'); out=P/(label+'-output.txt'); receipt=P/(label+'-exit.json')
assert not any(p.exists() for p in [source,out,receipt])
base=S/'finite-volume-flux-error-estimate'/'combined-check.lean'
assert sha(base)=='e39e864134339eb5a6c639db0c995ffdf138b70cbebc407db72efd95c4afca22'
inputs=[base,P/'TensorLines.lean.fragment']
decls=['TensorGrid.cellVolume_pos','TensorGrid.cellVolume_eq_width_mul_area',
'TensorGrid.cellBox_volume','TensorGrid.reference_spec','line_at_base','line_update_base',
'LineSolver.faceFlux_physical_trace','LineSolver.face_problem_solves','LineSolver.faceFlux_constant',
'LineSolver.advance_constant','LineSolver.linear_faceFlux_eq_rule','LineSolver.linear_faceFlux_eq_solver_average',
'line_advanceDirection','advanceDirection_line_local','advanceDirection_constant_line',
'advanceDirection_preserves_constants','advanceDirection_mass_balance','advanceDirection_full_volume_balance',
'scheduled_directions','scheduled_step_is_line_update','scheduled_sweep_executes','two_direction_composition',
'Witness.broadcast_is_not_directional_update','Witness.concrete_nonvacuity']
checks='\n'.join(f'#check NumStability.TensorLinesDraft.{d}\n#print axioms NumStability.TensorLinesDraft.{d}' for d in decls)
hashes={str(p.relative_to(R)).replace(chr(92),'/'):sha(p) for p in inputs}
prefix=b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting\nimport Mathlib.MeasureTheory.Measure.Lebesgue.Basic\n'
source.write_bytes(prefix+b'\n\n'.join(p.read_bytes() for p in inputs)+b'\n\n'+checks.encode()+b'\n')
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
m=json.loads((R/'lake-manifest.json').read_bytes())
assert next(p for p in m['packages'] if p['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
command=[r'C:/Users/qed_s/.elan/bin/lake.exe','env','lean',source.relative_to(R).as_posix()]
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip()
start=datetime.now(timezone.utc).isoformat(); tick=time.monotonic()
with out.open('xb') as f: result=subprocess.run(command,cwd=R,stdout=f,stderr=subprocess.STDOUT)
assert hashes=={str(p.relative_to(R)).replace(chr(92),'/'):sha(p) for p in inputs}
record={'command':command,'cwd':str(R),'started_at_utc':start,
 'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':result.returncode,
 'elapsed_ms':int((time.monotonic()-tick)*1000),'input_commit':head,'input_files':hashes,
 'checked_declarations':['NumStability.TensorLinesDraft.'+d for d in decls],
 'assembled_input_sha256':sha(source),'raw_output_sha256':sha(out),
 'lean_toolchain_sha256':sha(R/'lean-toolchain'),'lake_manifest_sha256':sha(R/'lake-manifest.json')}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='')
print(json.dumps(record),flush=True)
sys.stdout.buffer.write(out.read_bytes())
raise SystemExit(result.returncode)
