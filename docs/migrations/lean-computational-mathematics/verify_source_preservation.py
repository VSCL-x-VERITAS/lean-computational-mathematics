#!/usr/bin/env python3
"""Verify import-only identity changes against the immutable Git baseline.

Run from any directory. The default is a read-only check; --report writes the
explicitly selected JSON evidence path. No Lean compiler or dependency cache is
invoked. The baseline commit must remain available in the Git object database.
"""

from pathlib import Path
from datetime import datetime, timezone
import argparse, hashlib, io, json, re, subprocess, tarfile

DOCS = Path(__file__).resolve().parent
ROOT = DOCS.parents[2]
MAP_SHA = 'cbd53b282d8832245bb58b4c0d56958b6f15fb4810fd5da9cf748f24948429d5'
IMPORT_ORDER_MODULE = 'ComputationalMathematics.Source.Higham.Chapter14.Problem14'
IMPORT = re.compile(r'(?:(?:public|private|meta)\s+)*import[ \t]+([A-Za-z0-9_\'.]+)')

def header_imports(text):
    pos=0; found=[]; comments=[]
    while pos<len(text):
        if text[pos].isspace() or (pos==0 and text[pos]=='\ufeff'):
            pos+=1; continue
        if text.startswith('--',pos):
            start=pos; end=text.find('\n',pos); pos=len(text) if end<0 else end+1
            comments.append((start,pos)); continue
        if text.startswith('/-',pos):
            start=pos; pos+=2; depth=1
            while depth:
                opening=text.find('/-',pos); closing=text.find('-/',pos)
                assert closing>=0,'unclosed comment'
                if opening>=0 and opening<closing: depth+=1; pos=opening+2
                else: depth-=1; pos=closing+2
            comments.append((start,pos)); continue
        match=IMPORT.match(text,pos)
        if match:
            found.append(dict(module=match[1],start=match.start(1),end=match.end(1),command_start=pos))
            pos=match.end(); continue
        marker=re.match(r'(?:module|prelude)\b',text[pos:])
        if marker: pos+=marker.end(); continue
        break
    return found, comments

def canonical_bytes(raw, record, canonical):
    text=raw.decode('utf-8'); imports,_=header_imports(text)
    assert [r['module'] for r in imports]==record['imports_before']
    for r in reversed(imports):
        replacement=canonical.get(r['module'],r['module'])
        text=text[:r['start']]+replacement+text[r['end']:]
    assert [r['module'] for r in header_imports(text)[0]]==record['imports_after']
    return text.encode('utf-8')

def implementation_wrapper(raw, record):
    text=raw.decode('utf-8'); _,comments=header_imports(text)
    notices=[text[a:b] for a,b in comments if re.search(r'copyright|spdx|licensed under',text[a:b],re.I)]
    prefix='\n\n'.join(notices)
    if prefix: prefix+='\n\n'
    return (prefix+'import '+record['new_module']+'\n\n/-!\n'
        'Historical import path retained for compatibility.\n\n'
        'The implementation is provided by `'+record['new_module']+'`.\n'
        'Declaration names and mathematical terminology are unchanged.\n-/'+'\n').encode('utf-8')

def historical_wrapper(raw, record, forwarding):
    text=raw.decode('utf-8'); imports,_=header_imports(text); seen=set(); edits=[]
    assert [r['module'] for r in imports]==record['imports_before']
    for r in imports:
        targets=[]
        for target in forwarding.get(r['module'],[r['module']]):
            if target not in seen: seen.add(target); targets.append(target)
        if targets:
            edits.append((r['start'],r['end'],'\nimport '.join(targets)))
        else:
            edits.append((r['command_start'],r['end'],''))
    for a,b,replacement in reversed(edits): text=text[:a]+replacement+text[b:]
    assert [r['module'] for r in header_imports(text)[0]]==record['forwarding_imports']
    return text.encode('utf-8')


