"""Derive stronger record/provenance freshness without changing released evidence payloads."""
from pathlib import Path
import ast,hashlib,json,difflib
H=Path(__file__).resolve().parent;S=H.parents[1];R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
parent=H/'bind-final-global-evidence.py'
assert sha(parent)=='4eba0aa2194cda7d56cbf9e652ee8ee497a2809dedeafd982876ec3692baba5c'
validator=ref(H/'validate-closed-row-audits-v6.py')
assert validator['sha256']=='95fbb838b7c620228406574f7f9470ba4ca70474396405159ebdf73c7f4ddbe1'
assert sha(H/'qualified_row_support_v3.py')=='75bca786c37ea46940642b7db271d9501d3569c769e2081756da2e4a74905128'
paths=[H/'qualified_row_support_v3.py',H/'protected-baseline.json',
 S/'bind-audited-stronger-reused-row.py',S/'bind-audited-stronger-production-rows.py',
 S/'bind-variable-consensus-stronger-row.py',S/'unblock-nine-20260908/selected-interpretations.json',
 *[R/'.faithfulness-audit/scripts'/name for name in ('validate_audit.py','common.py','prepare_audit.py','schema_validate.py')]]
dependencies=[ref(path) for path in paths]
pins={'format':'final-global-v2-validator-dependencies-1','audit_validator':validator,
 'validator_dependencies':dependencies,'scope':'Exact v6 local dynamic support, protected baseline, selected authority and direct released complete-validator Python dependency closure. Per-audit manifests/configurations and qualified request/native/context provenance are additionally checked by the binder.'}
with (H/'final-global-v2-validator-dependencies.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(pins,f,indent=2);f.write('\n')
code=parent.read_text()
fragment=(H/'final-global-v2-provenance.fragment.py').read_text()
def replace_once(old,new):
 global code
 assert code.count(old)==1,(old,code.count(old))
 code=code.replace(old,new)
replace_once('def validate_audit_records(audit, closed, root, observed):',
 'FINAL_VALIDATOR_PIN = '+repr(validator)+'\nFINAL_VALIDATOR_DEPENDENCIES = '+repr(dependencies)+'\n\n'+fragment+
 '\n\ndef validate_audit_records(audit, closed, root, observed, qualified=None, bindings=None):')
replace_once("    observed[path] = reference['sha256']", "    require(path not in observed or observed[path] == reference['sha256'], 'Conflicting observed file pin: ' + str(path))\n    observed[path] = reference['sha256']")
old="""        for key in ('coordinator_selected_interpretation', 'interpretation_refinement_ref',
                    'strengthening_evidence'):
            if key in row or key in record:
                require(record.get(key) == row.get(key), f'Qualification mismatch: {key}')
"""
new="""        match_qualified_record(record, row)
        manifest_path = repository_path(root, task['audit_output']) / 'manifest.json'
        bound_file(root, {'path': manifest_path.relative_to(root).as_posix(),
                          'sha256': record.get('manifest_sha256')}, observed)
        if qualified is not None:
            observe_qualified_record(root, record, row, qualified, bindings, observed)
        else:
            require(not any(key in row or key in record for key in QUALIFIED_RECORD_FIELDS[3:]),
                    'Qualified records require the exact v6 support')
"""
replace_once(old,new)
replace_once("    validate_audit_records(decode(outputs['audits'].encode()), closed, root, observed)",
 "    qualified = load_final_validator_support(root, m, observed)\n    qualified.validate_preserved_rows(gate)\n    validate_audit_records(decode(outputs['audits'].encode()), closed, root, observed, qualified, context['bindings'])")
ast.parse(code)
target=H/'bind-final-global-evidence-v2.py'
with target.open('x',encoding='utf-8',newline='\n') as f:f.write(code)
diff=''.join(difflib.unified_diff(parent.read_text().splitlines(True),code.splitlines(True),fromfile=parent.name,tofile=target.name))
with (H/'final-global-v2.diff').open('x',encoding='utf-8',newline='\n') as f:f.write(diff)
print(json.dumps({'helper':ref(target),'validator_dependencies':ref(H/'final-global-v2-validator-dependencies.json'),'parent':ref(parent)}))
