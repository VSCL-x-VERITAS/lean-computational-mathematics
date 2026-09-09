from pathlib import Path
import datetime,hashlib,json,subprocess
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
queries=[
 ['rg','-n','coordinate_highResolution_specification|coordinate_stability|coordinateExecution_physical_error|extract_cell|theorem LineRealization.advance_eq',str(r/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume')],
 ['rg','-n','def data |theorem data_cellVolume|theorem faceMeasure_area|family_quality|family_advance|grid_volume',str(r/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FiniteCartesianGeometry.lean'),str(r/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/HighResolutionAdvectionLine.lean'),str(r/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/CFLUnitShift.lean')],
 ['rg','-n','def piFinset|mem_piFinset|card_piFinset|theorem update_idem|theorem update_self|theorem update_apply',str(r/'.lake/packages/mathlib/Mathlib/Data/Fintype/Pi.lean'),str(r/'.lake/packages/mathlib/Mathlib/Data/Fintype/BigOperators.lean'),str(r/'.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean')],
]
records=[]
for i,cmd in enumerate(queries,1):
 out=h/f'reuse-search-{i:02}.txt'
 if out.exists():raise SystemExit('Refusing overwrite')
 started=datetime.datetime.now(datetime.timezone.utc).isoformat()
 p=subprocess.run(cmd,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);out.write_bytes(p.stdout)
 records.append({'command':cmd,'started_at_utc':started,'actual_exit_code':p.returncode,
 'output':{'path':out.name,'sha256':hashlib.sha256(p.stdout).hexdigest(),'bytes':len(p.stdout)}})
 if p.returncode not in [0,1]:raise SystemExit(p.returncode)
(h/'reuse-searches.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
print(json.dumps(records,indent=2))
