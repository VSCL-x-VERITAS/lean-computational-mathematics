"""Require exact one-owner structural equality before constructing an additive inventory."""
from pathlib import Path
from datetime import datetime,timezone
import collections,copy,gzip,hashlib,importlib.util,json,os,re,shutil,subprocess
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
P=F.parent/'physical-current-fingerprints'
assert os.name=='posix'
def sha(p):
    digest=hashlib.sha256()
    with p.open('rb') as stream:
        for chunk in iter(lambda:stream.read(1024*1024),b''):digest.update(chunk)
    return digest.hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:json.dump(value,out,indent=2,ensure_ascii=False);out.write('\n')
    return ref(F/name)
assert sha(F/'inputs.json')=='41c4961576366beebb90765af8f998256ff173b1f6f22f61ea333eddad4d1350'
inputs=read(F/'inputs.json');native=read(F/'native-exit.json')
assert native['exit_code']==0 and native['input_bytes_and_head_unchanged']
assert native['input_manifest_sha256']==sha(F/'inputs.json')
assert native['argv']==['lake','env','lean',inputs['exporter_path']]
assert native['output_sha256']==sha(F/'native-output.txt')
assert (native['input_commit'],native['input_commit_tree'])==(inputs['input_commit'],inputs['input_commit_tree'])
pins=inputs['files']+inputs['prior_owners']+inputs['lean_environment']+inputs['prior_fingerprints']+inputs['input_manifests']
for pin in pins:assert sha(R/pin['path'])==pin['sha256'],pin['path']
for pin in [inputs['prior_exporter'],inputs['parser']]:assert sha(R/pin['path'])==pin['sha256']
assert sha(R/inputs['exporter_path'])==inputs['exporter_sha256']
def serializer(text):
    start=text.index('private def generated')
    left=text.index('private def selectedModules : Array String := #[',start)
    right=text.index('\n]\n',left)+3
    return re.sub(r'IO\.FS\.writeFile "[^"]+" text','IO.FS.writeFile "OUTPUT" text',text[start:left]+text[right:])
assert serializer((R/inputs['exporter_path']).read_text())==serializer((R/inputs['prior_exporter']['path']).read_text())
spec=importlib.util.spec_from_file_location('unchanged_v3_parser',R/inputs['parser']['path'])
parser=importlib.util.module_from_spec(spec);spec.loader.exec_module(parser)
fresh,raw=parser.records(R/inputs['raw_stream_path'])
cache=write('parsed-current-83.json',{'parser':inputs['parser'],'raw':raw,'records':fresh})
assert len(fresh)==len({r['name'] for r in fresh})==inputs['expected_constant_count']==83
assert (F/'native-output.txt').read_text().strip()=='Chapter 1 declaration expressions exported: 83'
assert {r['module'] for r in fresh}==set(inputs['selected_modules'])
assert all(r['kind']!='axiom' for r in fresh)
assert set(inputs['expected_authored_declarations'])<={r['name'] for r in fresh}
prior_pin=inputs['prior_fingerprints'][0];prior=read(R/prior_pin['path'])
old_fresh_pin=next(p for p in inputs['input_manifests'] if p['path'].endswith('/fresh-owner-expression-fingerprints.json'))
old_fresh=read(R/old_fresh_pin['path'])
module=inputs['selected_modules'][0]
expected=[r for r in old_fresh['records'] if r['module']==module]
assert len(old_fresh['records'])==560 and len(expected)==83
assert sorted(fresh,key=lambda r:r['name'])==sorted(expected,key=lambda r:r['name']), 'Owner structural records changed: stop without consolidated successor'
assert sorted(fresh,key=lambda r:r['name'])==[r for r in prior['records'] if r['module']==module]
archive_path=F/'native-expression-stream.jsonl.gz'
with (R/inputs['raw_stream_path']).open('rb') as src,archive_path.open('xb') as dst:
    with gzip.GzipFile(filename='',mode='wb',fileobj=dst,mtime=0) as gz:shutil.copyfileobj(src,gz,1024*1024)
digest=hashlib.sha256();size=0
with gzip.open(archive_path,'rb') as stream:
    for data in iter(lambda:stream.read(1024*1024),b''):digest.update(data);size+=len(data)
assert (size,digest.hexdigest())==(raw['bytes'],raw['sha256'])
archive=dict(**ref(archive_path),bytes=archive_path.stat().st_size,uncompressed_bytes=size,uncompressed_sha256=raw['sha256'],exact_decompression_verified=True,gzip_filename='',gzip_mtime=0)
canonical=lambda value:hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()).hexdigest()
equality=write('structural-equality.json',{'schema':1,'result':'EXACT ALL-FIELD RECORD EQUALITY',
    'module':module,'records':83,'expected_explicit_authors':len(inputs['expected_authored_declarations']),
    'prior_fresh_inventory':old_fresh_pin,'prior_consolidated':prior_pin,'parsed_current':cache,
    'all_record_keys_compared':sorted(fresh[0]),'compared_record_list_sha256':canonical(sorted(fresh,key=lambda r:r['name'])),
    'type_value_universes_recursor_bodies_and_names_equal':True,'native_receipt':ref(F/'native-exit.json'),
    'meaning':'Structural alpha-canonical tokens with unchanged serializer/parser; not a source-faithfulness or arbitrary semantic-equivalence decision.'})
