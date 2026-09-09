from pathlib import Path
import hashlib, importlib.util, json, re, sys
HERE=Path(__file__).resolve().parent
ROOT=next(p for p in HERE.parents if (p/'lean-toolchain').is_file())
KIT=ROOT.parent/'formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/kit'
sys.path.insert(0,str(KIT/'scripts'))
import prepare_audit as sealed
TASK=ROOT/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
def sha(b):return hashlib.sha256(b).hexdigest()
def ref(p):
 b=p.read_bytes();return {'path':str(p),'sha256':sha(b),'bytes':len(b)}
def write(name,value):
 p=HERE/name
 if p.exists():raise RuntimeError('Refusing overwrite: '+str(p))
 p.write_text(value,encoding='utf-8');return ref(p)
def load_report(name):return sealed.parse_lean_report((HERE/name).read_text(encoding='utf-8'))
probe=load_report('sealed-printer-02-output.txt')
primary=load_report('primary-two-owner-04-output.txt')
pd={d['name']:d for d in probe['dependencies']}
dd={d['name']:d for d in primary['dependencies']}
tests=[]
def check(name,condition):
 if not condition:raise AssertionError(name)
 tests.append({'name':name,'result':'PASS'})
def rate_guard(body):
 assert 'Classical.indefiniteDescription' in body
 for part in ['fun L =>','family.admitted n values','family.admitted n other',
  'family.inputStart n','family.inputCount n','family.activeStart n','family.activeCount n',
  'family.advance n values j','family.advance n other j','family.dt n']:
  assert part in body,part
 assert body.count('⋯')==1
 assert body.rstrip().endswith('⋯).val')
rate=pd['BlindEvidenceDiagnostic.explicitRate']['body_readable'];rate_guard(rate)
check('candidate complete predicate under unchanged sealed readable printer',True)
try:rate_guard(pd['NumStability.DirectionalLine.LineFamily.stabilityRate']['body_readable'])
except AssertionError:tests.append({'name':'reject current hidden choose predicate','result':'PASS'})
else:raise AssertionError('bad rate accepted')
check('theorem proof bodies excluded',all(not d['body_readable'] for s in [probe,primary] for d in s['dependencies'] if d['kind']=='theorem'))
for name in ['ContDiffOn','ContDiffWithinAt','ContDiffWithinAt.match_1','HasFTaylorSeriesUpToOn','HasFTaylorSeriesUpToOn.mk']:
 check(name+' recursively captured from exact promoted owner',name in dd and dd[name]['role']=='local')
within=dd['ContDiffWithinAt']['body_readable']
check('outer-top analytic branch visible','AnalyticOn' in within and 'HasFTaylorSeriesUpToOn WithTop.top.top' in within)
check('finite-order branch visible','∀ (m : Nat)' in within and 'HasFTaylorSeriesUpToOn m.cast' in within)
check('branch matcher body supplied',bool(dd['ContDiffWithinAt.match_1']['body_readable']))
mirror=HERE/'m/Mathlib/Analysis/Calculus/ContDiff/Defs.lean'
upstream=ROOT/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean'
check('source mirror byte identity',mirror.read_bytes()==upstream.read_bytes())
target=json.loads((TASK/'audit-task.json').read_text(encoding='utf-8'))
manifest=json.loads((TASK/'faithfulness/manifest.json').read_text(encoding='utf-8'))
order,graph,external=sealed.collect_local_imports((ROOT/manifest['target']['path']).read_text(encoding='utf-8'),
 {'_module_source_roots':[ROOT,HERE/'m']})
