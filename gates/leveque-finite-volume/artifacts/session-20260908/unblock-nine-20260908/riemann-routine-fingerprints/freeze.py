"""Freeze disjoint four-owner records with the unchanged v3 expression-token parser."""
from pathlib import Path
from datetime import datetime,timezone
import collections,gzip,hashlib,importlib.util,json,os,re,shutil
F=Path(__file__).resolve().parent;R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name!='nt','Use the POSIX launcher for parser paths and long-path portability.'
INPUT_SHA='6fa0a8a7f6a0a090023c2e2fb417fdcbae3e9ed60f136b2f812e198eae5ccede'
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
 p=F/name
 with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(value,f,indent=2,ensure_ascii=False);f.write('\n')
 return ref(p)
assert sha(F/'inputs.json')==INPUT_SHA
inputs=read(F/'inputs.json');receipt=read(F/'native-exit.json');output=(F/'native-output.txt').read_bytes()
assert receipt['exit_code']==0 and receipt['input_bytes_and_head_unchanged']
assert receipt['input_manifest_sha256']==INPUT_SHA
assert (receipt['input_commit'],receipt['input_commit_tree'])==(inputs['input_commit'],inputs['input_commit_tree'])
assert receipt['argv']==['lake','env','lean',inputs['exporter_path']]
assert receipt['output_sha256']==hashlib.sha256(output).hexdigest()
for item in inputs['files']+inputs['lean_environment']+inputs['prior_owners']+inputs['prior_fingerprints']+inputs['input_manifests']:
 assert sha(R/item['path'])==item['sha256'],item['path']
exporter=R/inputs['exporter_path'];prior_exporter=R/inputs['prior_exporter']['path'];parserpath=R/inputs['parser']['path']
assert sha(exporter)==inputs['exporter_sha256']
assert sha(prior_exporter)==inputs['prior_exporter']['sha256']
assert sha(parserpath)==inputs['parser']['sha256']
def serializer(text):
 start=text.index('private def generated');a=text.index('private def selectedModules : Array String := #[',start);b=text.index('\n]\n',a)+3
 return re.sub(r'IO\.FS\.writeFile "[^"]+" text','IO.FS.writeFile "OUTPUT" text',text[start:a]+text[b:])
assert serializer(exporter.read_text())==serializer(prior_exporter.read_text())
spec=importlib.util.spec_from_file_location('unchanged_v3_expression_token_parser',parserpath)
parser=importlib.util.module_from_spec(spec);spec.loader.exec_module(parser)
records,raw=parser.records(R/inputs['raw_stream_path'])
assert len(records)==len({x['name'] for x in records})==37
assert {r['module'] for r in records}==set(inputs['selected_modules'])
oldnames=set();oldowners=set()
for pin in inputs['prior_fingerprints']:
 old=read(R/pin['path'])
 for r in old['records']:assert r['name'] not in oldnames;oldnames.add(r['name'])
 for f in old['files']:assert f['path'] not in oldowners;oldowners.add(f['path'])
assert len(oldnames)==1089 and len(oldowners)==147
assert not {r['name'] for r in records}&oldnames
assert all(r['kind']!='axiom' for r in records)
assert output.decode().strip()=='Chapter 1 declaration expressions exported: '+str(len(records))
expected=set(inputs['expected_authored_new_declarations'])
assert len(expected)==22 and expected<={r['name'] for r in records}
assert len(inputs['files'])==len(inputs['selected_modules'])==4
assert not inputs['unchanged_dependency_files'] and not inputs['unfingerprinted_dependency_owners_outside_requested_scope']
rawpath=R/inputs['raw_stream_path'];gz=F/'native-expression-stream.jsonl.gz'
assert not gz.exists()
with rawpath.open('rb') as src,gz.open('xb') as dest:
 with gzip.GzipFile(filename='',mode='wb',fileobj=dest,mtime=0) as zipped:shutil.copyfileobj(src,zipped,1024*1024)
decompressed=hashlib.sha256();count=0
with gzip.open(gz,'rb') as f:
 for b in iter(lambda:f.read(1024*1024),b''):decompressed.update(b);count+=len(b)
