"""Freeze the completed additive placement and exact requested owner census."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re
P=Path(__file__).resolve().parent;F=P.parent/'riemann-certified-draft'
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
SHIM=P.parent/'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(p,v):
    with p.open('x',encoding='utf-8') as out:json.dump(v,out,indent=2,ensure_ascii=False);out.write('\n')
complete=read(P/'checks-complete.json')
assert complete['actual_build_exit_code']==complete['actual_declarations_exit_code']==0
assert complete['whole_native_output_byte_equal_to_scratch']
files=read(P/'files.json')['files']
assert len(files)==4 and sum(len(x['declarations']) for x in files)==7
for item in files+read(F/'reuse-inputs.json'):assert sha(R/item['path'])==item['sha256']
for label in ('build','declarations'):
    receipt=read(P/(label+'-exit.json'));assert receipt['exit_code']==0
    for key in ('stdout','stderr'):assert sha(R/receipt[key]['path'])==receipt[key]['sha256']
    out=(P/(label+'-output.txt')).read_text(encoding='utf-8')
    assert not any(word in out for word in ('error:','warning:','sorryAx'))
assert (P/'declarations-output.txt').read_bytes()==(F/'native-types.txt').read_bytes()
inventory={'files':[{key:item[key] for key in ('path','module','sha256','declarations')} for item in files]}
write(P/'production-files-frozen.json',inventory)
compiled=[]
for item in files:
    path=R/'.lake/build/lib/lean'/Path(item['path']).with_suffix('.olean')
    compiled.append(ref(path))
review=P.parent/'riemann-certified-independent-review/verification.json'
assert sha(review)=='fce6b96e5e5b094d0f772e948d777aea415a57993a25b3ff5ab3d9db4f2a9770'
manifest={'format':'certified-riemann-production-manifest-1','created_at_utc':datetime.now(timezone.utc).isoformat(),
    'files':[ref(x) for x in P.iterdir() if x.is_file()], 'production_files':inventory['files'],
    'production_compiled':compiled,'scratch_receipt':ref(F/'receipt.json'),
    'independent_review':ref(review),'unchanged_old_producers':read(F/'reuse-inputs.json')}
write(P/'manifest.json',manifest)
receipt={'format':'certified-riemann-production-receipt-1','completed_at_utc':datetime.now(timezone.utc).isoformat(),
    'manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md'),
    'production_files':ref(P/'production-files-frozen.json'),'build':ref(P/'build-exit.json'),
    'declarations':ref(P/'declarations-exit.json'),'native_output':ref(P/'declarations-output.txt'),
    'joint_application':ref(P/'DeclarationsAndApplication.lean'), 'scratch_receipt':ref(F/'receipt.json'),
    'independent_review':ref(review),'actual_build_exit_code':0,'actual_declaration_exit_code':0,
    'canonical_declarations':7,'separate_applicability_declarations':7,'full_type_and_axiom_output_byte_equal':True,
    'permitted_axioms_only':True,'old_owner_bytes_preserved':True,'source_acceptance':False,
    'aggregate_tier_stage_gate_changes':False}
write(P/'receipt.json',receipt)
print(json.dumps({'receipt':ref(P/'receipt.json'),**receipt},indent=2))
