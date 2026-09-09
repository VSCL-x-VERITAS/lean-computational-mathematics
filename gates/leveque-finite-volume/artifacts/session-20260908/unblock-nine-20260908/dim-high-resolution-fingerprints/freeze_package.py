from pathlib import Path
import ast,hashlib,json
F=Path(__file__).resolve().parent;R=next(p for p in F.parents if (p/'lean-toolchain').exists())
def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as src:
        for b in iter(lambda:src.read(1024*1024),b''):h.update(b)
    return h.hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    p=F/name
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(value,f,indent=2);f.write('\n')
    return ref(p)
receipt=read(F/'fingerprint-receipt.json');inputs=read(F/'inputs.json');fp=read(R/receipt['fingerprints']['path'])
assert receipt['actual_exit_code']==0 and receipt['total_constant_records']==293
assert receipt['combined_disjoint_constants']==1419 and receipt['combined_owner_files']==167
assert read(F/'freeze-exit.json')['exit_code']==0
assert read(F/'origin-presence.json')['all_sixteen_owners_absent_from_head_and_anchor']
for item in fp['files']+inputs['prior_owners']+inputs['lean_environment']+fp['prior_fingerprints']+[receipt['fingerprints'],receipt['mapping'],receipt['native_receipt'],receipt['native_output'],receipt['archive']]:
    assert sha(R/item['path'])==item['sha256'],item['path']
syntax=[]
for p in F.glob('*.py'):
    t=p.read_text();ast.parse(t);compile(t,str(p),'exec');syntax.append(ref(p))
syntaxref=write('syntax-validation.json',{'status':'PASS','method':'ast.parse and compile only; no invocation of optional committed verifier','scripts':syntax})
native=read(F/'native-exit.json');archive=receipt['archive'];counts=fp['owner_constant_counts']
rows='\n'.join(f"- `{module}`: {count} constants" for module,count in sorted(counts.items()))
readme=f'''# Directional high-resolution structural expression fingerprints

The native export completed with actual exit 0 in {native['elapsed_ms']:,} ms on actual input HEAD `{inputs['input_commit']}`, tree `{inputs['input_commit_tree']}`. All sixteen frozen worktree owners, their compiled files, tools, prior inventories and HEAD stayed unchanged during export. Git identity/presence checks used only the POSIX launcher.

The additive inventory contains **293 eligible environment constants in sixteen owners**, including **all 150 authored declarations** from the frozen production inventory. Constructors, projections and recursors follow the unchanged prior generated-name filter. These are environment-constant counts, not theorem or source-row counts.

{rows}

The five prior inventories remain byte-identical and disjoint: **1,126 constants across 151 owners**. The resulting union is **1,419 constants across 167 owners**. The entire 48-owner project import closure is covered by old or new inventories; no un-fingerprinted project dependency was omitted. Direct Mathlib source/compiled imports and the package/toolchain manifests are separately pinned.

The original serializer/filter and v3 streaming token parser are unchanged. Normalization removes metadata and bound-variable display names while retaining expression structure, indices, universes and binder kinds. It is alpha-canonical structural serialization, not full definitional normalization. This inventory supplies no source-faithfulness verdict or candidate acceptance.

The raw stream is {archive['uncompressed_bytes']:,} bytes, SHA256 `{archive['uncompressed_sha256']}`. Its deterministic gzip archive is {archive['bytes']:,} bytes, SHA256 `{archive['sha256']}`. Exact decompressed length and hash were verified; parser/archive execution returned actual exit 0. **Stage the gzip archive and exclude `native-expression-stream.jsonl`.** The raw stream remains local; `stage-files.json` records the exact exclusion. No staging or Git mutation was performed.

All sixteen source owners are absent from actual input HEAD and protected anchor `9e2225705fed906b1120d55105d607baabef57c9`, as shown by 32 actual absent-blob probes. The receipt records actual worktree source bytes, not a future commit. The optional `verify-at-commit.py --commit EXACT_40_HEX_COMMIT --label FRESH_LABEL` must run through the POSIX launcher after an actual later commit if committed-blob identity is needed. It has not been executed here.

Append this inventory to all five retained prior arguments for a real lane whose committed source blobs match:

```text
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-high-resolution-fingerprints/additional-expression-fingerprints.json
```

The five retained inventories are `chapter01-current-expression-fingerprints-24b3.json`, `baseline-equation03-expression-fingerprints.json`, `unblock-nine-20260908/final-fingerprints/additional-expression-fingerprints.json`, `unblock-nine-20260908/local-replacement-fingerprints/additional-expression-fingerprints.json`, and `unblock-nine-20260908/riemann-routine-fingerprints/additional-expression-fingerprints.json`. No lane inventory, reconciliation candidate, runtime request, source audit, gate status or promotion receipt was created or modified by this export.
'''
with (F/'README.md').open('x',encoding='utf-8',newline='\n') as f:f.write(readme)
stage=write('stage-files.json',{'files':[ref(p) for p in sorted(F.iterdir()) if p.is_file() and p.name not in ('native-expression-stream.jsonl','stage-files.json','final-package.json','final-receipt.json')], 'excluded':[{'path':fp['native_raw_stream']['path'],'sha256':fp['native_raw_stream']['sha256'],'bytes':fp['native_raw_stream']['bytes'],'reason':'Large exact raw stream retained locally; deterministic exact gzip is included.'}],'staging_performed':False})
package=write('final-package.json',{'status':'FROZEN-NATIVE-FINGERPRINTS-NO-SEMANTIC-VERDICT','fingerprint_receipt':ref(F/'fingerprint-receipt.json'),'readme':ref(F/'README.md'),'syntax_validation':syntaxref,'stage_files':stage,'records':293,'owners':16,'authored_new_declarations':150,'project_import_closure_owners':48,'combined_records':1419,'combined_owners':167,'all_prior_inventories_unchanged':True,'missing_project_dependency_owners':[],'later_committed_blob_check_pending':True,'no_staging_git_gate_or_audit_mutation':True})
final=write('final-receipt.json',{'final_package':package,'fingerprints':receipt['fingerprints'],'mapping':receipt['mapping'],'archive':archive,'fingerprint_receipt':ref(F/'fingerprint-receipt.json'),'native_actual_exit':0,'parser_archive_actual_exit':0,'syntax_validation':syntaxref,'staging_list':stage,'input_commit':inputs['input_commit'],'unchanged_source_olean_tools_and_head':True,'prepared_commit_verifier_not_executed':True})
print(json.dumps({'receipt':final,'package':package,'fingerprints':receipt['fingerprints'],'archive':archive,'staging_list':stage},indent=2))
