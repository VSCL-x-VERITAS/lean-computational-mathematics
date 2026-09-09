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


# Inserted additively into qualified_row_support_v3.py. No execution entry point.
SOURCE_CONTEXT_KEYS = ('source_context_extension', 'inherited_source_interpretation_packet', 'source_context_lineage')
SOURCE_CONTEXT_ROWS = {
    'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE': 'Q7',
    'LEV-CH01-RIEMANN-INTERFACE-FLUX': 'Q7',
    'LEV-CH01-DIMENSIONAL-SPLITTING': 'Q10',
}
INHERITED_RECEIPT = {
    'path': 'gates/leveque-finite-volume/artifacts/session-20260908/user-discontinuity-interpretation-20260908.json',
    'sha256': 'b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030',
}
SOURCE_CONTEXT_PREPARERS = {'f0f27bc5757411a7363fcc70a18c78b2d5bf8011920f9e7c9ee2ebc2013f4ce2': 'prepare-successor-audit-with-source-context.py', 'fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e': 'prepare-successor-audit-with-source-context-long-paths.py', 'ca25290925de0bb5f8d135c82b380077f7ee0e1a015fca7e6f00031d138f8b54': 'prepare-successor-audit-with-dim-module-roots-v2.py', '9346be6b7cddff5ce63aeabc889466f615bf94ef2ae6f660253bbc5def03e5d3': 'prepare-successor-audit-with-package-command-v1.py'}
SOURCE_CONTEXT_RECOVERY = {
    'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/fv-local-domain-review/fv-partial-preparation-recovery.json',
    'sha256': 'c09ae07dfec56808608e51f249e68196bebf78bdd0ce0ffb5009079c6a5c47a7',
}
SOURCE_CONTEXT_SCOPE_RULE = 'The primary claim remains the original selection. Added locations supply explicitly identified inherited context. Preserve each exact user receipt and its original scope; independently assess whether and how that scope applies to the primary claim. Do not enlarge a user answer, attribute it to the printed source, or infer global solution extensions or pointwise representative conventions. The coordinator Q-choice is separately supplied with its different authority. No prior judgment or requested verdict is supplied.'


def source_context_json(path):
    def unique(pairs):
        result = {}
        for key, value in pairs:
            require(key not in result, 'duplicate source-context JSON key: ' + key)
            result[key] = value
        return result
    return json.loads(path.read_text(encoding='utf-8'), object_pairs_hook=unique)


def source_context_ref(item):
    require(isinstance(item, dict) and set(item) == {'path', 'sha256'}, 'expected exact source-context FileRef')
    return bound(item)


def source_context_environment(item, configured, environment):
    path = source_context_ref(item)
    require(configured.count(item['path']) == 1, 'source-context input absent or repeated in exact configuration')
    found = [entry for entry in environment if entry['path'] == item['path']]
    require(len(found) == 1 and found[0]['sha256'] == item['sha256'], 'source-context input not uniquely manifest-bound')
    return path


# A literal user addendum, separate from the coordinator-selected Q10 choice.
HIGH_RESOLUTION_RECEIPT = {
    'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/user-high-resolution-interpretation-20260908.json',
    'sha256': '5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a',
}
HIGH_RESOLUTION_CONTEXT = {
    'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/directional-complete-repair-review/source-context-with-user-high-resolution-v2.json',
    'sha256': '71bd39828c9ba3c9d6dd49d9e84fe5f32c9b446ae830679607b7edfe3d2d2c5d',
}


DIM_INHERITED_HYPERBOLICITY_CONTEXT = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-inherited-hyperbolicity-context/source-context-v3.json', 'sha256': 'd7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206'}
REVIEWED_HIGH_RESOLUTION_CONTEXTS = (HIGH_RESOLUTION_CONTEXT, DIM_INHERITED_HYPERBOLICITY_CONTEXT)


