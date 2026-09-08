"""Read frozen evidence and write only this additive report directory. No tool execution."""
import collections
import datetime
import hashlib
import json
import os
import re
from pathlib import Path

W = Path('C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS')
R = W / 'lean-computational-mathematics'
S = R / 'gates/leveque-finite-volume/artifacts/session-20260908'
D = S / 'chapter01-final-report-preparation-80f5'
P = S / 'blocked-gate-binding-transcript-order-v2/runs/final-80f5'
inputs = {}

def native(p):
    return '\\\\?\\' + str(Path(p).absolute()).replace('/', '\\')

def raw(p):
    p = Path(p)
    b = Path(native(p)).read_bytes()
    inputs[str(p).replace('\\', '/')] = hashlib.sha256(b).hexdigest()
    return b

def read(p):
    return json.loads(raw(p).decode('utf-8-sig'))

def ref(p, expected=None):
    p = Path(p)
    b = raw(p)
    h = hashlib.sha256(b).hexdigest()
    if expected:
        assert h == expected, (str(p), h, expected)
    return {'path': str(p).replace('\\', '/'), 'sha256': h}

def resolve(p):
    if p.startswith('/c/'):
        return Path('C:/' + p[3:])
    return Path(p) if Path(p).is_absolute() else R / p

def bound(obj):
    return ref(resolve(obj['path']), obj['sha256'])

def write(name, content):
    assert '/' not in name and '\\' not in name
    with open(native(D / name), 'xb') as f:
        f.write(content.encode('utf-8'))

def dump(name, obj):
    write(name, json.dumps(obj, ensure_ascii=False, indent=2) + '\n')

def link(p, label=None):
    p = str(p).replace('\\', '/')
    return '[' + (label or Path(p).name) + '](<' + p + '>)'

def cell(text):
    return str(text).replace('|', '\\|').replace('\n', ' ')

attachment = ref(Path('C:/Users/qed_s/.codex/attachments/2ad9273d-d8aa-4354-a2d3-2032ca9861f1/pasted-text.txt'))
prep_ref = ref(P / 'preparation.json', 'c12dc8ca1662acd5a024188a1124e58d9f4a8f7c6882d6520c4d42254461f41e')
prep = read(P / 'preparation.json')
gate_ref = bound(prep['proposed_gate'])
gate = read(resolve(prep['proposed_gate']['path']))
request = read(resolve(prep['request']['path']))
request_ref = bound(prep['request'])
projection = read(resolve(request['question_projection']['path']))
projection_ref = bound(request['question_projection'])
route_ref = bound(request['route_manifest'])
routes = read(resolve(request['route_manifest']['path']))
source_manifest_ref = bound(request['source_manifest'])
source_manifest = read(resolve(request['source_manifest']['path']))
terminal_ref = ref(P / 'root-final-80f5-terminal.json')
terminal = read(P / 'root-final-80f5-terminal.json')
terminal_output = ref(P / 'root-final-80f5-checker-output.txt', terminal['output_sha256'])
terminal_text = raw(P / 'root-final-80f5-checker-output.txt').decode('utf-8-sig')
assert terminal['exit_code'] == 0 and terminal['derived_verdict'] == 'BLOCKED'
assert terminal['actionable_rows'] == 0 and terminal['gate_sha256'] == gate_ref['sha256']
installation_ref = ref(S / 'blocked-gate-installation/final-80f5/installation.json',
                       '62ecd701ca99b402f1979bb3eba7afb823221db06296c7a78fe235edb1f95c96')
mechanical_ref = ref(S / 'final-blocked-proposal-independent-review-80f5/final-receipt.json',
                     '83d9a79753d8367f578c42ea8c09463d1544d42813998c38b7c0c934f45d1b50')
ledger_record_ref = ref(S / 'root-final-ledger-records-80f5.json',
                        'ec241b0c4041f9ecae9779a4ab2a999e061420b8656b9abd23fb5c67d0605339')