fresh_pin=write('fresh-owner-expression-fingerprints.json',dict(schema=1,artifact_kind='single-owner-native-syntax-successor',
    input_commit=inputs['input_commit'],input_commit_tree=inputs['input_commit_tree'],normalization=inputs['normalization'],
    hash_encoding=inputs['hash_encoding'],counting_note=inputs['counting_note'],files=inputs['files'],selected_modules=[module],
    records=sorted(fresh,key=lambda r:r['name']),declaration_count=83,input_manifest=ref(F/'inputs.json'),
    native_receipt=ref(F/'native-exit.json'),native_output=ref(F/'native-output.txt'),native_raw_archive=archive,structural_equality=equality))
files=[inputs['files'][0] if p['path']==inputs['files'][0]['path'] else p for p in prior['files']]
assert len(files)==len({p['path'] for p in files})==183
new_records=sorted([r for r in prior['records'] if r['module']!=module]+fresh,key=lambda r:r['name'])
assert new_records==prior['records'] and len(new_records)==1688
source_diffs=[(a,b) for a,b in zip(prior['files'],files) if a!=b]
assert len(source_diffs)==1 and source_diffs[0][0]['path']==inputs['files'][0]['path']
prior_prov=read(P/'owner-provenance.json')
provenance=[]
for old_entry in prior_prov['owners']:
    entry=copy.deepcopy(old_entry)
    if entry['current_owner']['path']==inputs['files'][0]['path']:
        entry={'current_owner':inputs['files'][0],'mode':'fresh-one-owner-export-exact-structural-equality',
            'prior':{'consolidated':prior_pin,'owner_provenance':ref(P/'owner-provenance.json'),'entry':old_entry},
            'fresh_input_manifest':ref(F/'inputs.json'),'fresh_native_receipt':ref(F/'native-exit.json'),'structural_equality':equality}
    provenance.append(entry)
assert len(provenance)==183
prov=write('owner-provenance.json',{'owners':provenance,'retained_scope':'182 prior owner provenance entries retained byte-for-byte as JSON objects. Only chosen owner has new native/source binding.','prior':ref(P/'owner-provenance.json')})
result=write('current-expression-fingerprints.json',dict(schema=1,artifact_kind='consolidated-current-syntax-successor',
    input_commit=inputs['input_commit'],input_commit_tree=inputs['input_commit_tree'],normalization=inputs['normalization'],
    hash_encoding=inputs['hash_encoding'],counting_note=inputs['counting_note'],files=files,records=new_records,
    selected_modules=prior['selected_modules'],declaration_count=1688,owner_count=183,prior_consolidated=prior_pin,
    owner_provenance=prov,fresh_fingerprints=fresh_pin,fresh_native_receipt=ref(F/'native-exit.json'),
    fresh_native_output=ref(F/'native-output.txt'),fresh_native_raw_archive=archive,structural_equality=equality,
    fresh_owner_count=1,fresh_constant_count=83,retained_owner_count=182,retained_constant_count=1605,
    constant_kinds=prior['constant_kinds'],owner_constant_counts=prior['owner_constant_counts'],
    record_list_unchanged=True,record_list_sha256=canonical(new_records),input_manifest=ref(F/'inputs.json'),
    source_change_scope='Only exact Quality RHS parenthesis insertion; all other owner source hashes and all structural records preserved.',
    consumer_scope='Use this ONE inventory in place of the previous consolidated or seven historical inventories, never append them. Actual future committed-blob verification remains required.'))
git=lambda *args:subprocess.check_output(['git','--no-optional-locks','--no-replace-objects',*args],cwd=R).decode().strip()
for pin in pins:assert sha(R/pin['path'])==pin['sha256'],pin['path']
assert git('rev-parse','HEAD')==inputs['input_commit']
assert git('rev-parse',inputs['input_commit']+'^{tree}')==inputs['input_commit_tree']
receipt=write('fingerprint-receipt.json',dict(schema=1,status='NATIVE ONE-OWNER EQUALITY AND CONSOLIDATED SUCCESSOR PASS',
    frozen_at_utc=datetime.now(timezone.utc).isoformat(),input_commit=inputs['input_commit'],input_commit_tree=inputs['input_commit_tree'],
    fingerprints=result,fresh_fingerprints=fresh_pin,structural_equality=equality,owner_provenance=prov,
    input_manifest=ref(F/'inputs.json'),current_scope=ref(F/'current-scope.json'),native_receipt=ref(F/'native-exit.json'),
    native_output=ref(F/'native-output.txt'),archive=archive,parsed_cache=cache,total_records=1688,total_owners=183,
    fresh_records=83,fresh_owners=1,retained_records=1605,retained_owners=182,actual_native_exit=0,
    record_list_exactly_unchanged=True,source_olean_head_pins_unchanged_during_run=True,
    prior_package_unchanged=True,source_acceptance=False,production_mutation=False,git_mutation=False,
    later_committed_blob_verification_required=True))
print(json.dumps({'receipt':receipt,'consolidated':result,'equality':equality,'archive':archive},indent=2))
