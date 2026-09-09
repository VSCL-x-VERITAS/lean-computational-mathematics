"""Prepare a strictly additive current physical-owner publication policy; never stage."""
from pathlib import Path
from datetime import datetime,timezone
import copy,hashlib,importlib.util,json,os,subprocess
P=Path(__file__).resolve().parent
R=P.parents[5]
D=P.parent
S=D.parent
assert os.name=='posix'
def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for data in iter(lambda:f.read(1024*1024),b''):h.update(data)
    return h.hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (P/name).open('x',encoding='utf-8',newline='\n') as out:json.dump(value,out,indent=2,ensure_ascii=True);out.write('\n')
    return ref(P/name)
base_path=P/'policy-final-02.json'
checker_path=P/'check-publication-allowlist-v3.py'
extension_path=P/'extend-final-policy-receipts.py'
assert sha(base_path)=='0dc6d8d74c98c51284170c6c50119bf5423b53d663e8dcb0cfea02f46715ca10'
assert sha(checker_path)=='8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
assert sha(extension_path)=='799d7788ac1c9ec0e7c64bd2a80ed22a963c68f8e7b36ca4d3b1ccad3761ae2f'
spec=importlib.util.spec_from_file_location('unchanged_publication_checker_v3',checker_path)
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
base=read(base_path);m.verify_policy(base);new=copy.deepcopy(base)
started=datetime.now(timezone.utc).isoformat()
command=['git','--no-optional-locks','--no-replace-objects','rev-parse','HEAD']
p=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
assert p.returncode==0
head=p.stdout.decode().strip();assert head==base['snapshot_head']=='5e3f63594aa964263469ada134aee2809559d50d'
head_evidence=dict(command=command,actual_exit_code=p.returncode,stdout=p.stdout.decode(),stderr=p.stderr.decode(),stdout_sha256=hashlib.sha256(p.stdout).hexdigest(),stderr_sha256=hashlib.sha256(p.stderr).hexdigest())
build_path=D/'physical-production-promotion/owners-native-04-receipt.json'
assert sha(build_path)=='85cd930067a2e115ff1434ebbe633a09344332edf9e31b6708602537364b763c'
build=read(build_path);assert build['actual_exit_code']==0 and build['sources_unchanged']
assert sha(R/build['output']['path'])==build['output']['sha256']
for pin in build['input_sources']:assert sha(R/pin['path'])==pin['sha256']
stem='ComputationalMathematics/Analysis/PartialDifferentialEquations/'
new_leaves=['FiniteLineCoordinates','PhysicalLineCapacity','FinitePhysicalFluxError','PhysicalCellMesh',
    'CapacityCoordinateMethod','CapacityCoordinateSweep','CoordinateLineVariation','PhysicalRefinementQuality',
    'PhysicalHighResolutionSweep','Examples/RefiningCartesianGeometry','Examples/RefiningCartesianBoundary','Examples/ZeroFluxCartesianRefinement']
expected={stem+'FiniteVolume/'+name+'.lean' for name in new_leaves}|{stem+'ConservationLaws/Hyperbolicity.lean'}
production=[pin for pin in build['input_sources'] if pin['path'] in expected]
assert {pin['path'] for pin in production}==expected and len(production)==13
assert not expected&set(base['allow_exact'])
assert len([p for p in base['allow_exact'] if p.endswith('.lean')])==46

def bind_existing(path):
    assert path.resolve().is_relative_to(R) and path.is_file()
    assert not any(p.is_symlink() for p in (path,*path.parents) if p.is_relative_to(R))
    assert path.stat().st_size<90000000
    return ref(path)

observed=[p for p in sorted(S.glob('unblock-nine-*')) if p.is_file() and p.suffix in ('.json','.txt')]
receipts=[]
for path in observed:
    name=path.relative_to(R).as_posix()
    if name in base['allow_exact']:continue
    assert name.startswith(S.relative_to(R).as_posix()+'/unblock-nine-')
    assert '/' not in name[len(S.relative_to(R).as_posix())+1:]
    assert name not in base['exclude_exact'] and m.disposition(name,base)[0]!='hold'
    receipts.append(bind_existing(path))
