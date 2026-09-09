"""Place the exact five already reviewed and isolated-build-checked owner repairs."""
from pathlib import Path
import hashlib, json, os, datetime
P=Path(__file__).resolve().parent
D=P.parent
R=P.parents[5]
def native(p): return '\\\\?\\'+os.path.abspath(p) if os.name=='nt' else str(p)
def raw(p):
    with open(native(p),'rb') as stream:return stream.read()
def sha(p):return hashlib.sha256(raw(p)).hexdigest()
def put(p,data):
    os.makedirs(native(p.parent),exist_ok=True)
    with open(native(p),'xb') as stream:stream.write(data)
def jput(p,data):put(p,(json.dumps(data,indent=2)+'\n').encode())
proposal=D/'dim-blind-evidence-repair/five-owner-proposal.json'
assert sha(proposal)=='7326cc0da682528a8e79630ed1d527a8f5079a640b06a444639549e4254bba8b'
entries=json.loads(raw(proposal))['files']
assert len(entries)==5
prepared=[]
for entry in entries:
    target=(R/entry['target_path']).resolve()
    assert target.is_relative_to(R.resolve())
    assert target.suffix=='.lean' and entry['target_path'].startswith('ComputationalMathematics/')
    source=R/entry['proposal']['path']
    assert sha(target)==entry['current']['sha256'],str(target)
    assert sha(source)==entry['proposal']['sha256'],str(source)
    prepared.append((entry,target,raw(target),raw(source)))
capture=P/'five-owner-placement'
os.makedirs(native(capture),exist_ok=False)
for entry,target,before,after in prepared:
    put(capture/'before'/entry['target_path'],before)
    put(capture/'after'/entry['target_path'],after)
jput(capture/'intent.json',{'proposal_sha256':sha(proposal),'expected_files':entries,
      'status':'prepared; no completion claimed','source_acceptance':False})
changed=[]
try:
    for entry,target,before,after in prepared:
        assert raw(target)==before,('concurrent change',str(target))
        with open(native(target),'wb') as stream:stream.write(after)
        assert sha(target)==entry['proposal']['sha256']
        changed.append({'path':entry['target_path'],'before_sha256':entry['current']['sha256'],
                        'after_sha256':sha(target)})
except BaseException as error:
    jput(capture/'failure.json',{'actual_changed_files':changed,'error':repr(error)})
    raise
jput(capture/'receipt.json',{'format':'five-reviewed-owner-placement-1',
      'completed_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
      'proposal_sha256':sha(proposal),'actual_changed_files':changed,
      'native_canonical_build_complete':False,'source_acceptance':False,
      'git_index_changed':False,'git_ref_changed':False})
print(json.dumps({'receipt':str(capture/'receipt.json'),'sha256':sha(capture/'receipt.json'),
                  'placed_files':len(changed)},indent=2))
