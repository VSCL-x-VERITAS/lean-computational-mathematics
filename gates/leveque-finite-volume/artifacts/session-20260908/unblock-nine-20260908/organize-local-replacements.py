"""Expose three repaired source targets and census twelve additive production leaves."""
from pathlib import Path
import collections, hashlib, json, os, subprocess, sys
D=Path(__file__).resolve().parent; S=D.parent; R=S.parents[3]
assert os.name != 'nt', 'Run through the POSIX workflow launcher.'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins={v['path']:v['sha256'] for v in json.loads((D/'dimensional-method-production/placement-inventory.json').read_bytes())['files']}
pins.update({
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalCellErrorBounds.lean':'1d4916271a563a9e970ace21deff6e69a7d7ad0d16065c95f9320c521d77d14e',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformation.lean':'ba7190f2a87957bbe87ba2c095398cb56106a06f71e70480d89f98f4eff990ec',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformationUpdate.lean':'f6969c39f2d3052cc59516c4a07ed1e2299e4155afad2d48ea9395c632efeb76',
 'ComputationalMathematics/Source/LeVeque/Chapter01/FiniteVolumeLocalFluxUpdate.lean':'669f818bde8cc0e616ad63a9bcc5d05791da132d4edcdb2d6286a769193fde7b',
 'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalInformationInterface.lean':'713c7c9908e0d5757a147895cc64c7258ebaa94a6c2d5b2e67befabfb0632730'})
assert len(pins)==12 and all(sha(R/p)==h for p,h in pins.items())
out=D/'organization-local-replacements'; out.mkdir()
aggregate=R/'ComputationalMathematics/Source/LeVeque/Chapter01.lean'
raw=aggregate.read_bytes(); (out/'aggregate-before.lean.txt').write_bytes(raw)
lines=raw.decode().splitlines(); indices=[i for i,l in enumerate(lines) if l.startswith('import ')]
assert indices==list(range(indices[0],indices[-1]+1))
imports=set(lines[indices[0]:indices[-1]+1])
new={'import '+p[:-5].replace('/','.') for p in pins if '/Source/' in p}
assert len(new)==3 and not imports & new
lines[indices[0]:indices[-1]+1]=sorted(imports|new)
aggregate.write_text('\n'.join(lines)+'\n',encoding='utf-8',newline='\n')
command=['git','add','--',*sorted(pins),aggregate.relative_to(R).as_posix()]
p=subprocess.run(command,cwd=R,capture_output=True)
(out/'stage-output.txt').write_bytes(p.stdout); (out/'stage-stderr.txt').write_bytes(p.stderr)
assert p.returncode==0,p.stderr
sys.path.insert(0,str(R/'tools/architecture')); import check_tiers as tiers
mp=R/'docs/architecture/tiers.json'; old=mp.read_bytes(); (out/'tiers-before.json').write_bytes(old)
manifest=json.loads(old); modules=tiers.production_modules(R)
prefixes={v['prefix']:v['tier'] for v in manifest['prefixes']}; roles=collections.Counter(); decisions=collections.Counter()
for module in modules:
 role,rid=tiers.resolve(module,manifest['exact'],prefixes)
 assert role not in ('unclassified','mixed'),module
 roles[role]+=1; decisions[rid]+=1
for path in pins:
 module=path[:-5].replace('/','.'); assert module in modules
 role,rid=tiers.resolve(module,manifest['exact'],prefixes)
 assert role==('source' if '/Source/' in path else 'reusable'),(module,role,rid)
for rule in manifest['prefix_rules']:rule['modules_decided']=decisions[rule['rule_id']]
manifest['counts']={'by_role':dict(sorted(roles.items())),'exact_rules':len(manifest['exact']),
 'exact_rules_with_absent_file':sum(not (R/(m.replace('.','/')+'.lean')).is_file() for m in manifest['exact']),
 'prefix_rules':len(prefixes),'prefix_rules_deciding_nothing':sum(decisions['prefix:'+p]==0 for p in prefixes),'production_modules':len(modules)}
assert not tiers.validate(R,manifest,modules)
mp.write_text(json.dumps(manifest,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
stage_tiers=subprocess.run(['git','add','--',mp.relative_to(R).as_posix()],cwd=R,capture_output=True)
assert stage_tiers.returncode==0,stage_tiers.stderr
assert all(sha(R/p)==h for p,h in pins.items())
receipt={'schema':1,'stage_command':command,'stage_exit_code':p.returncode,'tier_stage_exit_code':stage_tiers.returncode,
 'source_files_unchanged':pins,'aggregate_before_sha256':hashlib.sha256(raw).hexdigest(),'aggregate_after_sha256':sha(aggregate),
 'tiers_before_sha256':hashlib.sha256(old).hexdigest(),'tiers_after_sha256':sha(mp),'counts':manifest['counts'],
 'new_exact_rules':0,'rationale':'Three source wrappers and nine reusable leaves resolve under existing reviewed prefixes; all prior source bytes and declarations are retained.'}
(out/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt))
