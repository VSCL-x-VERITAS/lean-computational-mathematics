"""Derive a native attempt runner without changing any frozen predecessor."""
from pathlib import Path
import hashlib, json, difflib
P = Path(__file__).resolve().parent
D = P.parent
old_path = D/'physical-high-resolution-sweep-draft/run_native.py'
old = old_path.read_text(encoding='utf-8')
assert hashlib.sha256(old_path.read_bytes()).hexdigest() == 'b030f8720f127a4111dc963ad81b117630ebe12c3d1750a93876827ef776f54c'
new = old.replace("P=D/'physical-high-resolution-sweep-draft'", "P=D/'physical-admitted-high-resolution-sweep'", 1)
start = new.index("bridge=D/'physical-refinement-quality-draft/native-02/Candidate.lean'")
end = new.index('seen=set()', start)
replacement = '''bridge=D/'physical-high-resolution-sweep-draft/native-03/Candidate.lean'
bridge_ref=ref(bridge);assert bridge_ref['sha256']=='73daca68c54303af3d73dd4916b2792b33b44c0b258e8c136ae95cc82525304e'
old_target=D/'physical-high-resolution-sweep-draft/SourceTarget.lean.fragment'
old_checks=D/'physical-high-resolution-sweep-draft/Checks.lean.fragment'
suffix=raw(old_target)+b'\\n'+raw(old_checks)
basis=raw(bridge);assert basis.endswith(suffix)
basis=basis[:-len(suffix)]
assert b'theorem leveque01_coordinateHighResolutionMethods_sourceContract' not in basis
source_target=P/'SourceTarget.lean.fragment'
fragment=P/'Admitted.lean.fragment'
put(A/'Admitted.lean.fragment',raw(fragment))
put(A/'SourceTarget.lean.fragment',raw(source_target))
source=basis+b'\\n'+raw(fragment)+b'\\n'+raw(source_target)
candidate=A/'Candidate.lean';candidate_ref=put(candidate,source)
pins=[bridge_ref,ref(old_target),ref(old_checks),ref(fragment),ref(source_target),candidate_ref,
      ref(P/'run_native.py'),ref(R/'lean-toolchain'),ref(R/'lake-manifest.json')]
'''
new = new[:start]+replacement+new[end:]
assert new != old
with (P/'run_native.py').open('x', encoding='utf-8', newline='\n') as out: out.write(new)
with (P/'runner.diff').open('x', encoding='utf-8', newline='\n') as out:
    out.writelines(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile=str(old_path),tofile=str(P/'run_native.py')))
record={'basis':str(old_path),'basis_sha256':hashlib.sha256(old_path.read_bytes()).hexdigest(),
        'successor_sha256':hashlib.sha256((P/'run_native.py').read_bytes()).hexdigest(),
        'change':'Replace only candidate assembly with frozen mathematical prefix and admitted source successor; native command and input pin validation unchanged.'}
with (P/'runner-derivation.json').open('x', encoding='utf-8') as out: json.dump(record,out,indent=2)
print(json.dumps(record,indent=2))
