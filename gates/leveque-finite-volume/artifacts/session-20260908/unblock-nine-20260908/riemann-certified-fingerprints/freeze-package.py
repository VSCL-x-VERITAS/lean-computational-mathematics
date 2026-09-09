"""Freeze actual seventh-increment evidence and exact raw-stream exclusion."""
from pathlib import Path
import ast,hashlib,json
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
def sha(p):
    result=hashlib.sha256()
    with p.open('rb') as stream:
        for block in iter(lambda:stream.read(1024*1024),b''):result.update(block)
    return result.hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    p=F/name
    with p.open('x',encoding='utf-8',newline='\n') as out:json.dump(value,out,indent=2);out.write('\n')
    return ref(p)
receipt=read(F/'fingerprint-receipt.json');inputs=read(F/'inputs.json')
fp=read(R/receipt['fingerprints']['path']);native=read(F/'native-exit.json')
count=len(fp['records']);combined=1419+count
assert receipt['actual_exit_code']==0 and receipt['total_constant_records']==count
assert receipt['combined_disjoint_constants']==combined and receipt['combined_owner_files']==171
assert receipt['authored_new_declarations']==7 and receipt['owner_modules']==4
assert len(inputs['prior_fingerprints'])==6 and len(inputs['project_import_closure'])==32
assert read(F/'freeze-exit.json')['exit_code']==0
assert read(F/'origin-presence.json')['all_four_owners_absent_from_head_and_anchor']
for pin in fp['files']+inputs['prior_owners']+inputs['lean_environment']+fp['prior_fingerprints']+[
        receipt['fingerprints'],receipt['mapping'],receipt['native_receipt'],receipt['native_output'],receipt['archive']]:
    assert sha(R/pin['path'])==pin['sha256'],pin['path']
syntax=[]
for p in F.glob('*.py'):
    text=p.read_text(encoding='utf-8');ast.parse(text);compile(text,str(p),'exec');syntax.append(ref(p))
syntaxref=write('syntax-validation.json',{'status':'PASS','scripts':syntax,
    'method':'ast.parse and compile; optional committed verifier not invoked'})
archive=receipt['archive']
owners='\n'.join(f'- `{name}`: {n} eligible constants' for name,n in sorted(fp['owner_constant_counts'].items()))
readme=f'''# Certified Riemann routine expression fingerprints

The actual native export exited 0 in {native['elapsed_ms']:,} ms at input HEAD
`{inputs['input_commit']}`, tree `{inputs['input_commit_tree']}`. All selected
source and compiled bytes, tools, six prior inventories and HEAD remained fixed.
All Git reads used the POSIX launcher; no Git mutation or staging was performed.

The new disjoint inventory contains **{count} eligible constants in four owners**,
including all **seven authored production declarations**. The seven separate
scratch applicability declarations are not added as production constants.

{owners}

The six prior inventories remain unchanged: **1,419 constants in 167 owners**.
The resulting union is **{combined} constants in 171 owners**. The complete
32-owner project import closure is covered by prior or new owners; no unchanged
project dependency was silently omitted. The direct Mathlib source/compiled
imports and package/toolchain manifests are also pinned.

The previous native serializer, generated/private-name filter and v3 streaming
token parser are unchanged. Alpha-canonical structural normalization removes
metadata and bound-variable display names while retaining expression structure,
universes, binder kinds and constant names. This is not a source-faithfulness
decision, full definitional normalization or candidate acceptance.

Raw export: {archive['uncompressed_bytes']:,} bytes, SHA256
`{archive['uncompressed_sha256']}`. Deterministic gzip: {archive['bytes']:,} bytes,
SHA256 `{archive['sha256']}`. Exact decompressed length and SHA were verified.
The raw JSONL stays local and is explicitly excluded from `stage-files.json`.
Use its gzip and listed evidence; also include the stage list and final package/
receipt control files. No raw stream was staged.

Eight actual absent-blob probes show these four new source owners absent from
HEAD and protected anchor `9e2225705fed906b1120d55105d607baabef57c9`.
The optional `verify-at-commit.py --commit EXACT_40_HEX_COMMIT --label FRESH_LABEL`
must run through the POSIX launcher after an actual later commit when committed
blob evidence is needed. It checks all 171 source owners and the pinned evidence
at that commit; it has not been executed here. The recorded native input commit
is not changed to a future commit.

For a real lane with matching committed source blobs, append this seventh
inventory to the six unchanged prior `--fingerprints` arguments:

```
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-certified-fingerprints/additional-expression-fingerprints.json
```

The prior inventory refs are preserved exactly in `inputs.json` and the additive
inventory. No lane, reconciliation candidate, operator receipt, runtime request,
audit verdict, gate or source file was changed during fingerprinting.
'''
with (F/'README.md').open('x',encoding='utf-8',newline='\n') as out:out.write(readme)
stage=write('stage-files.json',{'files':[ref(p) for p in sorted(F.iterdir()) if p.is_file() and p.name not in
    ('native-expression-stream.jsonl','stage-files.json','final-package.json','final-receipt.json')],
    'excluded':[{'path':fp['native_raw_stream']['path'],'sha256':fp['native_raw_stream']['sha256'],
        'bytes':fp['native_raw_stream']['bytes'],'reason':'Exact deterministic gzip is included; raw stream retained locally.'}],
    'additional_generated_control_paths':[(F/name).relative_to(R).as_posix() for name in
        ('stage-files.json','final-package.json','final-receipt.json')],'staging_performed':False})
package=write('final-package.json',{'status':'FROZEN-NATIVE-FINGERPRINTS-NO-SEMANTIC-VERDICT',
    'fingerprint_receipt':ref(F/'fingerprint-receipt.json'),'readme':ref(F/'README.md'),
    'syntax_validation':syntaxref,'stage_files':stage,'records':count,'owners':4,'authored_new_declarations':7,
    'project_import_closure_owners':32,'combined_records':combined,'combined_owners':171,
    'all_six_prior_inventories_unchanged':True,'missing_project_dependency_owners':[],
    'later_committed_blob_check_pending':True,'no_staging_git_gate_or_audit_mutation':True})
final=write('final-receipt.json',{'final_package':package,'fingerprints':receipt['fingerprints'],
    'mapping':receipt['mapping'],'archive':archive,'fingerprint_receipt':ref(F/'fingerprint-receipt.json'),
    'native_actual_exit':0,'parser_archive_actual_exit':0,'syntax_validation':syntaxref,'staging_list':stage,
    'input_commit':inputs['input_commit'],'unchanged_source_olean_tools_and_head':True,
    'prepared_commit_verifier_not_executed':True})
print(json.dumps({'receipt':final,'package':package,'fingerprints':receipt['fingerprints'],
    'archive':archive,'staging_list':stage},indent=2))
