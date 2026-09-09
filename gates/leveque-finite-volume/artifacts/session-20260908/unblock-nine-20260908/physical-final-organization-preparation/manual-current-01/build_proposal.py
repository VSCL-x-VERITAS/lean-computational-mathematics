"""Read-only evidence verification and append-only organization review proposal.

No Git, builds, organization capture/draft/measurement, gates or source edits.
The resulting descriptors require separate root review/adoption.
"""
from pathlib import Path
import ast, collections, datetime, hashlib, json, os, re, sys
sys.dont_write_bytecode = True
O = Path(__file__).resolve().parent
P = O.parent
D = P.parent
R = next(x for x in P.parents if (x / 'lean-toolchain').is_file())
S = D.parent
exec(compile((D / 'fv-local-domain-review/native-long-path-io.py').read_bytes(),
             'native-long-path-io.py', 'exec'), globals())
seen = {}

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def pin(p):
    h = sha(p)
    assert p not in seen or seen[p] == h, str(p)
    seen[p] = h
    return {'path': p.relative_to(R).as_posix(), 'sha256': h}

def read(p):
    pin(p)
    return json.loads(p.read_bytes())

def bound(ref):
    p = R / ref['path']
    assert pin(p) == {'path': ref['path'], 'sha256': ref['sha256']}
    return p

def write(name, obj):
    p = O / name
    with p.open('x', encoding='utf-8', newline='\n') as f:
        json.dump(obj, f, indent=2); f.write('\n')
    return pin(p)

def execution(label, evidence, rationale):
    recpath = S / ('unblock-nine-' + label + '-exit.json')
    outpath = S / ('unblock-nine-' + label + '-output.txt')
    rec = read(recpath)
    assert type(rec['exit_code']) is int and rec['exit_code'] == 0
    assert rec['input_commit'] == scope['input_commit']
    assert rec['output_sha256'] == pin(outpath)['sha256']
    assert type(rec['elapsed_ms']) is int and rec['elapsed_ms'] >= 0
    return {'receipt': pin(recpath), 'output': pin(outpath),
            'expected_command': rec['command'], 'applicability_rationale': rationale,
            'evidence': evidence}

scopepath = P / 'scope-final-01/unit-source-scope.json'
assert sha(scopepath) == '625703aeb0af04e542e2e68c33f2a4227d729ea80d90d3dd8b6a48ac5be1198e'
scope = read(scopepath)
scopereceipt = P / 'scope-final-01/receipt.json'
assert sha(scopereceipt) == '512cb6803d800890ed470b9b930a9a7d8da32adba0db950b95503e19f4d4c168'
sr = read(scopereceipt)
assert scope['source_tree_sha256'] == sr['source_tree_sha256'] == '0ce5a7e967129ddd5ff747d255f06fcb38c7620c2cf15802be05ab3fbbb40eda'
assert scope['input_commit'] == sr['input_commit'] == '5e3f63594aa964263469ada134aee2809559d50d'
assert scope['anchor'] == '9e2225705fed906b1120d55105d607baabef57c9'
assert all(x['exit_code'] == 0 for x in sr['commands'])
allpath = P / 'scope-final-01/all-production-source-pins.json'
allsource = read(allpath)
assert allsource['source']['source_tree_sha256'] == scope['source_tree_sha256']
assert len(allsource['files']) == scope['production_modules'] == 6024
for ref in allsource['files']: bound(ref)
current = {x['path']: x['sha256'] for x in scope['source_files']}
assert len(current) == len(scope['source_files']) == 221
for ref in scope['source_files']: bound(ref)
assert set(scope['reviewed_changed_source_paths']) <= set(current)
assert len(scope['reviewed_changed_source_paths']) == 149
assert scope['changed_paths_outside_semantic_scope'] == ['ComputationalMathematics/Analysis.lean']
oldpath = D / 'final-organization-manual-review/review-data.json'
old = read(oldpath)
previous = {x['path']: x['sha256'] for x in old['source_files']}
assert set(previous) <= set(current)
unchanged = sorted(p for p, h in previous.items() if current[p] == h)
changed = sorted(p for p, h in previous.items() if current[p] != h)
added = sorted(set(current) - set(previous))
assert (len(unchanged), len(changed), len(added)) == (199, 10, 12)
assets = read(P / 'scope-final-01/import-and-build-assets.json')
assert len(assets['source_imports']) == 220
imports = {x['module']: x['internal_imports'] for x in assets['source_imports']}
tierspath = R / 'docs/architecture/tiers.json'
tiers = read(tierspath)
prefixes = {r['prefix']:r['tier'] for r in tiers['prefixes']}
resolverpath = R / 'tools/architecture/check_tiers.py'
pin(resolverpath)
tree = ast.parse(resolverpath.read_text(encoding='utf-8'))
nodes = [n for n in tree.body if isinstance(n, ast.FunctionDef) and n.name in ('matching_prefixes', 'resolve')]
assert len(nodes) == 2
ns = {}
exec(compile(ast.Module(body=nodes, type_ignores=[]), str(resolverpath), 'exec'), ns)
roles = {p: dict(zip(('role', 'rule'), ns['resolve'](p[:-5].replace('/', '.'), tiers['exact'], prefixes))) for p in current}
assert all(x['role'] not in ('mixed', 'unclassified') for x in roles.values())
assert roles['ComputationalMathematics/Analysis.lean']['role'] == 'aggregate'
assert all(roles[p]['role'] == 'reusable' for p in added)
for p, assignment in roles.items():
    if assignment['role'] != 'reusable': continue
    queue = list(imports[p[:-5].replace('/', '.')]); visited = set()
    while queue:
        mod = queue.pop()
        if mod in visited: continue
        visited.add(mod)
        role, _ = ns['resolve'](mod, tiers['exact'], prefixes)
        assert role not in ('source', 'compatibility', 'mixed', 'unclassified'), (p, mod, role)
        assert mod in imports, ('incomplete semantic import closure', mod)
        queue.extend(imports[mod])
