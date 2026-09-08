"""Read-only installer review and isolated file-set cases; never execute an installer."""
from pathlib import Path
import ast, copy, hashlib, importlib.util, json, os, types

H=Path(__file__).resolve().parent
S=H.parent
R=S.parents[3]
PINS={
    'install-reviewed-blocked-gate.py':'7a58407aa57755f95d4905708c8185e0f61bc90dee9535c86dca89f1e39ad0b6',
    'install-reviewed-blocked-gate-v2.py':'1126be629bc417e249f4696bcf41b5d7aff8c3f402af3f835a4db23e02634cd6',
    'blocked-gate-installer-v2-derivation.json':'00580d031020d0ef11b4c3bc38a143d584b41d3c183646ca2fbcd046a47309ed',
    'install-reviewed-blocked-gate-v3.py':'6e2fb502fbd341eaedee506710e5a49067bfbaa3f153bd34ee5f44638b389dad',
    'blocked-gate-installer-v3-derivation.json':'cb84430d1d049e8120509e3f1774d630c5a142a92db775cfd8ca31f428805987',
    'blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py':'dbfb374e263b7b0a2f25e9d1b8815a3e65d4e4e0e693581c24a881299fa017a9'}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert os.name=='posix','Use the existing POSIX launcher'
subjects=[]
for name,pin in PINS.items():
    path=S/name;assert sha(path)==pin,name
    subjects.append(dict(path=str(path),sha256=pin))
bp=S/'blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py'
spec=importlib.util.spec_from_file_location('bounded_review_helper',bp)
b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
for path,pin in b.PINS.values():
    assert sha(path)==pin,str(path)
    subjects.append(dict(path=str(path),sha256=pin))
checker_path=b.CHECKER
checker_tree=ast.parse(checker_path.read_text(encoding='utf-8'))
cross_node=next(n for n in checker_tree.body if isinstance(n,ast.FunctionDef) and n.name=='cross_gate_state')
scope={'Path':Path,'json':json}
exec(compile(ast.Module(body=[cross_node],type_ignores=[]),str(checker_path),'exec'),scope)
cross=scope['cross_gate_state']
results=[]
def record(name,run):
    run();results.append(dict(name=name,status='PASS'))
def reject(run):
    try:run()
    except (ValueError,OSError):return
    raise AssertionError('expected rejection')
def syntax():
    for name in PINS:
        if name.endswith('.py'): compile((S/name).read_text(encoding='utf-8'),name,'exec')
record('Pinned source/parent chain and Python syntax; no installer imported or executed',syntax)
v1=(S/'install-reviewed-blocked-gate.py').read_text(encoding='utf-8')
v2=(S/'install-reviewed-blocked-gate-v2.py').read_text(encoding='utf-8')
addition1=" organization=proposed['verification_loops']['organization_completeness']\n cross_gate_before=checker.cross_gate_state(b.ROOT,organization)\n b.require(not cross_gate_before[1],'cross-gate organization mismatch')\n"
addition2=" b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed before installation')\n"
addition3="  b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed at write boundary')\n"
def exact_delta():
    reduced=v2
    for part in [addition1,addition2,addition3]:
        assert reduced.count(part)==1;reduced=reduced.replace(part,'')
    assert reduced==v1
record('V2 consists exactly of the three reported cross-gate additions',exact_delta)
v3=(S/'install-reviewed-blocked-gate-v3.py').read_text(encoding='utf-8')
validation=" complete=b.validate_proposed(proposed,context,checker,reader)\n"
after_validation=" b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed during validation')\n"
def v3_delta():
    assert v2.count(validation+addition1)==1
    assert v3==v2.replace(validation+addition1,addition1+validation+after_validation)
    assert v3.index(addition1)<v3.index(validation)<v3.index(after_validation)
    assert addition3+'  os.replace(temporary,b.GATE)' in v3
record('V3 exactly moves the snapshot before validation and adds the immediate post-validation rescan',v3_delta)

identities=json.loads((bp.parent/'expected-row-set.json').read_bytes())
base={'rows':[]}
for row,status in identities['closed_rows'].items():base['rows'].append({'id':row,'status':status,'preserve':[1,True,'raw ρ']})
for row in identities['skipped_rows']:base['rows'].append({'id':row,'status':'SKIPPED','preserve':[1,True,'raw ρ']})
for row in identities['choice_rows']:base['rows'].append({'id':row,'status':'READY'})
proposed=copy.deepcopy(base['rows'])
for row in proposed:
    if row['status']=='READY':
        row.update(status='HARD_BLOCKED',blocker_kind='material-user-choice',
                   **{k:'Synthetic test narrative only' for k in b.DETAILS})
