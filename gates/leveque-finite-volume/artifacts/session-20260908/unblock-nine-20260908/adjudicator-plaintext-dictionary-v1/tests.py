"""Transport/lineage rejection tests only; never invoke a role or write an audit."""
from copy import deepcopy
import json
import recovery as r
p=r.plaintext;v=r.visible
passed=[]
def yes(name,fn):
 assert fn() is not False,name;passed.append({'name':name,'result':'PASS'})
def no(name,fn):
 try:fn()
 except (AssertionError,KeyError,ValueError,IndexError,TypeError):
  passed.append({'name':name,'result':'REJECTED'});return
 raise AssertionError('Accepted invalid fixture: '+name)
def changed(value,fn):
 x=deepcopy(value);fn(x);return x
small=(r.D/'proposed-input.txt').read_bytes();m=r.read(r.D/'proposed-mapping.json')
raw=(r.P/'a_input.txt').read_bytes();inputs=r.read(r.P/'a_transport.json')['inputs']
yes('actual complete mapping reconstruction',lambda:p.reconstruct(small,m)==raw)
yes('mapping JSON serialization roundtrip',lambda:p.reconstruct(small,r.decode(json.dumps(m,ensure_ascii=False)))==raw)
yes('independent visible grammar without mapping',lambda:v.reconstruct(small,inputs)==raw)
yes('Unicode character capacity',lambda:len(small.decode())<=r.LIMIT<len(raw.decode()))
yes('UTF8 byte count is reported separately',lambda:len(small)>r.LIMIT)
no('changed plaintext byte',lambda:p.reconstruct(small[:-1]+b'x',m))
no('truncated plaintext',lambda:p.reconstruct(small[:-100],m))
for name,mut in [
 ('original digest',lambda x:x.update(original_sha256='0'*64)),
 ('original length',lambda x:x.update(original_bytes=x['original_bytes']+1)),
 ('middle digest',lambda x:x.update(middle_sha256='0'*64)),
 ('aliased digest',lambda x:x.update(aliased_sha256='0'*64)),
 ('phrase digest',lambda x:x['phrase_entries'][0].update(value_sha256='0'*64)),
 ('phrase count',lambda x:x['phrase_entries'][0].update(count=0)),
 ('phrase id',lambda x:x['phrase_entries'][0].update(id=999999)),
 ('phrase pool order',lambda x:x['phrase_entries'].reverse()),
 ('phrase length',lambda x:x['phrase_entries'][0].update(value_bytes=0)),
 ('phrase pool boundary',lambda x:x['phrase_entries'][0].update(pool_start=0)),
 ('short marker value',lambda x:x['short_markers'][0].update(short='wrong')),
 ('short marker overlapping span',lambda x:x['short_markers'][1].update(start=0)),
 ('raw block digest',lambda x:x['dictionary_layer']['blocks'][0].update(sha256='0'*64)),
 ('raw block duplicate ID',lambda x:x['dictionary_layer']['blocks'][1].update(id=x['dictionary_layer']['blocks'][0]['id'])),
 ('raw reference missing block',lambda x:x['dictionary_layer']['references'][0].update(block='B999999')),
 ('raw reference invalid range',lambda x:x['dictionary_layer']['references'][0].update(block_start=-1)),
 ('raw reference digest',lambda x:x['dictionary_layer']['references'][0].update(sha256='0'*64)),
 ('JSON mode',lambda x:x['json_layer']['documents'][1]['references'][0].update(ascii='false')),
 ('original document hash',lambda x:x['json_layer']['documents'][0]['input'].update(sha256='0'*64)),
 ('outer document order',lambda x:x['ordered_headers'].reverse())]:
 no(name,lambda mut=mut:p.reconstruct(small,changed(m,mut)))
# The independent parser is tested without relying on a stale whole-input hash.
no('visible unknown fragment',lambda:v.expand_display(small.replace('⟦1⟧'.encode(),'⟦999999⟧'.encode(),1)))
no('visible unknown phrase',lambda:v.expand_display(small.replace('⟪a1⟫'.encode(),'⟪a999999⟫'.encode(),1)))
no('visible recursive phrase',lambda:v.expand_display(small.replace('⟪A1⟫'.encode(),'⟪A1⟫⟪a1⟫'.encode(),1)))
no('visible duplicate phrase',lambda:v.expand_display(small.replace('⟪A2⟫'.encode(),'⟪A1⟫'.encode(),1)))
no('visible missing fragment close',lambda:v.expand_display(small.replace('⟦/b⟧'.encode(),b'',1)))
no('reserved grammar collision',lambda:p.phrases('literal ⟪ collision'.encode(),[]))
no('duplicate JSON key',lambda:r.decode(b'{"x":1,"x":2}'))
no('nonfinite JSON number',lambda:r.decode(b'{"x":NaN}'))