analysis = (R / 'ComputationalMathematics/Analysis.lean').read_text(encoding='utf-8')
analysisimports = re.findall(r'^import\s+(\S+)\s*$', analysis, re.M)
assert analysisimports == sorted(set(analysisimports), key=str.casefold)
assert all(p[:-5].replace('/', '.') in analysisimports for p in added)
baseline = P / 'scope-final-01/protected-anchor-layout-exceptions.json'
assert pin(baseline)['sha256'] == '82d45f87ffac2ba6ce7f717830ada910522e9418a90977c25c22ff5409c31ab6'
assert baseline.read_bytes() == (R / 'docs/architecture/layout-exceptions.json').read_bytes()
pin(R / 'docs/architecture/layout-exceptions.json')
fpdir = D / 'physical-syntax-fingerprints'
fppath = fpdir / 'current-expression-fingerprints.json'
assert sha(fppath) == '26817e845567840e94977e03a12fd89bb7b8ea3ba0ddc88d20c401e05036ac01'
fp = read(fppath)
assert len(fp['files']) == 183 and len(fp['records']) == 1688
assert len({r['name'] for r in fp['records']}) == 1688
for ref in fp['files']:
    bound(ref)
    assert current[ref['path']] == ref['sha256']
assert set(scope['additional_owner_seeds']) <= {r['path'] for r in fp['files']}
dup = collections.defaultdict(list)
for r in fp['records']:
    if r['module'].startswith('ComputationalMathematics.Source.LeVeque.Chapter01.'):
        dup[(r['type_sha256'], r['value_sha256'])].append(r['name'])
same_source = sorted(sorted(v) for v in dup.values() if len(v) > 1)
fr = read(fpdir / 'final-receipt.json')
assert fr['actual_native_exit'] == fr['actual_prepare_exit'] == fr['actual_parse_archive_exit'] == 0
assert fr['record_list_exactly_unchanged'] is True
eq = read(fpdir / 'structural-equality.json')
graphbase = S / 'architecture-graphs/unblock-nine-physical-current-source'
graph = {'json': pin(graphbase.with_suffix('.json')), 'markdown': pin(graphbase.with_suffix('.md'))}
assert read(graphbase.with_suffix('.json'))['source']['source_tree_sha256'] == scope['source_tree_sha256']
review = pin(O / 'REVIEW.md')
extra = [D/'final-organization-manual-review/REVIEW.md', D/'physical-dim-promotion-review/REVIEW.md',
 D/'physical-dim-canonical-comparisons/README.md', D/'physical-dim-canonical-comparisons/final-receipt.json',
 D/'physical-organization-exposure-preparation/applied-01/ROOT-ADOPTION.md',
 D/'physical-production-promotion/layout-rhs-parentheses-01/receipt.json',
 D/'physical-production-promotion/owners-native-04-receipt.json',
 fpdir/'final-receipt.json', fpdir/'structural-equality.json', fpdir/'fingerprint-receipt.json']