def baseline_sources(commit):
    process = subprocess.run(
        ['git', 'archive', commit, 'NumStability.lean', 'NumStability',
         'NumStabilityTest.lean', 'NumStabilityTest'],
        cwd=ROOT, capture_output=True, check=True)
    with tarfile.open(fileobj=io.BytesIO(process.stdout), mode='r:') as archive:
        return {member.name: archive.extractfile(member).read()
                for member in archive.getmembers() if member.isfile()}


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def import_order_adjustment(mapping):
    path = DOCS / 'import-order-adjustments.json'
    document = json.loads(path.read_text(encoding='utf-8'))
    assert document['schema_version'] == 1
    assert document['module_map_sha256'] == MAP_SHA
    assert document['baseline_commit'] == mapping['baseline_commit']
    assert len(document['adjustments']) == 1, 'only the reviewed aggregate may reorder imports'
    adjustment = document['adjustments'][0]
    record = next(r for r in mapping['implementation_modules'] if r['new_module'] == IMPORT_ORDER_MODULE)
    assert adjustment['module'] == IMPORT_ORDER_MODULE
    assert adjustment['path'] == record['new_path']
    assert adjustment['baseline_sha256'] == record['baseline_sha256']
    before = adjustment['imports_before']
    assert before == record['imports_after'] and len(before) == len(set(before)) == 14
    assert adjustment['imports_after'] == sorted(before)
    assert adjustment['permutation_zero_based'] == list(range(7, 14)) + list(range(7))
    assert [before[i] for i in adjustment['permutation_zero_based']] == adjustment['imports_after']
    return adjustment, sha(path.read_bytes())


