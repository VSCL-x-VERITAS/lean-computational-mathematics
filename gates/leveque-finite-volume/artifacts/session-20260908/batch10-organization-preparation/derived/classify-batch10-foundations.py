"""Classify the nine committed generic leaves using their actual introduction commit."""
from pathlib import Path
import collections,datetime,hashlib,json,subprocess,sys
S=Path(__file__).resolve().parents[2];R=S.parents[3]
sys.path.insert(0,str(R/'tools/architecture'));import check_tiers
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,text=True).strip()
intro='24b3a281d19aac39ee745a4168a877bd82f78208';assert git('rev-parse','HEAD')==intro
path=R/'docs/architecture/tiers.json';before=path.read_bytes()
assert sha(path)=='d2e3d27cc54a09021083064eed68f45741e06b2255c672c0bd79dc2307002aa2'
manifest=json.loads(before);prefixes={r['prefix'].rstrip('.'):r['tier'] for r in manifest['prefixes']}
reviewpath=R/'gates/leveque-finite-volume/artifacts/session-20260908/root-batch10-production-placement-verification.json';assert sha(reviewpath)=='8a787a175719f797fe928c580048d2e349d88a7816848b77b98ea37fd7a0e37b'
review=json.loads(reviewpath.read_bytes())
assert (S/'batch10-foundations-organization-review.md').is_file()
assert len(review['files'])==9
for f in review['files']:
 module=f['module'];assert sha(R/f['path'])==f['sha256']
 assert module not in manifest['exact'] and not check_tiers.matching_prefixes(module,prefixes)
 assert git('log','--diff-filter=A','-1','--format=%H','--',f['path'])==intro
 manifest['exact'][module]='reusable'
 manifest['exact_rules'].append({'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable','rationale':'Generic information-returning method, field adapter, conditional flux errors, admitted coordinate updates/sweeps, Cartesian geometry/update correspondence or explicit example; no source-specific contract.','introduction':{'commit':intro,'date':git('show','-s','--format=%cI',intro),'determined_by':'diff_filter_add'},'review':{'reviewer':'Codex root executing the authorized Chapter 1 organization loop','status':'accepted','review_date':datetime.datetime.now(datetime.timezone.utc).isoformat(),'evidence':'gates/leveque-finite-volume/artifacts/session-20260908/batch10-foundations-organization-review.md'},'exception':None,'file_present':True})
manifest['exact']=dict(sorted(manifest['exact'].items()));manifest['exact_rules'].sort(key=lambda x:x['module'])
modules=check_tiers.production_modules(R);roles=collections.Counter();decided=collections.Counter()
for name in modules:
 role,rid=check_tiers.resolve(name,manifest['exact'],prefixes);assert role!='unclassified',name
 roles[role]+=1;decided[rid]+=1
for rule in manifest['prefix_rules']:rule['modules_decided']=decided[rule['rule_id']]
manifest['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(manifest['exact']),'exact_rules_with_absent_file':0,'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decided['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
assert len(modules)==5968 and roles['source']==1512 and roles['reusable']==663
assert manifest['prefixes']==json.loads(before)['prefixes']
assert manifest['prefix_rules']==json.loads(before)['prefix_rules']
assert not check_tiers.validate(R,manifest,modules)
with (S/('batch10-tiers-before-'+hashlib.sha256(before).hexdigest()+'.json')).open('xb') as f:f.write(before)
path.write_text(json.dumps(manifest,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'introduction_commit':intro,'new_exact_rules':9,'counts':manifest['counts'],'before_sha256':hashlib.sha256(before).hexdigest(),'sha256':sha(path)}
with (S/'batch10-tier-update.json').open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
