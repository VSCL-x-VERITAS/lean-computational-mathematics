"""Freeze the reviewed preparation only; never invoke operational recovery."""
import recovery as r
E=r.D/'dim-a2-01';plan=r.read(E/'plan.json')
assert plan['runner']==r.ref(r.D/'recovery.py') and r.lineage()==plan['lineage']
for pin in plan['static_inputs']:r.verify(pin)
small=r.verify(plan['input']).read_bytes();raw=r.verify(plan['original_input']).read_bytes()
inputs=r.read(r.verify(plan['original_transport']))['inputs']
mapping=r.read(r.verify(plan['mapping']))
assert r.plaintext.reconstruct(small,mapping)==r.visible.reconstruct(small,inputs)==raw
assert len(small.decode())<=r.LIMIT
tests=r.read(r.D/'tests-01/receipt.json');prep=r.read(r.D/'prepare-01/receipt.json')
for x in [tests,prep]:
 assert x['exit_code']==0 and x['operational_originals_unchanged'] and not x['operational_new_files']
 assert x['roles_invoked'] is False
 r.verify(x['stdout']);r.verify(x['stderr'])
test_result=r.read(r.verify(tests['stdout']));assert test_result['tests']==64
kit=r.R.parent/'formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/kit'
selected=[r.D/x for x in ['recovery.py','plaintext.py','visible.py','tests.py','capture.py','freeze.py','REVIEW.md']]
selected += [E/x for x in ['plan.json','mapping.json','input.txt','manifest-before.json','agent-runs-before.json']]
selected += [r.D/sub/name for sub in ['tests-01','prepare-01'] for name in ['receipt.json','output.txt','stderr.txt']]
manifest={'format':'dim-plaintext-adjudicator-preparation-manifest-1','created_at_utc':r.now(),
 'task_id':r.TID,'files':[dict(r.ref(p),bytes=p.stat().st_size) for p in selected],
 'pinned_algorithm_dependencies':[r.ref(r.V3),r.ref(r.plaintext.BASE),r.ref(r.SHIM)],
 'policy_sources':[r.ref(kit/'skill/formalization-faithfulness-audit/SKILL.md'),r.ref(kit/'METHODOLOGY.md')],
 'lineage':plan['lineage'],'static_input_count':len(plan['static_inputs']),
 'stdin_characters':len(small.decode()),'stdin_bytes':len(small),'stdin_sha256':r.digest(small),
 'original_characters':len(raw.decode()),'original_bytes':len(raw),'original_sha256':r.digest(raw),
 'raw_blocks':len(mapping['dictionary_layer']['blocks']),
 'block_references':len(mapping['dictionary_layer']['references']),'phrase_entries':len(mapping['phrase_entries']),
 'independent_visible_reconstruction_exact':True,'mapping_reconstruction_exact':True,
 'roles_invoked':False,'audit_completed':False,'operational_mutations':False}
r.write(r.D/'manifest.json',manifest)
receipt={'format':'dim-plaintext-adjudicator-preparation-receipt-1','completed_at_utc':r.now(),
 'manifest':r.ref(r.D/'manifest.json'),'review':r.ref(r.D/'REVIEW.md'),'plan':r.ref(E/'plan.json'),
 'runner':r.ref(r.D/'recovery.py'),'tests':r.ref(r.D/'tests-01/receipt.json'),
 'prepare':r.ref(r.D/'prepare-01/receipt.json'),'tests_actual_exit_code':0,'prepare_actual_exit_code':0,
 'guard_tests':64,'static_pins_verified':len(plan['static_inputs']),
 'reconstruction':'both complete byte-for-byte; visible decoder does not use mapping',
 'stdin_characters':len(small.decode()),'stdin_bytes':len(small),'stdin_sha256':r.digest(small),
 'character_headroom':r.LIMIT-len(small.decode()),'roles_invoked':False,'audit_completed':False}
r.write(r.D/'receipt.json',receipt)
print(r.json.dumps({'receipt':r.ref(r.D/'receipt.json'),'manifest':r.ref(r.D/'manifest.json'),
 'review':r.ref(r.D/'REVIEW.md'),'plan':r.ref(E/'plan.json'),'runner':r.ref(r.D/'recovery.py')},indent=2))