original=r.read(r.T/'role-run-receipt.json');direct=r.read(r.DIRECT/'execution-receipt.json')
cont=r.read(r.CONT/'receipt.json');runs=r.read(r.O/'agent_outputs/agent_runs.json')
yes('actual three-event lineage',lambda:r.lineage_contract(original,direct,cont,runs))
for name,which,mut in [
 ('original failure relabeled success',0,lambda x:x.update(exit_code=0)),
 ('direct recovery not successful',1,lambda x:x.update(exit_code=1)),
 ('direct recovery falsely completed audit',1,lambda x:x.update(audit_completed=True)),
 ('direct recovery missing collection',1,lambda x:x['steps'].pop(2)),
 ('direct recovery missing requirement',1,lambda x:x.update(adjudication_required=False)),
 ('continuation failure relabeled success',2,lambda x:x.update(exit_code=0)),
 ('continuation wrong original wrapper',2,lambda x:x['original_wrapper'].update(sha256='0'*64)),
 ('continuation changed q',2,lambda x:x.update(unchanged_q_sha256='0'*64)),
 ('continuation changed role',2,lambda x:x['roles_before'].update(direct_judge_json='0'*64)),
 ('roles reordered',3,lambda x:x['runs'].reverse()),
 ('roles reused identity',3,lambda x:x['runs'][1].update(agent_id=x['runs'][0]['agent_id'])),
 ('direct recovery wrong new identity',3,lambda x:x['runs'][2].update(agent_id='wrong'))]:
 args=deepcopy([original,direct,cont,runs]);mut(args[which])
 no(name,lambda args=args:r.lineage_contract(*args))
e=r.events(r.P/'a_events.jsonl');err=(r.P/'a_stderr.txt').read_text();tr=r.read(r.P/'a_transport.json')
yes('actual native before-turn capacity failure',lambda:r.old.unstarted_failure(e,err,tr,raw))
no('started turn cannot be retried as unstarted',lambda:r.old.unstarted_failure(e+[{'type':'turn.started'}],err,tr,raw))
no('wrong actual chars',lambda:r.old.unstarted_failure(e,err.replace('2740284','2740283'),tr,raw))
no('failure transport success',lambda:r.old.unstarted_failure(e,err,{**tr,'exit_code':0},raw))
no('wrong original input digest',lambda:r.old.unstarted_failure(e,err,{**tr,'stdin_sha256':'0'*64},raw))
images=[r.Path(x['path']) for x in tr['inputs'] if r.Path(x['path']).suffix=='.png']
yes('exact original command/image contract',lambda:r.command_contract(tr,images))
no('extra native option',lambda:r.command_contract(changed(tr,lambda x:x['command'].append('--resume')),images))
no('different image order',lambda:r.command_contract(tr,list(reversed(images))))
no('forked native attempt',lambda:r.command_contract({**tr,'fork':True},images))
fresh=[{'type':'thread.started','thread_id':'SYNTHETIC-FRESH'}, {'type':'turn.started'},
 {'type':'item.completed','item':{'type':'agent_message'}},{'type':'turn.completed'}]
yes('synthetic fresh one-turn event grammar',lambda:r.completed(fresh,runs,{'FAILED'}))
no('synthetic old role identity',lambda:r.completed(changed(fresh,lambda x:x[0].update(thread_id=runs['runs'][0]['agent_id'])),runs,{'FAILED'}))
no('synthetic failed attempt identity',lambda:r.completed(changed(fresh,lambda x:x[0].update(thread_id='FAILED')),runs,{'FAILED'}))
no('synthetic second turn',lambda:r.completed(fresh+[{'type':'turn.started'}],runs,{'FAILED'}))
no('synthetic tool event',lambda:r.completed(fresh+[{'type':'item.completed','item':{'type':'command_execution'}}],runs,{'FAILED'}))
before={'status':'prepared','outputs':{},'fixed':42};after={'status':'completed','outputs':{'decision':'x'},'fixed':42,'completed_at_utc':'SYNTHETIC'}
yes('released completion permits only expected manifest fields',lambda:r.old.manifest_transition(before,after))
no('manifest immutable field altered',lambda:r.old.manifest_transition(before,{**after,'fixed':43}))
print(json.dumps({'format':'plaintext-recovery-guard-tests-1','tests':len(passed),
 'results':passed,'roles_invoked':False,'operational_writes':False},indent=2))