def permute_reviewed_import_header(raw, adjustment):
    """Permit exactly the recorded 14 complete import lines, preserving all other bytes."""
    lines = raw.splitlines(keepends=True)
    before_header = b''.join(lines[:14])
    body = b''.join(lines[14:])
    assert [line.rstrip(b'\r\n').decode('utf-8') for line in lines[:14]] == [
        'import ' + name for name in adjustment['imports_before']]
    assert sha(raw) == adjustment['canonical_before_sha256']
    assert sha(before_header) == adjustment['header_before_sha256']
    assert sha(body) == adjustment['unchanged_body_sha256']
    after_header = b''.join(lines[index] for index in adjustment['permutation_zero_based'])
    result = after_header + body
    assert sha(after_header) == adjustment['header_after_sha256']
    assert sha(result) == adjustment['canonical_after_sha256']
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, help='Write the evidence JSON to this path.')
    args = parser.parse_args()
    failures = []

    def verify(condition, message):
        if not condition:
            failures.append(message)

    map_raw = (DOCS / 'module-map.json').read_bytes()
    verify(sha(map_raw) == MAP_SHA, 'module-map.json differs from the reviewed immutable map')
    mapping = json.loads(map_raw)
    order_adjustment, order_manifest_sha = import_order_adjustment(mapping)
    fixtures = json.loads((DOCS / 'fixture-inventory.json').read_text(encoding='utf-8'))
    baseline = baseline_sources(mapping['baseline_commit'])
    implementations = mapping['implementation_modules']
    historical = mapping['existing_compatibility_modules']
    records = implementations + historical
    canonical = {r['old_module']: r['new_module'] for r in implementations}
    forwarding = {r['old_module']: r['forwarding_imports'] for r in records}
    baseline_production = {p for p in baseline if p == 'NumStability.lean' or
        (p.startswith('NumStability/') and p.endswith('.lean'))}
    verify(baseline_production == {r['old_path'] for r in records},
        'baseline production inventory differs from the reviewed map')
    current_old = {p.relative_to(ROOT).as_posix() for p in (ROOT / 'NumStability').rglob('*.lean')}
    current_old.add('NumStability.lean')
    verify(current_old == baseline_production, 'historical module inventory changed')
    current_new = {p.relative_to(ROOT).as_posix() for p in (ROOT / 'ComputationalMathematics').rglob('*.lean')}
    current_new.add('ComputationalMathematics.lean')
    verify(current_new == {r['new_path'] for r in implementations},
        'canonical module inventory differs from the reviewed map')
    source_records = []
    token_count = 0
    copyright_count = 0
    external_count = 0
    for record in records:
        old = record['old_module']; before = baseline[record['old_path']]
        verify(sha(before) == record['baseline_sha256'],
            record['old_path'] + ': baseline hash differs')
        expected_old = (implementation_wrapper(before, record) if old in canonical else
            historical_wrapper(before, record, forwarding))
        verify((ROOT / record['old_path']).read_bytes() == expected_old,
            record['old_path'] + ': forwarding source differs from the exact expected transformation')
        if old not in canonical:
            continue
        expected = canonical_bytes(before, record, canonical)
        if record['new_module'] == IMPORT_ORDER_MODULE:
            expected = permute_reviewed_import_header(expected, order_adjustment)
            verify(sha(expected_old) == order_adjustment['unchanged_forwarder_sha256'],
                record['old_path'] + ': documented import-order adjustment changed the forwarder')
        actual = (ROOT / record['new_path']).read_bytes()
        verify(actual == expected, record['new_path'] + ': change outside permitted import tokens or the one exact reviewed import permutation')
        verify(not any(i['module'] == 'NumStability' or i['module'].startswith('NumStability.')
            for i in header_imports(actual.decode('utf-8'))[0]),
            record['new_path'] + ': canonical production imports a historical module')
        token_count += sum(i in canonical for i in record['imports_before'])
        external_count += sum(i not in canonical for i in record['imports_before'])
        comments = header_imports(before.decode('utf-8'))[1]
        copyright_count += any(re.search(r'copyright|spdx|licensed under',
            before.decode('utf-8')[a:b], re.I) for a,b in comments)
        source_records.append({'old_module': old, 'new_module': record['new_module'],
            'baseline_sha256': sha(before), 'canonical_sha256': sha(actual),
            'historical_forwarder_sha256': sha(expected_old)})
    original_tests = {p: raw for p, raw in baseline.items()
        if p.startswith('NumStabilityTest/') and p.endswith('.lean')}
    for relative, before in original_tests.items():
        verify((ROOT / relative).read_bytes() == before,
            relative + ': pre-existing test source changed')
    aggregate = fixtures['test_root_added_import']
    original_root = baseline['NumStabilityTest.lean'].decode('utf-8')
    insertion = header_imports(original_root)[0][-1]['end']
    expected_root = (original_root[:insertion] + '\nimport ' + aggregate + original_root[insertion:]).encode('utf-8')
    verify((ROOT / 'NumStabilityTest.lean').read_bytes() == expected_root,
        'NumStabilityTest.lean differs beyond its one documented aggregate import')
    for relative, digest in fixtures['generated_files'].items():
        verify((ROOT / relative).is_file() and sha((ROOT / relative).read_bytes()) == digest,
            relative + ': generated regression fixture differs from its inventory hash')
    report = {'schema_version': 1, 'checked_at_utc': datetime.now(timezone.utc).isoformat(),
        'baseline_commit': mapping['baseline_commit'], 'module_map_sha256': sha(map_raw),
        'import_order_adjustments_sha256': order_manifest_sha,
        'status': 'PASS' if not failures else 'FAIL',
        'claim': 'All canonical bytes are preserved except exact initial import module tokens and one documented 14-import header permutation; authored declaration names, mathematical bodies, documentation, and attribution remain unchanged.',
        'counts': {'canonical_modules': len(implementations), 'historical_forwarders': len(records),
            'existing_wrapper_comment_bodies_preserved': len(historical),
            'canonical_import_tokens_rewritten': token_count, 'external_import_tokens_preserved': external_count,
            'import_order_adjusted_aggregates': 1, 'import_order_permuted_header_lines': 14,
            'new_wrappers_with_retained_license_notices': copyright_count,
            'existing_test_files_preserved': len(original_tests),
            'generated_test_files_checked': len(fixtures['generated_files']),
            'test_root_added_imports': 1},
        'limitations': ['This is a source preservation gate. Lean compilation and downstream behavior require separate validation.'],
        'import_order_adjustments': [{'module': IMPORT_ORDER_MODULE,
            'manifest': 'import-order-adjustments.json',
            'unchanged_body_sha256': order_adjustment['unchanged_body_sha256']}],
        'failures': failures, 'canonical_sources': source_records}
    if args.report:
        args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(json.dumps({k:v for k,v in report.items() if k != 'canonical_sources'}, indent=2))
    return 1 if failures else 0


if __name__ == '__main__':
    raise SystemExit(main())
