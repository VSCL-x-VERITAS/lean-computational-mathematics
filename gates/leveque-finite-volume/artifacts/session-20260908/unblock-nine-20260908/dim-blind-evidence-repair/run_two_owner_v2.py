from pathlib import Path
import hashlib,json,subprocess,time
HERE=Path(__file__).resolve().parent
ROOT=next(p for p in HERE.parents if (p/'lean-toolchain').is_file())
KIT=ROOT.parent/'formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/kit'
def ref(p):
 b=p.read_bytes();return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
module='Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries'
source=ROOT/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean'
mirror=HERE/'m/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean'
local=HERE/'primary-two-owner-local-modules.txt'
out=HERE/'primary-two-owner-04-output.txt';receipt=HERE/'primary-two-owner-04-receipt.json'
for p in [mirror,local,out,receipt]:
 if p.exists():raise SystemExit('Refusing overwrite: '+str(p))
mirror.parent.mkdir(parents=True,exist_ok=True)
mirror.write_bytes(source.read_bytes())
(mirror.parent/'Defs.lean').write_bytes((HERE/'exact-mathlib-root/Mathlib/Analysis/Calculus/ContDiff/Defs.lean').read_bytes())
local.write_bytes((HERE/'primary-promoted-local-modules.txt').read_bytes()+(module+'\n').encode())
inputs=[source,mirror,local,KIT/'scripts/declaration_dossier.lean']
for name in local.read_text().splitlines():
 if name.startswith('Mathlib.'):
  base=ROOT/'.lake/packages/mathlib'
 else:base=ROOT
 inputs.extend([base/(name.replace('.','/')+'.lean'),base/'.lake/build/lib/lean'/(name.replace('.','/')+'.olean')])
target='ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods'
inputs.extend([ROOT/(target.replace('.','/')+'.lean'),ROOT/'.lake/build/lib/lean'/(target.replace('.','/')+'.olean')])
before=[ref(p) for p in dict.fromkeys(inputs)]
command=['C:/Users/qed_s/.elan/bin/lake.EXE','env','lean','--run',str(KIT/'scripts/declaration_dossier.lean'),target,
 'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract',str(local)]
start=time.time();p=subprocess.run(command,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);out.write_bytes(p.stdout)
after=[ref(p) for p in dict.fromkeys(inputs)]
receipt.write_text(json.dumps({'format':'artifact-only-two-owner-diagnostic-1','command':command,'cwd':str(ROOT),
 'actual_exit_code':p.returncode,'elapsed_ms':round((time.time()-start)*1000),'output':ref(out),
 'inputs_before':before,'inputs_after':after,'inputs_unchanged':before==after,
 'limitation':'Not actual successor preparation. Released source discovery requires a future explicit FTaylorSeries import; public imports are not followed.'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'actual_exit_code':p.returncode,'output':ref(out),'receipt':ref(receipt),'inputs_unchanged':before==after},indent=2))
raise SystemExit(p.returncode)