rows = gate['rows']
accepted = [r for r in rows if r['status'] in ['PROVED', 'REUSED']]
blocked = [r for r in rows if r['status'] == 'HARD_BLOCKED']
skipped = [r for r in rows if r['status'] == 'SKIPPED']
counts = dict(collections.Counter(r['status'] for r in rows))
classes = dict(collections.Counter(r['classification'] for r in accepted))
assert counts == {'REUSED': 17, 'PROVED': 15, 'HARD_BLOCKED': 9, 'SKIPPED': 16}, counts
assert classes == {'faithful-equivalent': 28, 'faithful-stronger': 4}, classes
assert sorted(d for r in accepted for d in r['lean_declarations']) == prep['closed_declarations']
accepted_data = []
for r in accepted:
    item = {k: r[k] for k in ['id', 'source_label', 'printed_page', 'pdf_page', 'status', 'lean_declarations',
                              'classification', 'lean_implies_source', 'source_implies_lean']}
    item['decision'] = ref(resolve(r['faithfulness_decision']))
    for k in ['reuse_source', 'applicability_audit', 'nonvacuity_witness', 'strengthening_evidence']:
        if k in r:
            item[k] = r[k]
    accepted_data.append(item)

questions = [q for q in projection['questions'] if q.get('row_ids')]
assert len(questions) == 8
q_by_row = {}
for q in questions:
    assert q['status'] == 'pending'
    for row in q['row_ids']:
        assert row not in q_by_row
        q_by_row[row] = q
assert set(q_by_row) == {r['id'] for r in blocked}
question_numbers = {
    'call_ctzCZ7YK8zbx2yUzmX59YBdC': 3, 'call_6YQjDMqpCa41f93c3kdBhahI': 4,
    'call_Jsn9xP52SK6H0Gt06HXTTauK': 5, 'call_uHJOZR8JifMR8TsqhW2IOTRX': 6,
    'call_1UY4fVuKrjpIIQfhLdeuFoRH': 7, 'call_1JnoPOtxdApI1F5hUmt5F9Q7': 8,
    'call_owBbdcnANNrlxzRviSsTqHNo': 9, 'call_axfTXsEjNKG3lawf5Dq10qQv': 10,
}
blocked_data = []
for r in blocked:
    q = q_by_row[r['id']]
    assert q['question_id'] in r['resume_condition']
    item = dict(r)
    item['question_number'] = question_numbers[q['call_id']]
    item['question_id'] = q['question_id']
    item['question_text'] = q['exact_text']
    item['question_record'] = bound(q['record'])
    blocked_data.append(item)

validations = []
for label, pair in request['receipts'].items():
    eref = bound(pair['exit'])
    oref = bound(pair['output'])
    receipt = read(resolve(pair['exit']['path']))
    assert receipt['exit_code'] == 0, label
    assert receipt.get('output_sha256', receipt.get('raw_output_sha256')) == oref['sha256']
    validations.append({'label': label, 'receipt': eref, 'output': oref, 'details': receipt})
for label in ['batch10-graph-check', 'batch10-organization-preflight', 'final-material-choice-trackers-80f5']:
    eref = ref(S / (label + '-exit.json'))
    receipt = read(S / (label + '-exit.json'))
    assert receipt['exit_code'] == 0
    oref = ref(S / (label + '-output.txt'), receipt.get('output_sha256', receipt.get('raw_output_sha256')))
    validations.append({'label': label, 'receipt': eref, 'output': oref, 'details': receipt})

org = read(P / 'organization_scan.json')['payload']
assert all(v == 0 for v in org['counters'].values())
for artifact in prep['artifacts']:
    bound(artifact)
tiers_text = raw(S / 'batch10-tiers-output.txt').decode('utf-8-sig').strip()
compatibility_text = raw(S / 'batch10-compatibility-output.txt').decode('utf-8-sig').strip()

