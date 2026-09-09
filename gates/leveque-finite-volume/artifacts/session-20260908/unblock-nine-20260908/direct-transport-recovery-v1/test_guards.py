"""Synthetic tests only; never invokes a native role, collector or released mutator."""
from pathlib import Path
from copy import deepcopy
import hashlib,json,tempfile,time,sys
import recovery as r
import transport as t
import compact as c
rows=[]
def check(name,fn,reject=False):
 try:fn()
 except (AssertionError,ValueError,KeyError,IndexError,UnicodeError):
  assert reject,name;rows.append({'name':name,'result':'expected-rejection'})
 else:
  assert not reject,name;rows.append({'name':name,'result':'pass'})

def mutate(obj,path,value):
 x=deepcopy(obj);node=x
 for key in path[:-1]:node=node[key]
 node[path[-1]]=value;return x

RUN=Path(sys.argv[1]).resolve();assert RUN.parent==r.D;RUN.mkdir()
F=RUN/'synthetic-fixture';F.mkdir()
text=('Native α → β. "quoted" \\ slash\n' * 30)
canonical=('Exact direct document\n'+text+'Unique last line.\n').encode()
docs=[('Exact prompt','direct_judge.md',b'One fresh direct role. No other judgments.'),
 ('Complete direct review packet; dossier_sha256 is this packet hash','direct_review_packet.md',canonical),
 ('Complete dependency inventory','dependency_inventory.json',json.dumps({'dependencies':[{'type_explicit':text},{'type_explicit':text}]},indent=2,ensure_ascii=True).encode()),
 ('Environment','dependency-environment-packet.json',json.dumps({'text':('0123456789abcdefghij'*50+'x')*80},indent=2).encode())]
inputs=[];raw=b''
for label,name,body in docs:
 p=F/name;p.write_bytes(body);x={'label':label,'path':str(p),'sha256':t.digest(body),'bytes':len(body)}
 inputs.append(x);raw+=t.header(x)+body
final,m=t.encode(raw,inputs)
check('exact-complete-input-reconstruction',lambda:exec('assert t.reconstruct(final,m)==raw'))
check('saved-mapping-json-roundtrip',lambda:exec('assert json.loads(json.dumps(m))==m and t.reconstruct(final,json.loads(json.dumps(m)))==raw'))
check('full-canonical-packet-verbatim',lambda:exec('assert final.count(t.header(inputs[1])+canonical)==1'))
check('positive-compression',lambda:exec('assert len(final)<len(raw)'))
check('changed-compact-input',lambda:t.reconstruct(final+b'x',m),True)
check('wrong-original-hash',lambda:t.reconstruct(final,mutate(m,['original_sha256'],'0'*64)),True)
bm=m['byte_layer'];check('wrong-block-hash',lambda:c.reconstruct(final,mutate(bm,['blocks',0,'sha256'],'0'*64)),True)
check('wrong-reference-range',lambda:c.reconstruct(final,mutate(bm,['references',0,'block_end'],10**9)),True)
check('wrong-reference-target',lambda:c.reconstruct(final,mutate(bm,['references',0,'block'],'MISSING')),True)
check('reference-token-tamper',lambda:c.reconstruct(final,mutate(bm,['references',0,'token'],'bad')),True)
check('omitted-reference',lambda:c.reconstruct(final,mutate(bm,['references'],bm['references'][1:])),True)
check('canonical-byte-length',lambda:c.reconstruct(final,mutate(bm,['blocks',0,'original_end'],10**9)),True)
jm=m['json_layer'];middle=c.reconstruct(final,bm);di=next(i for i,x in enumerate(jm['documents']) if x['references'])
check('wrong-packet-string-range',lambda:t.reconstruct_layer(middle,mutate(jm,['documents',di,'references',0,'canonical_end'],10**9)),True)
check('wrong-json-token-hash',lambda:t.reconstruct_layer(middle,mutate(jm,['documents',di,'references',0,'token_sha256'],'0'*64)),True)
check('wrong-json-string-escape-mode',lambda:t.reconstruct_layer(middle,mutate(jm,['documents',di,'references',0,'ascii'],False)),True)
check('duplicate-json-keys',lambda:t.compact_json(b'{"a":1,"a":2}'),True)
check('nonfinite-json',lambda:t.compact_json(b'{"a":NaN}'),True)
check('json-string-whitespace-preserved',lambda:exec('assert t.compact_json(b\'{ "a": " x ", "b": 2 }\')==b\'{"a":" x ","b":2}\''))
check('reserved-block-marker',lambda:c.encode(b'[[DXR:spoof]]'),True)
check('reserved-packet-marker',lambda:t.layer(b'[[PACKET-JSON-STRING',inputs),True)
check('changed-canonical-file',lambda:t.layer(raw,[dict(x,sha256='0'*64) if i==1 else x for i,x in enumerate(inputs)]),True)
check('other-role-input-rejected',lambda:r.direct_isolation(b'',inputs+[{'path':'blind_translation.json'}]),True)
events=[{'type':'thread.started','thread_id':'fresh'},{'type':'turn.started'},
 {'type':'item.completed','item':{'type':'agent_message'}},{'type':'turn.completed'}]
