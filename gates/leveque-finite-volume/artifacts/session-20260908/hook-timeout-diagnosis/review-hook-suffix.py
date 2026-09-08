"""Review new transcript events after the frozen question projection, excluding reasoning."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent;W=D.parents[1];R=W/'lean-computational-mathematics';S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
T=Path('C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-01a07fae-4a67-7770-98b0-b95c4e393705.jsonl')
old_count=14462;old_sha='ddee927eed86844fc8be72b2f1e5c10fbecc1a82025379f0993475f2b75a9311'
prefix=hashlib.sha256();newprefix=hashlib.sha256();hooks=[];questions=[];replies=[]
for n,raw in enumerate(T.open('rb'),1):
 newprefix.update(raw)
 if n<=old_count:prefix.update(raw);continue
 obj=json.loads(raw);p=obj.get('payload',{})
 if obj.get('type')!='response_item' or not isinstance(p,dict):continue
 if p.get('type')=='function_call' and 'request_user_input_async' in p.get('name',''):questions.append(n)
 if p.get('type')=='message' and p.get('role')=='user':
  content='\n'.join(i.get('text','') for i in p.get('content',[]) if isinstance(i,dict))
  if '<send_user_message_question_reply>' in content:replies.append(n)
  assert content.startswith('<hook_prompt hook_run_id="stop:1:') and content.endswith('</hook_prompt>'),('unexpected later user record',n)
  assert 'timed out after 20 seconds' in content and 'diagnose it before stopping' in content
  dest=D/('original-stop-hook-line-'+str(n)+'.jsonl')
  with dest.open('xb') as f:f.write(raw)
  hooks.append({'line':n,'kind':'automatic-stop-hook-timeout','sha256':hashlib.sha256(raw).hexdigest(),'record_path':str(dest),'contains_source_choice':False})
assert prefix.hexdigest()==old_sha and not questions and not replies
assert len(hooks)<=1
result={'kind':'fresh-question-projection-suffix-review-after-automatic-hook','prior_projection_sha256':'15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc','prior_snapshot_lines':old_count,'prior_prefix_sha256':old_sha,'reviewed_through_line':n,'reviewed_prefix_sha256':newprefix.hexdigest(),'later_question_calls':questions,'later_answer_records':replies,'later_user_records':hooks,'conclusion':'No new source-choice answer or question. Any recorded later user-role item is the automatic Stop timeout instruction reviewed here. The prior 11 questions, two answers, nine mapped rows and eight pending material choices are unchanged.','original_projection_modified':False}
with (D/'question-suffix-review.json').open('xb') as f:f.write((json.dumps(result,indent=2)+'\n').encode())
A=S/'hook-timeout-diagnosis';added=[]
for name in ['review-hook-suffix.py','question-suffix-review.json']+[Path(h['record_path']).name for h in hooks]:
 src=D/name;dest=A/name
 with dest.open('xb') as f:f.write(src.read_bytes())
 added.append({'path':dest.relative_to(R).as_posix(),'sha256':hashlib.sha256(dest.read_bytes()).hexdigest()})
with (A/'suffix-review-addendum.json').open('xb') as f:f.write((json.dumps({'kind':'additive-source-choice-freshness-review','files':added},indent=2)+'\n').encode())
print(json.dumps({'status':'UNCHANGED_CHOICES_REVIEWED','new_questions':0,'new_answers':0,'automatic_hook_records':len(hooks),'reviewed_through_line':n}))
