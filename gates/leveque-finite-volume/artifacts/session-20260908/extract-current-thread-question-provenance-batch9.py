"""Additive exact current-task question/reply projection; exclude reasoning and unrelated text."""
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
   calls.append({'line':number,'line_sha256':hashlib.sha256(line).hexdigest(),'timestamp':obj.get('timestamp'),
    'call_id':p.get('call_id'),'name':p.get('name'),'arguments':json.loads(p['arguments'])})
  if p.get('type')=='message' and p.get('role')=='user':
   for item in p.get('content',[]):
    text=item.get('text','')
    if '<send_user_message_question_reply>' not in text:continue
    start=text.index('<send_user_message_question_reply>')+len('<send_user_message_question_reply>')
    end=text.index('</send_user_message_question_reply>',start)
    replies.append({'line':number,'line_sha256':hashlib.sha256(line).hexdigest(),'timestamp':obj.get('timestamp'),
     'answers':json.loads(text[start:end].strip())})
assert confirmed and len(calls)>=11
prior=S/'current-thread-clarification-provenance-batch8.json'
assert hashlib.sha256(prior.read_bytes()).hexdigest()=='2c21df1471dc2dcfaeb69e8d31f7682e41944d6ab176f134f69d41444bf91a30'
old=json.loads(prior.read_bytes())
assert calls[:len(old['clarification_calls'])]==old['clarification_calls']
assert replies[:len(old['explicit_question_replies'])]==old['explicit_question_replies']
record={'schema':1,'thread_id':thread,'as_of_utc':datetime.now(timezone.utc).isoformat(),
 'prior_projection_sha256':hashlib.sha256(prior.read_bytes()).hexdigest(),
 'source':'Exact current-task local conversation question calls and explicit replies only. Original line hashes are bound; no volatile whole-file hash, reasoning or unrelated message content is exposed.',
 'clarification_calls':calls,'explicit_question_replies':replies,
 'interpretation':'Only explicit replies authorize an interpretation. Missing replies are not answers. Later input requires an additive update; no current row is marked blocked by this projection.'}
dest=S/'current-thread-clarification-provenance-batch9.json'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'path':dest.name,'sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),
 'clarification_calls':len(calls),'explicit_reply_messages':len(replies),
 'new_call_ids':[c['call_id'] for c in calls[len(old['clarification_calls']):]]}))
