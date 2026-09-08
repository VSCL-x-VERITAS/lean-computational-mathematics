"""Read frozen evidence; write this independent review's new report only."""
from pathlib import Path
from hashlib import sha256
from collections import Counter
import datetime
import json
import re

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
CART = SESSION / 'cartesian-coordinate-line-composition-draft'
PROS = SESSION / 'prospective-density-material-riemann-capstones-draft'
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}
BINDINGS = []

def digest(path):
    return sha256(path.read_bytes()).hexdigest()

def read(path):
    return json.loads(path.read_text(encoding='utf-8'))

def resolve(path):
    value = Path(path)
    return value if value.is_absolute() else REPO / value

def bind(path, expected, origin):
    path = resolve(path)
    actual = digest(path)
    BINDINGS.append(dict(path=str(path), expected=expected, actual=actual, origin=origin))
    assert actual == expected, (origin, str(path), expected, actual)

def pairs(value, origin):
    if isinstance(value, dict):
        if isinstance(value.get('path'), str) and isinstance(value.get('sha256'), str):
            bind(value['path'], value['sha256'], origin)
            if 'bytes' in value:
                assert resolve(value['path']).stat().st_size == value['bytes'], origin
        for key, child in value.items():
            pairs(child, origin + '/' + key)
    elif isinstance(value, list):
        for index, child in enumerate(value):
            pairs(child, origin + '/' + str(index))

def canonical(name):
    # Lean pp.universes/pp.all may display declaration or axiom universe arguments.
    return re.sub(r'\.\{[^}]*\}', '', name.strip())

def axioms(output):
    pattern = r"^'([^'\n]+)'\s+(?:depends on axioms:\s*\[([^]]*)\]|does not depend on any axioms)"
    result = []
    for match in re.finditer(pattern, output, re.M):
        shown = match.group(1)
        deps = [canonical(x) for x in (match.group(2) or '').split(',') if x.strip()]
        result.append(dict(declaration=canonical(shown), displayed_declaration=shown,
                           axioms=deps, empty=not deps,
                           universe_displayed='.{ ' in shown or '.{' in shown))
    return result

def check_native(source, output, count):
    body = output.read_text(encoding='utf-8')
    source_body = source.read_text(encoding='utf-8')
    requests = re.findall(r'^#print axioms\s+(\S+)', source_body, re.M)
    reports = axioms(body)
    assert len(reports) == count, (str(output), len(reports), count)
    assert Counter(canonical(x) for x in requests) == Counter(x['declaration'] for x in reports)
    assert all(set(x['axioms']) <= ALLOWED for x in reports)
    assert not re.search(r'error:|warning:|sorryAx', body)
    return dict(source=str(source), output=str(output), reports=reports,
                report_count=len(reports), empty_reports=sum(x['empty'] for x in reports),
                universe_displayed_reports=sum(x['universe_displayed'] for x in reports),
                all_requested_axiom_reports_present=True, no_errors_warnings_or_sorry=True)

def check_cartesian():
    top = CART / 'final-receipt.json'
    bind(top, 'd8c42c4fff819da6d6d28674fd96192a40937449a290a5bb2aa4e3301f17f302', 'parent/cartesian')
    receipt = read(top)
    pairs(receipt, 'cartesian/final-receipt')
    provenance = read(CART / 'reuse-provenance.json')
    pairs(provenance, 'cartesian/reuse-provenance')
    for search in provenance['searches']:
        bind(CART / search['output'], search['output_sha256'], 'cartesian/search')
    final = read(CART / 'final03-exit.json')
    for key in ('input_files', 'compiled_imports'):
        for path, expected in final[key].items():
            bind(path, expected, 'cartesian/native-final/' + key)
    assert final['exit_code'] == receipt['native_exit_code'] == 0
    assert final['inputs_unchanged'] and final['exact_frozen_base']
    base = SESSION / 'dimensional-splitting-lines-draft/final-05-input.lean'
    fragment = CART / 'Composition.lean.fragment'
    names = ['NumStability.CartesianLineCompositionDraft.' + x for x in
             re.findall(r'^(?:noncomputable )?(?:def|theorem)\s+(\w+)', fragment.read_text(encoding='utf-8'), re.M)]
    assert names == final['checked_declarations'] and len(names) == 24
    prefix = b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep\n\n'
    checks = '\n'.join(f'#check {x}\n#print axioms {x}' for x in names).encode()
    assembled = prefix + base.read_bytes() + b'\n\n' + fragment.read_bytes() + b'\n\n' + checks + b'\n'
    assert assembled == (CART / 'final03-input.lean').read_bytes()
    native = check_native(CART / 'final03-input.lean', CART / 'final03-output.txt', 48)
    subset = {x['declaration']: x['axioms'] for x in native['reports'] if x['declaration'] in names}
    assert subset == receipt['actual_axioms']
    attempts = []
    for label, expected_exit in [('attempt01', 1), ('attempt02', 1), ('final03', 0)]:
        rec = read(CART / (label + '-exit.json'))
        bind(CART / (label + '-input.lean'), rec['assembled_input_sha256'], 'cartesian/attempt-input')
        bind(CART / (label + '-output.txt'), rec['output_sha256'], 'cartesian/attempt-output')
        assert rec['exit_code'] == expected_exit
        attempts.append(dict(label=label, exit_code=rec['exit_code'], input_retained=True))
    return dict(native=native, new_declarations=24, frozen_base_declarations=24,
                exact_assembled_input=True, attempts=attempts)