def validate_scoped_context_receipts(request, extension, packet, source, configured, environment):
    """Bind exact literal receipts without changing their authority or judging them."""
    extra_path = HIGH_RESOLUTION_RECEIPT['path']
    has_extra = (extra_path in configured or any(item['path'] == extra_path for item in environment)
                 or any(item.get('path') == extra_path for item in extension['interpretation_receipts']))
    expected = [INHERITED_RECEIPT]
    if has_extra:
        require(request['row'] == 'LEV-CH01-DIMENSIONAL-SPLITTING',
                'the literal high-resolution answer is scoped only to the dimensional-splitting row')
        require(request['source_context_extension'] in REVIEWED_HIGH_RESOLUTION_CONTEXTS,
                'the high-resolution answer requires the exact reviewed extended source context')
        expected.append(HIGH_RESOLUTION_RECEIPT)
    else:
        require(request['source_context_extension'] not in REVIEWED_HIGH_RESOLUTION_CONTEXTS,
                'the literal high-resolution answer cannot be silently omitted from its source context')
    require(extension['interpretation_receipts'] == expected,
            'source context must retain the exact original scoped receipts in their recorded order')
    exact = []
    for item in expected:
        path = source_context_environment(item, configured, environment)
        raw = path.read_bytes()
        receipt = source_context_json(path)
        require(receipt['kind'] == 'explicit user-adopted source interpretation'
                and receipt['source_sha256'] == source['sha256'], 'inherited authority/source mismatch')
        exact.append({'receipt': item, 'exact_receipt_bytes_utf8': raw.decode('utf-8'), 'exact_fields': receipt})
    require(packet['interpretation_receipts'] == exact,
            'literal inherited receipt bytes/fields or original authority/scope changed')
    return expected