evidence = [review, pin(scopepath), pin(scopereceipt), pin(allpath), pin(tierspath)] + [pin(p) for p in extra]
checkers = {}
for key, label in [('layout','layout-02'), ('tiers','tiers'), ('compatibility','compatibility'), ('hygiene','hygiene-02')]:
    checkers[key] = execution('physical-current-' + label, evidence,
        'Actual successful current checker with exact source, import and policy pins. Final parentheses have identical native structural records and imports; layout/hygiene use the post-repair 02 execution. Root adoption remains required.')
    assert checkers[key]['expected_command'] == ['/usr/bin/python3', 'tools/architecture/' + {'layout':'check_layout.py','tiers':'check_tiers.py','compatibility':'check_compatibility.py','hygiene':'check_placeholders.py'}[key]]
graph_execution = execution('physical-current-source-graphs', evidence,
    'Actual strict source-only graph capture with source_tree_sha256 equal to the current reviewed source tree. This graph does not claim a new native declaration export.')
manifestpath = D / 'physical-current-complete-declarations/manifest.json'
native_manifest = read(manifestpath)
eulerpath = D / 'physical-current-complete-declarations/execution-descriptors.json'
assert sha(eulerpath) == '7549359f5b5b3bb55089de21faa8648b8309e06596c500150e3bfd18052185d7'
euler = read(eulerpath)
eulerfinal = D / 'physical-current-complete-declarations/final-receipt.json'
assert sha(eulerfinal) == '44b5b168c1f4eda77349a41cb5949821617d1c54a82db687ef1d6b2900ff3966'
evidence += [pin(eulerpath), pin(eulerfinal)]
assert len(native_manifest['rows']) == 41
for ref in native_manifest['files']: bound(ref)
checkpath = R / native_manifest['check_file']
assert pin(checkpath)['sha256'] == native_manifest['check_file_sha256']
native = execution('physical-final41-declarations', evidence + [pin(manifestpath), pin(checkpath)],
    'Actual current 41 selected/prospective whole-type and axiom checks on the exact supplied owner and check bytes. Prospective source selections are not audit acceptance.')
native_out = bound(native['output']).read_text(encoding='utf-8')
reports = {}
for name, body in re.findall(r"'([^']+)' depends on axioms: \[([^]]*)\]", native_out):
    assert name not in reports
    reports[name] = {x.strip() for x in body.split(',') if x.strip()}
for name in re.findall(r"'([^']+)' does not depend on any axioms", native_out):
    assert name not in reports
    reports[name] = set()
assert set(reports) == {v['declaration'] for v in native_manifest['rows'].values()}
assert all(v <= {'propext','Classical.choice','Quot.sound'} for v in reports.values())
builds = {key: execution('physical-final41-' + label, evidence + [pin(manifestpath)],
    'Actual current successful native build. Source pins establish organization applicability; no source verdict is inferred.')
    for key, label in [('full','full-build'),('focused','chapter01-build')]}
for key, value in [('complete_native', native), ('full_build', builds['full']), ('focused_build', builds['focused'])]:
    assert {k:value[k] for k in ('receipt','output','expected_command')} == euler[key]
gatepath = P / 'current-gate-snapshot-01.json'
gatereceipt = P / 'current-gate-snapshot-01-receipt.json'
assert sha(gatepath) == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
assert sha(gatereceipt) == '15f3357fb4a4fdf6adb831ec7d6f9ce9fb638417ecd897905727b5c4bebe05cc'
gate = read(gatepath)
assert len(gate['rows']) == 57
assert {r['id'] for r in gate['rows'] if r['status'] != 'SKIPPED'} == set(native_manifest['rows'])
fpdescriptor = {'inventory':pin(fppath),'expected_records':1688,'expected_files':183,
    'provenance':[pin(fpdir/x) for x in ['final-receipt.json','fingerprint-receipt.json','structural-equality.json','final-package.json']]}
