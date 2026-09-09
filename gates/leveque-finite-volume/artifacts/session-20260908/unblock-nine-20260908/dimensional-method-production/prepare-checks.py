from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
base='ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
ns='NumStability.DirectionalFiniteVolume.'
specs=[
 ('DirectionalReference',ns,['IsDirectionalReference','faceAverage','reference_weighted_balance']),
 ('DirectionalReferenceError',ns,['advance_error_le']),
 ('CartesianDirectionalReference',ns,['cartesian_reference']),
 ('PhysicalCoordinateGeometry',ns,['PhysicalData','PhysicalData.cellVolume','PhysicalData.cellVolume_pos','PhysicalData.cellMean','PhysicalData.faceFlux','PhysicalData.ReferenceOn']),
 ('DirectionalMethodSweep',ns,['directional_splitting_contract']),
 ('Examples.PhysicalIntervalSweep','NumStability.PhysicalIntervalSweep.',['cells','axis','cell_measure','data','data_volume','data_mean','data_flux','reference_on','reference','reference_conserved','rule','constant_consistent','initial','oldError','faceError','simultaneous_contract','unit_update','nonconstant_execution']),
 ('@ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateDirectionalMethods','NumStability.',['leveque01_coordinateDirectionalMethods_sourceContract'])]
files=[]
for leaf,space,names in specs:
 mod=leaf[1:] if leaf.startswith('@') else base+leaf
 path=R/(mod.replace('.','/')+'.lean')
 files.append(dict(path=path.relative_to(R).as_posix(),module=mod,sha256=hashlib.sha256(path.read_bytes()).hexdigest(),declarations=[space+n for n in names],lines=len(path.read_text().splitlines())))
checks=[n for f in files for n in f['declarations']]
comparisons=['fromDraft','toDraft','from_to','to_from','reference_same','face_average_same','balance_type_same','error_type_same','cartesian_type_same','volume_same','mean_same','flux_same','reference_on_same','full_contract_same','source_contract_same']
checks+=['NumStability.DirectionalPlacementComparison.'+n for n in comparisons]
checks+=['NumStability.LeftStateCoordinateSweep.left_two_stage_nonvacuity']
old=P.parent/'dimensional-method-repair/Candidate.lean'
assert hashlib.sha256(old.read_bytes()).hexdigest()=='eb9fd7e8a6a528a17cbf252db2c0877dc510303fe736873f1b69d1b9c9248657'
text='import '+base+'Examples.PhysicalIntervalSweep\nimport ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateDirectionalMethods\n'+old.read_text(encoding='utf-8')+'\n'+(P/'comparison.fragment').read_text(encoding='utf-8')+'\n'
text+=''.join('#check '+n+'\n#print axioms '+n+'\n' for n in checks)
out=P/'Comparison.lean';assert not out.exists();out.write_text(text,encoding='utf-8',newline='\n')
(P/'placement-inventory.json').write_text(json.dumps({'files':files,'comparisons':comparisons,'checked_declarations':checks},indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'files':len(files),'production_declarations':sum(len(f['declarations']) for f in files),'total_checks':len(checks)}))
