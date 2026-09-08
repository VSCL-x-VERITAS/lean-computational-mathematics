"""Check exact scratch concatenation; freeze every attempt and actual native exit."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess,sys,time
assert os.name=='nt'
P=Path(__file__).resolve().parent; R=P.parents[4]
label=sys.argv[1]; assert re.fullmatch(r'[a-z0-9-]+',label)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
source=P/(label+'-input.lean'); out=P/(label+'-output.txt'); receipt=P/(label+'-exit.json')
assert not any(p.exists() for p in [source,out,receipt])
inputs=[P/'RectangleBalance.lean',P/'SourceWrapperProposal.lean.fragment']
decls=[
'IsRectangleBalanceLawSolution.integrated_source_eq_mass_defect',
'IsRectangleBalanceLawSolution.rectangle_conservation_iff_source_integral_zero',
'IsRectangleBalanceLawSolution.conservation_iff_source_integrals_zero',
'IsRectangleBalanceLawSolution.not_conservation_iff_exists_nonzero_source_integral',
'IsRectangleBalanceLawSolution.integrated_source_unique',
'zero_source_iff_conservation',
'IsRectangleBalanceLawSolution.hasDerivAt_mass_ae',
'linear_amplitude_balance','linear_amplitude_mass_derivative','linear_amplitude_classical_balance',
'stationaryStep_integrable','stationaryStep_unitCell','stationaryStep_signed_source_integral',
'stationaryStep_source_nonvacuity',
'SourceProposal.nonconservation_requires_integrated_source']
checks='\n'.join(f'#check NumStability.IntegralSourceDraft.{d}\n#print axioms NumStability.IntegralSourceDraft.{d}' for d in decls)
hashes={p.name:sha(p) for p in inputs}
source.write_bytes(b'\n\n'.join(p.read_bytes() for p in inputs)+b'\n\n'+checks.encode()+b'\n')
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
m=json.loads((R/'lake-manifest.json').read_bytes())
assert next(p for p in m['packages'] if p['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
command=[r'C:/Users/qed_s/.elan/bin/lake.exe','env','lean',source.relative_to(R).as_posix()]
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip()
start=datetime.now(timezone.utc).isoformat(); tick=time.monotonic()
with out.open('xb') as f: result=subprocess.run(command,cwd=R,stdout=f,stderr=subprocess.STDOUT)
assert hashes=={p.name:sha(p) for p in inputs}
record={'command':command,'cwd':str(R),'started_at_utc':start,
 'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':result.returncode,
 'elapsed_ms':int((time.monotonic()-tick)*1000),'input_commit':head,'input_files':hashes,
 'checked_declarations':['NumStability.IntegralSourceDraft.'+d for d in decls],
 'assembled_input_sha256':sha(source),'raw_output_sha256':sha(out),
 'lean_toolchain_sha256':sha(R/'lean-toolchain'),'lake_manifest_sha256':sha(R/'lake-manifest.json')}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='')
print(json.dumps(record),flush=True)
sys.stdout.buffer.write(out.read_bytes())
raise SystemExit(result.returncode)