checker=types.SimpleNamespace(meaningful=lambda obj,key:isinstance(obj.get(key),str) and bool(obj[key]))
record('Synthetic exact 57-row transition preserves all closed/skipped encoded objects',lambda:b.check_transition(base,proposed,identities,checker))
def closed_type_change():
    changed=copy.deepcopy(proposed);changed[0]['preserve'][0]=1.0
    reject(lambda:b.check_transition(base,changed,identities,checker))
record('Closed-row integer/float serialization change rejected',closed_type_change)
def skipped_change():
    changed=copy.deepcopy(proposed);next(r for r in changed if r['status']=='SKIPPED')['preserve'][2]='changed'
    reject(lambda:b.check_transition(base,changed,identities,checker))
record('Skipped-row content change rejected',skipped_change)
record('Row order change rejected',lambda:reject(lambda:b.check_transition(base,list(reversed(proposed)),identities,checker)))

F=H/'fixtures'
assert not F.exists(),'fresh isolated fixture directory required'
F.mkdir()
org={'mixed_modules':0}
def make_case(name):
    root=F/name;gate=root/'gates/example/chapter-01.json';gate.parent.mkdir(parents=True)
    gate.write_text(json.dumps({'verification_loops':{'organization_completeness':org}}),encoding='utf-8')
    return root,gate
def add_gate(root,counters=org):
    added=root/'gates/example/chapter-02.json'
    added.write_text(json.dumps({'verification_loops':{'organization_completeness':counters}}),encoding='utf-8')
    return added
def known_change():
    root,gate=make_case('known-change');reader=b.Reader(root);reader.raw(gate)
    gate.write_text('{}',encoding='utf-8');reject(reader.unchanged)
record('Reader rejects a changed already-bound gate',known_change)
def v1_gap():
    root,gate=make_case('v1-new-file-gap');reader=b.Reader(root);reader.raw(gate)
    validated=cross(root,org);assert validated[1]==[]
    add_gate(root);reader.unchanged()
    assert cross(root,org)!=validated and cross(root,org)[1]==[]
record('V1 counterexample: newly added matching-counter gate escapes known-file rehash',v1_gap)
def v2_gap():
    root,gate=make_case('v2-post-validation-baseline-gap');reader=b.Reader(root);reader.raw(gate)
    validated=cross(root,org)
    add_gate(root)
    later_baseline=cross(root,org);assert not later_baseline[1]
    reader.unchanged();assert cross(root,org)==later_baseline
    assert validated!=later_baseline
record('V2 counterexample: post-validation snapshot can absorb the newly added gate',v2_gap)
def rescans_work():
    root,gate=make_case('early-snapshot');reader=b.Reader(root);reader.raw(gate)
    before=cross(root,org);add_gate(root);reader.unchanged()
    reject(lambda:b.require(cross(root,org)==before,'changed set'))
record('Snapshot before validation plus later equality rejects a newly added gate',rescans_work)
def mismatch():
    root,gate=make_case('counter-mismatch');add_gate(root,{'mixed_modules':1})
    assert cross(root,org)[1]
record('Released cross_gate_state detects mismatching organization counters',mismatch)
def final_guards():
    root,gate=make_case('literal-v3-guards')
    before=cross(root,org)
    env={'b':types.SimpleNamespace(ROOT=root,require=b.require),
         'checker':types.SimpleNamespace(cross_gate_state=cross),
         'organization':org,'cross_gate_before':before}
    tree=ast.parse(v3)
    guards=[n for n in ast.walk(tree) if isinstance(n,ast.Expr) and isinstance(n.value,ast.Call)
            and len(n.value.args)==2 and isinstance(n.value.args[1],ast.Constant)
            and isinstance(n.value.args[1].value,str)
            and n.value.args[1].value.startswith('cross-gate set/counters changed')]
    assert len(guards)==3
    codes=[compile(ast.Module(body=[g],type_ignores=[]),'isolated-exact-v3-guard','exec') for g in guards]
    for code in codes:exec(code,env)
    add_gate(root)
    for code in codes:reject(lambda code=code:exec(code,env))
record('All three literal V3 equality guards accept an unchanged set and reject the added gate',final_guards)

for item in subjects: assert sha(Path(item['path']))==item['sha256']
result=dict(schema=1,scope='Static source/delta verification and isolated pure-function fixtures only. No installer CLI, operational preparation, current gate/context/transcript, Git, audit or terminal verification executed.',
            os_name=os.name,tests=results,count=len(results),subjects=subjects,
            source_acceptance=False,installation_authorized=False)
with (H/'checks.json').open('xb') as out:out.write((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps(dict(actual_checks_passed=len(results),results_sha256=sha(H/'checks.json'),operational_installer_executed=False)))