scope_assessment = {'rationale':
    'The exact changed paths are covered by preserved prior review and current contract/placement review. Current source hashes, semantic import closure, tier resolution, aggregate ordering, native owner inventory and actual check receipts agree. No confirmed duplicate canonical producer or unresolved placement was identified. Root adoption and the unchanged operational organization measurement remain required.',
    'unit_scope':{k:[] for k in ['unexpected_changes','unclassified_modules','mixed_pending_split','duplicate_wrappers','placeholder_findings','canonical_placement_pending']}}
review_data = {'schema':1,'status':'root-review-required','kind':'current-organization-manual-review-proposal',
    'observed_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'anchor':scope['anchor'],'input_commit':scope['input_commit'],'source_tree_sha256':scope['source_tree_sha256'],
    'source_files':scope['source_files'],'reviewed_changed_source_paths':scope['reviewed_changed_source_paths'],
    'review_evidence':evidence,'scope_assessment':scope_assessment,'roles':roles,
    'preservation':{'unchanged_prior_files':unchanged,'changed_prior_files':changed,'additional_files':added},
    'native_inventory':fpdescriptor,'source_only_exact_type_body_duplicate_signal':same_source,
    'duplicate_signal_is_exhaustive_semantic_test':False,'source_acceptance':False,
    'operational_measurement':False,'gate_mutation':False,'git_mutation':False}
placement = [{'evidence':review,'rationale':scope_assessment['rationale'],
              'covered_source_paths':scope['reviewed_changed_source_paths']}]
descriptors = {'schema':1,'status':'root-review-required','scope':pin(scopepath),'scope_receipt':pin(scopereceipt),
    'all_production_sources':pin(allpath),'graph':graph,'graph_execution':graph_execution,
    'fingerprints':[fpdescriptor],'complete_declaration_manifest':pin(manifestpath),
    'complete_native':native,'checker_executions':checkers,'placement_reviews':placement,
    'supporting_current_builds':builds,'missing_native_checks':[],
    'proposed_immutable_gate':pin(gatepath),'gate_snapshot_provenance':pin(gatereceipt),
    'remaining_actions':['Root review/adoption','Root topology selection','Root config assembly, capture, draft, applicability adoption and organization measurement'],
    'not_released_ready_inputs':True,'source_acceptance':False}
for p,h in list(seen.items()): assert sha(p) == h, ('input changed', str(p))
review_ref = write('review-data.json',review_data)
descriptor_ref = write('execution-descriptors.json',descriptors)
verification = write('verification.json',{'status':'verified-proposal-root-review-required',
    'production_sources_checked':6024,'unit_sources_checked':221,'current_native_owners_checked':183,
    'current_native_records':1688,'complete_native_reports':len(reports),
    'read_only_transitive_reusable_import_check':True,'current_aggregate_sorted_unique':True,
    'prior_unchanged':199,'prior_changed':10,'new_files':12,
    'actual_four_checker_exits':[0,0,0,0],'actual_graph_exit':0,
    'actual_complete_native_exit':0,'actual_full_and_focused_build_exits':[0,0],
    'source_only_exact_type_body_duplicate_signal':same_source,
    'operational_organization_runs':0,'git_operations':0,'source_acceptance':False})
inputs = [{'path':p.relative_to(R).as_posix(),'sha256':h} for p,h in seen.items() if p.parent != O]
manifest = write('manifest.json',{'format':'current-organization-review-proposal-1',
    'script':pin(Path(__file__)),'review':review,'review_data':review_ref,
    'execution_descriptors':descriptor_ref,'verification':verification,'inputs':inputs,
    'status':'root-review-required','source_acceptance':False})
receipt = write('receipt.json',{'manifest':manifest,'verification':verification,
    'review_data':review_ref,'execution_descriptors':descriptor_ref,
    'status':'proposal-frozen-root-review-required','actual_verification_completed':True,
    'organization_capture_runs':0,'organization_draft_runs':0,'organization_measurement_runs':0,
    'source_mutations':0,'git_operations':0,'gate_mutations':0,'source_acceptance':False})
print(json.dumps({'receipt':receipt,'manifest':manifest,'review_data':review_ref,'execution_descriptors':descriptor_ref}))
