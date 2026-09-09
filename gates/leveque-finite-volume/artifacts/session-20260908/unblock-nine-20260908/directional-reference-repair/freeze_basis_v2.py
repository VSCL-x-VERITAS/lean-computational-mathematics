from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
labels={'reference01':6,'geometry01':5,'projection02':2,'lift01':3}
records=[]
for label,count in labels.items():
    receipt=P/(label+'-receipt.json');v=json.loads(receipt.read_bytes())
    assert v['actual_exit_code']==0 and v['dependencies_unchanged']
    assert sha(R/v['source']['path'])==v['source']['sha256']
    assert sha(R/v['output']['path'])==v['output']['sha256']
    for dep in v['dependencies']:assert sha(R/dep['path'])==dep['sha256']
    text=(R/v['output']['path']).read_text(encoding='utf-8-sig')
    assert not re.search(r'error:|error\(|sorryAx',text)
    warnings=re.findall(r'warning: ([^\r\n]+)',text)
    assert all(w.startswith('automatically included section variable(s) unused in theorem `NumStability.DirectionalGeometryRepair.cartesian_facePoint_measurable`') for w in warnings)
    assert len(warnings) == (1 if label in ('geometry01','lift01') else 0)
    reports=re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",text,re.S)
    assert len(reports)==count,(label,len(reports))
    for _,axs in reports:assert set(x.strip() for x in axs.split(',') if x.strip())<={'propext','Classical.choice','Quot.sound'}
    records.append({'receipt':ref(receipt),'reports':count,'known_unused_Fintype_section_warning':bool(warnings)})
review='''# Frozen all-subinterval and Cartesian linkage basis

This packet is useful mathematics, not a finished dimensional-splitting capstone or a source-faithfulness verdict. No production file was added or modified.

Reference.lean quantifies the existing physical reference condition on every temporal subinterval, proves endpoint extraction and restriction, and exposes actual intermediate mass balances. Its nonconstant transported-step instance reuses PhysicalIntervalSweep and genuine rectangle conservation.

Geometry.lean identifies the actual restricted cell measures, the pushforward of actual face measures under their actual facePoint maps, and the same directional physical flux. It proves equality of actual cell volume, actual cell mean, and actual face integral. Null-boundary Ioc/Ico conventions may be handled only through equality of restricted measures; equal scalar volumes alone do not satisfy this contract.

Projection.lean derives the Cartesian cell integral and normalized average of a field depending on one coordinate from Mathlib's product-measure projection and integral_map, including all width/area factors. Lift.lean combines these with actual face integration to derive the same-data, same-law lifted directional reference. Its face identity holds even for an arbitrary profile because its normal coordinate is fixed on the actual Cartesian face. It does not require globally smooth profiles or assign unrelated flux functions to a matched volume.

These are conditional transfer theorems. They do not yet construct a finite Cartesian physical-data object, establish its nonvacuity, or connect a high-resolution method family to the actual executed finite lines. The old infinite PhysicalData owners remain unchanged. Separate finite active-cell and quality-family drafts are active and explicitly excluded from this freeze.

The completed DIM direct and round-trip findings required these repairs; the exact hconstant-free scratch remains a separate earlier algebraic generalization and is not presented as the full repair. Source context and the literal new high-resolution receipt are owned separately by root. The book's §6.3 is explanatory context, not a new Chapter6 inventory claim.

All four successful native executions have exact output and source/dependency pins and actual zero exits. There are sixteen declaration/axiom reports in total, using only propext, Classical.choice and Quot.sound. Geometry01 and lift01 each retain the same unused-section-variable warning for Fintype D in cartesian_facePoint_measurable; it has no proof or applicability failure, and has not been silently reported as a warning-free run. The first draft-freeze guard rejected that warning and wrote no frozen receipt; this reviewed v2 guard recognizes only that exact warning. Projection01 is retained as a failed attempt (missing explicit measure-family and index arguments), then repaired without changing the intended theorem. No source acceptance, final gate status or candidate readiness is asserted.
'''
(P/'BASIS-REVIEW.md').write_text(review,encoding='utf-8',newline='\n')
names=['Reference.lean','Geometry.lean','Projection.lean','Lift.lean','lift.fragment','combine_lift.py','native.py','freeze_basis.py','derive_freeze_basis_v2.py','freeze_basis_v2.py','BASIS-REVIEW.md']
for label in (*labels,'projection01'):
    names += [f.name for f in P.glob(label+'-*') if f.is_file()]
manifest={'status':'frozen-reference-geometry-basis-not-complete-capstone',
          'files':[ref(P/name) for name in sorted(set(names))],
          'active_drafts_excluded':['Finite.lean','Quality.lean']}
(P/'basis-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
receipt={'status':manifest['status'],'manifest':ref(P/'basis-manifest.json'),
         'native_executions':records,'total_reports':sum(labels.values()),
         'allowed_axioms':['propext','Classical.choice','Quot.sound'],
         'production_mutated':False,'source_acceptance_claimed':False}
(P/'basis-final-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'receipt':ref(P/'basis-final-receipt.json'),'manifest':ref(P/'basis-manifest.json')},indent=2))
