"""Derive an additive preparer for explicitly recorded interpretation refinements."""
from pathlib import Path
import ast,hashlib,json
D=Path(__file__).resolve().parent
base=D/'prepare-successor-audit-with-companions.py'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(base)=='a262f79466f9060695cda9dee41e65546858ab847fbdd4d0fc7d9abceffa8cad'
code=base.read_text(encoding='utf-8')
marker="writej(T/'user-interpretation-packet.json',interpretation)"
block="""refinement_ref=spec.get('interpretation_refinement')
if refinement_ref is not None:
 assert set(refinement_ref)=={'path','sha256'}
 refpath=(R/refinement_ref['path']).resolve()
 assert refpath.is_relative_to(D.resolve()) and sha(refpath)==refinement_ref['sha256']
 refinement=json.loads(refpath.read_bytes())
 assert refinement['format']=='coordinator-selected-interpretation-refinement-1'
 assert refinement['status']=='selected-for-fresh-independent-audit'
 assert refinement['scope_row']==spec['row_id'] and refinement['prior_choice_exact']==choice
 assert refinement['prior_choice_id']==choice['choice_id']
 assert refinement['prior_selection_receipt']=={'path':receipt.relative_to(R).as_posix(),'sha256':sha(receipt)}
 for key in ['authority','exact_user_objective','goal_observation_sha256']:
  assert refinement[key]==selections[key]
 assert refinement['source']['sha256']==task['source']['sha256']
 assert refinement['unchanged_target']=={**task['target'],'sha256':sha(R/task['target']['path'])}
 assert isinstance(refinement['selected_model'],dict) and refinement['selected_model']
 assert all(isinstance(v,str) and v.strip() for v in refinement['selected_model'].values())
 assert refinement['source_ambiguities_preserved']
 interpretation['interpretation_refinement_ref']=refinement_ref
 interpretation['interpretation_refinement']=refinement
 interpretation['comparison_rule']+=' The separate recorded refinement is part of this exact comparison convention. Independently assess the claim under both recorded inputs; preserve their source-only limitations and do not infer a requested verdict.'
writej(T/'user-interpretation-packet.json',interpretation)"""
assert code.count(marker)==1
code=code.replace(marker,block)
marker="envfiles=list(cfg['lean']['environment_files'])"
assert code.count(marker)==1
code=code.replace(marker,marker+"\nif refinement_ref is not None:envfiles.append(refinement_ref['path'])")
marker="packet=(out/'inputs/blind_review_packet.md').read_bytes();message=ns['message']"
assert code.count(marker)==1
code=code.replace(marker,"out=Path(chr(92)*2+'?'+chr(92)+str(out))\n"+marker)
ast.parse(code)
destination=D/'prepare-refined-successor-audit.py'
with destination.open('xb') as f:f.write(code.encode())
receipt={'base':{'path':base.name,'sha256':sha(base)},'successor':{'path':destination.name,'sha256':sha(destination)},
 'changes':['Hash-bound separate coordinator interpretation refinement in task packet/environment.',
 'Extended Windows path for the final native blind-packet preflight read.'],
 'released_kit_changed':False,'source_and_blind_role_boundaries_changed':False,'roles_invoked':False}
with (D/'refined-preparer-derivation.json').open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt))
