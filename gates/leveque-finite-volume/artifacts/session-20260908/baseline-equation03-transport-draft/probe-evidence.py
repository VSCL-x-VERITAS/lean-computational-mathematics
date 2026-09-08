from pathlib import Path
import json,subprocess,sys
sys.stdout.reconfigure(encoding='utf-8')
P=Path(__file__).resolve().parent; R=P.parents[4]
C='c4bfd6deb756ba46184c9418edc83bda33084719'
S='gates/leveque-finite-volume/artifacts/session-20260908/'
A=S+'audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/'
def blob(p):return subprocess.check_output(['git','-c','core.longpaths=true','show',C+':'+p],cwd=R)
for p in ['faithfulness/manifest.json','faithfulness/agent_outputs/agent_runs.json','faithfulness/orchestration/b_runtime.json']:
 o=json.loads(blob(A+p))
 print(p)
 if p.endswith('manifest.json'):
  print(json.dumps({k:({'keys':list(v) if isinstance(v,dict) else None,'count':len(v),'head':str(v)[:600]} if isinstance(v,(dict,list)) else v) for k,v in o.items()},indent=2))
 elif 'agent_runs' in p: print(json.dumps(o,indent=2)[:5000])
 else:print(json.dumps(o,indent=2))
