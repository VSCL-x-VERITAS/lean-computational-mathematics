"""Actual draft verification and pure negative guards; no candidate/epoch operations."""
import ast
import copy
import json
from pathlib import Path
from unittest.mock import patch
import prepare_mapping_catalogue as p
import emit_reviewed_mapping as e

HERE = Path(__file__).resolve().parent
R = HERE.parent.parents[4]


def main():
    tests = []
    def passed(name): tests.append(name)
    def rejected(name, action):
        try: action()
        except (ValueError, KeyError, TypeError): passed(name)
        else: raise AssertionError(name + ' was not rejected')
    for name in ('prepare_mapping_catalogue.py', 'emit_reviewed_mapping.py', 'test_mapping_preparation.py'):
        ast.parse((HERE/name).read_text()); passed('syntax ' + name)
    spec = p.read(HERE/'baseline-spec.json')
    actual = p.read(HERE/'baseline-catalogue.json')
    rebuilt = p.catalogue(R, spec)
    assert {k: v for k, v in actual.items() if k != 'input_spec'} == rebuilt
    passed('actual complete baseline catalogue reconstructs exactly')
    assert len(actual['assets']) == 1582 and all(x['assets'] == 791 and x['unique_obligations'] == 697 for x in actual['lanes'])
    passed('both actual 791-asset / 697-retained origin occurrences covered')
    grouped = {}
    for asset in actual['assets']:
        grouped.setdefault((asset['kind'], asset['stable_key']), []).append(asset)
    assert all(len(pair) == 2 for pair in grouped.values())
    assert all(pair[0]['origin_content_sha256'] == pair[1]['origin_content_sha256'] for pair in grouped.values())
    passed('all same-5e3 origin objects compared by exact content with distinct occurrences')
    assert all(a['proposed_disposition'] == 'retained-unresolved' for a in actual['assets'] if a['lane_id'] != actual['merge_lane'])
    passed('every inspection occurrence retained without candidate certificate')
    eq3 = [a for a in actual['assets'] if a['kind'] == 'declaration' and 'preserved_payloads' in a]
    assert len(eq3) == 4 and len({a['concept_id'] for a in eq3}) == 1
    assert len({a['producer_payload_id'] for a in eq3}) == len({a['policy_payload_id'] for a in eq3}) == 2
    passed('Eq1.3 common concept retains distinct old/new producer and policy identities')
    for asset in eq3:
        for kind in ('producer', 'policy'):
            raw = p.read(p.bound(R, asset['preserved_payloads'][kind + '_payload']))
            assert p.sha(p.canonical(raw)) == asset[kind + '_payload_id']
    passed('Eq1.3 five-hash transport producer/policy payloads reused exactly')
    assert sum(bool(w['selected_source_rows']) for w in actual['source_wrappers']) == 64
    passed('all 32 selected source wrappers per origin explicitly associated')
    assert all(a['certificate_role'].startswith('origin provenance only') for a in actual['assets'] if a['kind'] == 'audit')
    passed('all 116 audit occurrences marked origin provenance only')
    altered = copy.deepcopy(spec); altered['stage'] = 'final-origin-review-draft'
    rejected('pending final head cannot be promoted', lambda: p.catalogue(R, altered))
    altered['final_committed_head'] = actual['lanes'][0]['head']
    rejected('open merge baseline cannot be promoted despite real head', lambda: p.catalogue(R, altered))
    changed = copy.deepcopy(spec); changed['lanes'][0]['inventory']['sha256'] = '0' * 64
    rejected('wrong inventory hash', lambda: p.catalogue(R, changed))
    changed = copy.deepcopy(spec); changed['lanes'][0]['fingerprints'] = []
    rejected('omitted native input', lambda: p.catalogue(R, changed))
    changed = copy.deepcopy(spec); changed['lanes'][1]['lane_id'] = changed['lanes'][0]['lane_id']
    rejected('duplicate lane', lambda: p.catalogue(R, changed))
    changed = copy.deepcopy(spec); changed['declaration_overrides'][0]['producer_payload'] = changed['declaration_overrides'][1]['producer_payload']
    rejected('old Eq1.3 producer cannot be replaced with new native identity', lambda: p.catalogue(R, changed))
    changed = copy.deepcopy(spec); changed['merge_lane'] = 'not-a-lane'
    rejected('invented merge lane', lambda: p.catalogue(R, changed))
    before = p.sha(p.canonical(e.semantics(actual)))
    changed = copy.deepcopy(actual); changed['assets'][0]['origin_head'] = '0' * 40
    assert p.sha(p.canonical(e.semantics(changed))) == before
    passed('review surface avoids commit self-reference; final inventory independently binds head')
    changed = copy.deepcopy(actual); changed['assets'][0]['concept_id'] += '-changed'
    assert p.sha(p.canonical(e.semantics(changed))) != before
    passed('concept mutation changes reviewed semantic map hash')
    changed = copy.deepcopy(actual); next(a for a in changed['assets'] if a['kind'] == 'declaration')['policy_payload_id'] = '0' * 64
    assert p.sha(p.canonical(e.semantics(changed))) != before
    passed('policy mutation changes reviewed semantic map hash')
    e.validate_nondeclaration_groups(actual)
    passed('actual same-content nondeclaration groups are admissible')
    changed = copy.deepcopy(actual)
    changed['assets'][0]['origin_content_sha256'] = '0' * 64
    rejected('same-key changed gate cannot be mislabeled identical by missing controlled fields', lambda: e.validate_nondeclaration_groups(changed))
    changed['assets'][0]['concept_id'] += '-origin-provenance-variant'
    e.validate_nondeclaration_groups(changed)
    passed('explicit separately reviewed provenance concept permits honest retention without equivalence')
    # Synthetic review only in memory. Never written or used operationally.
    synthetic = {'schema': 1, 'status': 'reviewed-for-structural-preparation', 'source_acceptance': False,
                 'review': 'Synthetic test double, not actual review.', 'evidence': [{'path': 'x', 'sha256': '0' * 64}],
                 'mapping_semantics_sha256': before}
    def read(path): return actual if path == Path('catalogue') else synthetic
    with patch.object(p, 'bound', side_effect=lambda root, ref: Path(ref['path'])), patch.object(p, 'read', side_effect=read):
        fixture_spec = {'catalogue': {'path': 'catalogue'}, 'review': {'path': 'review'}}
        assert e.reviewed(R, fixture_spec)[0] == actual
        passed('synthetic externally supplied exact review surface recognized')
        rejected('actual baseline rejected before candidate mapping even with synthetic review', lambda: e.mapping(R, fixture_spec))
        original = synthetic['mapping_semantics_sha256']; synthetic['mapping_semantics_sha256'] = '0' * 64
        rejected('mutated review digest', lambda: e.reviewed(R, fixture_spec))
        synthetic['mapping_semantics_sha256'] = original; synthetic['source_acceptance'] = True
        rejected('structural review cannot invent source acceptance', lambda: e.reviewed(R, fixture_spec))
        synthetic['source_acceptance'] = False; synthetic['evidence'] = []
        rejected('missing actual review evidence', lambda: e.reviewed(R, fixture_spec))
    surface = {'schema': 1,
        'catalogue': p.reference(R, HERE/'baseline-catalogue.json'),
        'mapping_semantics_sha256': before, 'status': 'DRAFT_AWAITING_ROOT_REVIEW',
        'source_acceptance': False, 'semantics': e.semantics(actual)}
    surface_path = HERE/'mapping-review-surface.json'
    if surface_path.exists():
        assert p.read(surface_path) == surface
    else:
        p.create(surface_path, surface)
    print(json.dumps({'status': 'PASS_LOCAL_GUARDS_ONLY', 'count': len(tests), 'tests': tests,
                      'candidate_or_epoch_created': False, 'source_acceptance': False,
                      'semantic_review_surface_sha256': before}, indent=2))


if __name__ == '__main__': main()
