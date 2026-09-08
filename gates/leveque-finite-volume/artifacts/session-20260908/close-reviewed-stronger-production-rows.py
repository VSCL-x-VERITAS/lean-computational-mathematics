"""Run the two reviewed stronger adapters sequentially with their sealed configurations."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--gate-checker',type=Path,required=True);p.add_argument('--label',required=True);p.add_argument('--execute',action='store_true');a=p.parse_args()
assert os.name!='nt' and a.label.replace('-','').isalnum()
path=S/'bind-audited-stronger-production-rows.py'
spec=importlib.util.spec_from_file_location('stronger_production',path);adapter=importlib.util.module_from_spec(spec);spec.loader.exec_module(adapter)
data=adapter.pins();plans=[]
for pin in data['rows']:
 taskpath=S/'audits'/pin['task_id']/'audit-task.json';task=adapter.read(taskpath);out=R/task['audit_output'];manifest=adapter.read(out/'manifest.json');decision=adapter.read(out/'decision.json')
 evidence=adapter.bound_file(R,pin['evidence']);adapter.validate_strengthening_evidence(R,taskpath,task,manifest,decision,evidence)
 config=adapter.exact_manifest_config(R,manifest)
 cmd=[sys.executable,'-B',str(path),'--gate-checker',str(a.gate_checker),'--gate',str(R/'gates/leveque-finite-volume/chapter-01.json'),'--task',str(taskpath),'--row',pin['row'],'--strengthening-evidence',str(evidence)]
 plans.append({'row':pin['row'],'config':str(config),'command':cmd})
directory=S/a.label;directory.mkdir(exist_ok=False)
records=[]
for i,plan in enumerate(plans,1):
 if a.execute:
  result=subprocess.run(plan['command'],cwd=R,env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG=plan['config']),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
  for label,raw in [('stdout',result.stdout),('stderr',result.stderr)]:
   out=directory/f'{i:02d}-{label}.txt';out.write_bytes(raw);plan[label]={'path':out.relative_to(R).as_posix(),'sha256':adapter.sha(out)}
  plan['exit_code']=result.returncode
 records.append(plan)
 (directory/'progress.json').write_text(json.dumps({'mode':'execute' if a.execute else 'preflight','adapter_sha256':adapter.sha(path),'steps':records},indent=2)+'\n',encoding='utf-8')
 if a.execute and result.returncode:
  sys.stdout.buffer.write(result.stdout);sys.stderr.buffer.write(result.stderr);raise SystemExit(result.returncode)
print(json.dumps({'mode':'execute' if a.execute else 'preflight','rows':len(plans),'record':str(directory/'progress.json'),'record_sha256':adapter.sha(directory/'progress.json')}))
