"""Expose/classify the one approved constant-flux leaf. No Git, build or gate action."""
from pathlib import Path
from datetime import datetime,timezone
import collections,hashlib,json,os,sys
assert os.name!='nt','Use the established POSIX launcher.'
H=Path(__file__).resolve().parent
R=next(p for p in H.parents if (p/'lean-toolchain').is_file())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def create(p,b):
 with p.open('xb') as f:f.write(b)
def write(p,v):create(p,(json.dumps(v,indent=2,ensure_ascii=False)+'\n').encode())
assert len(sys.argv)==3
config_path=Path(sys.argv[1]).resolve();assert config_path.parent==H and sha(config_path)==sys.argv[2]
c=json.loads(config_path.read_bytes())
assert c['input_commit']=='b8ccf0d8bd610b599b13708e8c8518771bcf71ab'
assert c['script']==ref(Path(__file__)) and c['review']==ref(H/'REVIEW.md')
for pin in c['before']+c['relocated_sources']+[c['relocation_receipt']]:assert ref(R/pin['path'])==pin
module='ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ConstantFluxHyperbolicity'
leaf=R/(module.replace('.','/')+'.lean')
assert leaf.is_file()
analysis=R/'ComputationalMathematics/Analysis.lean';tier=R/'docs/architecture/tiers.json'
assert {x['path'] for x in c['before']}=={'ComputationalMathematics/Analysis.lean','docs/architecture/tiers.json'}
before_analysis=analysis.read_bytes();before_tier=tier.read_bytes()
sys.path.insert(0,str(R/'tools/architecture'))
import check_tiers
from project_roots import production_paths
modules=sorted(p.relative_to(R).as_posix()[:-5].replace('/','.') for p in production_paths(R))
assert len(modules)==len(set(modules)) and modules.count(module)==1
m=json.loads(before_tier);old_modules=[x for x in modules if x!=module]
assert len(old_modules)==m['counts']['production_modules']==6024
assert check_tiers.validate(R,m,old_modules)==[]
prefixes={x['prefix']:x['tier'] for x in m['prefixes']}
assert module not in m['exact'] and not check_tiers.matching_prefixes(module,prefixes)
now=datetime.now(timezone.utc).isoformat()
m['exact'][module]='reusable'
new_rule={'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable',
 'rationale':'Source-independent constant-flux hyperbolicity using its actual zero derivative and standard real eigenbasis; the existing theorem is relocated unchanged from the general criteria owner.',
 'introduction':{'commit':c['input_commit'],'date':now,'determined_by':'current_worktree_relocation_at_recorded_input_commit'},
 'review':{'reviewer':'Codex root authorized the bounded constant-flux relocation; hyperbolicity_audit applied the reviewed organization metadata',
  'status':'accepted','review_date':now,'evidence':ref(H/'REVIEW.md')['path']},
 'exception':None,'file_present':True}
m['exact_rules'].append(new_rule);m['exact']=dict(sorted(m['exact'].items()));m['exact_rules'].sort(key=lambda x:x['rule_id'])
roles=collections.Counter();decisions=collections.Counter()
for name in modules:
 role,rid=check_tiers.resolve(name,m['exact'],prefixes)
 assert role not in ('unclassified','mixed');roles[role]+=1;decisions[rid]+=1
for rule in m['prefix_rules']:rule['modules_decided']=decisions[rule['rule_id']]
m['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(m['exact']),
 'exact_rules_with_absent_file':sum(not (R/(n.replace('.','/')+'.lean')).is_file() for n in m['exact']),
 'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decisions['prefix:'+p]==0 for p in prefixes),
 'production_modules':len(modules)}
assert check_tiers.validate(R,m,modules)==[]
prior=json.loads(before_tier)
assert {k:v for k,v in m.items() if k not in ('exact','exact_rules','counts','prefix_rules')}=={k:v for k,v in prior.items() if k not in ('exact','exact_rules','counts','prefix_rules')}
assert {k:v for k,v in m['exact'].items() if k!=module}==prior['exact']
assert [x for x in m['exact_rules'] if x['module']!=module]==prior['exact_rules']
assert m['prefix_rules']==prior['prefix_rules'],'No prefix decision changes expected for one exact leaf'
anchor=b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Discontinuity\n'
addition=('import '+module+'\n').encode()
assert before_analysis.count(anchor)==1 and addition not in before_analysis
after_analysis=before_analysis.replace(anchor,addition+anchor)
assert after_analysis.replace(addition,b'')==before_analysis
imports=[line.decode() for line in after_analysis.splitlines() if line.startswith(b'import ')]
assert imports==sorted(imports,key=str.casefold),'Preserve canonical casefold import order'
after_tier=(json.dumps(m,indent=1,ensure_ascii=False)+'\n').encode()
assert not (H/'receipt.json').exists()
create(H/'Analysis.before.lean',before_analysis);create(H/'tiers.before.json',before_tier)
write(H/'module-census.json',{'scope':'actual filesystem production roots, including the new unstaged leaf',
 'producer':ref(R/'tools/architecture/project_roots.py'),'modules':modules,'count':len(modules)})
for pin in c['before']+c['relocated_sources']+[c['relocation_receipt']]:assert ref(R/pin['path'])==pin
analysis.write_bytes(after_analysis);tier.write_bytes(after_tier)
assert sha(analysis)==hashlib.sha256(after_analysis).hexdigest() and sha(tier)==hashlib.sha256(after_tier).hexdigest()
assert check_tiers.validate(R,json.loads(tier.read_bytes()),modules)==[]
write(H/'receipt.json',{'format':'constant-flux-organization-relocation-1','input_commit':c['input_commit'],
 'script':ref(Path(__file__)),'config':ref(config_path),'review':ref(H/'REVIEW.md'),
 'relocation_receipt':c['relocation_receipt'],'relocated_sources':c['relocated_sources'],
 'before':c['before'],'before_snapshots':[ref(H/'Analysis.before.lean'),ref(H/'tiers.before.json')],
 'after':[ref(analysis),ref(tier)],'new_exact_rule':new_rule,'module_census':ref(H/'module-census.json'),
 'counts':m['counts'],'tier_validation_failures':[],'check_tiers':ref(R/'tools/architecture/check_tiers.py'),
 'only_metadata_paths_changed':['ComputationalMathematics/Analysis.lean','docs/architecture/tiers.json'],
 'builds_run':False,'audits_run':False,'gate_mutated':False,'git_invoked':False,'source_acceptance_inferred':False})
print(json.dumps({'receipt':ref(H/'receipt.json'),'after':[ref(analysis),ref(tier)],'counts':m['counts']},indent=2))
