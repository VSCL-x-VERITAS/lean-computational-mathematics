"""Retain the failed harness and derive an additive syntax-only repair."""
from pathlib import Path
import hashlib,json
H=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=(H/'check.py').read_text(encoding='utf-8')
needle="test('Missing explicit context rejected',lambda:rejects(lambda:c.validate_context({},types.SimpleNamespace(BINDING_FIELDS=set())))))"
assert old.count(needle)==1
new=old.replace(needle,needle[:-1])
compile(new,'check-v2.py','exec')
run=(H/'run-checks.py').read_text(encoding='utf-8').replace("H/'check.py'","H/'check-v2.py'").replace('checks-01','checks-02')
for name,text in [('check-v2.py',new),('run-checks-v2.py',run)]:
 with (H/name).open('xb') as out:out.write(text.encode())
with (H/'harness-v2-derivation.json').open('xb') as out:
 out.write((json.dumps({'reason':'Remove one unmatched closing parenthesis in a test harness; constructor unchanged.',
 'parents':{name:sha(H/name) for name in ['check.py','run-checks.py']},
 'outputs':{name:sha(H/name) for name in ['check-v2.py','run-checks-v2.py']},
 'constructor_sha256':sha(H/'construct_request.py')},indent=2)+'\n').encode())
print(json.dumps({'derived':True,'constructor_sha256':sha(H/'construct_request.py')}))
