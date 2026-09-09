"""Verify existing native mathematical evidence, then freeze scratch files only."""
from pathlib import Path
import hashlib
import json
import re
D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p/'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def emit(name, value):
    with (D/name).open('xb') as f:
        f.write((json.dumps(value, indent=2)+'\n').encode())

origin = D.parent/'directional-reference-repair'
qr = origin/'quality03-receipt.json'
assert sha(qr) == '4d965fc5e0b2d785e9c9485d246e8aacd0022350ad3de901683672575d6ed41b'
receipt = json.loads(qr.read_text())
assert receipt['actual_exit_code'] == 0 and receipt['dependencies_unchanged']
for ent in [receipt['source'], receipt['output']]:
    assert sha(R/ent['path']) == ent['sha256']
assert sha(D/'quality03-Quality.lean.snapshot') == '6ac065b220e5610af0144e2205dcff3c6c3291e97d45fc9bf02ac605bd308b4c'
prior = D.parent/'dim-local-characteristic-witness/Connected.lean'
assert sha(prior) == '4e7828e9187049393e81df858aefbe5973accbd7d45402b50e70bc8c5f115f30'
imports = ['import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField\n',
           'import Mathlib.Algebra.Order.Floor.Ring\n']
bodies=[]
for path in [prior, D/'quality03-Quality.lean.snapshot']:
    lines=path.read_text().splitlines(keepends=True)
    imports += [x for x in lines if x.startswith('import ') and x not in imports]
    bodies.append(''.join(x for x in lines if not x.startswith(('import ', '#check ', '#print '))))
candidate=(D/'Candidate.lean').read_bytes()
assert candidate == (''.join(imports)+'\n'+''.join(bodies)+(D/'Family.lean.fragment').read_text()).encode()
assert b'\r' not in candidate
assert not re.search(rb'\b(sorry|admit|unsafe)\b', candidate)
assert (D/'Checks.lean').read_bytes().startswith(candidate)
snapshots = {sha(p):p for p in D.rglob('*.lean.snapshot')}
attempts, bindings, dependencies = [], [], {}
for i in range(1,4):
    folder=D/f'native-{i:02d}'
    native=json.loads((folder/'receipt.json').read_text())
    assert native['exit_code'] == (1 if i==1 else 0)
    assert native['inputs_unchanged'] and native['git_invocations']==native['model_role_invocations']==0
    assert sha(folder/'output.txt')==native['output_sha256']
    main=snapshots[native['input_snapshot_sha256']]
    runner=D/('run.py' if i<3 else 'run-checks.py')
    assert sha(runner)==native['runner_sha256']
    for ent in native['inputs']:
        assert ent['sha256_before']==ent['sha256_after']
        path=R/ent['path']
        resolved=path if sha(path)==ent['sha256_before'] else snapshots[ent['sha256_before']]
        bindings.append({'attempt':i,'recorded_path':ent['path'],'sha256':ent['sha256_before'],'resolved':ref(resolved)})
        if not path.is_relative_to(D):
            dependencies[ent['path']]=ent['sha256_before']
    attempts.append({'receipt':ref(folder/'receipt.json'),'actual_exit':native['exit_code'],
                     'main_input':ref(main),'output':ref(folder/'output.txt'),'runner':ref(runner)})
assert (D/'native-03/Checks.lean.snapshot').read_bytes()==(D/'Checks.lean').read_bytes()
names=json.loads((D/'declarations.json').read_text())['declarations']
output=(D/'native-03/output.txt').read_text()
assert not any(x in output for x in ['error:','warning:','sorryAx'])
reports={}
for name,body in re.findall(r"'([^']+)' depends on axioms: \[([^]]*)\]",output):
    reports[name]=[x.strip() for x in body.split(',') if x.strip()]
for name in re.findall(r"'([^']+)' does not depend on any axioms",output):
    reports[name]=[]
assert set(reports)=={'CFL1QualityFamilyWitness.'+x for x in names}
assert all(set(xs)<={'propext','Classical.choice','Quot.sound'} for xs in reports.values())
emit('verification.json',{'schema':1,'status':'PASS','bindings':bindings,'axiom_reports':reports,
                         'axiom_count':len(reports),'final_actual_exit':0,'assembly_exact':True})
emit('manifest.json',{'schema':1,'status':'PASS_COMPLETE_QUALITY_FAMILY_WITNESS','source_acceptance':False,
    'full_quality_family_instance':True,'candidate':ref(D/'Candidate.lean'),
    'authored_fragment':ref(D/'Family.lean.fragment'),'declarations':names,'declaration_count':len(names),
    'fragment_lines':len((D/'Family.lean.fragment').read_text().splitlines()),
    'quality_origin_receipt':ref(qr),'quality_origin_snapshot':ref(D/'quality03-Quality.lean.snapshot'),
    'prior_local_witness':ref(prior),'prior_local_receipt':ref(D.parent/'dim-local-characteristic-witness/receipt.json'),
    'prior_transport_receipt':ref(D.parent/'dim-cfl1-witness/receipt.json'),
    'literal_interpretation':ref(D.parent/'user-high-resolution-interpretation-20260908.json'),
    'attempts':attempts,'dependencies':dependencies,
    'files':[ref(p) for p in sorted(D.rglob('*')) if p.is_file() and '__pycache__' not in p.parts]})
emit('receipt.json',{'schema':1,'status':'PASS_COMPLETE_QUALITY_FAMILY_WITNESS','source_acceptance':False,
    'full_quality_family_instance':True,'manifest':ref(D/'manifest.json'),'candidate':ref(D/'Candidate.lean'),
    'authored_fragment':ref(D/'Family.lean.fragment'),'review':ref(D/'REVIEW.md'),
    'native_receipt':ref(D/'native-03/receipt.json'),'actual_exit':0,'axiom_reports':len(reports)})
print(json.dumps({'receipt':ref(D/'receipt.json'),'candidate':ref(D/'Candidate.lean'),
    'fragment':ref(D/'Family.lean.fragment'),'manifest':ref(D/'manifest.json'),'actual_exit':0,'axiom_reports':len(reports)},indent=2))
