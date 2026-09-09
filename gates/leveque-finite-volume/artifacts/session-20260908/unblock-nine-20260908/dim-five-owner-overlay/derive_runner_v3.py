"""Add the byte-exact unchanged prefix closure required by Lean search semantics."""
import hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent
old=(P/'run_overlay_v2.py').read_bytes();text=old.decode('utf-8')
edits=[('LIB = O / "lib02"','LIB = O / "lib03"'),
 ('P / "runs02" / label','P / "runs03" / label'),
 ('str(P / "run_overlay_v2.py")','str(P / "run_overlay_v3.py")'),
 ('P / "environment-v2.json"','P / "environment-v3.json"'),
 ('P / "dependency-resolutions-v2.json"','P / "dependency-resolutions-v3.json"'),
 ('P / "completion-v2.json"','P / "completion-v3.json"')]
for before,after in edits:
 assert text.count(before)==1,(before,text.count(before))
 text=text.replace(before,after)
before='os.makedirs(native(LIB))\ninherited ='
after='''os.makedirs(native(LIB))
# Lean 4.29 selects the first root containing the entire package prefix.
# Copy only unchanged members of the checked import closure; affected outputs
# must be absent until this run rebuilds them in topological order.
unchanged_copies = []
for mod, entry in plan["project_import_closure"].items():
    if mod in plan["affected_modules_topological"]:
        continue
    for original in entry["compiled_before"]:
        original_path = R / original["path"]
        relative = original_path.relative_to(R / ".lake/build/lib/lean")
        copied = create(LIB / relative, raw(original_path))
        assert copied["sha256"] == original["sha256"]
        unchanged_copies.append({"module": mod, "original": original, "overlay": copied})
create(P / "unchanged-compiled-copies-v3.json", {"copies": unchanged_copies,
    "reason": "Lean.Util.Path.SearchPath.findWithExt chooses one root for the package prefix.",
    "affected_old_oleans_copied": 0})
inherited ='''
assert text.count(before)==1;text=text.replace(before,after)
compile(text,'run_overlay_v3.py','exec')
with (P/'run_overlay_v3.py').open('xb') as f:f.write(text.encode('utf-8'))
with (P/'runner-v3-derivation.json').open('xb') as f:f.write((json.dumps({'before_sha256':hashlib.sha256(old).hexdigest(),'after_sha256':hashlib.sha256(text.encode()).hexdigest(),'edits':edits+[('after fresh LIB creation',after)],'source_changes':False},indent=2)+'\n').encode())
print(hashlib.sha256(text.encode()).hexdigest())
