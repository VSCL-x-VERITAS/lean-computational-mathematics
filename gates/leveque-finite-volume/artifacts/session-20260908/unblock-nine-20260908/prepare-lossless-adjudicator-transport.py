"""Derive one additive transport with lossless JSON whitespace compaction."""
from pathlib import Path
import hashlib
import json
import os

assert os.name == 'nt'
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
tid = 'LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908'
T = Path(chr(92) * 2 + '?' + chr(92) + str(S / 'audits' / tid))
O = T / 'faithfulness'
P = O / 'orchestration'
assert not (O / 'decision.json').exists()
assert not (O / 'agent_outputs/adjudicator.json').exists()
old_transport = json.loads((P / 'a_transport.json').read_bytes())
assert old_transport['exit_code'] == 1
events = [json.loads(line) for line in (P / 'a_events.jsonl').read_text(encoding='utf-8').splitlines()]
assert [e['type'] for e in events] == ['thread.started']
assert 'input_too_large' in (P / 'a_stderr.txt').read_text(encoding='utf-8')
original = (P / 'r.py').read_text(encoding='utf-8')
old = " data=path.read_bytes();parts.append(('\\n\\n'+label+' SHA256 '+hashlib.sha256(data).hexdigest()+'\\n').encode()+data);records.append({'label':label,'path':str(path),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)})"
new = ''' data=path.read_bytes()
 payload=data
 if path.suffix=='.json':
  def unique(pairs):
   result={}
   for k,v in pairs:
    assert k not in result, 'duplicate JSON key in frozen input'
    result[k]=v
   return result
  decoded=json.loads(data,object_pairs_hook=unique)
  payload=json.dumps(decoded,ensure_ascii=False,separators=(',',':')).encode()
  assert json.loads(payload,object_pairs_hook=unique)==decoded
  label=label+' (original-byte hash; complete lossless JSON representation with formatting whitespace removed)'
 parts.append(('\\n\\n'+label+' SHA256 '+hashlib.sha256(data).hexdigest()+'\\n').encode()+payload)
 records.append({'label':label,'path':str(path),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data),'transported_sha256':hashlib.sha256(payload).hexdigest(),'transported_bytes':len(payload),'lossless_json':path.suffix=='.json'})'''
assert original.count(old) == 1
successor = original.replace(old, new)
restriction = "assert task=='" + tid + "'"
assert successor.count(restriction) == 1
successor = successor.replace(restriction, restriction + "\nassert role=='adjudicator' and stem=='a2'\nassert pages_arg=='26,27,28'")
compile(successor, 'r-lossless-json.py', 'exec')
destination = P / 'r-lossless-json.py'
with destination.open('x', encoding='utf-8', newline='') as f:
    f.write(successor)
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
checked = []
for record in old_transport['inputs']:
    path = Path(record['path'])
    assert sha(path) == record['sha256']
    if path.suffix == '.json':
        data = path.read_bytes()
        payload = json.dumps(json.loads(data), ensure_ascii=False, separators=(',', ':')).encode()
        assert json.loads(payload) == json.loads(data)
        checked.append({'original_sha256': sha(path), 'bytes_before': len(data), 'bytes_after': len(payload)})
receipt = {'format': 'lossless-json-transport-derivation-1', 'task_id': tid,
           'parent': {'path': str(P / 'r.py'), 'sha256': sha(P / 'r.py')},
           'successor': {'path': str(destination), 'sha256': sha(destination)},
           'failed_attempt_sha256': sha(P / 'a_transport.json'),
           'failed_attempt_started_no_turn': True, 'original_attempt_retained': True,
           'unchanged_dossiers_and_source_images': True, 'json_equivalence_checks': checked,
           'byte_savings': sum(r['bytes_before'] - r['bytes_after'] for r in checked)}
assert receipt['byte_savings'] > 30000
with (D / 'lossless-adjudicator-transport-receipt.json').open('xb') as f:
    f.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