check('fresh-one-turn-runtime',lambda:r.fresh_completed(events,{'exit_code':0},{'old'}))
check('reused-role-id',lambda:r.fresh_completed(events,{'exit_code':0},{'fresh'}),True)
check('missing-turn-start',lambda:r.fresh_completed([x for x in events if x['type']!='turn.started'],{'exit_code':0},set()),True)
check('native-failure-not-success',lambda:r.fresh_completed(events,{'exit_code':1},set()),True)
check('tool-event-rejected',lambda:r.fresh_completed(mutate(events,[2,'item','type'],'command_execution'),{'exit_code':0},set()),True)
before={'task_id':'fixture','runs':[{'role':'source-contract','agent_id':'old'}]}
after={'task_id':'fixture','runs':before['runs']+[{'role':'direct-judge','agent_id':'fresh'}]}
check('append-direct-runtime',lambda:r.append_role(before,after,'direct-judge','fresh'))
check('wrong-runtime-role',lambda:r.append_role(before,after,'adjudicator','fresh'),True)
check('old-runtime-mutated',lambda:r.append_role(before,mutate(after,['runs',0,'agent_id'],'changed'),'direct-judge','fresh'),True)
attempt=F/'attempt';attempt.mkdir();check('fresh-d2-attempt',lambda:r.absent_attempt(attempt,'d2'))
(attempt/'d2_input.txt').write_bytes(b'old')
check('existing-attempt-rejected',lambda:r.absent_attempt(attempt,'d2'),True)
check('wrong-attempt-role',lambda:r.absent_attempt(attempt,'a2'),True)
big=b'x'*(r.LIMIT+1);failure={'exit_code':1,'stdin_bytes':len(big),'stdin_sha256':r.digest(big)}
stderr='input_too_large {"max_chars":1048576,"actual_chars":1048577}'
check('genuine-unstarted-failure',lambda:r.v3.unstarted_failure([{'type':'thread.started','thread_id':'failed'}],stderr,failure,big))
check('failure-after-turn-rejected',lambda:r.v3.unstarted_failure(events,stderr,failure,big),True)
check('wrong-reported-size',lambda:r.v3.unstarted_failure([{'type':'thread.started','thread_id':'failed'}],stderr.replace('1048577','1048578'),failure,big),True)
check('stale-input-pin',lambda:r.verify({'path':str(F/'direct_judge.md'),'sha256':'0'*64}),True)
receipt={'format':'synthetic-direct-transport-guard-tests-1','tests':rows,'count':len(rows),'exit_code':0,
 'roles_invoked':False,'operational_task_mutated':False,'fixture_input_sha256':t.digest(raw),
 'fixture_compact_sha256':t.digest(final),'fixture_original_bytes':len(raw),'fixture_compact_bytes':len(final)}
r.write(RUN/'guard-test-results.json',receipt)
print(json.dumps(receipt,indent=2))
