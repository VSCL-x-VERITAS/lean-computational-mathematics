from pathlib import Path
import hashlib,json,subprocess,datetime
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
prior=h.parent/'dim-shared-accuracy-certificate/freeze_v2.py'
s=prior.read_text(encoding='utf-8')
s=s.replace("attempt=h/'native-01'","attempt=h/'native-02'")
s=s.replace('assert len(records)==7','assert len(records)==18')
s=s.replace("assert out.count('NO_OLD_ACCURACY_DEPENDENCY ')==5","assert out.count('CORE_QUALITY_STABILITY_SEPARATE')==1")
s=s.replace("'declaration_checks':7","'declaration_checks':18")
s=s.replace("'direct_proof_dependency_guards':5","'core_stability_separation_guard':True")
s=s.replace("'scope_limit':ref(h/'SCOPE-LIMIT.md'),","'scope_limit':ref(h.parent/'dim-shared-accuracy-certificate/SCOPE-LIMIT.md'),")
s=s.replace('shared-accuracy-certificate','interval-quality-repair')
s=s.replace('shared all-level quantifier repair only','interval-only time-step/core-quality repair')
s=s.replace('artifact-only certificate and executed corollary','artifact-only interval family and core-quality separation')
assert not (h/'freeze.py').exists()
(h/'freeze.py').write_text(s,encoding='utf-8')
queries=[['rg','-n','order|oscillation|stability|InitialProjection|line_local','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RefiningLineMethod.lean'],
 ['rg','-n','family_quality|grid_volume|h_tendsto|smooth_local_reference|dt_le_horizon','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/HighResolutionAdvectionLine.lean'],
 ['rg','-n','positive_available|SmoothCertificate|CoreQuality','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume']]
records=[]
for i,argv in enumerate(queries,1):
 started=datetime.datetime.now(datetime.timezone.utc).isoformat()
 proc=subprocess.run(argv,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 p=h/f'reuse-{i:02}.txt';assert not p.exists();p.write_bytes(proc.stdout)
 records.append({'command':argv,'cwd':str(r),'started_at_utc':started,'actual_exit_code':proc.returncode,
 'output':{'path':str(p),'sha256':hashlib.sha256(proc.stdout).hexdigest(),'bytes':len(proc.stdout)}})
(h/'reuse.json').write_text(json.dumps({'searches':records,'nomatch_exit_one_is_expected_for_new_api':True,
 'prior_frozen_search_packets':['../dim-time-step-admission-draft/reuse-searches.json','../dim-shared-accuracy-certificate/reuse.json'],
 'freeze_derivation':{'source':str(prior),'sha256':hashlib.sha256(prior.read_bytes()).hexdigest(),
 'successor':str(h/'freeze.py'),'successor_sha256':hashlib.sha256((h/'freeze.py').read_bytes()).hexdigest()}},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'search_exits':[x['actual_exit_code'] for x in records]},indent=2))
