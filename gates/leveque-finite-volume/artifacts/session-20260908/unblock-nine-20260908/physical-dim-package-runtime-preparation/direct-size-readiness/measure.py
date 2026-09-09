"""Read-only in-memory replay of the prior exact direct transport; no role launcher."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,sys,time
H=Path(__file__).resolve().parent
P=H.parent;D=P.parent
shim=D/'fv-local-domain-review/native-long-path-io.py'
exec(compile(shim.read_bytes(),str(shim),'exec'),globals())
sys.path.insert(0,str(D/'direct-transport-recovery-v1'))
import transport
def ref(p):
 b=p.read_bytes();return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
plan_path=P/'role-size-guard/direct-byte-01/plan.json'
assert ref(plan_path)['sha256']=='9492c32a9bc0f132da869fe58d464b3b466cacf83a6369986f3231e617e47f96'
plan=json.loads(plan_path.read_bytes())
assert plan['task_id']=='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908'
assert plan['role']=='direct-judge' and not plan['within_limit'] and not plan['role_invoked']
original=Path(plan['input']['path']).read_bytes()
assert transport.digest(original)==plan['stdin_sha256']=='e5cfcc528c52b2f6dd8472e7164feaf90cee08c34dcf1e267199b42184f74971'
paths=[plan_path,Path(plan['input']['path']),shim,Path(__file__),
 D/'direct-transport-recovery-v1/transport.py',D/'direct-transport-recovery-v1/compact.py']
paths += [Path(x['path']) for x in plan['input_records']]
pins=[ref(p) for p in paths]
start=datetime.now(timezone.utc).isoformat();clock=time.monotonic()
result,mapping=transport.encode(original,plan['input_records'])
assert transport.reconstruct(result,mapping)==original
canonical=Path(mapping['json_layer']['canonical']['path']).read_bytes()
assert result.count(transport.header(mapping['json_layer']['canonical'])+canonical)==1
assert pins==[ref(p) for p in paths]
print(json.dumps({'format':'direct-existing-lossless-size-readiness-1','mode':'read-only in-memory measurement',
 'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'elapsed_seconds':time.monotonic()-clock,
 'pins':pins,'original_bytes':len(original),'original_codepoints':len(original.decode('utf-8')),
 'represented_bytes':len(result),'represented_codepoints':len(result.decode('utf-8')),
 'represented_sha256':transport.digest(result),'native_codepoint_limit':1048576,
 'margin_codepoints':1048576-len(result.decode('utf-8')),
 'canonical_direct_packet_bytes':len(canonical),'canonical_packet_verbatim_count':1,
 'reconstruction_byte_equal':True,'json_token_references':sum(len(x['references']) for x in mapping['json_layer']['documents']),
 'dictionary_blocks':len(mapping['byte_layer']['blocks']),'dictionary_references':len(mapping['byte_layer']['references']),
 'all_input_pins_unchanged':True,'replacement_prompt_written':False,'operational_plan_created':False,
 'semantic_roles_invoked':False,'old_recovery_runner_invoked':False,'fits':len(result.decode('utf-8'))<=1048576},indent=2))
