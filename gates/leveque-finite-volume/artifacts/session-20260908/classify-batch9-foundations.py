"""Classify the six committed generic leaves using their actual introduction commit."""
from pathlib import Path
import collections,datetime,hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sys.path.insert(0,str(R/'tools/architecture'));import check_tiers
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,text=True).strip()
intro='521f73a23a95a842928c581fa011a46379b3b547';assert git('rev-parse','HEAD')==intro
path=R/'docs/architecture/tiers.json';before=path.read_bytes()
assert sha(path)=='b2b31b08695ca45d1594adc1709e714af0373c560e3bafbc1a8ede2e5f3e6510'
manifest=json.loads(before);prefixes={r['prefix'].rstrip('.'):r['tier'] for r in manifest['prefixes']}
review=json.loads((S/'root-batch9-production-placement-verification.json').read_bytes())
assert len(review['files'])==6
for f in review['files']:
 module=f['module'];assert sha(R/f['path'])==f['sha256']
 assert module not in manifest['exact'] and not check_tiers.matching_prefixes(module,prefixes)
 assert git('log','--diff-filter=A','-1','--format=%H','--',f['path'])==intro
 manifest['exact'][module]='reusable'
 manifest['exact_rules'].append({'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable','rationale':'Generic normalized-average laws, trace estimate, returned-field method, conditional error estimates or explicit example; no source-specific contract.','introduction':{'commit':intro,'date':git('show','-s','--format=%cI',intro),'determined_by':'diff_filter_add'},'review':{'reviewer':'Codex root executing the authorized Chapter 1 organization loop','status':'accepted','review_date':datetime.datetime.now(datetime.timezone.utc).isoformat(),'evidence':'gates/leveque-finite-volume/artifacts/session-20260908/batch9-foundations-organization-review.md'},'exception':None,'file_present':True})
manifest['exact']=dict(sorted(manifest['exact'].items()));manifest['exact_rules'].sort(key=lambda x:x['module'])
modules=check_tiers.production_modules(R);roles=collections.Counter();decided=collections.Counter()
for name in modules:
 role,rid=check_tiers.resolve(name,manifest['exact'],prefixes);assert role!='unclassified',name
 roles[role]+=1;decided[rid]+=1
for rule in manifest['prefix_rules']:rule['modules_decided']=decided[rule['rule_id']]
manifest['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(manifest['exact']),'exact_rules_with_absent_file':0,'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decided['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
assert len(modules)==5959 and roles['source']==1512 and roles['reusable']==654
assert not check_tiers.validate(R,manifest,modules)
with (S/('batch9-tiers-before-'+hashlib.sha256(before).hexdigest()+'.json')).open('xb') as f:f.write(before)
path.write_text(json.dumps(manifest,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'introduction_commit':intro,'new_exact_rules':6,'counts':manifest['counts'],'before_sha256':hashlib.sha256(before).hexdigest(),'sha256':sha(path)}
with (S/'batch9-tier-update.json').open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
