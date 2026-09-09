"""Add only actually present current receipts, source graphs and the prepared audit root."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, importlib.util, json, os
assert os.name == 'posix'
P = Path(__file__).resolve().parent
D = P.parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path':p.relative_to(R).as_posix(), 'sha256':sha(p)}
read = lambda p: json.loads(p.read_bytes())
base_path=P/'policy-final-physical-01.json'
assert sha(base_path)=='e88daec76088ab2cbd8f4a0c54aeabebdc053ee4275afe521f11b97e0b38402d'
checker=P/'check-publication-allowlist-v3.py'
assert sha(checker)=='8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
spec=importlib.util.spec_from_file_location('physical_present_policy',checker)
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
base=read(base_path);m.verify_policy(base)
new=json.loads(json.dumps(base))
added=[]
for p in sorted(S.glob('unblock-nine-*')):
    if not p.is_file() or p.suffix not in ('.json','.txt'): continue
    name=p.relative_to(R).as_posix()
    if name in base['allow_exact']: continue
    assert name not in base['exclude_exact'] and m.disposition(name,base)[0]!='hold'
    assert p.stat().st_size<90000000 and not p.is_symlink()
    added.append(ref(p))
graphs=[]
for ext in ('json','md'):
    p=S/'architecture-graphs'/('unblock-nine-physical-current-source.'+ext)
    assert p.is_file() and not p.is_symlink()
    graphs.append(ref(p))
new['allow_exact']=sorted(set(base['allow_exact'])|{p['path'] for p in added+graphs})
tid='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908'
task_path=S/'audits'/tid/'audit-task.json'
task=read(task_path)
assert task['task_id']==tid and task['target']=={
 'path':'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean',
 'declaration':'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'}
assert sha(R/task['target']['path'])=='192df235c8ec993ca6815c5cf2c0808c1ffc0087c6a87810f9e26be4fbcd704c'
assert read(task_path.parent/'route-exit.json')['exit_code']==0
prefix=task_path.parent.relative_to(R).as_posix()+'/'
assert prefix not in base['allow_prefixes']
new['allow_prefixes']=base['allow_prefixes']+[prefix]
m.verify_policy(new)
assert sorted(k for k in base if new[k]!=base[k])==['allow_exact','allow_prefixes']
for item in added+graphs: assert m.disposition(item['path'],new)[0]=='select'
assert m.disposition(task_path.relative_to(R).as_posix(),new)[0]=='select'
for ext in ('olean','ilean','pyc'):
    assert m.disposition(prefix+'generated.'+ext,new)[0]=='hold'
for item in added+graphs: assert sha(R/item['path'])==item['sha256']
def create(name,obj):
    with (P/name).open('xb') as f: f.write((json.dumps(obj,indent=2)+'\n').encode())
create('policy-final-physical-02.json',new)
create('policy-final-physical-02-derivation.json',{
 'format':'root-current-publication-evidence-extension-1',
 'prior_policy':ref(base_path), 'policy':ref(P/'policy-final-physical-02.json'),
 'checked_at_utc':datetime.now(timezone.utc).isoformat(), 'checker':ref(checker),
 'added_existing_receipts':added, 'added_actual_graphs':graphs,
 'added_actual_audit_prefix':prefix, 'actual_audit_task':ref(task_path),
 'actual_route_receipt':ref(task_path.parent/'route-exit.json'),
 'status':'ROOT_REVIEWED_SCOPE_EXTENSION_ONLY',
 'meaning':'Publish the actual fresh audit evidence and current verification receipts, including retained incomplete or failed outcomes; source acceptance is not inferred.',
 'archive_entries_and_raw_exclusions_unchanged':True,
 'source_paths_and_all_other_policy_fields_unchanged':True,
 'final_checker_or_staging_run':False})
print(json.dumps({'policy':ref(P/'policy-final-physical-02.json'),
 'derivation':ref(P/'policy-final-physical-02-derivation.json'),
 'added_receipts':len(added), 'added_graphs':len(graphs)}))