assert len(receipts)==len({pin['path'] for pin in receipts})
new['allow_exact']=sorted(set(base['allow_exact'])|expected|{pin['path'] for pin in receipts})
added_archives=[];fingerprint_inputs=[]
for folder,receipt_sha,parse_name in (
    ('physical-current-fingerprints','7119d1f5b7dcee46469e6061bd7eb11025d3b62f5f562c1fda56971a41769400','freeze-v3-exit.json'),
    ('physical-syntax-fingerprints','fff115e4e1153c1a104d9dc92116dde3dd19b5ce69989080ab95d2e8e6dfaad4','freeze-exit.json')):
    fp=D/folder
    receipt_path=fp/'fingerprint-receipt.json';assert sha(receipt_path)==receipt_sha
    receipt=read(receipt_path);assert receipt['actual_native_exit']==0
    parse=read(fp/parse_name);assert parse['exit_code']==0
    archive=receipt['archive'];assert archive['exact_decompression_verified']
    assert sha(R/archive['path'])==archive['sha256']
    assert (R/archive['path']).stat().st_size==archive['bytes']<90000000
    raw=fp/'native-expression-stream.jsonl'
    assert raw.is_file() and raw.stat().st_size==archive['uncompressed_bytes']
    entry={'receipt':ref(receipt_path),
        'archive':{k:archive[k] for k in ('path','sha256','bytes')},
        'raw':{'path':raw.relative_to(R).as_posix(),'sha256':archive['uncompressed_sha256'],'bytes':archive['uncompressed_bytes']}}
    assert entry['raw']['path'] not in base['exclude_exact']
    new['exclude_exact'][entry['raw']['path']]='Large raw JSONL stream; preserve locally, publish exact verified archive only.'
    added_archives.append(entry)
    fingerprint_inputs.append({'receipt':ref(receipt_path),'parser_archive_actual_exit':ref(fp/parse_name),
        'compressed_bytes_rehashed':True,'decompression_replayed_by_this_preparation':False,
        'exact_decompression_evidence':'Existing actual0 frozen parser/archive receipt; final checker will independently decompress all7 archives.'})
assert len(base['archives'])==5
new['archives']+=added_archives
assert new['archives'][:5]==base['archives'] and len(new['archives'])==7
for entry in base['archives']:
    assert sha(R/entry['receipt']['path'])==entry['receipt']['sha256']
    assert sha(R/entry['archive']['path'])==entry['archive']['sha256']
    assert (R/entry['archive']['path']).stat().st_size==entry['archive']['bytes']
m.verify_policy(new)
changed_keys=sorted(k for k in base if base[k]!=new[k])
assert changed_keys==['allow_exact','archives','exclude_exact']
for key in set(base)-set(changed_keys):assert base[key]==new[key]
assert set(new['allow_exact'])-set(base['allow_exact'])==expected|{pin['path'] for pin in receipts}
assert set(new['exclude_exact'])-set(base['exclude_exact'])=={entry['raw']['path'] for entry in added_archives}
checks=[]
def check(path,expected_status,why):
    actual,reason=m.disposition(path,new);assert actual==expected_status,(path,actual)
    checks.append({'path':path,'expected':expected_status,'actual':actual,'checker_reason':reason,'classification_scope':why})
for pin in production:check(pin['path'],'select','Actual frozen newly-owned production path')
for pin in receipts:check(pin['path'],'select','Actually present direct session receipt/output absent from old exact allowlist; snapshot only')
for entry in new['archives']:
    check(entry['archive']['path'],'select','Hash-checked archive selected')
    check(entry['raw']['path'],'exclude','Exact raw stream retained locally')
for path in base['exclude_exact']:check(path,'exclude','Preserved old explicit exclusion')
probe=D.relative_to(R).as_posix()+'/physical-syntax-fingerprints/'
for suffix in ('unused.olean','unused.ilean','unused.pyc','unused.pyo','__pycache__/unused.json'):
    check(probe+suffix,'hold','Synthetic classification probe only; no file or completed evidence invented')
pending='gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908/'
assert pending not in new['allow_prefixes']
check(pending+'faithfulness/decision.json','exclude','Future audit prefix intentionally pending root preparation; no file existence or verdict asserted')
for pin in production+receipts:assert sha(R/pin['path'])==pin['sha256'],pin['path']
assert sha(base_path)=='0dc6d8d74c98c51284170c6c50119bf5423b53d663e8dcb0cfea02f46715ca10'
assert sha(checker_path)=='8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
assert subprocess.check_output(command,cwd=R)==p.stdout
policy=write('policy-final-physical-01.json',new)
derivation=write('policy-final-physical-01-derivation.json',dict(schema=1,status='PREPARED_POLICY_ROOT_REVIEW_REQUIRED',
    observed_start_utc=started,observed_end_utc=datetime.now(timezone.utc).isoformat(),base_policy=ref(base_path),policy=policy,
    checker=ref(checker_path),receipt_extension_rules_reused=ref(extension_path),source_build=ref(build_path),
    added_production=production,added_observed_session_files=receipts,observed_direct_session_file_count=len(observed),
    added_archives=added_archives,fingerprint_evidence=fingerprint_inputs,preserved_prior_archive_count=5,
    changed_policy_fields=changed_keys,other_policy_fields_json_identical=True,allow_prefixes_unchanged=True,
    classification_checks=checks,git_commands=[head_evidence],future_audit_prefix_pending=pending,
    note_scope='Old notes/path_discovery are preserved historical fields. Current counts are59 exact Lean paths and7 archives; this derivation supplies the additive scope without rewriting historical notes.',
    snapshot_limit='Only observed existing session files were added. Later files and the not-yet-prepared physical audit require a root-reviewed extension. No final publication completeness asserted.',
    publication_complete=False,stage_performed=False,git_mutation=False,official_publication_checker_main_run=False))
print(json.dumps({'policy':policy,'derivation':derivation,'added_production':len(production),'added_session_files':len(receipts),'archives':7,'classification_checks':len(checks),'changed_fields':changed_keys},indent=2))
