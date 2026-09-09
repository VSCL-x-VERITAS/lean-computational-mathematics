from pathlib import Path
import json,hashlib,re
E=Path(__file__).resolve().parent
R=E.parents[5]
base='ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
groups=[
 (base+'LocalRiemannRoutine', 'NumStability.LocalRiemannInformation.',
  ['Routine','Routine.flux','Routine.Consistent','Method.toRoutine','Method.toRoutine_flux',
   'Method.toRoutine_consistent','biasedRoutine','biasedRoutine_selected','exists_biasedRoutine',
   'Routine.reference_comparison']),
 (base+'LocalRiemannRoutineUpdate','NumStability.LocalRiemannInformation.',
  ['routine_local_interface_contract']),
 (base+'Examples.BiasedLocalRiemannRoutine','NumStability.BiasedLocalRiemannRoutine.',
  ['law','proper_states','reference','reference_mean','actual_error','equalProblem',
   'equal_state_selected','equal_state_error','not_consistent','zero_cell_update']),
 ('ComputationalMathematics.Source.LeVeque.Chapter01.RiemannLocalRoutineInterface',
  'NumStability.', ['leveque01_localRiemannRoutineInterface_sourceContract'])]
text='\n'.join('import '+m for m,_,_ in groups)+'\n\n'
files=[]
for module,ns,names in groups:
 p=R/(module.replace('.','/')+'.lean')
 data=p.read_bytes()
 declarations=[ns+n for n in names]
 assert len(re.findall(r'^(?:noncomputable )?(?:def|theorem|structure) ',data.decode(),re.M))==len(names)
 assert b'\r' not in data
 files.append(dict(path=p.relative_to(R).as_posix(),module=module,sha256=hashlib.sha256(data).hexdigest(),
  declarations=declarations,lines=len(data.splitlines())))
 for name in declarations:
  text+='#check '+name+'\n#print axioms '+name+'\n'
with (E/'Declarations.lean').open('x',encoding='utf8',newline='\n') as f:f.write(text)
with (E/'files-before-check.json').open('x',encoding='utf8',newline='\n') as f:
 json.dump(dict(schema=1,files=files,source_acceptance=False),f,indent=2);f.write('\n')
print(json.dumps({'files':len(files),'declarations':sum(len(f['declarations'])for f in files)}))
