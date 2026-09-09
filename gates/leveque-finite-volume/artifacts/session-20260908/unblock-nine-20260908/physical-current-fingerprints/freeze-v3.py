"""Freeze current selected-owner export and a duplicate-free consolidated inventory."""
from pathlib import Path
from datetime import datetime, timezone
import collections
import gzip
import hashlib
import importlib.util
import json
import os
import re
import shutil
import subprocess

F = Path(__file__).resolve().parent
R = next(p for p in F.parents if (p / 'lean-toolchain').exists())
assert os.name == 'posix'
INPUT_SHA = 'b95116235e67e1ad61c3c15d1799a7662082aaf3a628867ea44d9eddaca76bd8'


def sha(path):
    result = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(chunk)
    return result.hexdigest()


ref = lambda path: dict(path=path.relative_to(R).as_posix(), sha256=sha(path))
read = lambda path: json.loads(path.read_bytes())


def write(name, value):
    with (F / name).open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(value, stream, indent=2, ensure_ascii=False)
        stream.write('\n')
    return ref(F / name)


assert sha(F / 'inputs.json') == INPUT_SHA
inputs = read(F / 'inputs.json')
native = read(F / 'native-exit.json')
output = (F / 'native-output.txt').read_bytes()
assert native['exit_code'] == 0 and native['input_bytes_and_head_unchanged']
assert native['input_manifest_sha256'] == INPUT_SHA
assert native['argv'] == ['lake', 'env', 'lean', inputs['exporter_path']]
assert (native['input_commit'], native['input_commit_tree']) == (inputs['input_commit'], inputs['input_commit_tree'])
assert native['output_sha256'] == hashlib.sha256(output).hexdigest()
pins = inputs['files'] + inputs['lean_environment'] + inputs['prior_owners'] + inputs['prior_fingerprints'] + inputs['input_manifests']
for pin in pins:
    assert sha(R / pin['path']) == pin['sha256'], pin['path']
exporter = R / inputs['exporter_path']
template = R / inputs['prior_exporter']['path']
parser_path = R / inputs['parser']['path']
assert sha(exporter) == inputs['exporter_sha256']
assert sha(template) == inputs['prior_exporter']['sha256']
assert sha(parser_path) == inputs['parser']['sha256']


def serializer(text):
    start = text.index('private def generated')
    left = text.index('private def selectedModules : Array String := #[', start)
    right = text.index('\n]\n', left) + 3
    return re.sub(r'IO\.FS\.writeFile "[^"]+" text', 'IO.FS.writeFile "OUTPUT" text', text[start:left] + text[right:])


assert serializer(exporter.read_text()) == serializer(template.read_text())
spec = importlib.util.spec_from_file_location('unchanged_v3_expression_token_parser', parser_path)
parser = importlib.util.module_from_spec(spec)
spec.loader.exec_module(parser)
fresh, raw = parser.records(R / inputs['raw_stream_path'])
parsed_cache = write('parsed-current-560.json', {'parser': ref(parser_path), 'raw': raw, 'records': fresh})
assert len(fresh) == len({record['name'] for record in fresh})
assert {record['module'] for record in fresh} == set(inputs['selected_modules'])
assert all(record['kind'] != 'axiom' for record in fresh)
assert output.decode().strip() == 'Chapter 1 declaration expressions exported: ' + str(len(fresh))
expected = set(inputs['expected_authored_declarations'])
assert len(expected) == 300 and expected <= {record['name'] for record in fresh}

old_records = {}
old_files = {}
origin = {}
legacy_encoding_evidence = []
for pin in inputs['prior_fingerprints']:
    old = read(R / pin['path'])
    assert old['normalization'] == inputs['normalization']
    if 'hash_encoding' in old:
        assert old['hash_encoding'] == inputs['hash_encoding']
    else:
        # Narrow legacy schema case, independently reparsed using the unchanged v3 parser.
        assert pin['sha256'] == 'e29b3e71a3bffdba15b88e5e2ef5f45907e16aa982c40bb93da828c91aafd720'
        session = F.parent.parent
        assert R / pin['path'] == session / 'baseline-equation03-expression-fingerprints.json'
        producer = session / 'freeze-baseline-equation03-expressions.py'
        assert sha(producer) == 'ea917c1970996ed78a3fec6084eb74df0f84395d33dee637bf44381a2ecb99b8'
        old_input = session / 'baseline-equation03-expression-inputs.json'
        old_native = session / 'baseline-equation03-expression-export-after-prepare-exit.json'
        assert sha(old_input) == old['input_manifest_sha256']
        assert sha(old_native) == old['native_receipt_sha256']
        assert read(old_native)['exit_code'] == 0
        assert read(old_native)['output_sha256'] == sha(session / 'baseline-equation03-expression-export-after-prepare-output.txt')
        legacy_raw = R / '.lake/chapter01-baseline-equation03-expressions.jsonl'
        legacy_records, legacy_stream = parser.records(legacy_raw)
        assert legacy_stream == old['ignored_raw_stream']
        assert sorted(legacy_records, key=lambda record: record['name']) == old['records']
        legacy_encoding_evidence.append({'inventory': pin, 'producer': ref(producer),
            'input': ref(old_input), 'native_receipt': ref(old_native), 'parser': ref(parser_path),
            'raw': dict(path=legacy_raw.relative_to(R).as_posix(), **legacy_stream),
            'reparsed_records_equal': True, 'records': len(legacy_records),
            'qualification': 'Original hash_encoding field remains absent; current token encoding is established by exact reparse with the same pinned v3 parser, not filled into the historical artifact.'})
    for item in old['files']:
        assert item['path'] not in old_files
        old_files[item['path']] = item
        origin[item['path']] = {'inventory': pin, 'native_input_commit': old.get('input_commit'),
                              'native_provenance': {key: old[key] for key in (
                                  'input_manifest', 'native_receipt', 'native_output', 'native_raw_archive') if key in old}}
    for record in old['records']:
        assert record['name'] not in old_records
        old_records[record['name']] = record
