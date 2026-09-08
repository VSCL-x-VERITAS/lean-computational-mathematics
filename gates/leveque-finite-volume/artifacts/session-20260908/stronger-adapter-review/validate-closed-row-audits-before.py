"""Revalidate every closed row with its exact manifest-bound sealed-v1 config.

Inventory mode is read-only preparation and does not claim audit validation.
Validation mode runs the unchanged complete validator for every selected row.
Neither mode writes a gate, a judgment, or an audit artifact.
"""
from pathlib import Path
import argparse,hashlib,json,os,subprocess,sys

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--validate',action='store_true')
 p.add_argument('--require-all-closed',action='store_true')
 a=p.parse_args();S=Path(__file__).resolve().parent;R=S.parents[3]
 read=lambda p:json.loads(p.read_text(encoding='utf-8'))
 sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
 gate=read(R/'gates/leveque-finite-volume/chapter-01.json')
 rows=sorted([r for r in gate['rows'] if r['status'] in {'PROVED','REUSED','DISCREPANCY'}],key=lambda r:r['id'])
 assert rows
 if a.require_all_closed:assert all(r['status'] in {'PROVED','REUSED','DISCREPANCY','SKIPPED'} for r in gate['rows'])
 inventory=[]
 for row in rows:
  assert row['status']!='DISCREPANCY','Discrepancy acceptance requires its separate witness/correction protocol.'
  task_path=R/row['faithfulness_task'];task=read(task_path);out=R/task['audit_output'];manifest=read(out/'manifest.json')
  assert manifest['task_id']==task['task_id'] and manifest['task_metadata']['sha256']==sha(task_path)
  assert (R/row['faithfulness_decision']).resolve()==(out/'decision.json').resolve()
  assert row['lean_declarations']==[task['target']['declaration']]
  assert manifest['target']['sha256']==sha(R/task['target']['path'])
  decision=read(out/'decision.json')
  assert decision['accepted'] is True and decision['classification']=='faithful-equivalent'
  assert all(decision['implications'][k]['verdict']=='yes' for k in ['lean_implies_source','source_implies_lean'])
  configs=[]
  for item in manifest['audit_setup']:
   path=R/item['path']
   if path.suffix=='.json' and 'config' in path.name:
    assert sha(path)==item['sha256']
    if read(path).get('schema_version')=='formalization-faithfulness-config-1':configs.append(item)
  assert len(configs)==1,(row['id'],configs)
  record={'row':row['id'],'task':task['task_id'],'declaration':task['target']['declaration'],
   'config':configs[0],'manifest_sha256':sha(out/'manifest.json'),'decision_sha256':sha(out/'decision.json')}
  if a.validate:
   env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG=str((R/configs[0]['path']).resolve()))
   command=[sys.executable,'-B',str(R/'.faithfulness-audit/scripts/validate_audit.py'),str(task_path),'--phase','complete']
   run=subprocess.run(command,cwd=R,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
   record.update({'command':command,'exit_code':run.returncode,'output_sha256':hashlib.sha256(run.stdout).hexdigest()})
   if run.returncode:
    sys.stdout.buffer.write(run.stdout);print(json.dumps(record));return run.returncode
  inventory.append(record)
 print(json.dumps({'mode':'released-complete-validation' if a.validate else 'inventory-only-not-validation','closed_rows':len(rows),'records':inventory},indent=2))
 return 0

if __name__=='__main__':raise SystemExit(main())
