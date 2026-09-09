"""Freeze additive records with the exact pinned existing streaming token parser."""
from pathlib import Path
from datetime import datetime, timezone
import collections, hashlib, importlib.util, json, re

F = Path(__file__).resolve().parent
R = F.parents[5]
INPUT_SHA = '85f3dffc6cc52413316608457669ce95f3e252f84fab2b3c58c0298aa5937bec'
sha = lambda data: hashlib.sha256(data).hexdigest()
load = lambda path: json.loads(path.read_text(encoding='utf-8'))

def write_new(path, value):
    with path.open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(value, stream, indent=2, ensure_ascii=False); stream.write('\n')

def main():
    assert sha((F / 'inputs.json').read_bytes()) == INPUT_SHA
    inputs = load(F / 'inputs.json')
    oldpath = R / inputs['prior_fingerprints']['path']
    assert sha(oldpath.read_bytes()) == inputs['prior_fingerprints']['sha256']
    old = load(oldpath)
    for item in inputs['files'] + inputs['lean_environment'] + old['files']:
        assert sha((R / item['path']).read_bytes()) == item['sha256'], item['path']
    exporter = R / inputs['exporter_path']
    prior_exporter = R / inputs['prior_exporter']['path']
    assert sha(exporter.read_bytes()) == inputs['exporter_sha256']
    assert sha(prior_exporter.read_bytes()) == inputs['prior_exporter']['sha256']
    # The filtering, canonicalization, all ConstantInfo handling and JSON serialization
    # remain exact. Only imported modules, selected owner list and destination differ.
    def serializer(text):
        start = text.index('private def generated')
        a = text.index('private def selectedModules : Array String := #[', start)
        b = text.index('\n]\n', a) + 3
        body = text[start:a] + text[b:]
        return re.sub(r'IO\.FS\.writeFile "[^"]+" text', 'IO.FS.writeFile "OUTPUT" text', body)
    assert serializer(exporter.read_text(encoding='utf-8')) == serializer(prior_exporter.read_text(encoding='utf-8'))
    receipt = load(F / 'native-exit.json')
    output = (F / 'native-output.txt').read_bytes()
    assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
    assert receipt['input_commit'] == inputs['input_commit'] and receipt['input_commit_tree'] == inputs['input_commit_tree']
    assert receipt['input_manifest_sha256'] == INPUT_SHA and receipt['input_bytes_and_head_unchanged'] is True
    assert receipt['command'] == 'lake env lean ' + inputs['exporter_path']
    assert receipt['argv'] == ['lake', 'env', 'lean', inputs['exporter_path']]
    assert receipt['output_sha256'] == sha(output)
    parser_path = R / inputs['parser']['path']
    assert sha(parser_path.read_bytes()) == inputs['parser']['sha256']
    spec = importlib.util.spec_from_file_location('unchanged_v3_expression_token_parser', parser_path)
    parser = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(parser)
    records, raw = parser.records(R / inputs['raw_stream_path'])
    assert len(records) == len({r['name'] for r in records})
    assert {r['module'] for r in records} == set(inputs['selected_modules'])
    assert not {r['name'] for r in records} & {r['name'] for r in old['records']}
    assert all(r['kind'] != 'axiom' for r in records)
    new_modules = {f['path'][:-5].replace('/', '.') for f in inputs['new_source_files']}
    new_records = [r for r in records if r['module'] in new_modules]
    assert len(new_records) == 10 and {r['name'] for r in new_records} == set(inputs['expected_authored_new_declarations'])
    assert output.decode().strip() == 'Chapter 1 declaration expressions exported: ' + str(len(records))
    result = {'schema': 1, 'artifact_kind': 'additional-native-declaration-fingerprints',
        'input_commit': inputs['input_commit'], 'input_commit_tree': inputs['input_commit_tree'],
        'normalization': inputs['normalization'], 'counting_note': old['counting_note'], 'hash_encoding': inputs['hash_encoding'],
        'selected_modules': inputs['selected_modules'], 'files': inputs['files'],
        'added_production_modules': [f['path'] for f in inputs['new_source_files']],
        'declaration_count': len(records), 'new_module_declaration_constants': len(new_records),
        'authored_new_declaration_count': 10, 'missing_reusable_owner_count': 13,
        'constant_kinds': dict(collections.Counter(r['kind'] for r in records)),
        'input_manifest': {'path': (F / 'inputs.json').relative_to(R).as_posix(), 'sha256': INPUT_SHA},
        'native_receipt': {'path': (F / 'native-exit.json').relative_to(R).as_posix(), 'sha256': sha((F / 'native-exit.json').read_bytes())},
        'native_output': {'path': (F / 'native-output.txt').relative_to(R).as_posix(), 'sha256': sha(output)},
        'native_raw_stream': {'path': inputs['raw_stream_path'], **raw},
        'prior_fingerprints': inputs['prior_fingerprints'], 'prior_owner_pins_verified_unchanged': 111,
        'exact_prior_serializer_preserved': True, 'exact_prior_token_parser_preserved': True,
        'records': records,
        'reuse_basis': 'Disjoint additive owner inventory. The 111 previous owner files retain exact source hashes. Thirteen absent reusable owners equal both the shared anchor and actual input commit. The native run freshly exports these thirteen owners and all eight new source wrappers. No old records or producer data are rewritten.',
        'commit_scope': inputs['commit_scope'],
        'consumer_scope': 'Pass together with current24b3 via repeated --fingerprints after both inventories and exact source bytes are committed in the selected lane. Origin blob verification must bind the later lane commit; this native input_commit must not be changed to a future commit.'}
    dest = F / 'additional-expression-fingerprints.json'
    write_new(dest, result)
    summary = {'schema': 1, 'status': 'PASS', 'frozen_at_utc': datetime.now(timezone.utc).isoformat(),
        'input_commit': inputs['input_commit'], 'input_manifest_sha256': INPUT_SHA,
        'fingerprints': {'path': dest.relative_to(R).as_posix(), 'sha256': sha(dest.read_bytes())},
        'native_exit_code': receipt['exit_code'], 'native_receipt_sha256': result['native_receipt']['sha256'],
        'native_output_sha256': result['native_output']['sha256'], 'raw_stream': result['native_raw_stream'],
        'owner_modules': 21, 'new_source_modules': 8, 'new_authored_declarations': 10,
        'total_constant_records': len(records), 'additional_reusable_constant_records': len(records) - 10,
        'prior_constant_records_untouched': len(old['records']), 'combined_disjoint_constant_records': len(old['records']) + len(records),
        'no_gate_source_or_git_mutations': True, 'final_commit_source_verification_pending': True}
    write_new(F / 'fingerprint-receipt.json', summary)
    print(json.dumps(summary))

if __name__ == '__main__': main()