assert len(old_records) == 1426 and len(old_files) == 171
selected = set(inputs['selected_modules'])
replaced = {name: record for name, record in old_records.items() if record['module'] in selected}
retained = {name: record for name, record in old_records.items() if record['module'] not in selected}
fresh_by_name = {record['name']: record for record in fresh}
assert not set(retained) & set(fresh_by_name)
removed_name = '_private.ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods.0.NumStability.termV'
assert set(replaced) - set(fresh_by_name) == {removed_name}
assert replaced[removed_name]['type'] == 'Lean.Expr.const `Lean.ParserDescr []'
old_source = F.parent / 'dim-five-owner-overlay/overlay/ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean'
assert sha(old_source) == 'e7d3da45027462919030380de761642cb5013f00a451df12bdebbc0a4a8efc54'
assert 'local notation "V" => Fin m → ℝ' in old_source.read_text()
removed_evidence = write('removed-private-notation.json', {'name': removed_name,
    'record': replaced[removed_name], 'old_source': ref(old_source),
    'line': 28, 'source_text': 'local notation "V" => Fin m → ℝ',
    'scope': 'Only this exact old source wrapper private parser helper is removed. Every other prior selected name is required. Root independently reviewed and adopted this exact exclusion.'})
combined = sorted([*retained.values(), *fresh], key=lambda record: record['name'])
files = sorted([*inputs['prior_owners'], *inputs['files']], key=lambda item: item['path'])
assert len(files) == len({item['path'] for item in files}) == 183
assert len(combined) == len({record['name'] for record in combined})
owner_by_module = {item['path'][:-5].replace('/', '.'): item for item in files}
assert {record['module'] for record in combined} == set(owner_by_module)
for item in inputs['prior_owners']:
    assert item == old_files[item['path']]
for record in retained.values():
    assert record == old_records[record['name']]

archive_path = F / 'native-expression-stream.jsonl.gz'
assert not archive_path.exists()
with (R / inputs['raw_stream_path']).open('rb') as source, archive_path.open('xb') as destination:
    with gzip.GzipFile(filename='', mode='wb', fileobj=destination, mtime=0) as compressed:
        shutil.copyfileobj(source, compressed, 1024 * 1024)
decompressed = hashlib.sha256()
size = 0
with gzip.open(archive_path, 'rb') as stream:
    for chunk in iter(lambda: stream.read(1024 * 1024), b''):
        decompressed.update(chunk)
        size += len(chunk)
assert size == raw['bytes'] and decompressed.hexdigest() == raw['sha256']
archive = dict(**ref(archive_path), bytes=archive_path.stat().st_size,
               uncompressed_bytes=size, uncompressed_sha256=raw['sha256'],
               exact_decompression_verified=True, gzip_filename='', gzip_mtime=0)

provenance = []
fresh_paths = {item['path'] for item in inputs['files']}
for item in files:
    path = item['path']
    current = ref(R / path)
    assert current['sha256'] == item['sha256']
    provenance.append({'current_owner': item,
        'mode': 'fresh-whole-owner-export' if path in fresh_paths else 'exact-retained-prior-records',
        'prior': origin.get(path),
        'prior_owner': old_files.get(path),
        'fresh_input_manifest': ref(F / 'inputs.json') if path in fresh_paths else None,
        'fresh_native_receipt': ref(F / 'native-exit.json') if path in fresh_paths else None})
comparison = []
for name, record in sorted(replaced.items()):
    if name == removed_name: continue
    now = fresh_by_name[name]
    comparison.append({'name': name, 'prior_module': record['module'], 'current_module': now['module'],
        'owner_moved': record['module'] != now['module'],
        'changed_fields': [key for key in ('type_sha256', 'value_sha256', 'level_params_sha256',
                                          'recursor_values_sha256') if record[key] != now[key]]})
