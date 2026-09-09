"""Place the reviewed 16 physical DIM owner snapshots, retaining exact before/after bytes."""
from pathlib import Path
import hashlib,json,os,datetime
P=Path(__file__).resolve().parent
D=P.parent
R=P.parents[5]
native=lambda p:'\\\\?\\'+os.path.abspath(p) if os.name=='nt' else str(p)
def raw(p):
    with open(native(p),'rb') as stream:return stream.read()
def sha(p):return hashlib.sha256(raw(p)).hexdigest()
def put(p,data):
    os.makedirs(native(p.parent),exist_ok=True)
    with open(native(p),'xb') as stream:stream.write(data)
def jput(p,data):put(p,(json.dumps(data,indent=2)+'\n').encode())
mapping=D/'physical-dim-owner-proposals/attempt-06/mapping.json'
assert sha(mapping)=='6b8d51bf7ab2bf4fd585a92ff76c3845488f3119c87fbc8df820a6db978cf498'
entries=json.loads(raw(mapping))['files']
assert len(entries)==16 and sum(e['change']=='new' for e in entries)==12
assert len({e['target_path'] for e in entries})==16
prepared=[]
for entry in entries:
    target=(R/entry['target_path']).resolve()
    assert target.is_relative_to(R.resolve()) and target.suffix=='.lean'
    assert entry['target_path'].startswith('ComputationalMathematics/')
    assert entry['module']==entry['target_path'][:-5].replace('/','.')
    source=R/entry['proposed']['path']
    assert sha(source)==entry['proposed']['sha256']
    if entry['change']=='new':
        assert not os.path.exists(native(target)) and not os.path.exists(native(target.with_suffix('')))
        before=None
    else:
        assert entry['change']=='changed' and sha(target)==entry['current']['sha256']
        before=raw(target)
    prepared.append((entry,target,before,raw(source)))
capture=P/'owner-placement-01'
os.makedirs(native(capture),exist_ok=False)
for entry,target,before,after in prepared:
    if before is not None:put(capture/'before'/entry['target_path'],before)
    put(capture/'after'/entry['target_path'],after)
jput(capture/'intent.json',{'mapping_sha256':sha(mapping),'files':entries,
                           'status':'prepared; no completion claimed','source_acceptance':False})
changed=[]
try:
    for entry,target,before,after in prepared:
        if before is None:assert not os.path.exists(native(target))
        else:assert raw(target)==before,('concurrent change',str(target))
        os.makedirs(native(target.parent),exist_ok=True)
        mode='xb' if before is None else 'wb'
        with open(native(target),mode) as stream:stream.write(after)
        assert sha(target)==entry['proposed']['sha256']
        changed.append({'path':entry['target_path'],'before_sha256':hashlib.sha256(before).hexdigest() if before is not None else None,
                        'after_sha256':sha(target),'change':entry['change'],'role':entry['role']})
except BaseException as error:
    jput(capture/'failure.json',{'actual_changed_files':changed,'error':repr(error)})
    raise
receipt={'format':'reviewed-physical-owner-placement-1',
 'completed_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'mapping_sha256':sha(mapping),'actual_changed_files':changed,
 'new_owners':12,'replaced_owners':4,'native_canonical_build_complete':False,
 'exposure_metadata_updated':False,'source_acceptance':False,'git_index_changed':False,'git_ref_changed':False}
jput(capture/'receipt.json',receipt)
print(json.dumps({'receipt':str(capture/'receipt.json'),'sha256':sha(capture/'receipt.json'),
                  'placed_files':len(changed),'new_owners':12},indent=2))