def local_closure(source):
    pending = re.findall(r'^import (ComputationalMathematics\.[\w.]+)', source.read_text(encoding='utf-8'), re.M)
    seen = set()
    while pending:
        module = pending.pop()
        if module in seen:
            continue
        seen.add(module)
        path = REPO / (module.replace('.', '/') + '.lean')
        pending += re.findall(r'^import (ComputationalMathematics\.[\w.]+)', path.read_text(encoding='utf-8'), re.M)
    return seen

def check_prospective():
    top = PROS / 'evidence-manifest.json'
    bind(top, '02cba5390c9248dd8888cae8c931969d88cd73217c33caf24437b80e51aae939', 'parent/prospective')
    manifest = read(top)
    pairs(manifest, 'prospective/evidence-manifest')
    assert local_closure(PROS / 'Capstones.lean') == {x['module'] for x in manifest['canonical_import_closure']}
    questions = read(resolve(manifest['question_provenance']['path']))['clarification_calls']
    assert all(q in questions for q in manifest['precise_unanswered_questions'])
    for audit in manifest['frozen_audits']:
        decision = read(resolve(audit['decision']['path']))
        assert decision['classification'] == audit['frozen_classification']
        assert decision['accepted'] == audit['frozen_accepted'] == False
    finals = []
    for label, count in [('capstones-final-03', 11), ('measure-final-02', 8)]:
        receipt = read(PROS / (label + '.receipt.json'))
        assert receipt['exit_code'] == 0 and receipt['source_unchanged'] and not receipt['contains_sorryAx']
        for namekey, hashkey in [('source', 'source_sha256_before'), ('source', 'source_sha256_after'),
                                 ('output', 'output_sha256'), ('compiled', 'compiled_sha256')]:
            bind(PROS / receipt[namekey], receipt[hashkey], 'prospective/' + label + '/' + hashkey)
        bind(REPO / 'lean-toolchain', receipt['lean_toolchain_sha256'], 'prospective/runtime')
        bind(REPO / 'lake-manifest.json', receipt['lake_manifest_sha256'], 'prospective/runtime')
        native = check_native(PROS / receipt['source'], PROS / receipt['output'], count)
        assert [{k: row[k] for k in ('declaration', 'axioms')} for row in native['reports']] == receipt['axiom_reports']
        finals.append(dict(label=label, exit_code=receipt['exit_code'], command=receipt['command'], native=native))
    contracts = (PROS / 'contracts.proof-free.md').read_text(encoding='utf-8')
    embedded = contracts.split('```text\n', 1)[1].rsplit('```\n', 1)[0]
    assert embedded == (PROS / 'capstones-final-03.native.txt').read_text(encoding='utf-8')
    measure = (PROS / 'measure-final-02.native.txt').read_text(encoding='utf-8')
    assert '@inferInstance.{1} (MeasureTheory.MeasureSpace.{0} Real)' in measure
    assert '@measureSpaceOfInnerProductSpace.{0} Real' in measure
    assert '@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace' in measure
    assert 'Real.volume_Ioc {a b : ℝ} : volume (Set.Ioc a b) = ENNReal.ofReal (b - a)' in measure
    assert 'Real.volume_real_Ioc_of_le {a b : ℝ} (hab : a ≤ b) : volume.real (Set.Ioc a b) = b - a' in measure
    assert 'unitInterval : volume (Set.Ioc 0 1) = 1' in measure
    attempts = []
    for label, expected in [('capstones-check-01', 1), ('capstones-check-02', 0), ('measure-check-01', 0)]:
        receipt = read(PROS / (label + '.receipt.json'))
        bind(PROS / receipt['output'], receipt['output_sha256'], 'prospective/historical-output')
        assert receipt['exit_code'] == expected
        attempts.append(dict(label=label, exit_code=receipt['exit_code'],
                             current_source_matches=digest(PROS / receipt['source']) == receipt['source_sha256_after'],
                             historical_source_sha256=receipt['source_sha256_after']))
    return dict(finals=finals, canonical_source_and_olean_closure_count=21,
                native_contracts_embedding_exact=True, selected_real_measure_verified=True,
                question_records_exact=True, frozen_audit_decisions_unchanged=True,
                attempts=attempts,
                limitations=['Historical prospective source revisions were not snapshotted; final sources are fully bound.',
                             'The separate canonical owner build entry is an observation, not a raw hash-bound build receipt.'])

def main():
    output = HERE / 'verification.json'
    assert not output.exists(), 'append-only output already exists'
    cartesian = check_cartesian()
    prospective = check_prospective()
    summary = dict(cartesian_new=24, cartesian_base=24, prospective_capstones=11,
                   prospective_measure=8, total_final_axiom_reports=67,
                   empty_final_reports=0, universe_displayed_final_axiom_names=0)
    report = dict(kind='independent-frozen-evidence-verification', checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  verifier=dict(path=str(Path(__file__)), sha256=digest(Path(__file__))),
                  cartesian=cartesian, prospective=prospective, summary=summary,
                  binding_occurrences=len(BINDINGS), unique_bound_paths=len({x['path'].casefold() for x in BINDINGS}),
                  bindings=BINDINGS, all_assertions_passed=True,
                  limits='No source interpretation or faithfulness judgment; no frozen input writes. Existing native captures checked, not regenerated here.')
    output.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8', newline='\n')
    print(json.dumps(dict(output=str(output), sha256=digest(output), **summary,
                          binding_occurrences=report['binding_occurrences'], unique_bound_paths=report['unique_bound_paths'])))

if __name__ == '__main__':
    main()
