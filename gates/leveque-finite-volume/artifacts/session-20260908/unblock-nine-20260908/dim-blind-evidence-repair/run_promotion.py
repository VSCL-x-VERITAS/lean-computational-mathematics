from pathlib import Path
import hashlib,json,subprocess,time
HERE=Path(__file__).resolve().parent
ROOT=next(p for p in HERE.parents if (p/'lean-toolchain').is_file())
KIT=ROOT.parent/'formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/kit'
TASK=ROOT/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
manifest=json.loads((TASK/'faithfulness/manifest.json').read_text(encoding='utf-8'))
def ref(p):
 b=p.read_bytes();return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
owners=[manifest['target']]+manifest['local_import_sources']
for item in owners:
 assert ref(ROOT/item['path'])['sha256']==item['sha256'],item['path']
upstream=ROOT/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean'
mirror=HERE/'exact-mathlib-root/Mathlib/Analysis/Calculus/ContDiff/Defs.lean'
if mirror.exists():raise SystemExit('Refusing overwrite')
mirror.parent.mkdir(parents=True,exist_ok=True);mirror.write_bytes(upstream.read_bytes())
local=HERE/'primary-promoted-local-modules.txt'
local.write_text('\n'.join(x['module'] for x in manifest['local_import_sources'])+'\nMathlib.Analysis.Calculus.ContDiff.Defs\n',encoding='utf-8')
output=HERE/'primary-promoted-03-output.txt';receipt=HERE/'primary-promoted-03-receipt.json'
if output.exists() or receipt.exists():raise SystemExit('Refusing overwrite')
command=['C:/Users/qed_s/.elan/bin/lake.EXE','env','lean','--run',str(KIT/'scripts/declaration_dossier.lean'),
 manifest['target']['path'][:-5].replace('/','.'),manifest['target']['declaration'],str(local)]
before=[ref(ROOT/x['path']) for x in owners]+[ref(upstream),ref(mirror),ref(KIT/'scripts/declaration_dossier.lean')]
start=time.time();p=subprocess.run(command,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);output.write_bytes(p.stdout)
after=[ref(ROOT/x['path']) for x in owners]+[ref(upstream),ref(mirror),ref(KIT/'scripts/declaration_dossier.lean')]
payload={'format':'artifact-only-definition-closure-diagnostic-1','command':command,'cwd':str(ROOT),
 'actual_exit_code':p.returncode,'elapsed_ms':round((time.time()-start)*1000),'output':ref(output),
 'inputs_before':before,'inputs_after':after,'inputs_unchanged':before==after,'local_modules':ref(local),
 'mirror_semantics':'Exact source bytes only; upstream compiled owner remains original Mathlib owner. No source modification or audit preparation.',
 'proposed_additional_module_source_root':str(HERE.relative_to(ROOT)/'exact-mathlib-root')}
receipt.write_text(json.dumps(payload,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in payload.items() if k not in ('inputs_before','inputs_after')},indent=2))
raise SystemExit(p.returncode)