legacy_evidence = write('legacy-encoding-evidence.json', {'cases': legacy_encoding_evidence})
owner_provenance = write('owner-provenance.json', {'owners': provenance,
    'retained_scope': 'Prior records and original native provenance retained exactly for source-unchanged owners. Their earlier native commits are not relabeled as fresh exports.', 'legacy_encoding_evidence': legacy_evidence})
change_report = write('selected-record-changes.json', {'prior_selected_count': len(replaced),
    'fresh_selected_count': len(fresh), 'all_prior_selected_names_retained': False,
    'all_prior_selected_public_names_retained': True, 'exact_removed_private_helper': removed_evidence,
    'old_to_current': comparison, 'added_names': sorted(set(fresh_by_name) - set(old_records)),
    'relocated_names': [item['name'] for item in comparison if item['owner_moved']],
    'interpretation': 'Structural comparison only. Changed type/value tokens, including the materially new source contract, are not assigned semantic equivalence by this report.'})
fresh_inventory = write('fresh-owner-expression-fingerprints.json', dict(schema=1,
    artifact_kind='fresh-current-owner-native-declaration-fingerprints', input_commit=inputs['input_commit'],
    input_commit_tree=inputs['input_commit_tree'], normalization=inputs['normalization'],
    counting_note=inputs['counting_note'], hash_encoding=inputs['hash_encoding'],
    files=inputs['files'], selected_modules=inputs['selected_modules'], records=fresh,
    declaration_count=len(fresh), input_manifest=ref(F / 'inputs.json'),
    native_receipt=ref(F / 'native-exit.json'), native_output=ref(F / 'native-output.txt'),
    native_raw_stream=dict(path=inputs['raw_stream_path'], **raw), native_raw_archive=archive))
result = write('current-expression-fingerprints.json', dict(schema=1,
    artifact_kind='consolidated-current-declaration-fingerprints', input_commit=inputs['input_commit'],
    input_commit_tree=inputs['input_commit_tree'], normalization=inputs['normalization'],
    counting_note=inputs['counting_note'], hash_encoding=inputs['hash_encoding'],
    selected_modules=sorted(owner_by_module), files=files, records=combined,
    declaration_count=len(combined), owner_count=len(files),
    prior_fingerprints=inputs['prior_fingerprints'], owner_provenance=owner_provenance,
    fresh_fingerprints=fresh_inventory, fresh_native_receipt=ref(F / 'native-exit.json'),
    fresh_native_output=ref(F / 'native-output.txt'), fresh_native_raw_archive=archive,
    fresh_owner_count=29, fresh_constant_count=len(fresh),
    retained_owner_count=154, retained_constant_count=len(retained),
    exact_prior_serializer_preserved=True, exact_prior_token_parser_preserved=True,
    constant_kinds=dict(collections.Counter(record['kind'] for record in combined)),
    owner_constant_counts=dict(collections.Counter(record['module'] for record in combined)),
    changes=change_report, input_manifest=ref(F / 'inputs.json'),
    commit_scope=inputs['commit_scope'],
    consumer_scope='Replace the seven prior inventory arguments with this ONE consolidated inventory after exact current/committed source-byte verification. Do not append the old seven: their selected-owner rows are intentionally superseded. Retained records keep their original provenance; only 29 owners were freshly exported.'))
git = lambda *args: subprocess.check_output(['git', '--no-optional-locks', '--no-replace-objects', *args], cwd=R).decode().strip()
assert git('rev-parse', 'HEAD') == inputs['input_commit']
assert git('rev-parse', inputs['input_commit'] + '^{tree}') == inputs['input_commit_tree']
for pin in pins:
    assert sha(R / pin['path']) == pin['sha256']
receipt = write('fingerprint-receipt.json', dict(schema=1,
    status='NATIVE EXPORT AND CONSOLIDATION PASS; no semantic/candidate/source acceptance',
    frozen_at_utc=datetime.now(timezone.utc).isoformat(), input_commit=inputs['input_commit'],
    input_commit_tree=inputs['input_commit_tree'], input_manifest=ref(F / 'inputs.json'),
    fingerprints=result, fresh_fingerprints=fresh_inventory, owner_provenance=owner_provenance,
    changes=change_report, parsed_cache=parsed_cache, removed_private_helper=removed_evidence, native_receipt=ref(F / 'native-exit.json'),
    native_output=ref(F / 'native-output.txt'), archive=archive,
    total_records=len(combined), total_owners=183, fresh_records=len(fresh), fresh_owners=29,
    retained_records=len(retained), retained_owners=154, expected_explicit_fresh_authors=300,
    actual_native_exit=0, source_olean_head_pins_unchanged=True,
    exact_serializer_and_parser_preserved=True, all_prior_selected_public_names_retained=True,
    production_mutation=False, git_mutation=False, source_acceptance=False,
    later_committed_blob_verification_required=True))
print(json.dumps({'receipt': receipt, 'consolidated': result, 'fresh': fresh_inventory,
                  'archive': archive, 'total_records': len(combined), 'fresh_records': len(fresh),
                  'retained_records': len(retained), 'relocated': sum(item['owner_moved'] for item in comparison)}, indent=2))