assert count==raw['bytes'] and decompressed.hexdigest()==raw['sha256']
archive=dict(**ref(gz),bytes=gz.stat().st_size,uncompressed_bytes=count,
 uncompressed_sha256=raw['sha256'],exact_decompression_verified=True)
kind_counts=dict(collections.Counter(r['kind'] for r in records))
owner_counts=dict(collections.Counter(r['module'] for r in records))
result=dict(schema=1,artifact_kind='additional-native-declaration-fingerprints',
 input_commit=inputs['input_commit'],input_commit_tree=inputs['input_commit_tree'],
 normalization=inputs['normalization'],counting_note=inputs['counting_note'],hash_encoding=inputs['hash_encoding'],
 selected_modules=inputs['selected_modules'],files=inputs['files'],
 added_production_modules=[f['path'] for f in inputs['files']],unchanged_dependency_files=[],
 declaration_count=len(records),new_module_declaration_constants=len(records),
 authored_new_declaration_count=22,unchanged_dependency_constant_count=0,
 constant_kinds=kind_counts,owner_constant_counts=owner_counts,input_manifest=ref(F/'inputs.json'),
 native_receipt=ref(F/'native-exit.json'),native_output=ref(F/'native-output.txt'),
 native_raw_stream=dict(path=inputs['raw_stream_path'],**raw),native_raw_archive=archive,
 prior_fingerprints=inputs['prior_fingerprints'],prior_owner_pins_verified_unchanged=147,
 prior_constants_untouched=1089,exact_prior_serializer_preserved=True,exact_prior_token_parser_preserved=True,
 generated_constant_scope='Existing filtering unchanged: constructors, recursors, projections and other nonreserved public environment constants included; reserved/private/internal compiler-detail names remain excluded by the prior generated/private-name filter. Counts are not authored theorem counts.',
 records=records,commit_scope=inputs['commit_scope'],
 consumer_scope='Append this disjoint inventory to the four retained prior inventories only for a real lane whose committed blobs match the selected source bytes. Native input_commit remains actual5e3; no later commit identity or candidate acceptance is inferred.')
fingerprints=write('additional-expression-fingerprints.json',result)
owners={f['module']:f for f in inputs['files']}
mapping=write('declaration-mapping.json',dict(files=inputs['files'],native_records=[dict(name=r['name'],
 module=r['module'],owner_path=owners[r['module']]['path'],owner_sha256=owners[r['module']]['sha256'],
 kind=r['kind'],authored_new=r['name'] in expected,type_sha256=r['type_sha256'],value_sha256=r['value_sha256'],
 level_params_sha256=r['level_params_sha256'],recursor_values_sha256=r['recursor_values_sha256']) for r in records]))
final=write('fingerprint-receipt.json',dict(schema=1,status='NATIVE-PASS-NO-COMMIT-OR-SEMANTIC-ACCEPTANCE',
 frozen_at_utc=datetime.now(timezone.utc).isoformat(),input_commit=inputs['input_commit'],input_commit_tree=inputs['input_commit_tree'],
 input_manifest=ref(F/'inputs.json'),fingerprints=fingerprints,mapping=mapping,native_receipt=ref(F/'native-exit.json'),
 native_output=ref(F/'native-output.txt'),archive=archive,total_constant_records=len(records),new_owner_constants=len(records),
 unchanged_dependency_constants=0,authored_new_declarations=22,owner_modules=4,new_owner_modules=4,
 project_import_closure_owners=len(inputs['project_import_closure']),unfingerprinted_project_dependencies=[],
 prior_constants_untouched=1089,prior_owner_files_untouched=147,combined_disjoint_constants=1089+len(records),
 combined_owner_files=151,actual_exit_code=0,exact_serializer_and_parser_preserved=True,
 source_olean_head_pins_unchanged=True,no_gate_source_audit_git_mutation=True,later_committed_blob_verification_required=True))
print(json.dumps(dict(receipt=final,fingerprints=fingerprints,mapping=mapping,archive=archive,
 constants=len(records),owner_counts=owner_counts,combined=1089+len(records)),indent=2))
