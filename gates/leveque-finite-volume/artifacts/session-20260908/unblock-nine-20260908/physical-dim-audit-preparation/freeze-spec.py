"""Freeze successful current native/spec evidence; no operational preparation."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json
P=Path(__file__).resolve().parent;D=P.parent;R=D.parents[4]
disk=lambda p:Path('\\\\?\\'+str(p.resolve()))
raw=lambda p:disk(p).read_bytes()
read=lambda p:json.loads(raw(p))
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(raw(p)).hexdigest(),'bytes':len(raw(p))}
def put(name,data):
 p=P/name;assert not disk(p).exists()
 if not isinstance(data,str):data=json.dumps(data,indent=2,ensure_ascii=False)+'\n'
 disk(p).write_text(data,encoding='utf-8',newline='\n')
 return ref(p)
native=read(P/'native-02/receipt.json');preflight=read(P/'spec-01/preflight.json')
assert native['actual_exit_code']==0 and native['inputs_unchanged']
assert preflight['status']=='PASS_SPEC_ONLY' and not preflight['preparer_invoked'] and not preflight['roles_invoked']
attempts=sorted(P.glob('spec-preflight-*/receipt.json'))
assert attempts
success=read(attempts[-1]);assert success['actual_exit_code']==0
assert success['script_before']==success['script_after']
assert not raw(attempts[-1].parent/'stderr.txt')
inventory=read(P/'probe-sources-02/probe-inventory.json')
for owner in inventory['current_owners']:
 assert ref(R/owner['file']['path'])==owner['file']
for field in ('inputs_before','inputs_after','environment'):
 assert ref(R/native[field]['path'])==native[field]
target=R/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean'
assert ref(target)['sha256']=='192df235c8ec993ca6815c5cf2c0808c1ffc0087c6a87810f9e26be4fbcd704c'
comparison=[]
for group in inventory['groups']:
 name=Path(group['file']).stem+'-output.txt'
 comparison.append({'group':group['file'],'historical':ref(P/'native-01'/name),
  'current':ref(P/'native-02'/name),'identical_output_bytes':raw(P/'native-01'/name)==raw(P/'native-02'/name)})
spec=ref(P/'spec-01/audit-spec.json')
helper=ref(D/'prepare-successor-audit-with-dim-module-roots-v2.py')
command=['C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe','-X','utf8','-B',str(R/helper['path']),str(R/spec['path'])]
note=f'''# Physical DIM audit preparation — current spec only

All five current native probes passed, followed by the strict POSIX-only spec preflight. No released audit preparation or semantic role has been run by this preparation packet.

Fresh task: `LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908`.
Target: `NumStability.leveque01_coordinateHighResolutionMethods_sourceContract`, current source SHA `{ref(target)['sha256']}`.

The spec keeps the prior Q10 primary locator/config, binds source context v3 (pages 25, 26, 27, 28, 125, 126), retains the separately scoped literal receipts, and adds the exact reviewed Mathlib module-root extension. Native evidence contains current definitions, full primary and nested contract types, regularity constructors, numerical operators, physical/Cartesian geometry, and the complete canonical joint source application. Generic measure/operator/norm/topology spans are byte-checked; old FV source-contract spans are excluded.

Current native output totals {preflight['native_output_bytes']:,} bytes. Selected new/generic native spans total {preflight['all_selected_span_bytes']:,} bytes. The complete inherited-plus-additional native JSON is {preflight['merged_inherited_plus_additional_native_json_bytes']:,} bytes. Full source/direct/roundtrip/adjudicator stdin sizes still require actual measurement after official preparation; this native-only size does not establish those sizes. Preserve the 1,048,576-byte limit without truncation. Blind input remains the exact released masked packet with the reviewed genuine module-root definitions; no supplemental source or native packet is added to blind stdin.

`native-01` and the earlier canonical-comparison receipt remain historical pre-parenthesis evidence. `native-02` binds build04 and the exact current owner/olean closure. Only two import additions and the explicitly recorded RHS parentheses distinguish current owners from the proposed snapshots. All old attempts remain untouched.

Root's next authorized command (not run here):

```text
{' '.join(json.dumps(x) for x in command)}
```

Root must review this spec, perform actual released preparation/validation, inspect and measure exact role packets, and run fresh independent roles. No source acceptance, gate closure, or organization measurement is inferred from these native checks.
'''
review=put('REVIEW.md',note)
manifest=put('manifest.json',{'schema':1,'status':'CURRENT SPEC PREPARATION ONLY',
 'spec':spec,'helper':helper,'root_invocation_argv':command,'source_target':ref(target),
 'current_native_receipt':ref(P/'native-02/receipt.json'),'current_inventory':ref(P/'probe-sources-02/probe-inventory.json'),
 'current_build':ref(D/'physical-production-promotion/owners-native-04-receipt.json'),
 'notation_repair':ref(D/'physical-production-promotion/layout-rhs-parentheses-01/receipt.json'),
 'spec_preflight':ref(P/'spec-01/preflight.json'),'actual_posix_attempts':[ref(p) for p in attempts],
 'historical_native_receipt':ref(P/'native-01/receipt.json'),'output_comparisons':comparison,
 'native_packet':ref(P/'spec-01/native-packet.json'),'native_environment':ref(P/'spec-01/native-environment.json'),
 'elision_review':ref(P/'spec-01/ellipsis-review.json'),'derivation':ref(P/'current-v2-derivation.json'),
 'source_context':ref(D/'dim-inherited-hyperbolicity-context/source-context-v3.json'),
 'module_extension':ref(D/'dim-module-root-preparation/spec-extension-v2.json'),
 'review':review,'freezer':ref(Path(__file__)),'roles_run':False,'source_acceptance':False})
receipt=put('final-receipt.json',{'schema':1,'status':'PASS_NATIVE_AND_SPEC_PREFLIGHT_ONLY',
 'frozen_at_utc':datetime.now(timezone.utc).isoformat(),'manifest':manifest,
 'actual_native_exits':[g['actual_exit_code'] for g in native['groups']],
 'actual_posix_preflight_exit':success['actual_exit_code'],'spec':spec,
 'native_output_bytes':preflight['native_output_bytes'],
 'merged_native_json_bytes':preflight['merged_inherited_plus_additional_native_json_bytes'],
 'official_preparation_run':False,'semantic_roles_run':False,'source_acceptance':False,
 'running_native_sessions':[]})
print(json.dumps(receipt,indent=2))
