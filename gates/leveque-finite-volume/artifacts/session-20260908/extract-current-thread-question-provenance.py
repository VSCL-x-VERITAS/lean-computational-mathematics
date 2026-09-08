"""Freeze only explicit clarification calls and user replies from this task's local record."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
S=Path(__file__).resolve().parent
thread='01a07fae-4a67-7770-98b0-b95c4e393705'
path=Path('C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-'+thread+'.jsonl')
calls=[];replies=[];confirmed=False
with path.open('rb') as f:
 for number,line in enumerate(f,1):
  try:obj=json.loads(line)
  except json.JSONDecodeError:continue
  p=obj.get('payload',{})
  if obj.get('type')=='session_meta':
   assert p.get('id')==thread;confirmed=True
  if obj.get('type')!='response_item':continue
  if p.get('type')=='function_call' and 'request_user_input_async' in p.get('name',''):
   calls.append({'line':number,'line_sha256':hashlib.sha256(line).hexdigest(),'timestamp':obj.get('timestamp'),'call_id':p.get('call_id'),'name':p.get('name'),'arguments':json.loads(p['arguments'])})
  if p.get('type')=='message' and p.get('role')=='user':
   for item in p.get('content',[]):
    text=item.get('text','')
    if '<send_user_message_question_reply>' not in text:continue
    start=text.index('<send_user_message_question_reply>')+len('<send_user_message_question_reply>')
    end=text.index('</send_user_message_question_reply>',start)
    answers=json.loads(text[start:end].strip())
    replies.append({'line':number,'line_sha256':hashlib.sha256(line).hexdigest(),'timestamp':obj.get('timestamp'),'answers':answers})
assert confirmed and calls
record={'schema':1,'thread_id':thread,'as_of_utc':datetime.now(timezone.utc).isoformat(),'source':'Exact current-task local conversation records only; volatile whole-file hash is not asserted. Each included original JSONL line is hash-bound. No reasoning, other tasks or unrelated messages were read into this artifact.','clarification_calls':calls,'explicit_question_replies':replies,'interpretation':'Calls show what was asked; only explicit user replies authorize adoption. A missing reply is not an answer or approval. Later user input requires an additive update.'}
dest=S/'current-thread-clarification-provenance-batch8.json'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'path':dest.name,'sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),'clarification_calls':len(calls),'explicit_reply_messages':len(replies),'questions':[{'call_id':c['call_id'],'questions':c['arguments'].get('questions',[])} for c in calls]}))
