"""Select the existing strict closure adapter for one reviewed default audit.

The caller supplies the exact decision hash after reviewing the completed report.
This wrapper creates no judgment; the strict adapter revalidates the sealed run.
Only the untouched default-config task set in the frozen coordinator handoff is eligible.
"""
from pathlib import Path
import argparse,hashlib,json,os,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--task',required=True);p.add_argument('--row',required=True)
p.add_argument('--reviewed-decision-sha256',required=True);p.add_argument('--gate-checker',type=Path,required=True)
a=p.parse_args();read=lambda p:json.loads(p.read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
handoff=S/'audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/coordinator-handoff-20260908.json'
assert sha(handoff)=='0506bd8f4846d9725c1141b9cc390bf35aa93e67982336c7dca9ded647f71e1f'
entry=next(x for x in read(handoff)['pending'] if x['task_id']==a.task)
config=S/'audit.config.json';assert sha(config)==entry['config_sha256']
taskpath=S/'audits'/a.task/'audit-task.json';task=read(taskpath);out=R/task['audit_output']
assert sha(taskpath)==entry['task_sha256'] and task['target']==entry['target']
assert sha(R/task['target']['path'])==entry['target_source_sha256']
assert sha(out/'decision.json')==a.reviewed_decision_sha256
d=read(out/'decision.json');assert d['accepted'] is True and d['classification']=='faithful-equivalent'
assert not any('interpretation-qualified' in f.get('category','').replace(' ','-') for f in d['findings']), 'Use the separately scoped interpreted adapter.'
manifest=S/'chapter01-current-producer-inputs.json';m=read(manifest)
selected=[f for f in m['files'] if f['row']==a.row]
assert len(selected)==1 and selected[0]['task_id']==a.task and selected[0]['path']==task['target']['path']
assert selected[0]['sha256']==sha(R/task['target']['path'])
base='9e2225705fed906b1120d55105d607baabef57c9'
existing=subprocess.run(['git','-c','core.longpaths=true','cat-file','blob',base+':'+task['target']['path']],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
if existing.returncode==0:
 assert existing.stdout==(R/task['target']['path']).read_bytes(),'Integrated producer changed; review its provenance before closure.'
 helper=S/('close-adjudicated-reused-row.py' if d['adjudicated'] else 'close-reused-row.py')
 disposition='REUSED'
else:
 assert existing.returncode==128,existing.stderr
 assert subprocess.check_output(['git','-c','core.longpaths=true','ls-tree','-z',base,'--',task['target']['path']],cwd=R)==b''
 helper=S/'close-audited-proved-row.py';disposition='PROVED'
args=[sys.executable,str(helper),'--gate-checker',str(a.gate_checker),'--gate',str(R/'gates/leveque-finite-volume/chapter-01.json'),
 '--task',str(taskpath),'--row',a.row,'--resolution-log',str(S/'chapter01-current-producer-checks-output.txt')]
if disposition=='PROVED':args+=['--resolution-exit',str(S/'chapter01-current-producer-checks-exit.json'),
 '--resolution-manifest',str(manifest),'--check-file',str(S/'chapter01-current-producer-checks.lean')]
env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG=str(config))
run=subprocess.run(args,cwd=R,env=env)
if run.returncode==0:print(json.dumps({'row':a.row,'task':a.task,'disposition':disposition,'reviewed_decision_sha256':a.reviewed_decision_sha256,'adapter':helper.name}))
raise SystemExit(run.returncode)
