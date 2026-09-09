"""Finalize exact one-owner equality evidence without staging raw streams or caches."""
from pathlib import Path
import ast,hashlib,json,os,subprocess
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name=='posix'
def sha(p):
    digest=hashlib.sha256()
    with p.open('rb') as stream:
        for data in iter(lambda:stream.read(1024*1024),b''):digest.update(data)
    return digest.hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:
        if isinstance(value,str):out.write(value)
        else:json.dump(value,out,indent=2,ensure_ascii=False);out.write('\n')
    return ref(F/name)
inputs=read(F/'inputs.json');receipt=read(F/'fingerprint-receipt.json')
native=read(F/'native-exit.json');parse=read(F/'freeze-exit.json');prep=read(F/'prepare-exit.json')
assert native['exit_code']==parse['exit_code']==prep['exit_code']==0
assert sha(F/'freeze-output.txt')==parse['stdout_sha256'] and sha(F/'freeze-stderr.txt')==parse['stderr_sha256']
assert sha(F/'prepare-output.txt')==prep['stdout_sha256'] and sha(F/'prepare-stderr.txt')==prep['stderr_sha256']
fp=read(R/receipt['fingerprints']['path']);equality=read(R/receipt['structural_equality']['path'])
assert len(fp['files'])==183 and len(fp['records'])==1688 and equality['records']==83
assert receipt['record_list_exactly_unchanged']
for pin in inputs['files']+inputs['prior_owners']+inputs['lean_environment']+inputs['prior_fingerprints']+inputs['input_manifests']:
    assert sha(R/pin['path'])==pin['sha256'],pin['path']
for key in ('fingerprints','fresh_fingerprints','structural_equality','owner_provenance','native_receipt','native_output','archive','parsed_cache'):
    pin=receipt[key];assert sha(R/pin['path'])==pin['sha256']
head=subprocess.check_output(['git','--no-optional-locks','--no-replace-objects','rev-parse','HEAD'],cwd=R).decode().strip()
assert head==inputs['input_commit']
scripts=[]
for path in sorted(F.glob('*.py')):
    text=path.read_text();ast.parse(text);compile(text,str(path),'exec');scripts.append(ref(path))
syntax=write('syntax-validation.json',{'method':'ast.parse and compile only','status':'PASS','scripts':scripts})
archive=receipt['archive'];scope=read(F/'current-scope.json')
readme=write('README.md',f'''# Exact syntax-only fingerprint successor

This packet updates the current fingerprint binding after one parenthesis pair was added around the `AccuracyCertificate.bound` RHS in `PhysicalRefinementQuality.lean`. The preparation verifies the exact before/after source bytes and the successful build04 receipt. It finds exactly one changed source among all 183 fingerprinted owners. Across the prior 60-owner source/compiled closure, the only changed pins are that source and its `.olean`; every other one of the prior 29 selected compiled-owner hashes is identical. Actual HEAD remains `{head}`. There is no future commit or candidate claim.

Native `lake env lean` exited **0** in {native['elapsed_ms']:,} ms and exported **83 eligible constants**, including all **12 explicitly authored declarations**. Source, compiled, native-tool and POSIX HEAD hashes were rechecked before and after. The same serializer, generated-name filter, and pinned v3 streaming parser are used. All 83 complete record objects exactly equal their slice of the frozen previous 560-record export: names, modules, kinds, normalized types, values, universes and recursor bodies. `structural-equality.json` records this all-field comparison. This is structural alpha-canonical equality, not a source-faithfulness verdict or a general definitional-equivalence checker.

The resulting consolidated inventory retains **all 1,688 records exactly unchanged across 183 owners**. Only the one owner source binding and its current native provenance are replaced. The other 182 owner provenance objects are copied exactly from the previous packet; their historical native executions are not relabeled as fresh. The earlier 29-owner package, all seven older inventories and their actual failed/successful attempts remain untouched. The actual current compiled-pin observations are in `current-scope.json`; unchanged source/dependency scope is checked again at freeze.

The parser/equality/archive run exited **0** in {parse['elapsed_ms']:,} ms. The raw stream has {archive['uncompressed_bytes']:,} bytes, SHA256 `{archive['uncompressed_sha256']}`. Its deterministic gzip (empty filename, mtime 0) has {archive['bytes']:,} bytes, SHA256 `{archive['sha256']}`; exact decompressed bytes were verified. Keep the raw JSONL locally, publish the checked gzip, and exclude generated caches. `stage-files.json` is an artifact allowlist only; no staging occurred.

Use this single current inventory in place of the previous consolidated inventory or seven historical arguments:

```text
--fingerprints {receipt['fingerprints']['path']}
```

Do not append these inventories together. `fresh-owner-expression-fingerprints.json` is supporting evidence and is not another consolidated input. The actual later committed tree must independently match all 183 source hashes before lane/candidate use. Root owns organization, source audits, gate evidence and publication. This packet changes no production, index, Git reference, gate or ledger. Preparation, native export and freeze passed on their first runs in this successor folder; historical failures remain in the previous packet.
''')
included=[];excluded=[]
for path in sorted(F.rglob('*')):
    if not path.is_file():continue
    assert not path.is_symlink()
    rel=path.relative_to(F)
    if path.name in {'stage-files.json','final-package.json','final-receipt.json'}:continue
    if path.name=='native-expression-stream.jsonl' or '__pycache__' in rel.parts or path.suffix in {'.pyc','.olean','.ilean','.o','.c'}:
        excluded.append(dict(**ref(path),bytes=path.stat().st_size,reason='Exact raw retained locally; verified gzip supplied' if path.name.endswith('.jsonl') else 'Generated cache'))
    else:
        assert path.stat().st_size<90*1024*1024
        included.append(dict(**ref(path),bytes=path.stat().st_size))
stage=write('stage-files.json',{'files':included,'excluded':excluded,'staging_performed':False,'manifest_self_files':['stage-files.json','final-package.json','final-receipt.json']})
package=write('final-package.json',dict(schema=1,status='FROZEN EXACT SYNTAX-ONLY SUCCESSOR',fingerprint_receipt=ref(F/'fingerprint-receipt.json'),
    readme=readme,syntax_validation=syntax,stage_files=stage,records=1688,owners=183,fresh_records=83,fresh_owners=1,
    record_list_exactly_unchanged=True,prior_package=ref(F.parent/'physical-current-fingerprints/final-receipt.json'),
    actual_prepare_exit=0,actual_native_exit=0,actual_parse_archive_exit=0,later_committed_blob_check_pending=True,source_acceptance=False))
final=write('final-receipt.json',dict(final_package=package,fingerprints=receipt['fingerprints'],structural_equality=receipt['structural_equality'],
    archive=archive,staging_list=stage,fingerprint_receipt=ref(F/'fingerprint-receipt.json'),input_commit=head,
    actual_prepare_exit=0,actual_native_exit=0,actual_parse_archive_exit=0,all_source_olean_head_postchecks_passed=True,
    prior_package_unchanged=True,record_list_exactly_unchanged=True,source_acceptance=False,production_mutation=False,git_mutation=False))
print(json.dumps({'receipt':final,'package':package,'consolidated':receipt['fingerprints'],'structural_equality':receipt['structural_equality'],'stage_files':stage,'archive':archive},indent=2))