DIM_ROOT_PREPARER = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/prepare-successor-audit-with-dim-module-roots-v2.py', 'sha256': 'ca25290925de0bb5f8d135c82b380077f7ee0e1a015fca7e6f00031d138f8b54'}
DIM_ROOT_EXTENSION = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-module-root-preparation/module-root-extension.json', 'sha256': 'dab9569be722bf01499657069396e5f7dd63bccdd29b0f493c3fb94ac6aa881d'}
DIM_ROOT_PLAN = {'format': 'exact-dim-mathlib-module-roots-1', 'proposal': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/five-owner-proposal.json', 'sha256': '7326cc0da682528a8e79630ed1d527a8f5079a640b06a444639549e4254bba8b'}, 'roots': ['.', 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m'], 'modules': [{'module': 'Mathlib.Analysis.Calculus.ContDiff.Defs', 'mirror': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, 'upstream': {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, 'compiled': {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/Defs.olean', 'sha256': 'a66883bdc48c62933798e9de83fe3f9e34cd425866620a273b0d8fa9163f91fa'}, 'bytes': 64851}, {'module': 'Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries', 'mirror': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, 'upstream': {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, 'compiled': {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.olean', 'sha256': 'd46029388be2edef659aae84e84fcbf4a1fadbc1d9e1798b4d499c82988ea28a'}, 'bytes': 50681}], 'literal_receipt': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/user-high-resolution-interpretation-20260908.json', 'sha256': '5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a'}, 'environment_files': [{'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/five-owner-proposal.json', 'sha256': '7326cc0da682528a8e79630ed1d527a8f5079a640b06a444639549e4254bba8b'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/user-high-resolution-interpretation-20260908.json', 'sha256': '5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean', 'sha256': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711'}, {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/Defs.olean', 'sha256': 'a66883bdc48c62933798e9de83fe3f9e34cd425866620a273b0d8fa9163f91fa'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-blind-evidence-repair/m/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, {'path': '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean', 'sha256': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa'}, {'path': '.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.olean', 'sha256': 'd46029388be2edef659aae84e84fcbf4a1fadbc1d9e1798b4d499c82988ea28a'}]}
DIM_ROOT_CONTEXT = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-inherited-hyperbolicity-context/source-context-v3.json', 'sha256': 'd7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206'}

PACKAGE_PREPARER = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/prepare-successor-audit-with-package-command-v1.py', 'sha256': '9346be6b7cddff5ce63aeabc889466f615bf94ef2ae6f660253bbc5def03e5d3'}
PACKAGE_COMPILER_EXTENSION = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-package-runtime-preparation/suite/synthetic-fixture-01/fake-extension.json', 'sha256': '2581e91a5fed319c8656c5df84e1f6b5ae973656d84746ee05f8d28dc045b677'}
PACKAGE_COMPILER_PLAN = {'format': 'exact-package-command-extension-1', 'task_id': 'LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908', 'row_id': 'LEV-CH01-DIMENSIONAL-SPLITTING', 'target_file': 'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean', 'target_declaration': 'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract', 'adapter': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-package-runtime-preparation/suite/synthetic-fixture-01/fake-adapter.py', 'sha256': 'a665e1171d94c107986b146398ca9964faba9bed47b8271b998d54dc9095a62b'}, 'descriptor': {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-package-runtime-preparation/suite/synthetic-fixture-01/fake-descriptor.json', 'sha256': '7690718b992b72e097defb1fbed3f50cd08afbbe7c434ac3b470b59c710122b5'}, 'environment_files': [{'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-package-runtime-preparation/suite/synthetic-fixture-01/fake-environment.txt', 'sha256': '1c55a3d5b01a9522851015b992573ba28cf331a57838a156c8d7da19357cc238'}], 'command': ['python3', '-B', 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-package-runtime-preparation/suite/synthetic-fixture-01/fake-adapter.py', '--descriptor', 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-package-runtime-preparation/suite/synthetic-fixture-01/fake-descriptor.json', '--descriptor-sha256', '7690718b992b72e097defb1fbed3f50cd08afbbe7c434ac3b470b59c710122b5']}

PACKAGE_TASK_ID = 'LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908'
PACKAGE_ROW_ID = 'LEV-CH01-DIMENSIONAL-SPLITTING'
PACKAGE_TARGET = {'path': 'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean',
                  'declaration': 'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'}


def package_require(condition, message):
    if not condition:
        raise ValueError(message)


def package_json(raw):
    def unique(pairs):
        result = {}
        for key, value in pairs:
            package_require(key not in result, 'duplicate compiler-extension JSON key: ' + key)
            result[key] = value
        return result
    return json.loads(raw, object_pairs_hook=unique)


def package_bound_bytes(root, reference):
    package_require(isinstance(reference, dict) and set(reference) == {'path', 'sha256'}, 'invalid compiler FileRef')
    relative, digest = reference['path'], reference['sha256']
    package_require(isinstance(relative, str) and relative and '\\' not in relative and ':' not in relative
                    and all(part not in ('', '.', '..') for part in relative.split('/'))
                    and not Path(relative).is_absolute(), 'invalid compiler relative path')
    package_require(isinstance(digest, str) and len(digest) == 64
                    and all(char in '0123456789abcdef' for char in digest), 'invalid compiler digest')
    path = root / relative
    package_require(path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(root.resolve()),
                    'compiler reference escapes or is not a regular file')
    raw = path.read_bytes()
    package_require(hashlib.sha256(raw).hexdigest() == digest, 'compiler input changed: ' + relative)
    return raw


def package_compiler_inputs(reference, plan):
    result = {}
    for item in [reference, plan['adapter'], plan['descriptor'], *plan['environment_files']]:
        path = item['path']
        package_require(path not in result or result[path] == item, 'conflicting compiler input pin')
        result[path] = item
    return list(result.values())


def load_package_compiler_command(root, spec):
    package_require(spec.get('task_id') == PACKAGE_TASK_ID and spec.get('row_id') == PACKAGE_ROW_ID,
                    'compiler extension is limited to the exact package task and row')
    package_require(spec.get('target') == PACKAGE_TARGET, 'compiler extension target changed')
    package_require(spec.get('compiler_command_extension') == PACKAGE_COMPILER_EXTENSION,
                    'compiler extension pointer changed')
    plan = package_json(package_bound_bytes(root, PACKAGE_COMPILER_EXTENSION))
    package_require(isinstance(plan, dict) and set(plan) == {
        'format', 'task_id', 'row_id', 'target_file', 'target_declaration', 'command',
        'adapter', 'descriptor', 'environment_files'}, 'wrong compiler extension schema')
    package_require(plan == PACKAGE_COMPILER_PLAN, 'compiler extension differs from reviewed exact plan')
    package_require(plan['format'] == 'exact-package-command-extension-1'
                    and plan['task_id'] == PACKAGE_TASK_ID and plan['row_id'] == PACKAGE_ROW_ID
                    and plan['target_file'] == PACKAGE_TARGET['path']
                    and plan['target_declaration'] == PACKAGE_TARGET['declaration'], 'compiler extension identity changed')
    package_bound_bytes(root, plan['adapter'])
    package_bound_bytes(root, plan['descriptor'])
    package_require(plan['command'] == ['python3', '-B', plan['adapter']['path'], '--descriptor',
                                      plan['descriptor']['path'], '--descriptor-sha256', plan['descriptor']['sha256']],
                    'unreviewed compiler command shape')
    refs = plan['environment_files']
    package_require(isinstance(refs, list) and refs, 'compiler environment must be a nonempty FileRef list')
    for item in refs:
        package_bound_bytes(root, item)
    package_require(len({item['path'] for item in refs}) == len(refs), 'duplicate compiler environment path')
    for item in package_compiler_inputs(PACKAGE_COMPILER_EXTENSION, plan):
        package_bound_bytes(root, item)
    return plan


def apply_package_compiler_command(config, plan):
    package_require(config['lean']['command'] == ['lake', 'env', 'lean'], 'prior compiler command must remain exact')
    result = json.loads(json.dumps(config))
    result['lean']['command'] = list(plan['command'])
    return result


def verify_package_compiler_command(root, spec, config, manifested=None, lineage=None):
    plan = load_package_compiler_command(root, spec)
    package_require(config['lean']['command'] == plan['command'], 'configured compiler command differs')
    pins = package_compiler_inputs(PACKAGE_COMPILER_EXTENSION, plan)
    for reference in pins:
        package_require(config['lean']['environment_files'].count(reference['path']) == 1,
                        'compiler input absent or repeated in exact configuration')
        if manifested is not None:
            found = [item for item in manifested['lean_environment'] if item['path'] == reference['path']]
            package_require(len(found) == 1 and found[0]['sha256'] == reference['sha256'],
                            'compiler input not uniquely manifest-bound')
    if lineage is not None:
        package_require(lineage.get('compiler_command_extension') == PACKAGE_COMPILER_EXTENSION
                        and lineage.get('compiler_command') == plan['command']
                        and lineage.get('prior_compiler_command') == ['lake', 'env', 'lean']
                        and lineage.get('compiler_environment_inputs') == pins,
                        'compiler preparation lineage differs')
    return pins

def validate_exact_package_compiler_lineage(request, task, lineage, config, manifest):
    if lineage['preparer_sha256'] != PACKAGE_PREPARER['sha256']:
        return []
    spec = {'task_id': task['task_id'], 'row_id': request['row'], 'target': task['target'],
            'compiler_command_extension': lineage.get('compiler_command_extension')}
    return verify_package_compiler_command(ROOT, spec, config, manifest, lineage)


def validate_exact_dim_module_root_lineage(request, lineage, config, manifest):
    if lineage['preparer_sha256'] not in (DIM_ROOT_PREPARER['sha256'], PACKAGE_PREPARER['sha256']):
        return []
    require(request['row'] == 'LEV-CH01-DIMENSIONAL-SPLITTING', 'DIM root preparer used for another row')
    require(request['source_context_extension'] == DIM_ROOT_CONTEXT, 'DIM root context changed')
    require(lineage.get('module_source_root_extension') == DIM_ROOT_EXTENSION, 'missing or changed exact module-root lineage')
    require(lineage.get('module_source_roots') == DIM_ROOT_PLAN['roots'], 'module-root lineage changed')
    plan_path = source_context_environment(DIM_ROOT_EXTENSION, config['lean']['environment_files'], manifest['lean_environment'])
    require(source_context_json(plan_path) == DIM_ROOT_PLAN, 'module-root plan differs')
    require(config['lean']['module_source_roots'] == DIM_ROOT_PLAN['roots'], 'configured module roots differ')
    for item in DIM_ROOT_PLAN['environment_files']:
        source_context_environment(item, config['lean']['environment_files'], manifest['lean_environment'])
    return [DIM_ROOT_EXTENSION, *DIM_ROOT_PLAN['environment_files']]


def validate_source_context(request, task, manifest, config):
    """Keep appended source context and original literal scoped authority separate.

    The lineage is request-bound provenance, not a judge input or native proof.
    All actual context/receipt/image inputs must have been configured and sealed.
    No prior decision is read and no interpretation-applicability verdict is made.
    """
    present = [key in request for key in SOURCE_CONTEXT_KEYS]
    configured, environment = config['lean']['environment_files'], manifest['lean_environment']
    inherited_name = 'inherited-source-interpretation-packet.json'
    configured_inherited = [p for p in configured if Path(p).name == inherited_name]
    manifested_inherited = [p for p in environment if Path(p['path']).name == inherited_name]
    if not any(present):
        require(not configured_inherited and not manifested_inherited
                and HIGH_RESOLUTION_RECEIPT['path'] not in configured
                and not any(item['path'] == HIGH_RESOLUTION_RECEIPT['path'] for item in environment),
                'configured inherited source context cannot be silently omitted from the request')
        return None
    require(all(present), 'source context requires extension, inherited packet and lineage references together')
    expected_choice = SOURCE_CONTEXT_ROWS.get(request['row'])
    require(expected_choice is not None, 'source-context extension is scoped only to the three Q7/Q10 rows')
    _, selection_map = choices()
    require(selection_map[request['row']]['choice_id'] == expected_choice, 'source-context row/choice mismatch')
    extension_ref, packet_ref, lineage_ref = (request[key] for key in SOURCE_CONTEXT_KEYS)
    extension_path = source_context_environment(extension_ref, configured, environment)
    packet_path = source_context_environment(packet_ref, configured, environment)
    lineage_path = source_context_ref(lineage_ref)
    task_dir = bound(request['task']).parent
    require(packet_path == task_dir/inherited_name and lineage_path == task_dir/'preparation-lineage.json',
            'inherited packet/lineage must belong to the exact audited task')
    extension = source_context_json(extension_path)
    packet = source_context_json(packet_path)
    lineage = source_context_json(lineage_path)
    require(set(extension) == {'format', 'source', 'primary_locations', 'inherited_locations', 'pages', 'images', 'interpretation_receipts'}
            and extension['format'] == 'pinned-source-context-extension-1', 'wrong source-context extension schema')
    require(set(packet) == {'format', 'source', 'source_context_extension', 'primary_locations', 'inherited_locations', 'interpretation_receipts', 'scope_rule'}
            and packet['format'] == 'inherited-source-interpretation-evidence-1', 'wrong inherited packet schema')
    require(packet['source_context_extension'] == extension_ref and packet['scope_rule'] == SOURCE_CONTEXT_SCOPE_RULE,
            'packet changes source-context pointer or authority/scope rule')
    source = {key: task['source'][key] for key in ('path', 'sha256')}
    require(extension['source'] == packet['source'] == source, 'source-context PDF differs from exact task')
    source_context_environment(source, configured, environment)
    require(source['sha256'] == read(SELECTION)['source_sha256'], 'source context changes selected immutable source')
    for key in ('primary_locations', 'inherited_locations'):
        locations = extension[key]
        require(isinstance(locations, list) and locations and packet[key] == locations, 'source locator lists differ')
        for item in locations:
            require(isinstance(item, dict) and set(item) == {'location', 'anchor'} and
                    all(isinstance(x, str) and x.strip() for x in item.values()), 'malformed source locator')
    locations = extension['primary_locations'] + extension['inherited_locations']
    require(len({canonical_sha256(x) for x in locations}) == len(locations), 'duplicate primary/inherited source location')
    require(task['source']['locations'] == locations and manifest['source']['locations'] == locations,
            'task/manifest locator must be exact original primary plus explicit inherited locations')
    require(lineage['source_context_extension'] == extension_ref and
            lineage['inherited_interpretation_sha256'] == packet_ref['sha256'] and
            lineage['selected_interpretation_sha256'] == request['interpretation_packet']['sha256'] and
            lineage['target_sha256'] == manifest['target']['sha256'] and lineage['prior_decisions_reused'] is False,
            'preparation lineage does not bind this exact target and separately supplied packets')
    preparer_name = SOURCE_CONTEXT_PREPARERS.get(lineage['preparer_sha256'])
    require(preparer_name is not None, 'unreviewed source-context preparer')
    preparer = SESSION/'unblock-nine-20260908'/preparer_name
    require(lineage['preparer_sha256'] == sha(preparer), 'source-context preparer changed')
    module_root_provenance = validate_exact_dim_module_root_lineage(request, lineage, config, manifest)
    compiler_provenance = validate_exact_package_compiler_lineage(request, task, lineage, config, manifest)
    prior_id = lineage['prior_task']
    require(isinstance(prior_id, str) and re.fullmatch(r'[A-Za-z0-9-]+', prior_id) and prior_id != task['task_id'],
            'invalid source-locator predecessor identity')
    prior_dir = SESSION/'audits'/prior_id
    prior_manifest_path = prior_dir/'faithfulness/manifest.json'
    require(sha(prior_manifest_path) == lineage['prior_manifest_sha256'], 'source-locator predecessor manifest changed')
    prior_manifest = source_context_json(prior_manifest_path)
    prior_task_path = bound(prior_manifest['task_metadata'])
    require(prior_task_path == prior_dir/'audit-task.json' and prior_manifest['task_id'] == prior_id,
            'source-locator predecessor task binding differs')
    prior_task = source_context_json(prior_task_path)
    require(prior_task['task_id'] == prior_id and prior_task['source']['locations'] == extension['primary_locations'],
            'extension primary locator differs from the exact original task selection')
    require({k: v for k, v in prior_task['source'].items() if k != 'locations'} ==
            {k: v for k, v in task['source'].items() if k != 'locations'}, 'extension changed original source metadata')
    prior_config = base().exact_manifest_config(ROOT, prior_manifest)
    require(sha(prior_config) == lineage['prior_config_sha256'], 'source-locator predecessor configuration differs')
    pages, images = extension['pages'], extension['images']
    require(isinstance(pages, list) and pages and all(type(p) is int and p > 0 for p in pages)
            and len(set(pages)) == len(pages) and isinstance(images, list) and len(images) == len(pages),
            'invalid source page/image list')
    for page, image in zip(pages, images):
        require(isinstance(image, dict) and set(image) == {'page', 'path', 'sha256'} and image['page'] == page,
                'source image/page mismatch')
        image_ref = {key: image[key] for key in ('path', 'sha256')}
        raw = source_context_environment(image_ref, configured, environment).read_bytes()
        require(raw.startswith(b'\x89PNG\r\n\x1a\n'), 'source rendering is not PNG')
    receipt_refs = validate_scoped_context_receipts(request, extension, packet, source, configured, environment)
    refs = {key: request[key] for key in SOURCE_CONTEXT_KEYS}
    provenance = [*refs.values(), source, *receipt_refs,
        {'path': prior_manifest_path.relative_to(ROOT).as_posix(), 'sha256': sha(prior_manifest_path)},
        {'path': prior_task_path.relative_to(ROOT).as_posix(), 'sha256': sha(prior_task_path)},
        {'path': prior_config.relative_to(ROOT).as_posix(), 'sha256': sha(prior_config)},
        {'path': preparer.relative_to(ROOT).as_posix(), 'sha256': sha(preparer)},
        *[{k: item[k] for k in ('path', 'sha256')} for item in images]]
    provenance += module_root_provenance + compiler_provenance
    recovery_ref = lineage.get('partial_recovery_manifest')
    if recovery_ref is not None:
        require(recovery_ref == SOURCE_CONTEXT_RECOVERY, 'unreviewed partial-preparation recovery')
        recovery = source_context_json(source_context_ref(recovery_ref))
        require(recovery['format'] == 'two-file-unsealed-audit-preparation-recovery-1'
                and recovery['task_path'] == task_dir.relative_to(ROOT).as_posix()
                and recovery['failure_stage'] == 'before-released-route'
                and recovery['spec']['sha256'] == lineage['spec_sha256'], 'recovery provenance differs from this preparation')
        require({item['path'] for item in recovery['existing_files']} ==
                {request['task']['path'], request['interpretation_packet']['path']}, 'recovery changed the exact two-file scope')
        provenance += [recovery_ref, recovery['spec'], recovery['preparer_parent'], *recovery['existing_files']]
        for item in provenance:
            bound(item)
    return {'refs': refs, 'extension': extension, 'packet': packet, 'lineage': lineage, 'provenance': provenance}


def append_source_context_contract(contract, context):
    if context is None:
        return contract
    result = json.loads(json.dumps(contract))
    refs, extension, packet = context['refs'], context['extension'], context['packet']
    result['statement'] += (' Separate inherited source-context qualification: extension SHA-256 '
        + refs['source_context_extension']['sha256'] + '; inherited interpretation packet SHA-256 '
        + refs['inherited_source_interpretation_packet']['sha256'] + '; preparation lineage SHA-256 '
        + refs['source_context_lineage']['sha256'] + '. This preserves the original primary claim and '
        'adds only explicitly identified inherited context, not independently audited rows. '
        'The literal user receipt below retains its original scope and authority, separate from '
        'the coordinator-selected Q-choice; applicability belongs to the complete independent audit.')
    result['assumptions'] += ['Inherited context scope rule: ' + packet['scope_rule'],
        'Exact original primary locations: ' + json.dumps(extension['primary_locations'], ensure_ascii=False, sort_keys=True),
        'Exact appended inherited locations: ' + json.dumps(extension['inherited_locations'], ensure_ascii=False, sort_keys=True),
        'Exact source-context extension: ' + json.dumps(extension, ensure_ascii=False, sort_keys=True)]
    for item in packet['interpretation_receipts']:
        result['assumptions'].append('Separate original scoped user receipt SHA-256 ' + item['receipt']['sha256']
            + '; exact UTF-8 receipt content: ' + item['exact_receipt_bytes_utf8'])
    return result



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
    source_context = validate_source_context(request, task, manifest, read(config))
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
    if source_context is not None:
        checked_files += [bound(item) for item in source_context['provenance']]
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
            'refinement': refinement, 'source_context': source_context}


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
    return append_source_context_contract(contract, validated.get('source_context'))


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
    context = validated['source_context']
    if context is not None:
        require(all(row.get(key) == value for key, value in context['refs'].items()),
                'row inherited-source context references differ from the exact audited qualification')
    else:
        require(not any(key in row for key in SOURCE_CONTEXT_KEYS), 'unextended row retains stale inherited source context')
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