check('released configured source-root discovery includes promoted exact module','Mathlib.Analysis.Calculus.ContDiff.Defs' in order)
expected=set(x['module'] for x in manifest['local_import_sources'])|{'Mathlib.Analysis.Calculus.ContDiff.Defs','Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries'}
check('public-import parser boundary retained','Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries' not in order)
future_source='import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries\n'+(ROOT/manifest['target']['path']).read_text(encoding='utf-8')
future_order,_,_=sealed.collect_local_imports(future_source,{'_module_source_roots':[ROOT,HERE/'m']})
check('two-owner promotion discovered after explicit genuine dependency import',set(future_order)==expected)
preview=sealed.make_blind_dossier(primary)
for forbidden in ['LeVeque','leveque','LEV-CH01','CoordinateHighResolutionMethods','source-context','user-high-resolution','C:/','C:\\']:
 check('no source/path leakage: '+forbidden,forbidden not in preview)
check('diagnostic theorem proof excluded from its blind rendering','rfl' not in sealed.make_blind_dossier(probe))
old=(TASK/'faithfulness/inputs/blind_review_packet.md').read_bytes()
old_input=(TASK/'faithfulness/orchestration/b_input.txt').read_bytes()
check('original exact blind packet supplied once at end',old_input.endswith(old) and old_input.count(old)==1)
prefix=old_input[:-len(old)].replace(sha(old).encode(),sha(preview.encode()).encode())
future_input=prefix+preview.encode()
check('promoted diagnostic blind input under native limit',len(future_input.decode('utf-8'))<1048576 and len(future_input)<1048576)
def size_guard(b):
 assert len(b.decode('utf-8'))<1048576 and len(b)<1048576
try:size_guard(b'x'*1048576)
except AssertionError:tests.append({'name':'reject native limit equality/overflow','result':'PASS'})
else:raise AssertionError('overflow accepted')
artifacts=[]
artifacts.append(write('promoted-primary-blind-preview.md',preview))
artifacts.append(write('candidate-rate-readable.txt',rate+'\n'))
artifacts.append(write('regularity-readable.json',json.dumps({name:dd[name] for name in ['ContDiffOn','ContDiffWithinAt','ContDiffWithinAt.match_1','HasFTaylorSeriesUpToOn','HasFTaylorSeriesUpToOn.mk']},indent=2,ensure_ascii=False)+'\n'))
payload={'format':'blind-evidence-successor-preparation-diagnostic-1','status':'REVIEW ONLY; no prepared successor or model invocation',
 'sealed_python':ref(KIT/'scripts/prepare_audit.py'),'sealed_lean':ref(KIT/'scripts/declaration_dossier.lean'),
 'original_task':ref(TASK/'audit-task.json'),'original_blind_packet':ref(TASK/'faithfulness/inputs/blind_review_packet.md'),
 'mirror':ref(mirror),'original_mathlib_source':ref(upstream),'artifacts':artifacts,
 'tests':tests,'metrics':{'original_packet_bytes':len(old),'original_input_bytes':len(old_input),
 'promoted_dependency_count':len(primary['dependencies']),'promoted_packet_characters':len(preview),
 'promoted_packet_bytes':len(preview.encode()),'promoted_input_characters':len(future_input.decode()),
 'promoted_input_bytes':len(future_input),'native_limit':1048576,'native_headroom_bytes':1048576-len(future_input)},
 'remaining':[
 'Original audit must complete honestly before production repair and successor preparation.',
 'Current primary diagnostic retains original hidden choose and outer-top regularity; it is not a repaired task.',
 'Root must review/implement exact explicitRate body preserving rfl semantics and separately correct regularity.',
 'Fresh config must add the exact two-owner mirror module source root plus one explicit genuine FTaylorSeries import and hash-bind original source plus mirror.',
 'Actual successor prepare/prepared validation must pass; no actual preparation was run by this diagnostic.',
 'Fresh final blind packet and complete role stdin must pass semantic, isolation and byte/character size guards.',
 'The original parser does not follow public import syntax; promoted Defs compiled imports remain original pinned Mathlib external frontier.',
 'Direct/RT/adjudicator size must be checked separately; this blind result does not license lossy compression or supplementary blind input.']}
write('guard-results.json',json.dumps(payload,indent=2,ensure_ascii=False)+'\n')
print(json.dumps({'tests_passed':len(tests),'metrics':payload['metrics'],'guard_results':ref(HERE/'guard-results.json')},indent=2))
