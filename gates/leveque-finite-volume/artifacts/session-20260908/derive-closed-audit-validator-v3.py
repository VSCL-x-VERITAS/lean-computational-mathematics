"""Extend exact closed-audit verification for one pinned stronger consensus."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
parent=S/'validate-closed-row-audits-v2.py';assert sha(parent)=='6beb4fd9fdb5ac2e7d8c66702f9232be797559151ad618d13c19a006b3fea20e'
adapter=S/'bind-variable-consensus-stronger-row.py';assert sha(adapter)=='e4b0e2d242e7fc7e91e955e3c828bc43992cc4748493c2f4b0d2bea2716f8b4c'
text=parent.read_text(encoding='utf-8')
needle='    pspec.loader.exec_module(production)\n'
addition="""    consensus_path = session / 'bind-variable-consensus-stronger-row.py'
    require(sha(consensus_path) == 'e4b0e2d242e7fc7e91e955e3c828bc43992cc4748493c2f4b0d2bea2716f8b4c',
            'Pinned stronger consensus checker changed')
    cspec = importlib.util.spec_from_file_location('variable_consensus_checks', consensus_path)
    consensus = importlib.util.module_from_spec(cspec)
    require(cspec.loader is not None, 'Missing consensus evidence loader')
    cspec.loader.exec_module(consensus)
"""
assert text.count(needle)==1;text=text.replace(needle,needle+addition)
needle="        if classification == 'faithful-stronger':\n"
addition="""        if classification == 'faithful-stronger' and row['id'] == 'LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION':
            require(decision.get('adjudicated') is False
                    and row.get('adjudication_required') is False
                    and not row.get('adjudication_status') and not row.get('adjudication_audit'),
                    'The pinned agreeing audit must preserve the absence of adjudication')
            evidence_path = stronger.bound_file(root, row.get('strengthening_evidence'))
            consensus.validate_strengthening_evidence(root, task_path, task, manifest, decision,
                                                      evidence_path, row=row)
            record['strengthening_evidence'] = row['strengthening_evidence']
            record['native_nonvacuity_checks'] = 'exact source/output/exit hashes, command, actual zero exit and allowed axioms verified'
            record['independent_consensus'] = 'Both original judges agree on yes/no faithful-stronger; no adjudication trigger or adjudicator was recorded.'
        elif classification == 'faithful-stronger':
"""
assert text.count(needle)==1;text=text.replace(needle,addition)
ast.parse(text)
dest=S/'validate-closed-row-audits-v3.py'
with dest.open('x',encoding='utf-8',newline='\n') as f:f.write(text)
record={'schema':1,'parent':{'path':parent.name,'sha256':sha(parent)},'derived':{'path':dest.name,'sha256':sha(dest)},'consensus_adapter':{'path':adapter.name,'sha256':sha(adapter)},'change':'Add exact task-pinned agreeing-judge stronger verification while retaining all previous adjudicated stronger and ordinary complete validation paths unchanged.','gate_or_audit_changed':False}
out=S/'closed-audit-validator-v3-derivation.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'derivation_sha256':sha(out)}))

