"""Freeze this bounded helper preparation; no operational helper is executed."""
from pathlib import Path
import hashlib, importlib.util, json, os

H=Path(__file__).resolve().parent
S=H.parent
R=H.parents[4]
def native(p):
    p=Path(p)
    return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
def sha(p): return hashlib.sha256(native(p).read_bytes()).hexdigest()
def write(name,obj):
    with native(H/name).open('xb') as out:
        out.write((json.dumps(obj,indent=2)+'\n').encode())
spec=importlib.util.spec_from_file_location('batch10_preparation',H/'prepare-v2.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
for name,pin in m.PINS.items(): assert sha(S/name)==pin,(name,sha(S/name))
assert sha(R/'docs/architecture/tiers.json')==m.TIERS_SHA
for name,expected in [('tests-01.receipt.json',1),('tests-02.receipt.json',0)]:
    receipt=json.loads((H/name).read_bytes());assert receipt['exit_code']==expected
    assert sha(receipt['output']['path'])==receipt['output']['sha256']
    for item in receipt['inputs']: assert sha(item['path'])==item['sha256'],item
tests=json.loads((H/'tests.json').read_bytes())
files=[]
for directory,dirs,names in os.walk(native(H)):
    dirs[:]=[d for d in dirs if d!='__pycache__']
    for name in names:
        p=Path(directory)/name
        relative=Path(os.path.relpath(p,native(H))).as_posix()
        assert relative not in ['manifest.json','final-receipt.json'],'already frozen'
        files.append(dict(path=relative,sha256=sha(p),bytes=p.stat().st_size,
            synthetic_fixture=relative.startswith('synthetic-fixture-')))
manifest=dict(schema=1,scope='Additive organization helper preparation only; no generated operational helper executed.',
    authoritative_helper='prepare-v2.py',helper_sha256=sha(H/'prepare-v2.py'),
    tests=dict(actual_exit=0,receipt='tests-02.receipt.json',receipt_sha256=sha(H/'tests-02.receipt.json'),
        results='tests.json',results_sha256=sha(H/'tests.json')),
    preserved_failure=dict(receipt='tests-01.receipt.json',actual_exit=1),
    pinned_parents=m.PINS,tiers_before_sha256=m.TIERS_SHA,
    source_acceptance=False,operational_helpers_executed=False,
    operational_inputs='Final root inventory, entry receipt and actual introduction commit not supplied to the helper.',
    files=sorted(files,key=lambda f:f['path']))
write('manifest.json',manifest)
write('final-receipt.json',dict(schema=1,status='PREPARATION_FROZEN',source_acceptance=False,
    manifest_sha256=sha(H/'manifest.json'),helper_sha256=sha(H/'prepare-v2.py'),readme_sha256=sha(H/'README.md'),
    actual_test_exit=0,test_receipt_sha256=sha(H/'tests-02.receipt.json'),
    limitations='Synthetic/read-only checks only; no actual final input derivation, classification, export, graph capture, FP merge, gate or Git action.'))
print(json.dumps(dict(manifest_sha256=sha(H/'manifest.json'),receipt_sha256=sha(H/'final-receipt.json'),helper_sha256=sha(H/'prepare-v2.py'),readme_sha256=sha(H/'README.md'))))
