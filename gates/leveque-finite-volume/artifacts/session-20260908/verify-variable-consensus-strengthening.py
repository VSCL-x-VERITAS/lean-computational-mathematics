"""Read-only verification of the exact stronger-consensus evidence."""
from pathlib import Path
import hashlib,importlib.util,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
path=S/'bind-variable-consensus-stronger-row.py'
assert sha(path)=='e4b0e2d242e7fc7e91e955e3c828bc43992cc4748493c2f4b0d2bea2716f8b4c'
spec=importlib.util.spec_from_file_location('variable_consensus_checks',path)
mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
pins=mod.pins();pin=pins['rows'][0]
taskpath=S/'audits'/pin['task_id']/'audit-task.json';task=mod.read(taskpath);out=R/task['audit_output']
fields=mod.validate_strengthening_evidence(R,taskpath,task,mod.read(out/'manifest.json'),mod.read(out/'decision.json'),R/pin['evidence']['path'])
assert fields['source_ambiguity_note'] and fields['consensus_audit']
print(json.dumps({'schema':1,'task':pin['task_id'],'decision_sha256':pin['decision_sha256'],'evidence_sha256':pin['evidence']['sha256'],'native_applicability_verified':True,'source_only_ambiguities_preserved':True,'independent_judge_agreement_verified':True,'adjudicator_invoked':False,'gate_written':False}))

