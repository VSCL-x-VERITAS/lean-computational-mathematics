from pathlib import Path
import hashlib,json,re
from datetime import datetime,timezone
G=Path(__file__).resolve().parent;R=G.parents[5];D=G.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
def write(name,data):
    p=G/name
    with p.open('x',encoding='utf-8',newline='\n') as out:json.dump(data,out,indent=2);out.write('\n')
    return ref(p)
files=read(G/'production-files-frozen.json')['files']
for f in files:assert sha(R/f['path'])==f['sha256'],f['path']
allowed={'propext','Classical.choice','Quot.sound'};receipts=[];environment={};reports={}
for label,expected in [('canonical01',149),('joint01',40),('sourcejoint01',42),('comparisons03',25)]:
    p=G/(label+'-receipt.json');j=read(p)
    assert j['actual_exit_code']==0 and j['dependencies_unchanged'],label
    for f in [j['source'],j['output']]+j['dependencies']:assert sha(R/f['path'])==f['sha256'],f['path']
    text=(R/j['output']['path']).read_text(encoding='utf-8-sig')
    items=re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",text)
    assert len(items)==expected,(label,len(items),expected)
    for name,axioms in items:assert set(a.strip() for a in axioms.split(',') if a.strip())<=allowed,(name,axioms)
    reports[label]={'authored_axiom_reports':len(items),'source':j['source'],'output':j['output'],'receipt':ref(p)}
    for f in j['dependencies']:
        if f['path'] in environment:assert environment[f['path']]==f
        environment[f['path']]=f
    receipts.append(ref(p))
text=(G/'comparisons03-output.txt').read_text()
plan=read(G/'comparison-plan-final.json')
actual=re.findall(r'^TYPE_TRANSPORT_OK (\S+) -> (\S+)$',text,re.M)
assert actual==[tuple(x) for x in plan['pairs']] and len(actual)==149
build=read(G/'build04-receipt.json');assert build['actual_exit_code']==0
sourcebuild=read(G/'source-build-tool-result.json');assert sourcebuild['tool_result']['exit_code']==0
proof_inputs=[D/'directional-reference-repair/complete-core-receipt.json',D/'dim-cfl1-witness/final-receipt.json',D/'dim-local-characteristic-witness/receipt.json',D/'dim-quality-family-witness/receipt.json',D/'finite-cartesian-geometry-draft/final-receipt.json',D/'dim-joint-primary-witness/final-receipt.json']
proof_inputs=[p for p in proof_inputs if p.exists()]
review='''# Directional high-resolution production placement

Sixteen new owners contain 150 authored declarations: fifteen reusable leaves and one thin Chapter 1 wrapper. Existing source owners, aggregate imports, tiers, gate, ledgers, audits and Git state were not edited by this placement. The measured Cartesian constructor and reference predicates each have a single canonical owner. Sequential perturbation estimates live under Analysis/Normed/Group and have no PDE imports.

The primary combines actual supplied refining line methods, their uniform smooth-reference order and perturbation/oscillation bounds, admitted successive finite-cell execution, retained boundary transfer, all-subinterval physical reference balance, repeated-step error propagation with separate local and splitting defects, and identification of the same physical data with actual Cartesian measures and normal flux. Local order is stated uniformly before arbitrary refinement levels. No high temporal order for the split composite or arbitrary-law solver existence is asserted.

The full-quality CFL-one example has positive physical widths, a fixed nonempty covered target, actual mesh comparability, arbitrary genuine local smooth references, all arrays admitted, stability and finite-window TV control. The separately compiled joint application applies the entire source wrapper on four actual measured cells, the same Cartesian identification, a nonconstant array and an actual moving update. The reference is zero under the nonzero identity flux; the selected Classical.choose stability rate is used honestly. The fixture remains evidence only and introduces no seventeenth production owner.

All 149 generic declarations and the source declaration were native checked with only propext, Classical.choice and Quot.sound (or none). The source theorem has the same type as the generic producer and is equal by rfl/proof irrelevance. Four nominal structure families have explicit field-preserving toDraft/fromDraft maps and round trips; reference, mean, flux, line update, extraction, admission and rule observations commute. Twenty-five bridge declarations pass. Each of the 149 production types is also checked by native definitional equality after an explicit constant-name transport, including generated structure projections. This is a declared namespace/nominal transport, not an assertion that independently named structures are definitionally equal without conversion.

The exact original scratch mathematics remains unchanged. Build attempts 01–03 are retained: missing direct imports/open namespaces after semantic splitting were corrected; attempt04 passes. Comparison01 exposed an incomplete mapping of generated projection constants; comparison02 accidentally selected an older similarly named measurability alias with an unused Fintype premise. Comparison03 names the actual frozen finite-Cartesian source declaration and passes. The only comparison warning is inherited verbatim from that old unused-variable alias; canonical and joint files have no authored warnings. No theorem or target was changed to fit a failed comparison.

Source context and the literal high-resolution receipt remain separately pinned. This packet records kernel/placement evidence only, with no source-faithfulness verdict, gate closure, candidate acceptance or publication claim.
'''
with (G/'REVIEW.md').open('x',encoding='utf-8',newline='\n') as f:f.write(review)
verification=write('verification.json',{'actual_exit_code':0,'files':files,'authored_declarations':150,'native':reports,'transport_type_comparisons':149,'nominal_bridge_declarations':25,'full_compiled_closure':sorted(environment.values(),key=lambda f:f['path']),'scope':'Kernel and placement verification only; no source acceptance.'})
manifest=write('manifest.json',{'status':'FROZEN-NATIVE-PLACEMENT','files':files,'input_receipts':[ref(p) for p in proof_inputs],'initial_placement':ref(G/'initial-placement.json'),'comparison_plan':ref(G/'comparison-plan-final.json'),'verification':verification,'review':ref(G/'REVIEW.md'),'artifacts':[ref(p) for p in sorted(G.rglob('*')) if p.is_file() and p.name not in ('manifest.json','final-receipt.json')]})
receipt=write('final-receipt.json',{'status':'FROZEN-NATIVE-PASS-NO-SOURCE-ACCEPTANCE','frozen_at_utc':datetime.now(timezone.utc).isoformat(),'manifest':manifest,'verification':verification,'production_inventory':ref(G/'production-files-frozen.json'),'files':files,'native_receipts':receipts,'build':ref(G/'build04-receipt.json'),'source_build':ref(G/'source-build-tool-result.json'),'all_source_and_dependency_pins_unchanged':True,'actual_exit_code':0,'authored_declarations':150,'transport_type_comparisons':149,'nominal_bridge_declarations':25,'joint_owner_count':0,'source_acceptance':False,'git_mutation':False})
print(json.dumps({'receipt':receipt,'manifest':manifest,'verification':verification},indent=2))
