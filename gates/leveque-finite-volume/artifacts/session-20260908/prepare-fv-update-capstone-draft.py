"""Record scoped reuse evidence before assembling the unselected FV capstone."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'fv-update-capstone-draft'
P.mkdir(exist_ok=False)
queries=[
 ['rg','-n','riemannFiniteVolumeUpdate_weighted_error|riemannFiniteVolumeUpdate_error_le|timeAveragedPhysicalFaceFlux_isCellAverage','ComputationalMathematics'],
 ['rg','-n','riemannFiniteVolumeUpdate_weighted_error|riemannFiniteVolumeUpdate_error_le|timeAveragedPhysicalFaceFlux','Mathlib']
]
records=[]
for idx,args in enumerate(queries,1):
 cwd=R if idx==1 else R/'.lake/packages/mathlib'
 out=subprocess.run(args,cwd=cwd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 assert out.returncode in (0,1)
 p=P/f'search-{idx:02}.txt';p.write_bytes(out.stdout)
 records.append({'argv':args,'cwd':str(cwd),'exit_code':out.returncode,'output':p.name,'output_sha256':hashlib.sha256(out.stdout).hexdigest()})
record={'queries':records,'selected_producers':['NumStability.riemannFiniteVolumeUpdate_weighted_error','NumStability.riemannFiniteVolumeUpdate_error_le','NumStability.timeAveragedPhysicalFaceFlux_isCellAverage','NumStability.finiteVolumeCellAverageOn_spec'],
 'decision':'Assemble the existing canonical conclusions without scratch numericalUpdate or physicalFaceAverage aliases. The old checked witness is relocated with explicit canonical operations. No new averaging, balance, norm estimate or source-accuracy claim is proved.',
 'scope':'Name searches only over the listed current project and pinned Mathlib trees; no global semantic absence claim.'}
(P/'reuse.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record))

