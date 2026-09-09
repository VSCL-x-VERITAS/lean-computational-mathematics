"""Connect the eight interpreted source leaves and measure the existing tier rules."""
from pathlib import Path
import collections, hashlib, importlib.util, json, os, subprocess, sys
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
assert os.name!='nt', 'Run through the POSIX workflow launcher.'
sha=lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
names=['AcousticsLeftSolutionDomains','CoordinateSplittingBalance','FiniteVolumeUpdateError',
 'MaterialCellVolumeAveraging','MaterialInterfaceLocalRiemannData',
 'RiemannInformationInterfaceFlux','RiemannProblemDataClassification','SourceTermsRectangleBalance']
paths=['ComputationalMathematics/Source/LeVeque/Chapter01/'+n+'.lean' for n in names]
out=D/'organization'
assert not out.exists()
out.mkdir()
before={p:sha(R/p) for p in paths}
aggregate=R/'ComputationalMathematics/Source/LeVeque/Chapter01.lean'
raw=aggregate.read_bytes()
(out/'aggregate-before.lean.txt').write_bytes(raw)
lines=raw.decode().splitlines()
indices=[i for i,l in enumerate(lines) if l.startswith('import ')]
assert indices==list(range(indices[0],indices[-1]+1))
imports=set(lines[indices[0]:indices[-1]+1])
new={'import '+p[:-5].replace('/','.') for p in paths}
assert not imports & new
lines[indices[0]:indices[-1]+1]=sorted(imports|new)
aggregate.write_text('\n'.join(lines)+'\n',encoding='utf-8',newline='\n')
command=['git','add','--',*paths,aggregate.relative_to(R).as_posix()]
result=subprocess.run(command,cwd=R,capture_output=True)
(out/'stage-output.txt').write_bytes(result.stdout)
(out/'stage-stderr.txt').write_bytes(result.stderr)
assert result.returncode==0,result.stderr
sys.path.insert(0,str(R/'tools/architecture'))
import check_tiers as tiers
manifest_path=R/'docs/architecture/tiers.json'
old=manifest_path.read_bytes()
(out/'tiers-before.json').write_bytes(old)
manifest=json.loads(old)
modules=tiers.production_modules(R)
prefixes={r['prefix']:r['tier'] for r in manifest['prefixes']}
roles=collections.Counter()
decisions=collections.Counter()
for module in modules:
 role,rid=tiers.resolve(module,manifest['exact'],prefixes)
 assert role not in ('unclassified','mixed')
 roles[role]+=1
 decisions[rid]+=1
for path in paths:
 module=path[:-5].replace('/','.')
 assert module in modules
 role,rid=tiers.resolve(module,manifest['exact'],prefixes)
 assert role=='source' and rid.startswith('prefix:'),(module,role,rid)
for rule in manifest['prefix_rules']:
 rule['modules_decided']=decisions[rule['rule_id']]
manifest['counts']={'by_role':dict(sorted(roles.items())),
 'exact_rules':len(manifest['exact']),
 'exact_rules_with_absent_file':sum(not (R/(m.replace('.','/')+'.lean')).is_file() for m in manifest['exact']),
 'prefix_rules':len(prefixes),
 'prefix_rules_deciding_nothing':sum(decisions['prefix:'+p]==0 for p in prefixes),
 'production_modules':len(modules)}
assert not tiers.validate(R,manifest,modules)
manifest_path.write_text(json.dumps(manifest,indent=1,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
assert {p:sha(R/p) for p in paths}==before
receipt={'schema':1,'stage_command':command,'stage_exit_code':result.returncode,
 'source_files_unchanged':before,'aggregate_before_sha256':hashlib.sha256(raw).hexdigest(),
 'aggregate_after_sha256':sha(aggregate),'tiers_before_sha256':hashlib.sha256(old).hexdigest(),
 'tiers_after_sha256':sha(manifest_path),'counts':manifest['counts'],
 'new_exact_rules':0,'rationale':'All eight thin source wrappers resolve under the existing reviewed source prefix; producers and prior declarations remain unchanged.'}
(out/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt))
