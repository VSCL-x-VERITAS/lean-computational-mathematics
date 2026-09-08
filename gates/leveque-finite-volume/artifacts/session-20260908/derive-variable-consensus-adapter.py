"""Derive a task-pinned stronger adapter for agreeing independent judges."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
parent=S/'bind-audited-stronger-production-rows.py'
assert sha(parent)=='2b6e6d26931f831970479cfdae30f066d3712586363ef08e6ce0b830306782d6'
assert sha(S/'variable-opening-binding-pins.json')=='fef802d48786322675ce9cf6170c8d5fd6cf48605a96702e03e05aa281797e60'
old=parent.read_text(encoding='utf-8');new=old
def change(a,b):
 global new
 assert new.count(a)==1,(a,new.count(a))
 new=new.replace(a,b)
change('Project only two pinned stronger decisions with native nonvacuity evidence.','Project one pinned agreeing stronger decision with native nonvacuity evidence.')
change("PINS_SHA='8ae05bceda115976746809a758068bbcf27dfe3217b3e4712c2b7366a3193123'","PINS_SHA='fef802d48786322675ce9cf6170c8d5fd6cf48605a96702e03e05aa281797e60'")
change("S/'stronger-production-binding-pins.json'","S/'variable-opening-binding-pins.json'")
change("'Only the two pinned production tasks are supported'","'Only the pinned variable-coefficient opening-claim task is supported'")
change("require(decision['accepted'] is True and decision['adjudicated'] is True and decision['classification']=='faithful-stronger','Stronger audit not accepted and adjudicated')",
"require(decision['accepted'] is True and decision['adjudicated'] is False and decision['classification']=='faithful-stronger','Pinned consensus decision changed')\n require(decision['adjudication_reasons']==[] and decision['judge_classifications']=={'direct':'faithful-stronger','roundtrip':'faithful-stronger'},'Independent judges do not agree without an adjudication trigger')")
change("require(evidence['remaining_source_uncertainties']==decision['remaining_uncertainties'],'Source ambiguity was lost')",
"require(evidence['remaining_source_uncertainties']==decision['remaining_uncertainties'],'Final uncertainties changed')\n source_path=bound_file(root,evidence['source_contract'])\n require(source_path==out/'agent_outputs/source_contract.json','Source-only record changed')\n require(evidence['source_only_ambiguities']==read(source_path)['ambiguities'],'Source-only ambiguities were lost')")
change("'source_ambiguity_note':json.dumps(evidence['remaining_source_uncertainties'],ensure_ascii=True)}",
"'source_ambiguity_note':json.dumps({'source_only_ambiguities':evidence['source_only_ambiguities'],'remaining_decision_uncertainties':evidence['remaining_source_uncertainties']},ensure_ascii=True),\n  'consensus_audit':'Both independent judges agree on faithful-stronger yes/no; the unchanged sealed decision records no adjudication trigger. No adjudicator was invoked or represented. '+provenance}")
change("'adjudication_required':True,'adjudication_status':'resolved',\n  'adjudication_audit':f\"The independent adjudicator accepts genuine additional conclusions with source applicability preserved: yes/no. Decision SHA-256 {pin['decision_sha256']}; strengthening evidence SHA-256 {pin['evidence']['sha256']}. Original role classifications remain unchanged: {decision['judge_classifications']}. \"+decision['rationale'],**fields})",
"'adjudication_required':False,**fields})")
change(" for key in ('next_foundation','next_action','current_target','open_reason'):row.pop(key,None)",
" for key in ('next_foundation','next_action','current_target','open_reason','adjudication_status','adjudication_audit'):row.pop(key,None)")
change("PASS projects the adjudicated faithful-stronger result; original role outcomes are retained.","PASS projects the agreeing independent faithful-stronger result; original role outcomes and absence of adjudication are retained.")
change("complete validated role and adjudicated decision.","complete validated role and agreeing independent decision.")
ast.parse(new)
dest=S/'bind-variable-consensus-stronger-row.py'
with dest.open('x',encoding='utf-8',newline='\n') as f:f.write(new)
record={'schema':1,'parent':{'path':parent.name,'sha256':sha(parent)},'derived':{'path':dest.name,'sha256':sha(dest)},'pins_sha256':sha(S/'variable-opening-binding-pins.json'),'scope':'Only the exact variable-coefficient opening-claim task with both independent judges agreeing, no triggered adjudication, actual native nonvacuity, and exact source-only ambiguity preservation.','preserved':'All complete sealed validator calls, exact task/target/config/native/axiom/search/row artifact checks, immutable snapshots and current-context checks remain. No frozen role or decision changed.','not_executed':True}
out=S/'variable-consensus-adapter-derivation.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'derivation_sha256':sha(out)}))

