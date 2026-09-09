"""Finish the interrupted tier census with nine explicitly reviewed reusable rules."""
from pathlib import Path
from datetime import datetime,timezone
import collections,hashlib,json,os,subprocess,sys
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];out=D/'organization-local-replacements'
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
sys.path.insert(0,str(R/'tools/architecture'));import check_tiers as tiers
mp=R/'docs/architecture/tiers.json';old=mp.read_bytes()
assert old==(out/'tiers-before.json').read_bytes()
manifest=json.loads(old);modules=tiers.production_modules(R)
prefixes={v['prefix']:v['tier'] for v in manifest['prefixes']}
unclassified=[m for m in modules if tiers.resolve(m,manifest['exact'],prefixes)[0]=='unclassified']
names={'CartesianDirectionalReference','DirectionalMethodSweep','DirectionalReference','DirectionalReferenceError','Examples.PhysicalIntervalSweep','LocalCellErrorBounds','LocalRiemannInformation','LocalRiemannInformationUpdate','PhysicalCoordinateGeometry'}
assert set(unclassified)=={'ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'+n for n in names}
head=subprocess.run(['git','rev-parse','HEAD'],cwd=R,capture_output=True,check=True,text=True).stdout.strip()
assert head=='5e3f63594aa964263469ada134aee2809559d50d'
now=datetime.now(timezone.utc).isoformat()
review=(out/'REVIEW.md').relative_to(R).as_posix()
for module in sorted(unclassified):
 assert not tiers.matching_prefixes(module,prefixes)
 manifest['exact'][module]='reusable'
 manifest['exact_rules'].append({'rule_id':'exact:'+module,'match_kind':'exact','module':module,'role':'reusable',
 'rationale':'Generic local conservation/error, admitted Riemann information, measured directional reference/sweep API or a concrete example; source-specific statements reside in Source/LeVeque wrappers.',
 'introduction':{'commit':head,'date':now,'determined_by':'current_worktree_addition_at_recorded_input_commit'},
 'review':{'reviewer':'Codex root executing the authorized Chapter 1 organization loop','status':'accepted','review_date':now,'evidence':review},
 'exception':None,'file_present':True})
manifest['exact']=dict(sorted(manifest['exact'].items()))
manifest['exact_rules'].sort(key=lambda v:v['rule_id'])
roles=collections.Counter();decisions=collections.Counter()
for module in modules:
 role,rid=tiers.resolve(module,manifest['exact'],prefixes)
 assert role not in ('unclassified','mixed')
 roles[role]+=1;decisions[rid]+=1
for rule in manifest['prefix_rules']:rule['modules_decided']=decisions[rule['rule_id']]
manifest['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(manifest['exact']),
 'exact_rules_with_absent_file':sum(not(R/(m.replace('.','/')+'.lean')).is_file() for m in manifest['exact']),
 'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decisions['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
failures=tiers.validate(R,manifest,modules);assert not failures,failures
mp.write_text(json.dumps(manifest,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
staged=subprocess.run(['git','add','--',mp.relative_to(R).as_posix()],cwd=R,capture_output=True)
assert staged.returncode==0,staged.stderr
receipt={'schema':1,'input_commit':head,'review_sha256':sha(R/review),'tiers_before_sha256':hashlib.sha256(old).hexdigest(),
 'tiers_after_sha256':sha(mp),'new_exact_rules':unclassified,'counts':manifest['counts'],'validation_failures':failures,
 'tier_stage_exit_code':staged.returncode,'aggregate_before_sha256':sha(out/'aggregate-before.lean.txt'),
 'aggregate_after_sha256':sha(R/'ComputationalMathematics/Source/LeVeque/Chapter01.lean'),'prior_attempt_exit_code':1,
 'prior_failure':'No reusable prefix applies to nine new modules; explicit rules supplied after review.'}
with (out/'receipt.json').open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt))
