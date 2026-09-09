from pathlib import Path
import json
G=Path(__file__).resolve().parent
t=(G/'Comparisons02.lean').read_text()
a='(`NumStability.DirectionalGeometryRepair.cartesian_facePoint_measurable, `NumStability.FiniteCartesian.facePoint_measurable)'
b='(`NumStability.FiniteCartesianDraft.facePoint_measurable, `NumStability.FiniteCartesian.facePoint_measurable)'
assert t.count(a)==1;t=t.replace(a,b)
(G/'Comparisons03.lean').write_text(t,encoding='utf-8',newline='\n')
plan=json.loads((G/'comparison-plan.json').read_text())
for p in plan['pairs']:
    if p[1]=='NumStability.FiniteCartesian.facePoint_measurable':p[0]='NumStability.FiniteCartesianDraft.facePoint_measurable'
plan['corrections']=['Generated structure projections follow explicitly mapped structure prefixes.', 'Compare facePoint_measurable against its actual copied finite-Cartesian constructor owner, not the older broader-context alias with an unused Fintype premise.']
(G/'comparison-plan-final.json').write_text(json.dumps(plan,indent=2)+'\n',encoding='utf-8',newline='\n')
