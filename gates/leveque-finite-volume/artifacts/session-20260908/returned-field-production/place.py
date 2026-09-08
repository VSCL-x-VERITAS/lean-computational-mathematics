"""One-time additive placement from the root-reviewed frozen returned-field draft."""
from pathlib import Path
import hashlib, json, re, subprocess
P=Path(__file__).resolve().parent; R=P.parents[4]; S=P.parent
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,s):
    assert not p.exists(),p
    p.parent.mkdir(parents=True,exist_ok=True)
    p.write_bytes(s.encode('utf-8'))
draft=S/'returned-riemann-field-draft/Candidate.lean'
review=S/'root-batch9-returned-field-verification.json'
assert sha(draft)=='0e0376759b0021cb5d1756147baf778d6145807dc7d395ecd66e3ea7a00c6b99'
assert sha(review)=='b8e0428901e256fe63a4a146e70fa051ed2f745bd0c02e15667d72984fac2148'
assert json.loads(review.read_bytes())['status']=='PASS'
search=['rg','-n','RiemannFieldFluxMethod|norm_sub_oneDimensionalCellAverage_le_of_trace|StationaryRiemannField|CellAverageTraceEstimate|RiemannFieldFluxError','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean']
r=subprocess.run(search,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
assert r.returncode==1,r.stdout.decode('utf-8')
write(P/'exact-name-search.txt',r.stdout.decode('utf-8'))
base='ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
paths=['CellAverageTraceEstimate','RiemannFieldFluxMethod','RiemannFieldFluxError','Examples.StationaryRiemannField']
targets=[R/Path(*(base+x).split('.')).with_suffix('.lean') for x in paths]
assert not any(p.exists() for p in targets)
t=draft.read_text(encoding='utf-8')
def span(a,b): return t[t.index(a):t.index(b)].rstrip()+'\n'
method=span('/-- A field-producing method','/-- A trace-level bound')
method=method.replace('structure FieldFluxMethod','structure RiemannFieldFluxMethod').replace(': FieldFluxMethod',': RiemannFieldFluxMethod').replace('    FieldFluxMethod','    RiemannFieldFluxMethod')
method=method.replace('variable {Result :', 'namespace RiemannFieldFluxMethod\n\nvariable {Result :')
trace=span('/-- A trace-level bound','/-- Extraction error').replace('theorem flux_error_of_trace','theorem norm_sub_oneDimensionalCellAverage_le_of_trace')
error=span('/-- Extraction error','namespace Witness').replace('FieldFluxMethod','RiemannFieldFluxMethod').replace('flux_error_of_trace','norm_sub_oneDimensionalCellAverage_le_of_trace')
witness=span('noncomputable def transportLaw','end Witness').replace('FieldFluxMethod','RiemannFieldFluxMethod')
witness=witness.replace('linearHyperbolicConservationLaw 1 identity_hyperbolic','''linearHyperbolicConservationLaw 1 (by
    refine ⟨fun _ => 1, Pi.basisFun ℝ (Fin m), ?_⟩
    intro p
    simp only [Matrix.one_mulVec, one_smul])''')
def header(imports,title,desc):
    return '/-\nSPDX-License-Identifier: MIT\n-/\n\n'+''.join('import '+base+i+'\n' for i in imports)+'\n/-!\n# '+title+'\n\n'+desc+'\n-/\n\nopen MeasureTheory\n\n'
write(targets[0],header(['CellAverageEstimates'],'Cell-average estimates through an intermediate trace','Two pointwise trace bounds control the error against the normalized average.\nThe estimate is independent of any governing law or numerical method.')+'namespace NumStability\n\n'+trace+'\nend NumStability\n')
write(targets[1],header(['RectangleRiemannInterface'],'Methods returning Riemann fields','The selected result supplies both the returned field and extracted information.\nFields have the ordered initial data and integrable physical interface traces\non every finite real time interval. Exact conservation is not required.')+'namespace NumStability\n\nvariable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}\n\n'+method+'\nend RiemannFieldFluxMethod\nend NumStability\n')
write(targets[2],header(['CellAverageTraceEstimate','FluxUpdateErrorBounds','RiemannFieldFluxMethod'],'Conditional errors for returned Riemann fields','Extraction and returned-field trace errors are independent hypotheses.\nThe resulting interface bound feeds the existing conservative update estimate.')+'namespace NumStability.RiemannFieldFluxMethod\n\nvariable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}\nvariable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}\n\n'+error+'\nend NumStability.RiemannFieldFluxMethod\n')
write(targets[3],header(['LinearRectangleRiemannInterface','RiemannFieldFluxMethod'],'A stationary inexact Riemann field','Unit-speed transport admits a consistent method returning stationary Riemann\ndata. Unequal states show that this returned field is not rectangle-conserved;\nits positive-time interface trace still agrees with the translated reference.')+'namespace NumStability.StationaryRiemannField\n\nvariable {m : ℕ}\n\n/-- Unit-speed vector transport, with its hyperbolicity proof kept local. -/\n'+witness+'\nend NumStability.StationaryRiemannField\n')
old=re.findall(r'^#check (NumStability.ReturnedRiemannDraft\.[\w.]+)',t,re.M)
mapping=[]
for x in old:
    suffix=x.removeprefix('NumStability.ReturnedRiemannDraft.')
    if suffix=='Witness.identity_hyperbolic':
        mapping.append(dict(draft=x,canonical=None,disposition='inline hyperbolicity proof in StationaryRiemannField.transportLaw; no redundant public helper'))
        continue
    if suffix=='FieldFluxMethod': new='NumStability.RiemannFieldFluxMethod'; file=targets[1]
    elif suffix=='flux_error_of_trace': new='NumStability.norm_sub_oneDimensionalCellAverage_le_of_trace'; file=targets[0]
    elif suffix.startswith('Witness.'): new='NumStability.StationaryRiemannField.'+suffix.removeprefix('Witness.');file=targets[3]
    else: new='NumStability.RiemannFieldFluxMethod.'+suffix;file=targets[2] if 'error_le' in suffix else targets[1]
    mapping.append(dict(draft=x,canonical=new,owner=file.relative_to(R).as_posix()))
manifest=dict(schema=1,source_acceptance=False,mode='additive canonical placement only',draft=dict(path=draft.relative_to(R).as_posix(),sha256=sha(draft)),root_review=dict(path=review.relative_to(R).as_posix(),sha256=sha(review)),search=dict(command=search,exit_code=r.returncode,output_sha256=sha(P/'exact-name-search.txt')),modules=[base+x for x in paths],source_files={p.relative_to(R).as_posix():sha(p) for p in targets},declaration_map=mapping,toolchain_sha256=sha(R/'lean-toolchain'),lake_manifest_sha256=sha(R/'lake-manifest.json'))
write(P/'placement-map.json',json.dumps(manifest,indent=2)+'\n')
print(json.dumps(dict(modules=manifest['modules'],canonical_declarations=sum(bool(x['canonical']) for x in mapping))))