# Frozen review summaries are reported as observed scoped searches, not new exhaustive searches.
reuse = [
    {'topic': 'Actual acoustic mode and sound speed',
     'terms': ['linearAcousticsRightInvariant', 'acousticsRightMode', 'sq_sqrt', 'sqrt_pos'],
     'candidates_rejected': ['The old positive-material source wrapper and its private helper require separate signs, so do not directly cover the requested positive-ratio domain.', 'mul_div_cancel_left₀ was inspected; field_simp sufficed for local cancellation.'],
     'selected': ['linearAcousticsRightInvariant_isLinearAdvectionSolutionAt', 'Real.sq_sqrt', 'Real.sqrt_pos'],
     'duplicate_avoidance': 'Thin source arithmetic reuses the genuine given-system derivative producer; no duplicate acoustic or derivative owner.',
     'evidence': ['acoustics-algebraic-domain/source-reuse-domain-review.md', 'acoustics-algebraic-domain/reuse-searches.json']},
    {'topic': 'General one-step dependence',
     'terms': ['FactorsThrough', 'rangeFactorization', 'oneStep', 'surjective factorization', 'surjective lifts'],
     'candidates_rejected': ['Function.factorsThrough_iff requires Nonempty NextData and an update on the full intermediate type; it is not the desired attainable-range contract.', 'Algebraic surjective lifts add structure unnecessary for the arbitrary-function statement.'],
     'selected': ['Function.FactorsThrough', 'Set.rangeFactorization', 'Set.rangeFactorization_surjective', 'Function.Surjective.hasRightInverse'],
     'duplicate_avoidance': 'Reuses the dependence predicate and surjectivity/choice primitives; the finite-history API is a specialization.',
     'evidence': ['one-step-general-domain-draft/source-and-reuse-review.md', 'one-step-general-domain-draft/mathlib-factorization-search.stdout.txt', 'one-step-general-domain-draft/project-search.stdout.txt']},
    {'topic': 'Transport and rectangle conservation',
     'terms': ['Riemann', 'translation', 'translate', 'integral.*transport', 'rectangle.*balance', 'spaceTime.*[Bb]alance', 'integral_comp_(sub|add|mul|div)'],
     'candidates_rejected': ['The existing classical interval-mass derivative predicate is not a general discontinuous rectangle certificate; the later moving-step witness proves the endpoint-crossing distinction.', 'No matching complete time-integrated transport theorem was selected in the recorded PDE/interval-integral search.'],
     'selected': ['travelingWave', 'riemannData', 'intervalIntegral.integral_comp_sub_right', 'intervalIntegral.smul_integral_comp_sub_mul', 'intervalIntegral.integral_interval_sub_interval_comm', 'IntervalIntegrable.comp_sub_right'],
     'duplicate_avoidance': 'Reuses translation, substitution and four-edge cancellation, avoiding new special Heaviside integral proofs for the general balance.',
     'evidence': ['transport-rectangle-reuse-review.md']},
    {'topic': 'Nonlinear shock witness',
     'terms': ['Huber', 'shock', 'piecewise integrability', 'piecewise derivative helpers'],
     'candidates_rejected': ['Classical breakdown alone does not prove a discontinuous conserved continuation.', 'The nonentropy Burgers bubble was rejected; the bounded inverse-branch route was not needed for the selected C1-flux witness.'],
     'selected': ['HuberShock.shockState_isRectangleConservationLawSolution', 'IsRectangleConservationLawSolution', 'Integrable.piecewise', 'intervalIntegral.integral_hasDerivAt_right', 'intervalIntegral.integral_eq_sub_of_hasDeriv_right', 'Monotone.convexOn_univ_of_deriv'],
     'duplicate_avoidance': 'One shared rectangle owner; generic calculus/integrability helpers and Huber flux are separate from the example and source existential.',
     'evidence': ['shock-production/post-rename-lf/extraction-review.md', 'shock-production/reuse-searches.json', 'shock-production/piecewise-producer-search.json']},
    {'topic': 'Real integration normalization',
     'terms': ['Real.measureSpace', 'MeasureSpace.volume', 'measureSpaceOfInnerProductSpace', 'addHaar', 'volume_Ioc', 'volume_Icc'],
     'candidates_rejected': ['Bare inferInstance syntax does not by itself expose the selected real measure or normalization.', 'A unit interval alone is not used as an unsupported whole-measure identification.'],
     'selected': ['Real.volume_eq_stieltjes_id', 'Real.volume_Icc', 'Real.volume_Ioc', 'Real.volume_real_Icc_of_le', 'Real.volume_real_Ioc_of_le', 'Module.Basis.addHaar_def'],
     'duplicate_avoidance': 'Pinned elaborated instance chain and existing whole-measure/length theorems supply the dossier; no measure construction or normalization proof is duplicated.',
     'evidence': ['real-measure-dependency/supplementary-declaration-dossier-v2.md', 'real-measure-dependency/reuse-searches.json', 'real-measure-dependency/additional-searches.json']},
    {'topic': 'Variable-coefficient local-flux obstruction',
     'terms': ['Has.*Flux', 'transport.*[Ff]lux', 'Flux.*[Oo]bstruction'],
     'candidates_rejected': ['Existing linear-flux and Riemann-interface derivative producers do not prove the variable-coefficient obstruction.', 'The earlier state-only flux candidate does not cover spatially dependent local flux F(x,q).'],
     'selected': ['is_const_of_deriv_eq_zero', 'HasDerivAt.unique', 'HasDerivAt.comp', 'ContDiff.add', 'ContDiff.pow'],
     'duplicate_avoidance': 'Uses constant and affine test profiles and existing scalar hyperbolicity; excludes local flux for unchanged density without asserting an obstruction to changed density/integrating factors.',
     'evidence': ['variable-coefficient-local-flux-reuse-review.md']},
    {'topic': 'Information-only Riemann routine and conditional accuracy',
     'terms': ['RiemannInformationFluxMethod', 'RiemannFieldFluxMethod', 'norm_sub_oneDimensionalCellAverage_le_of_trace', 'riemannFiniteVolumeUpdate_error_le'],
     'candidates_rejected': ['A compulsory full returned field and all-real integrable trace restrict execution unnecessarily.', 'Constant consistency is not physical accuracy; approximate information is not automatically a solved physical problem.'],
     'selected': ['RiemannInformationFluxMethod', 'RiemannInformationFluxMethod.interface_execution', 'RiemannInformationFluxMethod.interface_error_le', 'norm_sub_oneDimensionalCellAverage_le_of_trace', 'riemannFiniteVolumeUpdate_error_le'],
     'duplicate_avoidance': 'Four semantic leaves reuse existing trace and update estimates, preserve the field adapter, and prove nominal structure maps/round trips instead of claiming false definitional equality.',
     'evidence': ['information-method-production/REVIEW.md', 'information-method-production/search-01.txt', 'information-method-production/search-02.txt', 'information-method-production/search-03.txt']},
]
for item in reuse:
    item['evidence'] = [ref(S / path) for path in item['evidence']]

