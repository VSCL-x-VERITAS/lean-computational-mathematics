"""Classify the ten committed generic leaves using their actual introduction commit."""
from pathlib import Path
import collections,datetime,hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sys.path.insert(0,str(R/'tools/architecture'));import check_tiers
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,text=True).strip()
intro='03c81fa2a551b5089133c958deedc4828899adbd';assert git('rev-parse','HEAD')==intro
path=R/'docs/architecture/tiers.json';before=path.read_bytes()
assert sha(path)=='7e7bd763431edadb9e87b4deb48e1bc7796a3294907b6b06f69c1a57304b244e'
manifest=json.loads(before);prefixes={r['prefix'].rstrip('.'):r['tier'] for r in manifest['prefixes']}
review=json.loads((S/'root-batch8-placement-verification.json').read_bytes())
assert len(review['files'])==10
for f in review['files']:
 module=f['module'];assert sha(R/f['path'])==f['sha256']
 assert module not in manifest['exact'] and not check_tiers.matching_prefixes(module,prefixes)
 assert git('log','--diff-filter=A','-1','--format=%H','--',f['path'])==intro
 manifest['exact'][module]='reusable'
 manifest['exact_rules'].append({'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable','rationale':'Generic mathematics or explicit example in the reviewed jump, rectangle production balance, coordinate-line conservation or admitted-method flux-error API; no source-specific contract.','introduction':{'commit':intro,'date':git('show','-s','--format=%cI',intro),'determined_by':'diff_filter_add'},'review':{'reviewer':'Codex root executing the authorized Chapter 1 organization loop','status':'accepted','review_date':datetime.datetime.now(datetime.timezone.utc).isoformat(),'evidence':'gates/leveque-finite-volume/artifacts/session-20260908/batch8-foundations-organization-review.md'},'exception':None,'file_present':True})
manifest['exact']=dict(sorted(manifest['exact'].items()));manifest['exact_rules'].sort(key=lambda x:x['module'])
modules=check_tiers.production_modules(R);roles=collections.Counter();decided=collections.Counter()
for name in modules:
 role,rid=check_tiers.resolve(name,manifest['exact'],prefixes);assert role!='unclassified',name
 roles[role]+=1;decided[rid]+=1
for rule in manifest['prefix_rules']:rule['modules_decided']=decided[rule['rule_id']]
manifest['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(manifest['exact']),'exact_rules_with_absent_file':0,'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decided['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
assert len(modules)==5953 and roles['source']==1512 and roles['reusable']==648
assert not check_tiers.validate(R,manifest,modules)
with (S/('batch8-tiers-before-'+hashlib.sha256(before).hexdigest()+'.json')).open('xb') as f:f.write(before)
path.write_text(json.dumps(manifest,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'introduction_commit':intro,'new_exact_rules':10,'counts':manifest['counts'],'before_sha256':hashlib.sha256(before).hexdigest(),'sha256':sha(path)}
with (S/'batch8-tier-update.json').open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
