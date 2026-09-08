"""Additive current-thread user-question freshness review, excluding reasoning."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent
T=Path('C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-01a07fae-4a67-7770-98b0-b95c4e393705.jsonl')
old_count=14462;old_sha='ddee927eed86844fc8be72b2f1e5c10fbecc1a82025379f0993475f2b75a9311'
prefix=hashlib.sha256();current=hashlib.sha256();hooks=[];questions=[];replies=[]
for n,raw in enumerate(T.open('rb'),1):
 current.update(raw)
 if n<=old_count:prefix.update(raw);continue
 obj=json.loads(raw);p=obj.get('payload',{})
 if obj.get('type')!='response_item' or not isinstance(p,dict):continue
 if p.get('type')=='function_call' and 'request_user_input_async' in p.get('name',''):questions.append(n)
 if p.get('type')=='message' and p.get('role')=='user':
  content='\n'.join(i.get('text','') for i in p.get('content',[]) if isinstance(i,dict))
  if '<send_user_message_question_reply>' in content:replies.append(n)
  assert content.startswith('<hook_prompt hook_run_id="stop:1:') and content.endswith('</hook_prompt>'),('unexpected user record',n)
  assert 'timed out after 20 seconds' in content and 'diagnose it before stopping' in content
  dest=D/('automatic-stop-line-'+str(n)+'.jsonl')
  with dest.open('xb') as f:f.write(raw)
  hooks.append({'line':n,'timestamp':obj.get('timestamp'),'kind':'automatic-stop-hook-timeout','sha256':hashlib.sha256(raw).hexdigest(),'record_name':dest.name,'contains_source_choice':False})
assert prefix.hexdigest()==old_sha and not questions and not replies
assert len(hooks)==2,len(hooks)
record={'kind':'fresh-question-projection-suffix-review-after-second-automatic-hook','original_projection_sha256':'15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc','prior_snapshot_lines':old_count,'prior_prefix_sha256':old_sha,'reviewed_through_line':n,'reviewed_prefix_sha256':current.hexdigest(),'later_question_calls':questions,'later_answer_records':replies,'later_user_records':hooks,'conclusion':'The 11 questions, 2 replies, 8 pending mapped material choices and 9 blocked rows remain unchanged; later user messages are the 2 automatic timeout continuations. No original question, reply or frozen projection was modified.'}
with (D/'question-suffix-review.json').open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(record))

