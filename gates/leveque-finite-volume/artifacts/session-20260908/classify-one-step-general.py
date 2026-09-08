from pathlib import Path
import collections,datetime,hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3];sys.path.insert(0,str(R/'tools/architecture'))
import check_tiers
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
path=R/'docs/architecture/tiers.json';before=path.read_bytes();m=json.loads(before)
module='ComputationalMathematics.Logic.Function.RangeFactorization';assert module not in m['exact']
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,text=True).strip()
intro=git('log','--diff-filter=A','-1','--format=%H','--',module.replace('.','/')+'.lean');assert intro=='7707ce2ecade640cbacc8f5fe08ad3bd7c3213a3'
prefixes={r['prefix'].rstrip('.'):r['tier'] for r in m['prefixes']}
assert not check_tiers.matching_prefixes(module,prefixes)
m['exact'][module]='reusable';m['exact']=dict(sorted(m['exact'].items()))
m['exact_rules'].append({'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable','rationale':'Source-independent factorization through an actual range, without a nonempty output type or extension to unattainable inputs.','introduction':{'commit':intro,'date':git('show','-s','--format=%cI',intro),'determined_by':'diff_filter_add'},'review':{'reviewer':'Codex root executing the authorized Chapter 1 organization loop','status':'accepted','review_date':datetime.datetime.now(datetime.timezone.utc).isoformat(),'evidence':'gates/leveque-finite-volume/artifacts/session-20260908/one-step-general-organization-review.md'},'exception':None,'file_present':True})
m['exact_rules'].sort(key=lambda x:x['module'])
modules=check_tiers.production_modules(R);roles=collections.Counter();decided=collections.Counter()
for name in modules:
 role,rid=check_tiers.resolve(name,m['exact'],prefixes);assert role!='unclassified',name;roles[role]+=1;decided[rid]+=1
for rule in m['prefix_rules']:rule['modules_decided']=decided[rule['rule_id']]
m['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(m['exact']),'exact_rules_with_absent_file':0,'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decided['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
assert len(modules)==5934 and roles['source']==1510 and roles['reusable']==631
assert not check_tiers.validate(R,m,modules)
snapshot=S/('one-step-tiers-before-'+hashlib.sha256(before).hexdigest()+'.json');assert not snapshot.exists();snapshot.write_bytes(before)
path.write_text(json.dumps(m,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
receipt={'schema':1,'introduction_commit':intro,'new_exact_rules':1,'source_wrapper':'Covered by existing reviewed source prefix; measured census updated.','counts':m['counts'],'before_sha256':hashlib.sha256(before).hexdigest(),'sha256':sha(path)}
(S/'one-step-general-tier-update.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt))
