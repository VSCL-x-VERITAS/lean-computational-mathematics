from pathlib import Path
import hashlib, json, os, subprocess, time
HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p/'lean-toolchain').is_file())
KIT = ROOT.parent/'formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/kit'
LAKE = Path('C:/Users/qed_s/.elan/bin/lake.EXE')
def ref(path):
    b=path.read_bytes(); return {'path':str(path),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def run(label,args,env=None):
    out=HERE/(label+'-output.txt'); receipt=HERE/(label+'-receipt.json')
    if out.exists() or receipt.exists(): raise SystemExit('Refusing overwrite')
    start=time.time(); p=subprocess.run(args,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    out.write_bytes(p.stdout)
    receipt.write_text(json.dumps({'command':args,'cwd':str(ROOT),'actual_exit_code':p.returncode,
       'elapsed_ms':round((time.time()-start)*1000),'output':ref(out),'input':ref(HERE/'Probe.lean'),
       'sealed_helper':ref(KIT/'scripts/declaration_dossier.lean'),'LEAN_PATH_override':env.get('LEAN_PATH') if env else None},indent=2)+'\n',encoding='utf-8')
    print(label,p.returncode,ref(out));
    if p.returncode: raise SystemExit(p.returncode)
run('compile-02',[str(LAKE),'env','lean','-R',str(HERE),'-o',str(HERE/'Probe.olean'),str(HERE/'Probe.lean')])
local=HERE/'local-modules.txt'
if local.exists(): raise SystemExit('Refusing overwrite')
local.write_text('Probe\nComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod\nComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference\nMathlib.Analysis.Calculus.ContDiff.Defs\n',encoding='utf-8')
env=os.environ.copy(); env['LEAN_PATH']=str(HERE)+os.pathsep+env.get('LEAN_PATH','')
run('sealed-printer-02',[str(LAKE),'env','lean','--run',str(KIT/'scripts/declaration_dossier.lean'),
    'Probe','BlindEvidenceDiagnostic.explicitRate_eq',str(local)],env)
