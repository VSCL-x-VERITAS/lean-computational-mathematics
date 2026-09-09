"""Freeze the completed structural fingerprint package and a raw/cache-excluding stage list."""
from pathlib import Path
import ast
import collections
import gzip
import hashlib
import json
import os
import shutil
import subprocess

F = Path(__file__).resolve().parent
R = next(p for p in F.parents if (p / 'lean-toolchain').exists())
assert os.name == 'posix'


def sha(path):
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for data in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(data)
    return digest.hexdigest()


ref = lambda path: {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
read = lambda path: json.loads(path.read_bytes())


def write(name, data):
    with (F / name).open('x', encoding='utf-8', newline='\n') as stream:
        if isinstance(data, str): stream.write(data)
        else: json.dump(data, stream, indent=2, ensure_ascii=False); stream.write('\n')
    return ref(F / name)


receipt = read(F / 'fingerprint-receipt.json')
inputs = read(F / 'inputs.json')
fp = read(R / receipt['fingerprints']['path'])
changes = read(R / receipt['changes']['path'])
native = read(F / 'native-exit.json')
parse = read(F / 'freeze-v2-exit.json')
assert receipt['actual_native_exit'] == native['exit_code'] == parse['exit_code'] == 0
assert receipt['total_owners'] == len(fp['files']) == 183
assert receipt['fresh_owners'] == 29 and receipt['retained_owners'] == 154
assert receipt['fresh_records'] == 560
assert len(fp['records']) == receipt['total_records']
assert changes['all_prior_selected_names_retained']
assert not inputs['unfingerprinted_dependency_owners_outside_requested_scope']
for item in fp['files'] + inputs['lean_environment'] + inputs['prior_fingerprints'] + [
        receipt['fingerprints'], receipt['fresh_fingerprints'], receipt['owner_provenance'],
        receipt['changes'], receipt['native_receipt'], receipt['native_output'], receipt['archive']]:
    assert sha(R / item['path']) == item['sha256'], item['path']
head = subprocess.check_output(['git', '--no-optional-locks', '--no-replace-objects', 'rev-parse', 'HEAD'], cwd=R).decode().strip()
assert head == inputs['input_commit']
scripts = []
for path in sorted(F.glob('*.py')):
    text = path.read_text(encoding='utf-8')
    ast.parse(text)
    compile(text, str(path), 'exec')
    scripts.append(ref(path))
syntax = write('syntax-validation.json', {'status': 'PASS', 'method': 'ast.parse and compile only', 'scripts': scripts})
archive = receipt['archive']
legacy = read(F / 'legacy-encoding-evidence.json')
assert len(legacy['cases']) == 1
legacy_case = legacy['cases'][0]
legacy_raw = R / legacy_case['raw']['path']
assert sha(legacy_raw) == legacy_case['raw']['sha256']
legacy_archive_path = F / 'baseline-equation03-stream.jsonl.gz'
with legacy_raw.open('rb') as source, legacy_archive_path.open('xb') as destination:
    with gzip.GzipFile(filename='', mode='wb', fileobj=destination, mtime=0) as compressed:
        shutil.copyfileobj(source, compressed)
with gzip.open(legacy_archive_path, 'rb') as stream:
    legacy_bytes = stream.read()
assert len(legacy_bytes) == legacy_case['raw']['bytes']
assert hashlib.sha256(legacy_bytes).hexdigest() == legacy_case['raw']['sha256']
legacy_replay = write('legacy-replay.json', {
    'encoding_evidence': ref(F / 'legacy-encoding-evidence.json'),
    'original_raw_path': legacy_case['raw']['path'], 'original_raw': legacy_case['raw'],
    'archive': ref(legacy_archive_path), 'exact_decompression_verified': True,
    'replay': 'Restore the checked decompressed bytes to the original raw path only when absent, before replaying the legacy same-parser comparison. Historical inventory and receipts are unchanged.'})
changed_types = sum('type_sha256' in item['changed_fields'] for item in changes['old_to_current'])
changed_values = sum('value_sha256' in item['changed_fields'] for item in changes['old_to_current'])
fresh = read(R / receipt['fresh_fingerprints']['path'])
fresh_counts = collections.Counter(record['module'] for record in fresh['records'])
rows = '\n'.join('- `' + module + '`: ' + str(count) + ' constants'
    for module, count in sorted(fresh_counts.items()))
review = f'''# Current physical DIM structural expression fingerprints

The native Lean export completed with actual exit 0 in {native['elapsed_ms']:,} ms. It exported **560 eligible constants in the current 29 owners**, including all **300 explicit authored declarations**. The 29 owners are the original DIM sixteen, the twelve new physical owners, and the extended hyperbolicity owner. Actual HEAD was `{head}`; tree `{inputs['input_commit_tree']}`. Current owner sources, compiled project files, directly imported Mathlib source/compiled entries, package/toolchain manifests and native tool files stayed hash-identical during export. The full recursive project import closure has {len(inputs['project_import_closure'])} owners, all covered by old or fresh inventories. This follows the inherited upstream pinning scope; it is not a new exhaustive census of every transitive Mathlib compiled file.

The consolidated successor contains **{receipt['total_records']} constants across 183 unique owners**. It retains **{receipt['retained_records']} exact prior records across 154 source-unchanged owners** and replaces every old record belonging to the 29 selected modules with its fresh current record. The old selected owner set had {changes['prior_selected_count']} constants. All their public names remain present; {len(changes['relocated_names'])} constants move to a new owner (including the five explicit lookup declarations and their eligible generated structure constants). Among those prior selected names, {changed_types} type tokens and {changed_values} value tokens changed. These are structural observations, not semantic judgments. The source contract deliberately changed, as did the C∞ definitions and the explicit-choice presentation.

`owner-provenance.json` binds each retained owner to its exact original inventory/native provenance and each refreshed owner to the new input/native receipt. No earlier native commit is relabeled as a fresh export. The seven old inventories remain untouched. Their 1,426 records/171 owners were checked; nine old source hashes were stale, all inside the approved 29-owner scope. No unexpected stale owner or un-fingerprinted project dependency was found. Current records are source- and compiler-bound observations; the retained earlier records are not silently called a new whole-library export.

The native serializer and generated/private-name filter are byte-identical after excluding only the selected import/module list and output path. The pinned v3 streaming JSON-token parser is loaded unchanged. Normalization erases expression metadata and binder display names while preserving de Bruijn indices, universes, constants, binder kinds and expression shape. It is structural alpha-canonical serialization, not full definitional normalization. The artifact gives no source-faithfulness verdict, semantic-equivalence proof, reconciliation acceptance or future commit authority.

Fresh owner counts:

{rows}

The raw stream is {archive['uncompressed_bytes']:,} bytes, SHA256 `{archive['uncompressed_sha256']}`. The deterministic gzip (empty filename, mtime 0) is {archive['bytes']:,} bytes, SHA256 `{archive['sha256']}`. The unchanged streaming parse and archive operation exited 0, and exact decompressed length/SHA were verified. **Retain the raw stream locally and stage the gzip only.** `stage-files.json` excludes the raw JSONL and all generated caches; no staging was performed.

For a later current organization or real committed lane, replace the seven previous fingerprint arguments with this single inventory:

```text
--fingerprints {receipt['fingerprints']['path']}
```

Do not append the old seven to this current successor: their selected-owner pins and records are historical and intentionally superseded. `fresh-owner-expression-fingerprints.json` is supporting evidence for the 29 fresh owners; it must not be added alongside the consolidated inventory. A later actual committed-blob check must verify all 183 owner source hashes against that real commit before candidate/lane use. No future commit, candidate, gate, source audit, production file, index or ref was created or changed here.

The small original baseline Eq1.3 raw stream is additionally preserved in `baseline-equation03-stream.jsonl.gz`; `legacy-replay.json` binds its exact decompressed bytes to the historical local path. This makes the narrow metadata compatibility check replayable without changing any historical inventory or receipt.

The native exporter, coverage and preparation passed on their first runs. The first parser/freeze attempt exited 1 because the historical three-record baseline Eq1.3 inventory lacks the later hash_encoding metadata field. Its source/native provenance and exact raw stream were then checked, and the unchanged v3 parser reproduced all three records exactly. A narrow successor admits only that exact hash-pinned legacy case, preserving the historical bytes and the failed attempt. The second parser/archive run exited 0. Script syntax checks were separate from execution and did not invoke any semantic role. Exact raw outputs and actual exit receipts are retained. Root remains responsible for final organization, nominal transport checks, source audits and committed/candidate integration.
'''
readme = write('README.md', review)
excluded = []
included = []
for path in sorted(F.rglob('*')):
    if not path.is_file(): continue
    assert not path.is_symlink(), path
    relative = path.relative_to(F)
    if path.name in {'stage-files.json', 'final-package.json', 'final-receipt.json'}:
        continue
    if path.name == 'native-expression-stream.jsonl' or '__pycache__' in relative.parts or path.suffix in {'.pyc', '.olean', '.ilean', '.o', '.c'}:
        excluded.append(dict(**ref(path), bytes=path.stat().st_size,
                             reason='Exact large raw stream retained locally with verified gzip' if path.name.endswith('.jsonl') else 'Generated cache'))
        continue
    assert path.stat().st_size < 90 * 1024 * 1024, 'Unexpected large publication artifact'
    included.append(dict(**ref(path), bytes=path.stat().st_size))
stage = write('stage-files.json', {'files': included, 'excluded': excluded, 'staging_performed': False,
    'manifest_self_files': ['stage-files.json', 'final-package.json', 'final-receipt.json']})
package = write('final-package.json', {'schema': 1, 'status': 'FROZEN NATIVE FINGERPRINT SUCCESSOR',
    'fingerprint_receipt': ref(F / 'fingerprint-receipt.json'), 'readme': readme,
    'syntax_validation': syntax, 'stage_files': stage, 'records': receipt['total_records'],
    'owners': 183, 'fresh_records': 560, 'fresh_owners': 29, 'retained_records': receipt['retained_records'],
    'retained_owners': 154, 'all_seven_prior_inventories_unchanged': True,
    'replacement_not_append': True, 'legacy_replay': legacy_replay, 'later_committed_blob_check_pending': True,
    'source_acceptance': False, 'production_mutation': False, 'git_mutation': False})
final = write('final-receipt.json', {'final_package': package, 'fingerprints': receipt['fingerprints'],
    'fresh_fingerprints': receipt['fresh_fingerprints'], 'owner_provenance': receipt['owner_provenance'],
    'changes': receipt['changes'], 'archive': archive, 'fingerprint_receipt': ref(F / 'fingerprint-receipt.json'),
    'native_actual_exit': 0, 'parser_archive_actual_exit': 0, 'syntax_validation': syntax,
    'staging_list': stage, 'input_commit': head, 'unchanged_source_olean_tools_and_head': True,
    'legacy_replay': legacy_replay, 'future_committed_blob_verification_required': True})
print(json.dumps({'receipt': final, 'package': package, 'consolidated': receipt['fingerprints'],
                  'archive': archive, 'stage_files': stage}, indent=2))
