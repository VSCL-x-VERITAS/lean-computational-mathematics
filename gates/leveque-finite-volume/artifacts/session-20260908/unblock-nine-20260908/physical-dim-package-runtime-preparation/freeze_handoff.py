"""Freeze completed preparatory evidence, without executing any workflow action."""
from pathlib import Path
import hashlib
import json
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
D=P.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
assert read(P/'spec-run-01/receipt.json')['actual_exit_code']==0
assert read(P/'fixture-outer-03/receipt.json')['actual_exit_code']==0
render=read(P/'suite/actual-render-01/manifest.json')
helper=render['entry_points']['preparer']
spec=ref(P/'spec-01/audit-spec.json')
review=P/'suite/actual-review-01/receipt.json'
assert review.is_file()
lines=[
'READY PREPARATION HANDOFF — NO OFFICIAL PREPARATION OR SEMANTIC ROLE RUN', '',
'The fresh task is LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908. The prior failed physical task remains unchanged. The source primary, Q10/context v3, native supplement and exact two mirrored source modules are inherited unchanged from the previous spec. Only task identity/key and supported compiler-command configuration are added.', '',
'After root reviews the eight proposed installed files and diffs, use native Python with -X utf8 -B to run:', '',
'  '+str(P/'install_reviewed_suite.py')+' --manifest-sha256 '+sha(P/'suite/actual-render-01/manifest.json'), '',
'That command installs new helper paths only and captures a byte-exact installation receipt. It invokes neither preparation nor gate logic. All eight destinations must be absent.', '',
'Then root may invoke the installed official preparation wrapper through the unchanged POSIX launcher, from repository root:', '',
'  PY -X utf8 -B '+str(R.parent/'workflow-v5.0.1-local/run_workflow_posix.py')+' '+str(R/helper['path'])+' '+str(R/spec['path']), '',
'The actual task config and released prepared manifest do not exist in this handoff. Their actual hashes/receipts must be captured by that run. The adapter will require all 41 inherited module compilations plus AuditTarget before its final dossier. The completed three-source runtime fixture does not substitute for that official run.', '',
'After genuine released preparation succeeds, follow role-size-guard/COMMANDS.md. Source and blind plans are prepared first; blind is exactly the released masked packet with an empty pages argument. Each actual r.py message is frozen and checked against 1,048,576 UTF-8 bytes before execution. Later direct/roundtrip/adjudicator plans use the same complete content and declared source images. Do not truncate any packet or invoke q.py to manufacture a receipt.', '',
'The unchanged staged.py records actual roles, collections, adjudication check, released finalization and complete validation. Its successful aggregate can still describe an unaccepted result. No verdict is assumed here.', '',
'The coherent helper suite carries the new qualified support and all historical guards/dependencies. Final-global now expects 11 dependency entries (the prior 10 plus new support). A separate final-current-evidence input-assembler successor remains future work and must use this exact new suite; it need not delay official preparation.', '',
'Private publication exclusion: '+(P/'environment-failure-stdout.private.txt').relative_to(R).as_posix()+'. Original raw full environment capture remains excluded by the existing policy. Temporary compiled overlays remain ignored; no binaries are included in this handoff.', '',
'No canonical source, original compiled cache, gate, ledger, Git ref, or audit judgment changed in this work.', '']
(P/'HANDOFF.md').write_text('\n'.join(lines),encoding='utf-8')
files=[P/'runtime-receipt.json',P/'runtime-manifest.json',P/'compiler-command-extension.json',
 P/'suite/receipt.json',P/'suite/manifest.json',P/'suite/actual-render-01/manifest.json',review,
 P/'spec-01/audit-spec.json',P/'spec-01/preflight.json',P/'spec-run-01/receipt.json',
 P/'role-size-guard/receipt.json',P/'install_reviewed_suite.py',P/'prepare_spec.py',P/'run_spec.py',P/'HANDOFF.md',P/'freeze_handoff.py']
manifest={'status':'READY_FOR_ROOT_REVIEW_AND_OFFICIAL_PREPARATION','files':[ref(p) for p in files],
          'entry_points':render['entry_points'],'spec':spec,'native_fixture_exit_codes':[0]*5,
          'posix_spec_preflight_exit_code':0,'official_preparation_runs':0,'semantic_roles':0,
          'source_or_gate_changes':False}
with (P/'ready-manifest.json').open('x',encoding='utf-8') as f:f.write(json.dumps(manifest,indent=2)+'\n')
receipt={'status':manifest['status'],'manifest':ref(P/'ready-manifest.json'),'spec':spec,
         'compiler_extension':ref(P/'compiler-command-extension.json'),'helper_render':ref(P/'suite/actual-render-01/manifest.json'),
         'native_fixture':ref(P/'fixture-03/receipt.json'),'preflight':ref(P/'spec-01/preflight.json'),
         'handoff':ref(P/'HANDOFF.md'),'official_preparation_runs':0,'semantic_roles':0}
with (P/'ready-receipt.json').open('x',encoding='utf-8') as f:f.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(ref(P/'ready-receipt.json')))
