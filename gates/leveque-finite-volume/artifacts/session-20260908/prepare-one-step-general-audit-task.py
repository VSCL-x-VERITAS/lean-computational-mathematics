from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_text(encoding='utf-8'))
old='LEV-CH01-ONE-STEP-METHOD-DEFINITION-PRODUCTION-20260908';new='LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908'
prior=S/'audits'/old;dest=S/'audits'/new
assert sha(prior/'faithfulness/decision.json')=='407f81e19b77273538f53bce5cb3894398d0615ca932a6e87ca02f37071b80d7'
assert sha(S/'one-step-general-production-verification.json')=='0fd3d90431d8d44c6326d7cfebef50bc4480932fdd7fd6f41de4c9207a863699'
task=read(prior/'audit-task.json');assert sha(R/task['source']['path'])==task['source']['sha256']
task['task_id']=new;task['target']={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/OneStepCurrentData.lean','declaration':'NumStability.leveque01_oneStepMethod_iff_attainableCurrentDataMap'}
assert sha(R/task['target']['path'])=='8d5cc4073cd1cf377bca28100150fbebfa08fc6fe40bee6074816bf73646a73d'
task['audit_output']=(dest/'faithfulness').relative_to(R).as_posix();assert not dest.exists();dest.mkdir()
path=dest/'audit-task.json';path.write_text(json.dumps(task,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
lineage={'schema':1,'task_id':new,'task_sha256':sha(path),'config_sha256':sha(S/'audit.config.json'),'target':task['target'],'target_source_sha256':sha(R/task['target']['path']),'pages_argument':'31,32,33','prior_task':old,'prior_decision_sha256':sha(prior/'faithfulness/decision.json'),'production_verification_sha256':sha(S/'one-step-general-production-verification.json'),'change':'Arbitrary admissible History, CurrentData and NextData, with factor only on the actual current-data range. Source bytes and locator unchanged; no user-selected interpretation or acceptance inferred.'}
p=dest/'general-domain-lineage.json';p.write_text(json.dumps(lineage,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'task':path.relative_to(R).as_posix(),'task_sha256':sha(path),'lineage_sha256':sha(p)}))
