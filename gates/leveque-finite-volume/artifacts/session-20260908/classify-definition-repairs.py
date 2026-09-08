"""Add measured tier rules for the committed definition increment."""
from pathlib import Path
import collections, datetime, hashlib, json, subprocess, sys
S=Path(__file__).resolve().parent; R=S.parents[3]
sys.path.insert(0,str(R/'tools/architecture'))
import check_tiers
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,text=True).strip()
path=R/'docs/architecture/tiers.json'; before=path.read_bytes(); m=json.loads(before)
prefixes={r['prefix'].rstrip('.'):r['tier'] for r in m['prefixes']}
rules={
 'ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation':'Concrete first-order equation, its actual residual and matching principal-matrix hyperbolicity, independent of a numbered source.',
 'ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann':'Hyperbolic first-order initial-value problem data, strict half-line states and distinct-jump subfamily, independent of a source or selected solution theory.'}
for module,rationale in rules.items():
 assert module not in m['exact'] and not check_tiers.matching_prefixes(module,prefixes)
 intro=git('log','--diff-filter=A','-1','--format=%H','--',module.replace('.','/')+'.lean')
 assert intro=='3239b41c4fc9a0232b8f098c19c1a43a2491de96'
 m['exact'][module]='reusable'
 m['exact_rules'].append({'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable','rationale':rationale,
  'introduction':{'commit':intro,'date':git('show','-s','--format=%cI',intro),'determined_by':'diff_filter_add'},
  'review':{'reviewer':'Codex root executing the authorized Chapter 1 organization loop','status':'accepted','review_date':datetime.datetime.now(datetime.timezone.utc).isoformat(),'evidence':'gates/leveque-finite-volume/artifacts/session-20260908/definition-repairs-organization-review.md'},
  'exception':None,'file_present':True})
m['exact']=dict(sorted(m['exact'].items())); m['exact_rules'].sort(key=lambda x:x['module'])
modules=check_tiers.production_modules(R); roles=collections.Counter(); decided=collections.Counter()
for name in modules:
 role,rid=check_tiers.resolve(name,m['exact'],prefixes); assert role!='unclassified',name
 roles[role]+=1; decided[rid]+=1
for rule in m['prefix_rules']:rule['modules_decided']=decided[rule['rule_id']]
m['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(m['exact']),'exact_rules_with_absent_file':0,'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decided['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
assert len(modules)==5938 and roles['source']==1512 and roles['reusable']==633
assert not check_tiers.validate(R,m,modules)
snapshot=S/('definition-tiers-before-'+hashlib.sha256(before).hexdigest()+'.json')
assert not snapshot.exists(); snapshot.write_bytes(before)
path.write_text(json.dumps(m,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'introduction_commit':intro,'new_exact_rules':2,'source_wrappers':'Covered by the existing source prefix; measured full census updated.',
 'counts':m['counts'],'before_sha256':hashlib.sha256(before).hexdigest(),'sha256':sha(path)}
receipt=S/'definition-repairs-tier-update.json'; assert not receipt.exists()
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record))
