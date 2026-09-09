from pathlib import Path
import hashlib, json, difflib
P=Path(__file__).resolve().parent
old_path=P.parent/'physical-high-resolution-sweep-draft/freeze.py'
old=old_path.read_text(encoding='utf-8')
new=old
changes=[
 ('physical-high-resolution-sweep','physical-admitted-high-resolution-sweep'),
 ("A = P / 'native-03'", "A = P / 'native-01'"),
 ('Sweep.lean.fragment','Admitted.lean.fragment'),
 ('== 6\n','== 3\n'),
 ('== 59,','== 61,'),
 ("'authored_declarations': 6", "'authored_declarations': 3"),
 ("'total_axiom_reports': 59", "'total_axiom_reports': 61")]
for a,b in changes:
    assert a in new,a
    new=new.replace(a,b)
needle="assert raw(P/'Admitted.lean.fragment') == raw(A/'Admitted.lean.fragment')"
new=new.replace(needle,needle+"\nassert raw(P/'SourceTarget.lean.fragment') == raw(A/'SourceTarget.lean.fragment')",1)
with (P/'freeze.py').open('x',encoding='utf-8',newline='\n') as out:out.write(new)
with (P/'freezer.diff').open('x',encoding='utf-8',newline='\n') as out:
    out.writelines(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile=str(old_path),tofile=str(P/'freeze.py')))
print(json.dumps({'basis_sha256':hashlib.sha256(old_path.read_bytes()).hexdigest(),
 'successor_sha256':hashlib.sha256((P/'freeze.py').read_bytes()).hexdigest()},indent=2))
