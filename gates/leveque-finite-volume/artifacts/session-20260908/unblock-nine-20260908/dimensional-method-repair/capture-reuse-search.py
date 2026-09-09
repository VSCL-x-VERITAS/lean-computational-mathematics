from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;R=next(x for x in P.parents if (x/'lean-toolchain').exists())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
commands=[['rg','-n',r'advance_mass_balance|finite_line_mass_balance|advance_line_local|cartesian_full_line_update|riemannFiniteVolumeUpdate_error_le|IsHyperbolicFluxOn|cellWidth_smul_oneDimensionalCellAverage|cellVolumeAverage','ComputationalMathematics/Analysis/PartialDifferentialEquations','-g','*.lean'],
 ['rg','-n',r'theorem smul |theorem integral_sub|norm_sub_le|norm_add_le|toReal_pos','.'+'lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean','.lake/packages/mathlib/Mathlib/Analysis/Normed/Group/Basic.lean','.lake/packages/mathlib/Mathlib/Data/ENNReal/Real.lean']]
records=[]
for i,command in enumerate(commands):
 output=P/f'reuse-search-{i+1:02}.txt';assert not output.exists()
 with output.open('xb') as f:run=subprocess.run(command,cwd=R,stdout=f,stderr=subprocess.STDOUT)
 records.append(dict(command=command,actual_exit_code=run.returncode,output=dict(path=output.relative_to(R).as_posix(),sha256=sha(output))))
receipt=P/'reuse-search-receipt.json';assert not receipt.exists()
receipt.write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'path':receipt.relative_to(R).as_posix(),'sha256':sha(receipt)}))