ledger_base = R / 'ledgers/leveque-finite-volume'
ledger_dirs = {
    'book': ledger_base / 'book-issues/leveque-finite-volume/chapters/chapter-01',
    'process': ledger_base / 'skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908',
}
ledgers = {}
for kind, folder in ledger_dirs.items():
    paths = []
    issue_ids = []
    for name in ['issues.md', 'limitations.md', 'inconsistencies.md', 'tracker.json']:
        src = folder / name
        b = raw(src)
        snap = kind + '-' + name + '.snapshot.txt'
        write(snap, b.decode('utf-8-sig'))
        # UTF-8 byte snapshots are exact; this assertion also rejects BOM conversion.
        assert Path(native(D / snap)).read_bytes() == b
        paths.append({'original': ref(src), 'snapshot': {'path': str(D / snap).replace('\\', '/'), 'sha256': hashlib.sha256(b).hexdigest()}})
        if name == 'issues.md':
            issue_ids = re.findall(r'^\| ([^ |]+) \|', b.decode('utf-8'), re.M)
            issue_ids = [x for x in issue_ids if x != 'ID']
    ledgers[kind] = {'files': paths, 'issue_ids': issue_ids,
                     'through_80f5_numbered_range': '001-070' if kind == 'book' else '001-062',
                     'terminal_additions_captured': '071-079' if kind == 'book' else '063-066'}

