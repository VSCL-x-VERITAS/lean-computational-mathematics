"""Additive Windows extended-path adaptation; no mathematical input edits."""
import hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent
old=(P/'run_overlay.py').read_bytes()
text=old.decode('utf-8')
edits=[
 ('LIB = O / "lib"','LIB = O / "lib02"'),
 ('P / "runs" / label','P / "runs02" / label'),
 ('str(P / "run_overlay.py")','str(P / "run_overlay_v2.py")'),
 ('P / "environment.json"','P / "environment-v2.json"'),
 ('os.pathsep.join([str(LIB)] + inherited_entries)','os.pathsep.join([native(LIB)] + inherited_entries)'),
 ('[lean, "-R", str(O), "--deps", relative_source]','[lean, "-R", native(O), "--deps", native(O / relative_source)]'),
 ('path = Path(line.strip())','path = Path(line.strip().removeprefix("\\\\\\\\?\\\\"))'),
 ('[lean, "-R", str(O), source, "-o", str(output), "-i", str(info)]','[lean, "-R", native(O), native(O / source), "-o", native(output), "-i", native(info)]'),
 ('[lean, "-R", str(O), name, "-o", str(LIB / (label + ".olean")),','[lean, "-R", native(O), native(O / name), "-o", native(LIB / (label + ".olean")),'),
 ('"-i", str(LIB / (label + ".ilean"))]','"-i", native(LIB / (label + ".ilean"))]'),
 ('[lean, "-R", str(O), "ImportClosureProbe.lean"]','[lean, "-R", native(O), native(O / "ImportClosureProbe.lean")]'),
 ('path = Path(location)','path = Path(location.removeprefix("\\\\\\\\?\\\\"))'),
 ('P / "dependency-resolutions.json"','P / "dependency-resolutions-v2.json"'),
 ('P / "completion.json"','P / "completion-v2.json"'),
]
for before,after in edits:
 assert text.count(before)==1,(before,text.count(before))
 text=text.replace(before,after)
compile(text,'run_overlay_v2.py','exec')
with (P/'run_overlay_v2.py').open('xb') as f:f.write(text.encode('utf-8'))
with (P/'runner-v2-derivation.json').open('xb') as f:f.write((json.dumps({'before_sha256':hashlib.sha256(old).hexdigest(),'after_sha256':hashlib.sha256(text.encode()).hexdigest(),'edits':edits,'source_changes':False},indent=2)+'\n').encode())
print(hashlib.sha256(text.encode()).hexdigest())
