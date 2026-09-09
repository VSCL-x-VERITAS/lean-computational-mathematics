"""Create exact current-owner check inputs; never execute Lean or change production."""
from pathlib import Path
import hashlib
import json
import os
import re

R = Path(r'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
D = R / 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908'
P = D / 'physical-canonical-check-preparation'


def raw(path):
    with open('\\\\?\\' + str(path), 'rb') as stream:
        return stream.read()


def ref(path):
    content = raw(path)
    return {'path': path.relative_to(R).as_posix(),
            'sha256': hashlib.sha256(content).hexdigest(), 'bytes': len(content)}


def write(name, value):
    path = P / name
    content = value.encode('utf-8') if isinstance(value, str) else (
        json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode('utf-8')
    with open('\\\\?\\' + str(path), 'xb') as stream:
        stream.write(content)
    return ref(path)


mapping_path = D / 'physical-dim-owner-proposals/attempt-06/mapping.json'
placement_path = D / 'physical-production-promotion/owner-placement-01/receipt.json'
assert ref(mapping_path)['sha256'] == '6b8d51bf7ab2bf4fd585a92ff76c3845488f3119c87fbc8df820a6db978cf498'
assert ref(placement_path)['sha256'] == '73c9027cfd4f55e272ddf56dc545a82195651b90401da3f0c2e3ac6b88a3188b'
mapping = json.loads(raw(mapping_path))
placement = json.loads(raw(placement_path))
placed = {item['path']: item for item in placement['actual_changed_files']}
assert placement['mapping_sha256'] == ref(mapping_path)['sha256']
assert set(placed) == {item['target_path'] for item in mapping['files']}
records = []
by_name = {}
for owner in mapping['files']:
    path = R / owner['target_path']
    current = ref(path)
    assert current['sha256'] == owner['proposed']['sha256'] == placed[owner['target_path']]['after_sha256']
    assert raw(path) == raw(R / owner['proposed']['path'])
    text = raw(path).decode('utf-8')
    assert len(text.splitlines()) == owner['lines']
    records.append({'path': owner['target_path'], 'module': owner['module'],
                    'sha256': current['sha256'], 'lines': owner['lines'],
                    'declarations': owner['declarations'], 'exports': owner['exports'],
                    'change': owner['change']})
    for declaration in owner['exports']:
        assert declaration['name'] not in by_name
        # Inventory names/kinds are explicit source declarations, not guessed generated names.
        source_line = text.splitlines()[declaration['line'] - 1]
        assert re.match(r'^(?:(?:noncomputable|private|protected)\s+)*' + declaration['kind'] + r'\s+', source_line)
        by_name[declaration['name']] = {'owner': owner['target_path'], **declaration}
assert len(by_name) == 169
moved = mapping['preserved_moved_names']
assert len(moved) == 5
assert all(by_name[name]['owner'].endswith('/FiniteLineCoordinates.lean') for name in moved)
retained = [name for item in records if item['change'] == 'changed'
            for name in item['declarations'] if name != 'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'
            and name != 'NumStability.constantFlux_isHyperbolicOn']
assert len(retained) == 18

fv = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
lookup_module = fv + 'FiniteLineCoordinates'
source_module = 'ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods'
all_names = [name for item in records for name in item['declarations']]
lookup_names = next(item['declarations'] for item in records if item['module'] == lookup_module)
legacy_names = moved + [name for item in records if item['module'] in {
    fv + 'CoordinateLineMethod', fv + 'CoordinateLineMethodEstimates'} for name in item['declarations']]
source_names = ['NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'] + [
    'NumStability.PhysicalRefinementQuality.Family' + suffix for suffix in (
        '', '.SmoothReference', '.AccuracyCertificate', '.HasHighResolution',
        '.AccuracyCertificate.perturbed_at', '.HasHighResolution.two_state_available')] + [
    'NumStability.PhysicalHighResolutionSweep.' + suffix for suffix in (
        'coordinates', 'method', 'execution', 'Specification', 'specification',
        'ValidSubsteps', 'admitted_specification')]


def check_input(filename, modules, names, scope):
    assert len(names) == len(set(names))
    assert all(name in by_name for name in names)
    imports = sorted(set(modules), key=str.casefold)
    text = '\n'.join('import ' + module for module in imports) + '\n\n'
    text += '/-! ' + scope + ' Native execution is intentionally pending. -/\n\n'
    text += 'set_option pp.universes true\nset_option pp.fullNames true\nset_option pp.deepTerms true\n\n'
    for name in names:
        text += '#check ' + name + '\n#print axioms ' + name + '\n\n'
    file = write(filename, text)
    return {'file': file, 'imports': imports, 'declarations': names,
            'expected_check_count': len(names), 'expected_axiom_report_count': len(names),
            'scope': scope}


checks = [
    check_input('AllCurrentDeclarations.lean', [item['module'] for item in records], all_names,
                'All 169 explicit declarations in the 16 exact current owners.'),
    check_input('SourceImportSmoke.lean', [source_module], source_names,
                'Only the Chapter 1 source owner is imported; core physical contract names must be exposed.'),
    check_input('LookupImportSmoke.lean', [lookup_module], lookup_names,
                'Only the minimal new lookup owner is imported, exposing five moved and five ghost declarations.'),
    check_input('LegacyLookupImportSmoke.lean', [fv + 'CoordinateLineMethodEstimates'], legacy_names,
                'The existing estimates import must continue to expose the five moved lookup names and 13 retained realization/execution names.'),
]

expected = write('expected-declarations.json', {
    'schema': 1, 'status': 'PREPARED; native verification not run',
    'explicit_author_count': 169, 'files': records,
    'declarations': all_names, 'declaration_records': [by_name[name] for name in all_names],
    'moved_unchanged_names': moved, 'retained_changed_owner_names': retained,
    'generated_declarations': 'No private generated declaration, recursor, projection or instance name is guessed or separately asserted.',
    'checks': checks, 'allowed_axioms': ['propext', 'Classical.choice', 'Quot.sound'],
    'axiom_reporting': 'Accept the actual empty-axiom form as well as a subset of the three allowed axioms; retain universe parameters on names and raw output. A check input is not a success receipt.',
    'source_type_note': 'The source declaration name is retained but its type intentionally changes; this packet asserts no equality to the old rejected source type.',
})
manifest = write('manifest.json', {
    'schema': 1, 'status': 'CHECK INPUTS ONLY; build and checks pending',
    'proposal_mapping': ref(mapping_path), 'actual_placement': ref(placement_path),
    'expected_declarations': expected,
    'check_file': checks[0]['file']['path'], 'check_file_sha256': checks[0]['file']['sha256'],
    'files': [{'path': item['path'], 'sha256': item['sha256'], 'declarations': item['declarations']}
              for item in records], 'declarations': all_names, 'checks': checks,
    'toolchain': ref(R / 'lean-toolchain'), 'package_manifest': ref(R / 'lake-manifest.json'),
    'native_lean_run': False, 'production_written': False, 'source_acceptance': False,
    'deferred_scope': 'The separate five-owner C-infinity/choice group and historical 149-author packet remain independently pinned; this input covers the requested current 16 owners only.'})
readme = write('README.md', '''# Current physical owner declaration checks

These are prepared inputs, not native verification results. Run them only after root's canonical owner build succeeds. The current sixteen owner files were byte-compared with the frozen attempt-06 proposals and the actual placement receipt before generation.

`AllCurrentDeclarations.lean` imports the exact sixteen modules and emits one `#check` and one `#print axioms` for each of their 169 explicit authored declarations. `expected-declarations.json` records exact source lines and declaration kinds, five unchanged moved lookup names, eighteen retained names in the changed mathematical owners, and each check's expected report count. Generated/private implementation names are not invented.

The three independent smoke inputs have deliberately narrow imports:

- `SourceImportSmoke.lean`: only the source module; 14 source/core contract names.
- `LookupImportSmoke.lean`: only `FiniteLineCoordinates`; all 10 explicit lookup/ghost declarations.
- `LegacyLookupImportSmoke.lean`: only the existing `CoordinateLineMethodEstimates`; 18 lookup and retained realization/execution names.

Root should use the established native Lake capture helper with fresh labels for `lake env lean <input>`, preserving actual command, exit, stdout/stderr, source and compiled dependency pins. An actual result must check all expected reports, permitting empty axiom output or only `propext`, `Classical.choice`, and `Quot.sound`, and preserving displayed universe parameters. These inputs request full names, universe parameters and deep terms; they do not truncate printed statements.

This packet does not perform the separate nominal transport comparisons, prove old/new source equivalence, or claim that an import smoke check excludes every unrelated transitive dependency. The existing five-owner C∞/choice group and its old 149-author packet remain separate root-owned verification scopes. No Lean, build, Git, audit, gate or production mutation is executed by the preparer.
''')
for item in records:
    assert ref(R / item['path'])['sha256'] == item['sha256'], 'Concurrent source mutation'
receipt = write('receipt.json', {'schema': 1,
    'status': 'FROZEN CHECK PREPARATION; native checks pending',
    'script': ref(P / 'prepare.py'), 'manifest': manifest, 'expected': expected,
    'readme': readme, 'checks': [item['file'] for item in checks],
    'current_owner_hashes_verified': 16, 'explicit_declarations': 169,
    'moved_names': 5, 'retained_changed_owner_names': 18,
    'native_lean_run': False, 'production_written': False, 'source_acceptance': False})
print(json.dumps({'receipt': receipt, 'manifest': manifest, 'expected': expected,
                  'inputs': [item['file'] for item in checks]}, indent=2))