source_pdf = next(x for x in prep['input_files'] if x['path'].endswith('.pdf'))
source_ref = bound(source_pdf)
data = {
    'schema_version': 1, 'kind': 'chapter01-final-report-draft',
    'created_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'input_commit': prep['input_commit'],
    'report_stage': 'Actual installed BLOCKED checker result included; final durable checkpoint and campaign integration update reserved to root.',
    'initial_preparation_state': 'The proposal was uninstalled when this report task began. Root subsequently installed the exact proposal and ran the released checker; both actual receipts are now included.',
    'gate_verdict': 'BLOCKED', 'derived_verdict': terminal['derived_verdict'], 'actionable_rows': 0,
    'progress': {'formalized_objects': 32, 'remaining_objects': 9, 'formalization_denominator': 41, 'formalization_percentage': 78.05, 'total_inventory_rows': 57, 'skipped': 16, 'deferred': 0},
    'status_counts': counts, 'classifications': classes, 'accepted_rows': accepted_data,
    'blocked_rows': blocked_data, 'distinct_pending_questions': questions, 'skipped_rows': skipped,
    'organization': {'counters': org['counters'], 'cross_gate_consistency': org['cross_gate_consistency'], 'tier_output': tiers_text, 'compatibility_output': compatibility_text},
    'source_pdf': source_ref, 'bindings': prep['bindings'],
    'runtime': {'lean': '4.29.0-rc3', 'lean_commit': '5d86aa4032284a5242470e95fbe25f1ff506763d', 'mathlib_commit': 'e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'},
    'source_profile_note': 'lean_git_head in gate bindings is the integrated baseline; input_commit is the actual current validation HEAD. They are not interchangeable.',
    'validation_receipts': validations, 'terminal': terminal, 'terminal_ref': terminal_ref, 'terminal_output': terminal_output,
    'installed_gate': gate_ref, 'installation': installation_ref, 'preparation': prep_ref, 'request': request_ref,
    'source_choice_manifest': source_manifest_ref, 'question_projection': projection_ref, 'route_manifest': route_ref,
    'independent_mechanical_review': mechanical_ref,
    'reuse_search_examples': reuse, 'issue_ledgers': ledgers, 'terminal_ledger_record': ledger_record_ref,
    'integration': {'through_80f5': 'checkpointed', 'final_blocked_checkpoint': 'pending root final update', 'campaign_status': 'pending root final update', 'integrated_claim': False},
    'limits': ['No new source-faithfulness judgment is made by this report.', 'Eight distinct unanswered choices affect nine rows; Q7 is shared by FV and interface.', 'Q11 full-field representation remains unmapped and is not a required blocker.', 'Earlier adopted conventions remain scoped to their recorded rows.', 'Fresh source-contract auditing is required after a pending choice is supplied.', 'No PASS reconciliation epoch, integration authority or external acceptance is asserted.'],
    'original_final_response_requirements': attachment,
}
dump('report-data.json', data)

md = []
def para(text):
    md.append(text + '\n')

para('Chapter 1 is **BLOCKED**, with **32 of 41 counted objects formalized (78.05%)**: 15 `PROVED`, 17 `REUSED`, and nine `HARD_BLOCKED` rows. The inventory contains 57 rows in total, with 16 lawful skips and zero deferred rows. The actual released checker exited 0 and found zero actionable rows. This is a certified blocked state, not Chapter 1 completion.')
para('The proposal was uninstalled when this report task began. Root has since installed its exact bytes and run the separate released installed check. This draft includes that result at `80f5d4340d507dbc347a806717ff31c5a9aace72`; root must add the final durable checkpoint and campaign state. Work through 80f5 is checkpointed. No integrated or PASS result is asserted here.')
para('The organization and semantic-equivalence loops are closed; formalization completeness remains open. All eight evidence categories were verified: source inventory, organization, faithfulness, declaration resolution, axioms, focused build, full build and hygiene. ' + link(P / 'root-final-80f5-terminal.json', 'Actual terminal receipt') + ' and ' + link(P / 'root-final-80f5-checker-output.txt', 'raw checker output') + '.')
para('The 32 accepted declarations are individually listed below. Names use the exact `NumStability` namespace. `Equivalent` means the recorded sealed decision accepts both implications. `Stronger` means an accepted compatible strengthening with separate applicability and nonvacuity evidence, not a claim of both implications.')
md.append('| Gate status | Accepted declaration | Faithfulness |\n|---|---|---|')
for r in accepted_data:
    for declaration in r['lean_declarations']:
        md.append('| ' + r['status'] + ' | `' + declaration + '` | ' + r['classification'].removeprefix('faithful-').capitalize() + ' |')
