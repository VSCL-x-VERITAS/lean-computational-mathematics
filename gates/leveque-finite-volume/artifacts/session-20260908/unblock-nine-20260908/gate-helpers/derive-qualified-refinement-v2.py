"""Additive local derivation only. Never invokes an operational entry point."""
from pathlib import Path
import difflib
import hashlib
import json

HERE = Path(__file__).resolve().parent
PINS = {
    'qualified_row_support.py': '82088e95adecfc729cff50c3ed04853441cffc3f589b021b6ffddc10d73339c3',
    'bind-qualified-row.py': 'c03568be771a719ae2b997e00d554deaa7c64e0e2f8a1256e4b514c72b067a35',
    'validate-closed-row-audits-v4.py': 'df33ad0a44d4197f933314d8c7764eae66c683f040147606d8096f89701827dc',
}


def create(name, text):
    payload = text.encode('utf-8')
    with (HERE/name).open('xb') as handle:
        handle.write(payload)
    return hashlib.sha256(payload).hexdigest()


def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old, new, 1)


def main():
    originals = {}
    for name, digest in PINS.items():
        raw = (HERE/name).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == digest, name
        originals[name] = raw.decode().replace('\r\n', '\n')
    support = originals['qualified_row_support.py']
    marker = '\n\ndef validate_request(request_path, complete=False):'
    addition = r'''


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
'''
    support = replace_once(support, marker, addition + marker)
    support = replace_once(support,
        "    require(any('interpretation-qualified' in f.get('category', '') for f in decision['findings']),",
        "    refinement = validate_refinement(packet, task, manifest, read(config))\n"
        "    require(any('interpretation-qualified' in f.get('category', '') for f in decision['findings']),")
    support = replace_once(support,
        "            'packet': packet, 'fields': fields, 'axioms': axioms, 'output': out, 'audit_hashes': audit_hashes}",
        "            'packet': packet, 'fields': fields, 'axioms': axioms, 'output': out, 'audit_hashes': audit_hashes,\n"
        "            'refinement': refinement}")
    support = replace_once(support,
        "    return {'statement': prefix + source['contract_plain_english'],",
        "    contract = {'statement': prefix + source['contract_plain_english'],")
    support = replace_once(support,
        "            'quantifiers': source['statement']['binders']}\n\n\ndef validate_bound_row",
        "            'quantifiers': source['statement']['binders']}\n"
        "    refinement = validated.get('refinement')\n"
        "    if refinement is not None:\n"
        "        content, digest = refinement['content'], refinement['reference']['sha256']\n"
        "        contract['statement'] += (' Coordinator-selected refinement ' + content['refinement_id']\n"
        "            + ', SHA-256 ' + digest + ': its exact model clauses and preserved source ambiguities below '\n"
        "            'are part of this qualified contract, not additional printed-source assertions or literal user replies.')\n"
        "        contract['assumptions'] += ['Coordinator-selected refinement SHA-256: ' + digest]\n"
        "        contract['assumptions'] += ['Selected model [' + key + ']: ' + value\n"
        "                                    for key, value in content['selected_model'].items()]\n"
        "        contract['assumptions'] += ['Preserved source ambiguity: ' + value\n"
        "                                    for value in content['source_ambiguities_preserved']]\n"
        "    return contract\n\n\ndef validate_bound_row")
    support = replace_once(support,
        "    require(row['native_evidence'] == request['native'], 'row native binding mismatch')",
        "    require(row['native_evidence'] == request['native'], 'row native binding mismatch')\n"
        "    refinement = validated['refinement']\n"
        "    if refinement is not None:\n"
        "        require(row.get('interpretation_refinement_ref') == refinement['reference'],\n"
        "                'row refinement reference differs from its exact audited packet')\n"
        "    else:\n"
        "        require('interpretation_refinement_ref' not in row, 'unrefined row retains a stale refinement reference')")
    binder = replace_once(originals['bind-qualified-row.py'], 'import qualified_row_support as q',
                          'import qualified_row_support_v2 as q')
    binder = replace_once(binder, "                'reuse_source', 'reuse_audit'):",
                          "                'reuse_source', 'reuse_audit', 'interpretation_refinement_ref'):")
    binder = replace_once(binder,
        "                'adjudication_required': decision.get('adjudicated') is True})",
        "                'adjudication_required': decision.get('adjudicated') is True})\n"
        "    if v['refinement'] is not None:\n"
        "        row['interpretation_refinement_ref'] = v['refinement']['reference']")
    validator = replace_once(originals['validate-closed-row-audits-v4.py'],
        'import qualified_row_support as qualified', 'import qualified_row_support_v2 as qualified')
    validator = replace_once(validator,
        "            record['native_axioms'] = checked['axioms']",
        "            record['native_axioms'] = checked['axioms']\n"
        "            if checked['refinement'] is not None:\n"
        "                record['interpretation_refinement_ref'] = checked['refinement']['reference']")
    outputs = {}
    for old, new, text in [
        ('qualified_row_support.py', 'qualified_row_support_v2.py', support),
        ('bind-qualified-row.py', 'bind-qualified-row-v2.py', binder),
        ('validate-closed-row-audits-v4.py', 'validate-closed-row-audits-v5.py', validator),
    ]:
        outputs[new] = create(new, text)
        diff = ''.join(difflib.unified_diff(originals[old].splitlines(True), text.splitlines(True), fromfile=old, tofile=new))
        outputs[new + '.derivation.diff'] = create(new + '.derivation.diff', diff)
    outputs['derive-qualified-refinement-v2.py'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    create('qualified-refinement-v2-derivation.json', json.dumps({'schema': 1, 'inputs': PINS, 'outputs': outputs,
        'operational_entry_points_invoked': False}, indent=2) + '\n')
    print(json.dumps({'status': 'DERIVED_ONLY', 'outputs': outputs}, indent=2))


if __name__ == '__main__':
    main()
