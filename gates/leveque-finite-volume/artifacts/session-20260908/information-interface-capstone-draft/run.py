"""Append-only native Lean execution with exact source/olean dependencies."""
from pathlib import Path
from hashlib import sha256
import datetime,json,re,subprocess,sys,time

here=Path(__file__).resolve().parent;repo=here.parents[4]
label=sys.argv[1]
digest=lambda p:sha256(p.read_bytes()).hexdigest()
source=here/(label+'.lean');out=here/(label+'.output.txt');receipt=here/(label+'.receipt.json')
assert not any(p.exists() for p in [source,out,receipt])
candidate=(here/'Candidate.lean').read_bytes()
names=[];namespace='NumStability.InformationInterfaceDraft'
for line in candidate.decode().splitlines():
 if line=='namespace Witness': namespace+='.'+'Witness'
 match=re.match(r'^(?:noncomputable )?(def|theorem) (\w+)',line)
 if match:names.append(namespace+'.'+match.group(2))
reused=['NumStability.RiemannInformationFluxMethod.interface_execution',
 'NumStability.RiemannInformationFluxMethod.interfaceFlux_constant',
 'NumStability.RiemannInformationFluxMethod.ofField_interfaceFlux',
 'NumStability.RiemannInformationFluxMethod.interface_error_le',
 'NumStability.RiemannInformationFluxMethod.update_error_le',
 'NumStability.cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage',
 'NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae',
 'NumStability.LeftStateInformationFlux.concrete_information_only',
 'NumStability.LeftStateInformationFlux.selected_flux_eq_reference_average',
 'Real.volume_Ioc']
checks='\n'.join(f'#check {n}\n#print axioms {n}' for n in names+reused)+'\n'
source.write_bytes(candidate+b'\n'+checks.encode())
pending=re.findall(r'^import (\S+)',candidate.decode(),re.M);local={};mathlib={}
for_module=lambda base,mod,suffix:base/Path(*mod.split('.')).with_suffix(suffix)
while pending:
 mod=pending.pop()
 if mod in local:continue
 path=for_module(repo,mod,'.lean')
 imports=re.findall(r'^import (\S+)',path.read_text(encoding='utf-8'),re.M)
 obj=for_module(repo/'.lake/build/lib/lean',mod,'.olean')
 local[mod]=dict(source=str(path),source_sha256=digest(path),olean=str(obj),olean_sha256=digest(obj),imports=imports)
 for imp in imports:
  assert not imp.startswith(('Source.','NumStability.')),imp
  if imp.startswith('ComputationalMathematics.'):pending.append(imp)
  elif imp.startswith('Mathlib.'):
   src=for_module(repo/'.lake/packages/mathlib',imp,'.lean')
   obj=for_module(repo/'.lake/packages/mathlib/.lake/build/lib/lean',imp,'.olean')
   mathlib[imp]=dict(source=str(src),source_sha256=digest(src),olean=str(obj),olean_sha256=digest(obj))
before={str(p):digest(p) for p in [source,here/'run.py',here/'Candidate.lean',here/'preparation.json',repo/'lean-toolchain',repo/'lake-manifest.json']}
for entry in list(local.values())+list(mathlib.values()):
 before[entry['source']]=entry['source_sha256'];before[entry['olean']]=entry['olean_sha256']
command=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',str(source)]
started,tick=datetime.datetime.now(datetime.timezone.utc).isoformat(),time.monotonic()
run=subprocess.run(command,cwd=repo,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
out.write_bytes(run.stdout)
record=dict(command=command,cwd=str(repo),started_utc=started,elapsed_seconds=round(time.monotonic()-tick,3),
 exit_code=run.returncode,source=str(source),source_sha256=digest(source),output=str(out),output_sha256=digest(out),
 inputs=before,inputs_unchanged=all(digest(Path(p))==h for p,h in before.items()),
 declarations=names,reused_declarations=reused,local_dependencies=local,direct_mathlib_imports=mathlib,
 source_acceptance=False)
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(dict(receipt=str(receipt),sha256=digest(receipt),exit_code=run.returncode)),flush=True)
if run.returncode:sys.stdout.buffer.write(run.stdout)
sys.exit(run.returncode)