md.append('')
para('Faithfulness totals are **28 equivalent and four stronger**. The four strengthened contracts are the smooth integral-to-differential bridge, nonlinear shock formation, linear Riemann eigensolution, and the variable-coefficient local-flux obstruction. Their source applicability and independently checked extra instances remain bound to each row in ' + link(D / 'report-data.json') + '. Historical rejected and undetermined audits remain preserved; successor acceptance does not rewrite them.')
para('Nine rows await the following eight source choices. These are the actual mapped pending questions, not newly posed questions. Each row must receive its recorded choice, select the explicit source-facing contract while preserving the ambiguity, and pass a fresh statement-faithfulness audit before acceptance. Q7 is shared by two rows; Q11 is not a required blocker because the information-only routine removes the compulsory full-field representation.')
md.append('| Remaining gate row | Choice | Exact call ID (question index 0) | Unresolved scope |\n|---|---|---|---|')
for r in blocked_data:
    q = q_by_row[r['id']]
    scope = r['obstruction'].split('remains unanswered: ', 1)[-1]
    md.append('| `' + r['id'] + '` | Q' + str(r['question_number']) + ' | `' + q['call_id'] + '` | ' + cell(scope) + ' |')
md.append('')
para('Each full question ID is the exact JSON string `["request_user_input_async","CALL_ID",0]`, with CALL_ID from the table. The complete IDs, original question text, captured record hashes and row-specific completed routes are in ' + link(D / 'report-data.json') + '; their independent chronology is in ' + link(resolve(request['question_projection']['path']), 'question projection') + '. The reviewed source boundaries are in ' + link(resolve(request['source_manifest']['path']), 'source-choice manifest') + '. Earlier adopted profile and rectangle/AE conventions have not been silently extended to these unanswered scopes.')
para('The 16 excluded inventory rows and their preserved reasons are:')
md.append('| Skipped row | Reason code | Scope reason |\n|---|---|---|')
for r in skipped:
    md.append('| `' + r['id'] + '` | ' + cell(r.get('reason_code', '')) + ' | ' + cell(r.get('reason', '')) + ' |')
md.append('')
para('The four organization counters are all zero: unclassified modules, duplicate wrappers, placeholder findings, and canonical placement pending. The same zero counters agree across the one active chapter gate. The actual tier scan reports 5,968 production modules: 449 aggregate, 3,334 compatibility, five internal, 663 reusable, 1,512 source and five upstream; mixed modules are zero. The compatibility scan reports 3,334 forwarding modules, 2,537 unique canonical targets, 14,688 target edges and zero production imports of historical paths. These measured counts come from the current scan receipts, not from counting this report.')
para('Recorded library and pinned-Mathlib searches guided producer selection. The following are concrete examples with preserved query/candidate evidence; they are not a claim that a textual miss proves global semantic absence.')
for item in reuse:
    para('**' + item['topic'] + '.** Terms: ' + ', '.join('`' + x + '`' for x in item['terms']) + '. Selected: ' + ', '.join('`' + x + '`' for x in item['selected']) + '. ' + ' '.join(item['candidates_rejected']) + ' ' + item['duplicate_avoidance'] + ' Evidence: ' + ', '.join(link(x['path']) for x in item['evidence']) + '.')
para('The final actual validation commands are recorded below. This report only reads their frozen receipts; it does not rerun a build, audit or operational gate command. Native Lean/Lake was used for Lean; released Python commands ran through the prepared POSIX workflow launcher.')
md.append('| Validation | Exact recorded command | Actual exit |\n|---|---|---:|')
for v in validations:
    command = v['details'].get('command', v['details'].get('argv'))
    command = ' '.join(command) if isinstance(command, list) else str(command)
    md.append('| ' + link(v['receipt']['path'], v['label']) + ' | `' + cell(command) + '` | 0 |')
