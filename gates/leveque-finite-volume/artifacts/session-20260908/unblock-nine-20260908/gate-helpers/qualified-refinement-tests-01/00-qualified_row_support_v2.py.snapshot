"""Read-only checks shared by the nine-row qualified binder and validator.

No import-time subprocess, audit output read, or gate mutation occurs here.
Run operational entry points through the existing POSIX launcher.
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
SESSION = HERE.parents[1]
ROOT = SESSION.parents[3]
SELECTION = SESSION / 'unblock-nine-20260908/selected-interpretations.json'
SELECTION_SHA = 'cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
CHECKER_SHA = '3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104'
BASE_SHA = '286f9932e8e0e2242bfaa663498e0ac97abea60e0af6fa8cd6b1cdbacfb63694'
ALLOWED_AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}
PAIRS = {'faithful-equivalent': ('yes', 'yes'), 'faithful-stronger': ('yes', 'no')}
DIRECTIONS = ('lean_implies_source', 'source_implies_lean')
BASELINE_SHA = 'ac260c0b09f90012c4474b8f4873b8790515858070892cdff6a98f006a483091'


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    return json.loads(Path(path).read_text(encoding='utf-8-sig'))


def encode(value):
    return (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode()


def canonical_sha256(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':'), ensure_ascii=False).encode()).hexdigest()


def load_module(name, path, expected=None):
    if expected:
        require(sha(path) == expected, 'pinned helper changed: ' + str(path))
    spec = importlib.util.spec_from_file_location(name, path)
    require(spec is not None and spec.loader is not None, 'missing module loader')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def base():
    return load_module('qualified_pinned_base', SESSION / 'bind-audited-stronger-reused-row.py', BASE_SHA)


def repo_path(relative):
    require(isinstance(relative, str) and relative and '\\' not in relative,
            'expected normalized repository-relative path')
    require(not Path(relative).is_absolute() and not re.match(r'^[A-Za-z]:', relative),
            'absolute paths are not file bindings')
    path = (ROOT / relative).resolve()
    require(path.is_relative_to(ROOT.resolve()), 'path escapes repository')
    return path


def bound(item):
    require(isinstance(item, dict), 'missing file binding')
    require(re.fullmatch(r'[0-9a-f]{64}', item.get('sha256', '')) is not None, 'invalid SHA-256')
    path = repo_path(item.get('path'))
    require(path.is_file() and sha(path) == item['sha256'], 'file binding mismatch: ' + str(path))
    return path


def reference(path):
    return {'path': path.resolve().relative_to(ROOT.resolve()).as_posix(), 'sha256': sha(path)}


def runtime_path(value):
    """Resolve native Windows paths recorded by native Lean under POSIX replay."""
    require(isinstance(value, str) and value, 'missing runtime path')
    value = value.replace('\\', '/')
    if re.match(r'^[A-Za-z]:/', value) and os.name != 'nt':
        value = '/' + value[0].lower() + value[2:]
    path = Path(value)
    path = path.resolve() if path.is_absolute() else (ROOT / path).resolve()
    require(path.is_relative_to(ROOT.resolve()), 'runtime path escapes repository')
    return path


def choices():
    require(sha(SELECTION) == SELECTION_SHA, 'coordinator-selection receipt changed')
    selection = read(SELECTION)
    mapping = {row: choice for choice in selection['choices'] for row in choice['rows']}
    require(len(mapping) == 9 and len(selection['choices']) == 8, 'wrong selected row/choice set')
    return selection, mapping


def validate_preserved_rows(gate):
    path = HERE/'protected-baseline.json'
    require(sha(path) == BASELINE_SHA, 'protected baseline changed')
    baseline = read(path)
    rows = {row['id']: row for row in gate['rows']}
    require(len(rows) == len(gate['rows']), 'duplicate gate row IDs')
    expected = set(baseline['selected_rows']) | {row['id'] for row in baseline['closed_rows'] + baseline['skipped_rows']}
    require(set(rows) == expected, 'chapter inventory changed')
    artifact_fields = {prefix + suffix for prefix in ('source_contract', 'blind', 'direct', 'round_trip')
                       for suffix in ('_artifact', '_sha256')}
    strip_refs = lambda row: {key: value for key, value in row.items() if key not in artifact_fields}
    for old in baseline['closed_rows']:
        require(strip_refs(rows[old['id']]) == strip_refs(old), 'historical accepted semantic/audit binding changed: ' + old['id'])
    for old in baseline['skipped_rows']:
        require(rows[old['id']] == old, 'historical skip changed: ' + old['id'])
    return baseline


def gate_checker():
    path = ROOT.parent/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
    return load_module('qualified_current_gate', path, CHECKER_SHA)


def accepted_pair(decision):
    classification = decision.get('classification')
    require(decision.get('accepted') is True and classification in PAIRS,
            'only a genuinely accepted equivalent or stronger decision can close a row')
    pair = tuple(decision['implications'][d]['verdict'] for d in DIRECTIONS)
    require(pair == PAIRS[classification], 'classification and implication pair disagree')
    return classification, pair


def declaration_axioms(text, declaration):
    require(re.search(r'^' + re.escape(declaration) + r'(?:\.\{[^}]*\})?(?:\s|:)', text, re.M),
            'missing exact #check output: ' + declaration)
    escaped = re.escape(declaration)
    reports = re.findall(r"'" + escaped + r"(?:\.\{[^}]*\})?' depends on axioms:\s*\[([^\]]*)\]", text)
    empty = re.findall(r"'" + escaped + r"(?:\.\{[^}]*\})?' does not depend on any axioms", text)
    require(len(reports) + len(empty) == 1, 'expected exactly one axiom report: ' + declaration)
    axioms = {x.strip() for x in reports[0].split(',') if x.strip()} if reports else set()
    require(axioms <= ALLOWED_AXIOMS, 'unexpected axioms: ' + repr(sorted(axioms)))
    return sorted(axioms)


def validate_native(native, task):
    paths = {key: bound(native[key]) for key in ('check', 'output', 'receipt', 'proof_manifest')}
    receipt, proof = read(paths['receipt']), read(paths['proof_manifest'])
    require(type(receipt.get('exit_code')) is int and receipt['exit_code'] == 0, 'native check did not exit zero')
    require(receipt.get('output_sha256') == sha(paths['output']), 'native output hash mismatch')
    check = paths['check'].relative_to(ROOT).as_posix()
    require(paths['check'].suffix == '.lean', 'check input must be Lean source')
    target = task['target']
    matches = [row for row in proof['files'] if row['path'] == target['path']]
    require(len(matches) == 1 and bound(matches[0]) == repo_path(target['path']), 'proof target mismatch')
    require(target['declaration'] in matches[0]['declarations'], 'proof manifest omits target declaration')
    if native['receipt_kind'] == 'snapshots':
        command = receipt.get('command')
        require(isinstance(command, list) and len(command) == 4
                and command[0].lower().endswith('lake.exe') and command[1:3] == ['env', 'lean']
                and runtime_path(command[3]) == paths['check'], 'wrong native snapshot command')
        require(runtime_path(receipt['cwd']) == ROOT.resolve(), 'wrong native working directory')
        require(runtime_path(receipt['output']) == paths['output'], 'native output path mismatch')
        require(receipt.get('inputs_unchanged') is True, 'native inputs changed')
        inputs = {}
        for item in receipt['inputs']:
            path, snapshot = runtime_path(item['path']), runtime_path(item['snapshot'])
            require(path not in inputs, 'duplicate native input')
            require(sha(path) == item['sha256_before'] == item['sha256_after']
                    == item['snapshot_sha256'] == sha(snapshot), 'native input/snapshot binding changed')
            inputs[path] = item['sha256_before']
        require({paths['check'], repo_path(target['path']), ROOT/'lean-toolchain', ROOT/'lake-manifest.json'} <= set(inputs),
                'native receipt must bind check, target and pinned Lean environment')
    elif native['receipt_kind'] == 'argv':
        argv = ['lake', 'env', 'lean', check]
        require(receipt.get('argv') == argv and receipt.get('command') == ' '.join(argv), 'wrong native argv')
        require(isinstance(receipt.get('native_lake'), str) and receipt['native_lake'].lower().endswith('lake.exe'),
                'missing native Lake provenance')
        require(re.fullmatch(r'[0-9a-f]{40}', receipt.get('input_commit', '')) is not None,
                'missing native input commit provenance')
        require(proof.get('check_file_sha256') == sha(paths['check']), 'proof manifest omits exact check hash')
    else:
        raise ValueError('unsupported native receipt kind; derive an explicit successor, do not guess')
    text = paths['output'].read_text(encoding='utf-8-sig')
    require(not re.search(r'\b(?:error|warning):|sorryAx', text), 'native output contains diagnostics or sorryAx')
    lines = paths['check'].read_text(encoding='utf-8-sig').splitlines()
    declarations = native['declarations']
    require(isinstance(declarations, list) and len(declarations) == len(set(declarations))
            and target['declaration'] in declarations, 'native declarations must include exact target')
    result = {}
    for declaration in declarations:
        require('#check ' + declaration in lines and '#print axioms ' + declaration in lines,
                'missing exact check/axiom command: ' + declaration)
        result[declaration] = declaration_axioms(text, declaration)
    return result


def stronger_fields(request, task, decision):
    item = request.get('strengthening_evidence')
    path = bound(item)
    evidence = read(path)
    require(type(evidence.get('schema')) is int and evidence['schema'] == 1 and evidence.get('row') == request['row']
            and evidence.get('task_id') == task['task_id'], 'wrong stronger evidence identity')
    require(evidence['decision'] == request['decision'] and evidence['manifest'] == request['manifest'],
            'stronger evidence must bind this exact decision/manifest')
    require(evidence['applicability_audit'] == decision['implications']['lean_implies_source']['reasoning'],
            'applicability must be the actual independent sealed reasoning')
    require(evidence['genuine_strengthening'] == decision['implications']['source_implies_lean']['reasoning'],
            'strengthening must be the actual independent sealed reasoning')
    require(evidence['remaining_source_uncertainties'] == decision['remaining_uncertainties'],
            'source uncertainties changed')
    checked = validate_native(evidence['native'], task)
    witness = evidence['formal_nonvacuity_declaration']
    require(witness != task['target']['declaration'] and witness in checked, 'missing separate native nonvacuity witness')
    require(isinstance(evidence.get('formal_nonvacuity_scope'), str) and evidence['formal_nonvacuity_scope'].strip(),
            'missing target-premise coverage and witness scope')
    require(isinstance(evidence.get('target_application_review'), str) and evidence['target_application_review'].strip(),
            'missing explicit review of actual target application and all premises')
    review = bound(evidence['witness_review']).read_text(encoding='utf-8-sig')
    require(evidence['target_application_review'] in review and witness in review
            and task['target']['declaration'] in review,
            'native witness applicability requires an exact bound target-specific review, not free prose')
    provenance = f"Decision SHA-256 {request['decision']['sha256']}; strengthening evidence SHA-256 {item['sha256']}."
    return {'strengthening_evidence': item,
            'applicability_audit': evidence['applicability_audit'] + ' ' + provenance,
            'nonvacuity_witness': witness + ': ' + evidence['formal_nonvacuity_scope'] + ' '
                + evidence['target_application_review'] + ' Native input/output/exit and allowed axioms are hash-bound. ' + provenance}



# These are coordinator addenda, never native Lean inputs or literal user replies.
# Changing either exact addendum requires another explicit additive helper version.
REFINEMENTS = {
    'LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION': {
        'choice_id': 'Q9',
        'refinement_id': 'Q9-DECLARED-FIRST-ORDER-MODEL-20260908',
        'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-definition-repair/interpretation-refinement.json',
        'sha256': '8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21',
    },
    'LEV-CH01-NONCONSERVATION-SOURCE-TERMS': {
        'choice_id': 'Q6',
        'refinement_id': 'Q6-FIXED-REPRESENTATIVE-ITERATED-BALANCE-20260908',
        'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-definition-repair/q6-interpretation-refinement.json',
        'sha256': '8658feb83ed55f4c7a4a5c64a95c45313814c44b62573372ea716b5c791e97f3',
    },
}


def validate_refinement(packet, task, manifest, config):
    """Validate an optional exact, separately configured coordinator addendum.

    This is interpretation evidence, not proof evidence. Native checks remain
    independently required by validate_request; JSON need not be in Lean snapshots.
    No prior judgment is used to decide the current audit's accepted relation.
    """
    keys = ('interpretation_refinement_ref', 'interpretation_refinement')
    present = [key in packet for key in keys]
    configured = config['lean']['environment_files']
    environment = manifest['lean_environment']
    known_paths = {item['path'] for item in REFINEMENTS.values()}
    if not any(present):
        require(not any(path in known_paths for path in configured)
                and not any(item['path'] in known_paths for item in environment),
                'configured refinement cannot be silently omitted from the row packet')
        return None
    require(all(present), 'refinement requires both pointer and exact embedded content')
    expected = REFINEMENTS.get(packet['scope_row'])
    require(expected is not None, 'refinement is permitted only for the precise Q6/Q9 row pairing')
    item, refinement = (packet[key] for key in keys)
    expected_ref = {key: expected[key] for key in ('path', 'sha256')}
    require(isinstance(item, dict) and set(item) == {'path', 'sha256'}
            and item == expected_ref, 'refinement is not the exact pinned row addendum')
    path = bound(item)
    require(refinement == read(path), 'embedded refinement differs from its exact bound JSON')
    require(configured.count(item['path']) == 1, 'addendum is absent or duplicated in exact configuration')
    matches = [entry for entry in environment if entry['path'] == item['path']]
    require(len(matches) == 1 and matches[0]['sha256'] == item['sha256'],
            'addendum is not an exact unique manifest-bound environment input')
    require(not any(other in configured or any(entry['path'] == other for entry in environment)
                    for other in known_paths - {item['path']}),
            'a differently scoped refinement cannot enter this row environment')
    selection, mapping = choices()
    require(refinement['format'] == 'coordinator-selected-interpretation-refinement-1'
            and refinement['status'] == 'selected-for-fresh-independent-audit'
            and refinement['refinement_id'] == expected['refinement_id'], 'wrong refinement schema or identity')
    require(refinement['scope_row'] == packet['scope_row']
            and refinement['prior_choice_id'] == expected['choice_id']
            and refinement['prior_choice_exact'] == packet['choice'] == mapping[packet['scope_row']],
            'refinement row/choice differs from the original pinned selection')
    require(refinement['prior_selection_receipt'] == packet['selection_receipt'] == reference(SELECTION),
            'refinement changes the original selection receipt')
    for key in ('authority', 'exact_user_objective', 'goal_observation_sha256', 'preservation'):
        require(refinement[key] == packet[key] == selection[key],
                'refinement changes coordinator attribution or preservation: ' + key)
    require(refinement['source'] == task['source']
            and refinement['source']['sha256'] == selection['source_sha256']
            and bound(refinement['source']) == repo_path(task['source']['path']),
            'refinement source differs from the exact selected source and locator')
    require(refinement['unchanged_target'] == {**task['target'], 'sha256': sha(repo_path(task['target']['path']))}
            and bound(refinement['unchanged_target']) == repo_path(task['target']['path']),
            'refinement target/declaration differs from the exact checked target')
    model = refinement['selected_model']
    require(isinstance(model, dict) and model
            and all(isinstance(k, str) and k.strip() and isinstance(v, str) and v.strip()
                    for k, v in model.items()), 'missing precise mathematical model clauses')
    ambiguities = refinement['source_ambiguities_preserved']
    require(isinstance(ambiguities, list) and ambiguities
            and all(isinstance(value, str) and value.strip() for value in ambiguities),
            'missing explicit preserved source ambiguities')
    for key in ('coordinator_authorization', 'required_audit_qualification', 'independence'):
        require(isinstance(refinement[key], str) and refinement[key].strip(), 'missing refinement qualification: ' + key)
    require(refinement['no_production_or_native_supplement_change'] is True,
            'this helper supports only the reviewed unchanged-target refinements')
    # Historical references are provenance, never acceptance or proof substitutes.
    for key in ('prior_task', 'prior_undetermined_decision'):
        bound(refinement[key])
    if 'defining_dependency' in refinement:
        for key in ('owner', 'dossier'):
            bound(refinement['defining_dependency'][key])
    return {'reference': item, 'content': refinement}


def validate_interpretation_qualification(decision, choice_id):
    """Recognize explicit qualification without imposing a sealed finding category.

    This is a conservative textual guard, not a new semantic judgment. Complete
    sealed acceptance, exact choice inputs, and all other checks remain mandatory.
    """
    if any('interpretation-qualified' in finding.get('category', '') for finding in decision['findings']):
        return 'explicit-finding-category'
    rationale = decision.get('rationale', '')
    prefix = 'under the recorded coordinator-selected interpretation'
    require(isinstance(rationale, str) and 'interpretation-qualified' in rationale.lower()
            and re.search(r'\b' + re.escape(choice_id) + r'\b', rationale) is not None
            and all(isinstance(decision['implications'][direction].get('reasoning'), str)
                    and decision['implications'][direction]['reasoning'].strip().lower().startswith(prefix)
                    for direction in DIRECTIONS),
            'complete decision lacks explicit interpretation qualification in category or rationale and both implications')
    return 'explicit-rationale-and-both-implications'


def validate_request(request_path, complete=False):
    request = read(request_path)
    require(type(request.get('schema')) is int and request['schema'] == 1, 'wrong binding request schema')
    selection, mapping = choices()
    row_id = request['row']
    require(row_id in mapping and request['status'] in ('PROVED', 'REUSED'), 'unsupported row or status')
    paths = {key: bound(request[key]) for key in ('task', 'manifest', 'decision', 'interpretation_packet')}
    task, manifest, decision = read(paths['task']), read(paths['manifest']), read(paths['decision'])
    out = repo_path(task['audit_output'])
    require(paths['task'] == SESSION/'audits'/task['task_id']/'audit-task.json'
            and out == paths['task'].parent/'faithfulness', 'audit paths do not match task')
    require(paths['manifest'] == out/'manifest.json' and paths['decision'] == out/'decision.json', 'wrong audit outputs')
    require(task['task_id'] == manifest['task_id'] == decision['task_id'], 'task identity mismatch')
    require(bound(manifest['task_metadata']) == paths['task'], 'manifest task metadata mismatch')
    require(manifest['target']['declaration'] == task['target']['declaration']
            and bound(manifest['target']) == repo_path(task['target']['path']), 'exact current target mismatch')
    require(task['source']['sha256'] == selection['source_sha256'] == sha(repo_path(task['source']['path'])), 'pinned source mismatch')
    classification, pair = accepted_pair(decision)
    config = base().exact_manifest_config(ROOT, manifest)
    environment = {item['path']: item['sha256'] for item in manifest['lean_environment']}
    for item in manifest['lean_environment']:
        bound(item)
    for p in (SELECTION, paths['interpretation_packet']):
        rel = p.relative_to(ROOT).as_posix()
        require(environment.get(rel) == sha(p) and rel in read(config)['lean']['environment_files'],
                'interpretation was not an exact configured, manifest-bound audit input')
    packet = read(paths['interpretation_packet'])
    require(paths['interpretation_packet'] == paths['task'].parent/'user-interpretation-packet.json'
            and packet['format'] == 'coordinator-selected-source-interpretation-1'
            and packet['scope_row'] == row_id and packet['choice'] == mapping[row_id], 'wrong row interpretation')
    for key in ('authority', 'exact_user_objective', 'goal_observation_sha256', 'preservation'):
        require(packet[key] == selection[key], 'choice attribution/preservation changed: ' + key)
    require(packet['selection_receipt'] == reference(SELECTION)
            and packet['source_sha256'] == selection['source_sha256'], 'choice receipt/source mismatch')
    refinement = validate_refinement(packet, task, manifest, read(config))
    validate_interpretation_qualification(decision, packet['choice']['choice_id'])
    axioms = validate_native(request['native'], task)
    fields = stronger_fields(request, task, decision) if classification == 'faithful-stronger' else {}
    if classification == 'faithful-equivalent':
        require('strengthening_evidence' not in request, 'equivalent request must not hide a stronger classification')
    checked_files = [out/'decision.json', out/'manifest.json', out/'report.md'] + [
        out/'agent_outputs'/name for name in ('source_contract.json', 'blind_translation.json',
        'direct_judge.json', 'roundtrip_judge.json', 'agent_runs.json')]
    if decision.get('adjudicated') is True:
        checked_files.append(out/'agent_outputs/adjudicator.json')
    if refinement is not None:
        checked_files += [bound(refinement['reference']), paths['interpretation_packet'], SELECTION]
    audit_hashes = {str(path): sha(path) for path in checked_files}
    if complete:
        require(os.name != 'nt', 'run released validators through the existing POSIX launcher')
        env = dict(os.environ, FAITHFULNESS_AUDIT_CONFIG=str(config))
        subprocess.run([sys.executable, '-B', str(ROOT/'.faithfulness-audit/scripts/validate_audit.py'),
                        str(paths['task']), '--phase', 'complete'], cwd=ROOT, env=env, check=True)
        require(all(sha(path) == digest for path, digest in audit_hashes.items()), 'audit outputs changed during complete validation')
    return {'request': request, 'task': task, 'manifest': manifest, 'decision': decision,
            'config': config, 'classification': classification, 'pair': pair,
            'packet': packet, 'fields': fields, 'axioms': axioms, 'output': out, 'audit_hashes': audit_hashes,
            'refinement': refinement}


def contract_for(validated):
    request, packet = validated['request'], validated['packet']
    source_path = validated['output']/'agent_outputs/source_contract.json'
    source = read(source_path)
    prefix = ('This contract is audited only under the coordinator-selected interpretation under the broad user objective; '
              'it is not a literal detailed user reply or a printed-source hypothesis. Choice '
              + packet['choice']['choice_id'] + ', selection SHA-256 ' + SELECTION_SHA
              + ', row packet SHA-256 ' + request['interpretation_packet']['sha256']
              + '. Original source-only contract SHA-256 ' + sha(source_path) + '. Original source account: ')
    contract = {'statement': prefix + source['contract_plain_english'],
            'assumptions': source['statement']['hypotheses'] + source['statement']['implicit_context']
                + ['Coordinator-selected interpretation: ' + packet['choice']['selected_interpretation']]
                + ['Preserved limitation: ' + item for item in packet['preservation']],
            'quantifiers': source['statement']['binders']}
    refinement = validated.get('refinement')
    if refinement is not None:
        content, digest = refinement['content'], refinement['reference']['sha256']
        contract['statement'] += (' Coordinator-selected refinement ' + content['refinement_id']
            + ', SHA-256 ' + digest + ': its exact model clauses and preserved source ambiguities below '
            'are part of this qualified contract, not additional printed-source assertions or literal user replies.')
        contract['assumptions'] += ['Coordinator-selected refinement SHA-256: ' + digest]
        contract['assumptions'] += ['Selected model [' + key + ']: ' + value
                                    for key, value in content['selected_model'].items()]
        contract['assumptions'] += ['Preserved source ambiguity: ' + value
                                    for value in content['source_ambiguities_preserved']]
    return contract


def validate_bound_row(row, complete=False):
    request_path = bound(row.get('qualified_binding_request'))
    validated = validate_request(request_path, complete=complete)
    request, task, decision = validated['request'], validated['task'], validated['decision']
    require(row['id'] == request['row'] and row['status'] == request['status'], 'bound row/request identity mismatch')
    require(row['faithfulness_task'] == request['task']['path']
            and row['faithfulness_decision'] == request['decision']['path']
            and row['lean_declarations'] == [task['target']['declaration']], 'bound row audit/target mismatch')
    require(row['classification'] == validated['classification']
            and tuple(row[d] for d in DIRECTIONS) == validated['pair'], 'row changes accepted relation strength')
    require(row['coordinator_selected_interpretation'] == request['interpretation_packet'], 'row choice binding mismatch')
    require(row['native_evidence'] == request['native'], 'row native binding mismatch')
    refinement = validated['refinement']
    if refinement is not None:
        require(row.get('interpretation_refinement_ref') == refinement['reference'],
                'row refinement reference differs from its exact audited packet')
    else:
        require('interpretation_refinement_ref' not in row, 'unrefined row retains a stale refinement reference')
    for key, value in validated['fields'].items():
        require(row.get(key) == value, 'stronger row evidence mismatch: ' + key)
    if validated['classification'] == 'faithful-equivalent':
        require(not any(key in row for key in ('strengthening_evidence', 'applicability_audit', 'nonvacuity_witness')),
                'equivalent row retains stale strengthening fields')
    if decision.get('adjudicated') is True:
        require(row.get('adjudication_required') is True and row.get('adjudication_status') == 'resolved',
                'required adjudication not resolved')
    else:
        require(row.get('adjudication_required') is False and not row.get('adjudication_status')
                and not row.get('adjudication_audit'), 'do not invent adjudication for an agreeing audit')
    require(row['contract_hash'] == canonical_sha256(contract_for(validated)), 'qualified contract changed')
    return validated
