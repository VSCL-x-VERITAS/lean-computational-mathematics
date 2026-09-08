"""Place reviewed volume-average laws and examples, preserving old definitions."""
from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'cell-volume-average-production'
P.mkdir(exist_ok=False)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
original=S/'heterogeneous-volume-average-draft/Candidate.lean'
assert sha(original)=='d05321ada063fff739b5234a0d81c2cd1d91d1f42386fa3a60cde5d633e0d366'
assert sha(S/'root-batch8-normalized-volume-verification.json')=='a5f2b308facad35f77011c08f1678f55cbe1bb0403f1d945495be1815c169f75'
pattern='cellVolumeAverage_(eq_setAverage|congr_ae|congr|const|Ioc_eq_oneDimensionalCellAverage)|existsUnique_cellVolumeAssignment|CellVolumeAverageExamples'
queries=[]
for label,cwd,args in [
 ('project',R,['rg','-n',pattern,'ComputationalMathematics']),
 ('mathlib',R/'.lake/packages/mathlib',['rg','-n',pattern,'Mathlib'])]:
 run=subprocess.run(args,cwd=cwd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 assert run.returncode==1,(label,run.returncode,run.stdout.decode())
 out=P/(label+'-name-search.txt');out.write_bytes(run.stdout)
 queries.append({'argv':args,'cwd':str(cwd),'exit_code':run.returncode,'output':out.name,'output_sha256':sha(out)})
text=original.read_text(encoding='utf-8')
begin=text.index('/-- Bridge to the existing Mathlib average')
contract=text.index('/-- Concrete normalized-volume assignment')
interval=text.index('/-- The existing multidimensional volume operator')
examples=text.index('/-- Two adjacent, disjoint, finite-volume real cells')
end=text.index('\nend NumStability.HeterogeneousVolumeDraft')
core=text[begin:contract]+text[interval:examples]
example=text[examples:end]
prefix='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
sources={
 prefix+'CellVolumeAverage.lean':
 '/-\nSPDX-License-Identifier: MIT\n-/\n\nimport ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage\nimport Mathlib.MeasureTheory.Integral.Average\n\n/-!\n# Normalized volume-average laws and assignments\n\nThe existing cell average agrees with Mathlib set averaging, is local,\nreproduces constants, and gives unique assignments on measured cells.\n-/\n\nopen MeasureTheory\n\nnamespace NumStability\n\nvariable {Point E Cell : Type*} [MeasurableSpace Point]\n  [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n'+core+'end NumStability\n',
 prefix+'Examples/CellVolumeAverage.lean':
 '/-\nSPDX-License-Identifier: MIT\n-/\n\nimport ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage\nimport Mathlib.Analysis.SpecialFunctions.Integrals.Basic\n\n/-!\n# Equal and different averages of heterogeneous fields\n\nQuadratic and linear fields on adjacent unit intervals show that\nwithin-cell variation does not force distinct normalized averages.\n-/\n\nopen MeasureTheory\n\nnamespace NumStability.CellVolumeAverageExamples\n\n'+example+'\nend NumStability.CellVolumeAverageExamples\n'
}
files=[]
for path,data in sources.items():
 out=R/path;assert not out.exists(),path
 out.write_text(data,encoding='utf-8',newline='')
 names=re.findall(r'^(?:noncomputable )?(?:def|theorem) (\w+)',data,re.M)
 namespace='NumStability.CellVolumeAverageExamples.' if '/Examples/' in path else 'NumStability.'
 files.append({'path':path,'module':path[:-5].replace('/','.'),'sha256':sha(out),'lines':len(data.splitlines()),
 'declarations':[{'old':'NumStability.HeterogeneousVolumeDraft.'+n,'new':namespace+n} for n in names]})
assert [len(f['declarations']) for f in files]==[6,8]
record={'schema':1,'input_commit':subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R).decode().strip(),
 'old_candidate':{'path':original.relative_to(R).as_posix(),'sha256':sha(original)},
 'new_files':files,'queries':queries,
 'not_promoted':['NumStability.HeterogeneousVolumeDraft.cellVolumeAssignment_contract'],
 'rationale':'The combined assignment/locality/constants capstone stays unselected scratch composition. Its six generic producers and eight examples receive semantic owners; no second averaging definition, source wrapper or interpretation is introduced.',
 'unmodified_current_owners':[{'path':prefix+'CellAverage.lean','sha256':sha(R/(prefix+'CellAverage.lean'))}]}
out=P/'placement-inputs.json';out.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'new_files':files,'manifest_sha256':sha(out)}))