md.append('| Installed released gate | `' + cell(' '.join(terminal['command'])) + '` | 0 |')
md.append('')
para('The current native declaration check covers all 32 accepted declarations and 32 axiom reports. The accepted outputs use only `propext`, `Classical.choice`, and `Quot.sound`; no `sorryAx` is accepted. Focused Chapter 1 and full both-root builds at 80f5 exited 0. Earlier failures remain separate evidence, including premature invocation before the generated final check file existed, the two accidentally tracked generated caches, and the corrected staging postcondition. They are not substituted for successful receipts.')
para('Immutable source and profile bindings:')
md.append('| Binding | SHA-256 or exact revision |\n|---|---|')
for label, value in [('Source PDF', source_ref['sha256']), ('Module profile', prep['bindings']['module_profile_sha256']), ('Unit index', prep['bindings']['unit_index_sha256']), ('Unit record', prep['bindings']['unit_record_sha256']), ('Gate policy', prep['bindings']['gate_policy_sha256']), ('Current validated code fingerprint', prep['bindings']['lean_worktree_sha256']), ('Installed gate', gate_ref['sha256']), ('Preparation', prep_ref['sha256']), ('Terminal raw output', terminal_output['sha256']), ('Pinned Mathlib', data['runtime']['mathlib_commit']), ('Native Lean commit', data['runtime']['lean_commit'])]:
    md.append('| ' + label + ' | `' + value + '` |')
md.append('')
para('The unit audit epoch is `' + prep['bindings']['unit_audit_epoch'] + '`. The gate binding `lean_git_head=' + prep['bindings']['lean_git_head'] + '` denotes the integrated baseline; the actual final native validation input is `80f5d4340d507dbc347a806717ff31c5a9aace72`. Those two commit roles remain distinct.')
para('Book/source issues and process issues remain in separate ledgers. The 80f5 checkpoint includes the book numbered sequence through 070 and process sequence through 062, with stable follow-up identifiers and historical entries preserved. The subsequent actual terminal update appends **Book 071–079** (one explicit material-choice boundary per blocked row) and **Process 063–066** (final native ordering, request schema, review path correction, and installed-versus-durable boundary). The exact live bytes captured for this draft and all issue IDs are snapshotted beside the report; ' + link(S / 'root-final-ledger-records-80f5.json', 'root ledger receipt') + ' binds the terminal additions. The actual final tracker validation exited 0. Earlier open ledger entries are historical; current gate rows and later resolution entries determine current status.')
para('The exact hard blockers are the eight unanswered choices mapped above. They are source-scope choices, not unproved local prerequisites disguised as closure. The final route dossier records all seven required local-work categories as completed for each row, with source, reuse, construction, consumer/organization, validation, review and counterexample/alternative evidence. This report does not independently judge source exhaustion. Root retains responsibility for the final durable BLOCKED checkpoint, live campaign disposition (`checkpointed`, `queued`, `integrated` or `superseded` as supported by the actual receipt), and final terminal state after that checkpoint. No reconciliation epoch or authority artifact is fabricated.')
write('report-draft.md', '\n'.join(md) + '\n')
dump('input-manifest.json', {'schema_version': 1, 'kind': 'read-only-report-input-bindings', 'inputs': [{'path': p, 'sha256': h} for p, h in sorted(inputs.items())], 'note': 'Ledger snapshots preserve the captured bytes if root later appends final checkpoint records. No runtime, proof, audit, gate, Git or ledger command was invoked.'})
outputs = []
for name in ['assemble-report.py', 'report-data.json', 'report-draft.md', 'input-manifest.json'] + [p.name for p in D.iterdir() if p.name.endswith('.snapshot.txt')]:
    b = Path(native(D / name)).read_bytes()
    outputs.append({'path': str(D / name).replace('\\', '/'), 'sha256': hashlib.sha256(b).hexdigest(), 'bytes': len(b)})
dump('final-receipt.json', {'schema_version': 1, 'kind': 'report-assembly-receipt', 'status': 'DRAFT_FROZEN', 'source_acceptance_claim': False, 'input_commit': prep['input_commit'], 'inputs': len(inputs), 'accepted_declarations': 32, 'blocked_rows': 9, 'distinct_pending_questions': 8, 'skipped_rows': 16, 'validation_receipts_read': len(validations), 'terminal_actual_exit': terminal['exit_code'], 'outputs': outputs, 'limitations': data['limits'], 'final_durable_checkpoint': 'root update pending'})
print(json.dumps({'status': 'DRAFT_FROZEN', 'files': outputs, 'receipt_sha256': hashlib.sha256(Path(native(D / 'final-receipt.json')).read_bytes()).hexdigest()}, ensure_ascii=True))
