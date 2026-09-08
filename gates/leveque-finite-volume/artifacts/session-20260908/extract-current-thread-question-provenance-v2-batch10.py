"""Export exact current-task question/reply records with transcript-order chronology."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
THREAD='01a07fae-4a67-7770-98b0-b95c4e393705'
native=Path('C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-'+THREAD+'.jsonl')
posix='/c/'+native.as_posix()[3:]
P=S/'current-thread-question-provenance-v2-batch10'
assert not P.exists()
data=native.read_bytes();lines=data.splitlines(keepends=True)
if lines and not lines[-1].endswith(b'\n'):lines.pop()
prefix=b''.join(lines)
assert len(prefix)>0 and native.read_bytes()[:len(prefix)]==prefix
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
qid=lambda call,index:json.dumps(['request_user_input_async',call,index],separators=(',',':'))
mapping={
'call_ctzCZ7YK8zbx2yUzmX59YBdC':['LEV-CH01-ACOUSTICS-LEFT-MODE'],
'call_6YQjDMqpCa41f93c3kdBhahI':['LEV-CH01-EIGENVALUES-WAVE-SPEEDS'],
'call_Jsn9xP52SK6H0Gt06HXTTauK':['LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA'],
'call_uHJOZR8JifMR8TsqhW2IOTRX':['LEV-CH01-NONCONSERVATION-SOURCE-TERMS'],
'call_1UY4fVuKrjpIIQfhLdeuFoRH':['LEV-CH01-FINITE-VOLUME-FLUX-UPDATE','LEV-CH01-RIEMANN-INTERFACE-FLUX'],
'call_1JnoPOtxdApI1F5hUmt5F9Q7':['LEV-CH01-HETEROGENEOUS-CELL-AVERAGING'],
'call_owBbdcnANNrlxzRviSsTqHNo':['LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION'],
'call_axfTXsEjNKG3lawf5Dq10qQv':['LEV-CH01-DIMENSIONAL-SPLITTING']}
contexts={'call_Y2sqv6fyDugzXxzv3TlRkG6y','call_GV856xXH10OQXasWapraHP5y','call_gBZtG6Mn328LLCQ5DfzmFZtV'}
questions=[];replies=[];selected={};events=[];confirmed=False
for number,line in enumerate(lines,1):
 try:obj=json.loads(line)
 except json.JSONDecodeError:continue
 p=obj.get('payload',{})
 if obj.get('type')=='session_meta':
  assert p['id']==THREAD;confirmed=True
 if obj.get('type')!='response_item':continue
 if p.get('type')=='function_call' and p.get('name','').endswith('request_user_input_async'):
  call=p['call_id'];assert call in mapping or call in contexts,('unreviewed new question',call)
  for index,question in enumerate(json.loads(p['arguments'])['questions']):
   questions.append({'question_id':qid(call,index),'call_id':call,'question_index':index,'line':number,'row_ids':mapping.get(call,[]),'exact_text':question['title'],'timestamp':obj['timestamp'],'status':'pending','mapping_review':('Explicit original accuracy question applies to both finite-volume update and its Riemann-interface comparison.' if call=='call_1UY4fVuKrjpIIQfhLdeuFoRH' else 'Context only: adopted earlier interpretation for unchanged closed rows, or now-avoidable returned-field representation choice.' if call in contexts else 'Exact pending question selects the recorded source convention for this row.')})
  selected[number]=line;events.append((number,obj['timestamp']))
 if p.get('type')=='message' and p.get('role')=='user':
  for item in p.get('content',[]):
   text=item.get('text','');marker='<send_user_message_question_reply>'
   if marker not in text:continue
   start=text.index(marker)+len(marker);end=text.index('</send_user_message_question_reply>',start)
   for answer in json.loads(text[start:end].strip()):
    identity=json.loads(answer['questionItemId'])
    assert identity[0]=='request_user_input_async'
    replies.append({'question_id':qid(identity[1],identity[2]),'line':number,'exact_text':answer['answer'],'timestamp':obj['timestamp']})
   selected[number]=line;events.append((number,obj['timestamp']))
assert confirmed and len(questions)==11 and len(replies)==2
lookup={q['question_id']:q for q in questions};assert len(lookup)==len(questions)
for answer in replies:
 assert answer['question_id'] in lookup and answer['line']>lookup[answer['question_id']]['line']
 lookup[answer['question_id']]['status']='answered'
assert all(lookup[qid(call,0)]['status']=='pending' for call in mapping)
P.mkdir();(P/'records').mkdir()
for number,line in selected.items():
 f=P/'records'/f'line-{number:06d}.jsonl'
 with f.open('xb') as out:out.write(line)
 for event in questions+replies:
  if event['line']==number:event.update(record=ref(f),record_sha256=sha(f))
dt=lambda s:datetime.fromisoformat(s.replace('Z','+00:00'))
events=sorted(set(events));regressions=[]
for before,after in zip(events,events[1:]):
 if dt(after[1])<dt(before[1]):
  regressions.append({'earlier_line':before[0],'later_line':after[0],'earlier_timestamp':before[1],'later_timestamp':after[1]})
extracted=datetime.now(timezone.utc).isoformat().replace('+00:00','Z')
old=S/'current-thread-clarification-provenance-batch9.json'
assert sha(old)=='764aeb5a5bc813c55d85165eca3ac1b98b71be98b6ab307b53cd59e0ee03989c'
provenance=P/'extraction.json'
p={'kind':'exact-own-thread-record-extraction','thread_id':THREAD,'source_path':posix,'scanned_line_count':len(lines),'snapshot_prefix_sha256':hashlib.sha256(prefix).hexdigest(),'extracted_at_utc':extracted,'extractor_sha256':sha(Path(__file__)),'prior_projection':ref(old),'selected_original_records':[ref(P/'records'/f'line-{n:06d}.jsonl') for n in sorted(selected)],'scope':'Only exact question tool calls and explicit user reply records are exported. Transcript line order determines event order. All literal timestamps are retained; some historical records are ahead of host clock and a later record regresses. No future wall time or answer is inferred. Later relevant records require a fresh projection.'}
with provenance.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(p,indent=2)+'\n')
result={'schema_version':2,'kind':'current-material-choice-projection','thread_id':THREAD,'source_path':posix,'scanned_line_count':len(lines),'snapshot_prefix_sha256':hashlib.sha256(prefix).hexdigest(),'extracted_at_utc':extracted,'chronology':'transcript-line-order','projection_review':'Reviewed exact current-task questions and both explicit replies. The first two adopted conventions remain scoped as recorded. Q7 covers FV and INTERFACE conditional accuracy. Q11 full-field representation is no longer a necessary source choice for the broader information-only alternative. Absence of later replies must be checked against the live transcript before use. Original timestamps do not provide a reliable cross-event chronological cutoff.','provenance':ref(provenance),'timestamp_regressions':regressions,'questions':questions,'replies':replies}
dest=P/'projection.json'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
assert native.read_bytes()[:len(prefix)]==prefix
print(json.dumps({'projection':ref(dest),'questions':len(questions),'replies':len(replies),'records':len(selected),'scanned_line_count':len(lines),'timestamp_regressions':regressions,'extracted_at_utc':extracted}))

