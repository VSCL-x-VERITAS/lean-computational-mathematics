"""Remove obsolete fixed native paths while preserving the binding checks."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
old = D / 'prepare-source-context-binding-request.py'
assert sha(old) == '5262735e1f0ffd0286ee5b44d4d37521426999035386965a4c8db8525764b091'
changes = [
    ("specification=json.loads(Path(sys.argv[1]).read_bytes())", "assert len(sys.argv)==5, 'SPEC DESTINATION CURRENT_NATIVE_MANIFEST CURRENT_NATIVE_LABEL'\nspecification=json.loads(Path(sys.argv[1]).read_bytes())"),
    ("native_manifest=D/'local-complete-declaration-manifest.json'", "native_manifest=Path(sys.argv[3]).resolve()\nassert native_manifest.is_relative_to(D.resolve())\nnative_label=sys.argv[4]\nassert native_label and all(c.isascii() and (c.isalnum() or c in '-_') for c in native_label)"),
    ("assert all(sha(R/f['path'])==f['sha256'] for f in manifest['files'])", "assert all(sha(R/f['path'])==f['sha256'] for f in manifest['files'])\ncheck_path=(R/manifest['check_file']).resolve()\nassert check_path.is_relative_to(D.resolve()) and sha(check_path)==manifest['check_file_sha256']\nnative_receipt=json.loads((S/(native_label+'-exit.json')).read_bytes())\nassert type(native_receipt['exit_code']) is int and native_receipt['exit_code']==0\nassert native_receipt['argv']==['lake','env','lean',manifest['check_file']]\nassert native_receipt['output_sha256']==sha(S/(native_label+'-output.txt'))"),
    ("'check':ref(D/'LocalCompleteDeclarations.lean')", "'check':ref(check_path)"),
    ("'output':ref(S/'unblock-nine-local-complete-declarations-02-output.txt')", "'output':ref(S/(native_label+'-output.txt'))"),
    ("'receipt':ref(S/'unblock-nine-local-complete-declarations-02-exit.json')", "'receipt':ref(S/(native_label+'-exit.json'))")]
text = old.read_text(encoding='utf-8')
for before, after in changes:
    assert text.count(before) == 1
    text = text.replace(before, after)
new = D / 'prepare-source-context-binding-request-v2.py'
compile(text, new.name, 'exec')
with new.open('xb') as stream:
    stream.write(text.encode())
record = {'format': 'current-native-binding-preparation-derivation-1',
          'parent': {'path': old.name, 'sha256': sha(old)},
          'output': {'path': new.name, 'sha256': sha(new)},
          'exact_replacements': [{'before': a, 'after': b} for a, b in changes],
          'operational_requests_created': 0, 'gate_mutations': 0}
with (D / 'current-native-binding-preparation-derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record['output']))
