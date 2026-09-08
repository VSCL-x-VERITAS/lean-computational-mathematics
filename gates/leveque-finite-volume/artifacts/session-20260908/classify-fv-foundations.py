"""Add measured exact tier rules for the committed FV foundation leaves."""
from pathlib import Path
import collections,datetime,hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sys.path.insert(0,str(R/'tools/architecture'));import check_tiers
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,text=True).strip()
path=R/'docs/architecture/tiers.json';before=path.read_bytes()
assert sha(path)=='bc6bdc9a4f5fe7adc507833365025a46555c44ae142d805bc4aef4508355213f'
m=json.loads(before);prefixes={r['prefix'].rstrip('.'):r['tier'] for r in m['prefixes']}
reasons={
'CellAverageEstimates':'Norm bound for differences of normalized interval averages in real complete normed spaces.',
'PhysicalFluxAverage':'Time-averaged physical face flux and exact finite-volume cell mass balance from rectangle conservation.',
'FluxUpdateError':'Weighted local and contiguous-block errors for arbitrary full-array numerical flux rules.',
'FluxUpdateErrorBounds':'Conditional next-cell and total block-mass error bounds with explicit old/face error premises.',
'LinearRiemannFluxAverage':'Actual selected linear Riemann method flux/trace averages and conditional comparison with an independent global field.'}
for leaf,rationale in reasons.items():
 module='ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'+leaf
 assert module not in m['exact'] and not check_tiers.matching_prefixes(module,prefixes)
 intro=git('log','--diff-filter=A','-1','--format=%H','--',module.replace('.','/')+'.lean')
 assert intro=='4d4bc03d138206b13024d8ef353ea85c89181a46'
 m['exact'][module]='reusable'
 m['exact_rules'].append({'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable','rationale':rationale,'introduction':{'commit':intro,'date':git('show','-s','--format=%cI',intro),'determined_by':'diff_filter_add'},'review':{'reviewer':'Codex root executing the authorized Chapter 1 organization loop','status':'accepted','review_date':datetime.datetime.now(datetime.timezone.utc).isoformat(),'evidence':'gates/leveque-finite-volume/artifacts/session-20260908/fv-foundations-organization-review.md'},'exception':None,'file_present':True})
m['exact']=dict(sorted(m['exact'].items()));m['exact_rules'].sort(key=lambda x:x['module'])
modules=check_tiers.production_modules(R);roles=collections.Counter();decided=collections.Counter()
for name in modules:
 role,rid=check_tiers.resolve(name,m['exact'],prefixes);assert role!='unclassified',name
 roles[role]+=1;decided[rid]+=1
for rule in m['prefix_rules']:rule['modules_decided']=decided[rule['rule_id']]
m['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(m['exact']),'exact_rules_with_absent_file':0,'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decided['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
assert len(modules)==5943 and roles['source']==1512 and roles['reusable']==638
assert not check_tiers.validate(R,m,modules)
snapshot=S/('fv-foundations-tiers-before-'+hashlib.sha256(before).hexdigest()+'.json')
with snapshot.open('xb') as f:f.write(before)
path.write_text(json.dumps(m,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'introduction_commit':intro,'new_exact_rules':5,'counts':m['counts'],'before_sha256':hashlib.sha256(before).hexdigest(),'sha256':sha(path)}
out=S/'fv-foundations-tier-update.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))

