#!/usr/bin/env python3
"""Verify exact mapped identity changes against the immutable Git baseline.

Run from any directory. The default is a read-only check; --report writes the
explicitly selected JSON evidence path. No Lean compiler or dependency cache is
invoked. The baseline commit must remain available in the Git object database.
"""

from pathlib import Path
from datetime import datetime, timezone
import argparse, copy, hashlib, io, json, re, subprocess, tarfile

DOCS = Path(__file__).resolve().parent
ROOT = DOCS.parents[2]
MAP_SHA = 'cbd53b282d8832245bb58b4c0d56958b6f15fb4810fd5da9cf748f24948429d5'
IMPORT_ORDER_MODULE = 'ComputationalMathematics.Source.Higham.Chapter14.Problem14'
FORWARDER_HEADER_MODULE = 'NumStability.Source.Higham.Chapter11.Theorem07.Core.Results'
PRIVATE_ADAPTER = 'NumStabilityTest.Reorganization.ProjectIdentityPrivateNames'
PRIVATE_ADAPTER_TEST = PRIVATE_ADAPTER + 'Test'
PRIVATE_TEMPLATE_SHA = 'cfb3edfa6825d3e1d6d59f87a3362e87d974fac3bc19d18d8aa4b32a4d7070a4'
PRIVATE_TEST_SHA = '95f8d39351c9fbd87a12f3e458471103d642d84cfdf42ae0404758cc5625a9b3'
PUBLIC_INSTANCE_MODULE = 'ComputationalMathematics.Analysis.Equidistribution.AddCircle'
PUBLIC_INSTANCE_NAME = 'NumStability.instFactLtRealOfNat_numStability'
PUBLIC_INSTANCE_INSERTION = 'instFactLtRealOfNat_numStability '
PUBLIC_INSTANCE_BEFORE_SHA = '2384ebfc9dd635eaa8c2f9a58e3c5fd46ecbdd857a1fe8aa96cd5b60c6b172c2'
PUBLIC_INSTANCE_TEST = 'NumStabilityTest.Import.ProjectIdentity.GeneratedInstanceName'
PUBLIC_INSTANCE_TEST_SHA = '5e24035e5c8cb9b25f2dc38e8bd056feb76c7b36fb903fa408cea2a6930adaff'
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


def forwarder_header_adjustment(mapping):
    path = DOCS / 'forwarder-header-adjustments.json'
    document = json.loads(path.read_text(encoding='utf-8'))
    assert document['schema_version'] == 1
    assert document['module_map_sha256'] == MAP_SHA
    assert document['baseline_commit'] == mapping['baseline_commit']
    assert document['failed_candidate'] == 'abceba9f3f45f5432ed24ed9ba3902f7bd5d5bbf'
    assert len(document['adjustments']) == 1, 'only the reviewed generated forwarder may relocate its import'
    adjustment = document['adjustments'][0]
    record = next(r for r in mapping['implementation_modules'] if r['old_module'] == FORWARDER_HEADER_MODULE)
    assert adjustment['module'] == FORWARDER_HEADER_MODULE
    assert adjustment['path'] == record['old_path']
    assert adjustment['target_module'] == record['new_module']
    assert adjustment['baseline_sha256'] == record['baseline_sha256']
    assert adjustment['permutation'] == ['import', 'retained_notices', 'compatibility_documentation']
    return adjustment, sha(path.read_bytes())


def relocate_reviewed_forwarder_import(raw, adjustment):
    """Move the one import before the preserved module-doc notice, changing no bytes."""
    marker = ('import ' + adjustment['target_module'] + '\n\n').encode('utf-8')
    assert sha(raw) == adjustment['before_sha256']
    assert raw.count(marker) == 1
    prefix, suffix = raw.split(marker)
    assert prefix.startswith(b'/-!') and prefix.endswith(b'\n\n')
    assert sha(marker) == adjustment['moved_import_sha256']
    assert sha(prefix) == adjustment['preserved_prefix_sha256']
    assert sha(suffix) == adjustment['preserved_suffix_sha256']
    result = marker + prefix + suffix
    assert sha(result) == adjustment['after_sha256']
    return result


def validate_public_instance_document(document, mapping):
    assert document['schema_version'] == 1
    assert document['baseline_commit'] == mapping['baseline_commit']
    assert document['module_map_sha256'] == MAP_SHA
    assert document['failed_candidate'] == 'feb121c8813abc72f6e6ea1f419e8fe5427dfb43'
    assert document['failed_run_id'] == 34012018278
    assert len(document['adjustments']) == 1, 'only the one observed public instance may be named'
    adjustment = document['adjustments'][0]
    record = next(r for r in mapping['implementation_modules'] if r['new_module'] == PUBLIC_INSTANCE_MODULE)
    for key, expected in [('module', record['new_module']), ('path', record['new_path']),
                          ('old_module', record['old_module']), ('old_path', record['old_path']),
                          ('baseline_sha256', record['baseline_sha256'])]:
        assert adjustment[key] == expected, 'public instance adjustment is outside the exact map'
    assert adjustment['baseline_public_name'] == PUBLIC_INSTANCE_NAME
    assert adjustment['observed_migrated_name'] == 'NumStability.instFactLtRealOfNat_computationalMathematics'
    return adjustment


def public_instance_adjustment(mapping):
    path = DOCS / 'public-instance-name-adjustments.json'
    document = json.loads(path.read_text(encoding='utf-8'))
    validate_public_instance_document(document, mapping)
    return document, sha(path.read_bytes())


def name_reviewed_public_instance(raw, adjustment):
    """Insert only the baseline public name at its exact anonymous-instance boundary."""
    marker = 'instance : Fact (0 < (1 : ℝ)) := ⟨by norm_num⟩'.encode('utf-8')
    assert sha(raw) == adjustment['canonical_before_sha256'] == PUBLIC_INSTANCE_BEFORE_SHA
    assert raw.count(marker) == 1
    offset = raw.index(marker) + len(b'instance ')
    assert adjustment['insertion'] == {'byte_offset': offset, 'insert_utf8': PUBLIC_INSTANCE_INSERTION}
    prefix, suffix = raw[:offset], raw[offset:]
    assert sha(prefix) == adjustment['unchanged_prefix_sha256']
    assert sha(suffix) == adjustment['unchanged_suffix_sha256']
    inserted = PUBLIC_INSTANCE_INSERTION.encode('utf-8')
    result = prefix + inserted + suffix
    assert sha(result) == adjustment['canonical_after_sha256']
    assert result[:offset] + result[offset + len(inserted):] == raw
    return result


def validate_public_instance_regression(document, expected_root):
    test = document['standalone_test']
    assert test['module'] == PUBLIC_INSTANCE_TEST
    assert test['path'] == PUBLIC_INSTANCE_TEST.replace('.', '/') + '.lean'
    source = test['source_utf8'].encode('utf-8')
    assert sha(source) == test['sha256'] == PUBLIC_INSTANCE_TEST_SHA
    root = document['test_root']
    assert root['path'] == 'NumStabilityTest.lean' and root['before_sha256'] == sha(expected_root)
    marker = b'import NumStabilityTest.Import.ProjectIdentity\n'
    assert expected_root.count(marker) == 1
    offset = expected_root.index(marker) + len(marker)
    inserted = 'import ' + PUBLIC_INSTANCE_TEST + '\n'
    assert root['insertion'] == {'byte_offset': offset, 'insert_utf8': inserted}
    result = expected_root[:offset] + inserted.encode('utf-8') + expected_root[offset:]
    assert sha(result) == root['after_sha256']
    assert result[:offset] + result[offset + len(inserted.encode('utf-8')):] == expected_root
    return {test['path']: source, 'NumStabilityTest.lean': result}


def public_instance_self_test(document, mapping, before, expected_root):
    adjustment = validate_public_instance_document(document, mapping)
    name_reviewed_public_instance(before, adjustment)
    validate_public_instance_regression(document, expected_root)
    mutations = []
    for key, value in [('module_map_sha256', '0' * 64), ('failed_run_id', 1)]:
        changed = copy.deepcopy(document); changed[key] = value; mutations.append(changed)
    for key, value in [('module', PUBLIC_INSTANCE_MODULE + '.Unapproved'), ('baseline_sha256', '0' * 64),
                       ('baseline_public_name', PUBLIC_INSTANCE_NAME + 'Changed'),
                       ('canonical_after_sha256', '0' * 64), ('unchanged_suffix_sha256', '0' * 64)]:
        changed = copy.deepcopy(document); changed['adjustments'][0][key] = value; mutations.append(changed)
    changed = copy.deepcopy(document); changed['adjustments'].append(copy.deepcopy(changed['adjustments'][0])); mutations.append(changed)
    changed = copy.deepcopy(document); changed['adjustments'][0]['insertion']['byte_offset'] += 1; mutations.append(changed)
    changed = copy.deepcopy(document); changed['adjustments'][0]['insertion']['insert_utf8'] += 'unapproved '; mutations.append(changed)
    changed = copy.deepcopy(document); changed['standalone_test']['source_utf8'] = changed['standalone_test']['source_utf8'].replace('some 1000', 'some 999')
    changed['standalone_test']['sha256'] = sha(changed['standalone_test']['source_utf8'].encode()); mutations.append(changed)
    changed = copy.deepcopy(document); changed['test_root']['insertion']['insert_utf8'] += 'import Unapproved\n'; mutations.append(changed)
    changed = copy.deepcopy(document); changed['test_root']['insertion']['byte_offset'] += 1; mutations.append(changed)
    for mutation in mutations:
        try:
            current = validate_public_instance_document(mutation, mapping)
            name_reviewed_public_instance(before, current)
            validate_public_instance_regression(mutation, expected_root)
        except AssertionError:
            pass
        else:
            raise AssertionError('unapproved public instance/test/root adjustment accepted')
    # Forged hashes cannot make a changed instance type, proof or attribute eligible.
    for changed_raw in [before.replace(b'0 < (1', b'0 <= (1'),
                        before.replace(b'by norm_num', b'by positivity'),
                        before.replace(b'instance : Fact', b'@[simp] instance : Fact')]:
        forged = copy.deepcopy(adjustment); forged['canonical_before_sha256'] = sha(changed_raw)
        try:
            name_reviewed_public_instance(changed_raw, forged)
        except AssertionError:
            pass
        else:
            raise AssertionError('changed mathematics or attributes admitted through forged manifest hashes')
    print('Public instance preservation self-test passed: 16 map/name/insertion/test/root/type/proof/attribute mutations rejected')


def private_authority_rows(raw, kind):
    pattern = (rb'private def ' + kind.encode() +
        rb'PrivateNames\s*:\s*List Lean\.Name\s*:=\s*\[(.*?)\r?\n\]')
    match = re.search(pattern, raw, re.S)
    if match is None:
        assert kind == 'retired', 'approved authority list missing'
        return [], b''
    row = re.compile(rb'(?:mangledPrivateName|approvedPrivateName) "([^"]+)" "([^"]+)"(?: (\d+))?')
    assert not row.sub(b'', match[1]).strip(b' \t\r\n,'), 'unparsed private authority row'
    return [(a.decode(), b.decode(), int(c or b'0')) for a, b, c in row.findall(match[1])], match[0]


def public_probe_lines(raw):
    return re.findall(rb'(?m)^#(?:check|synth|print|eval|guard)[^\r\n]*(?:\r?\n|$)', raw)


def private_insert(raw, offset, text, kind, operations):
    """The reviewed allowance consists only of additions at derived byte positions."""
    assert 0 <= offset <= len(raw)
    operations.append({'kind': kind, 'byte_offset': offset, 'insert_utf8': text})
    return raw[:offset] + text.encode('utf-8') + raw[offset:]


def expected_private_fixture(raw):
    newline = '\r\n' if b'\r\n' in raw else '\n'
    text = raw.decode('utf-8')
    last = header_imports(text)[0][-1]
    end = text.index('\n', last['end']) + 1
    operations = []
    result = private_insert(raw, len(text[:end].encode('utf-8')),
        'import ' + PRIVATE_ADAPTER + newline, 'adapter_import', operations)
    marker = ('  for name in approvedPrivateNames do' + newline).encode()
    assert result.count(marker) == 1
    result = private_insert(result, result.index(marker) + len(marker),
        '    let name ← ' + PRIVATE_ADAPTER + '.requireMapped name' + newline,
        'approved_owner_lookup', operations)
    retired = re.search(rb'  for name in retiredPrivateNames do\r?\n'
        rb'    if Lean\.Environment\.contains environment name then\r?\n'
        rb'      throwError "[^\r\n]+"(?:\r?\n|$)', result)
    assert bool(retired) == bool(private_authority_rows(raw, 'retired')[0])
    if retired:
        old_absence_check = retired[0]
        result = private_insert(result, retired.end(),
            '    if let some mappedName := ' + PRIVATE_ADAPTER + '.migrate? name then' + newline +
            '      if Lean.Environment.contains environment mappedName then' + newline +
            '        throwError "private normalization: canonical retired name {mappedName} still present"' + newline,
            'mapped_retired_absence', operations)
        assert result.count(old_absence_check) == 1, 'original retired absence check changed'
    for kind in ['approved', 'retired']:
        assert private_authority_rows(result, kind) == private_authority_rows(raw, kind)
    assert public_probe_lines(result) == public_probe_lines(raw)
    imports = [r['module'] for r in header_imports(result.decode('utf-8'))[0]]
    assert imports.count(PRIVATE_ADAPTER) == 1
    assert [m for m in imports if m != PRIVATE_ADAPTER] == [
        r['module'] for r in header_imports(raw.decode('utf-8'))[0]]
    return result, operations


def validate_private_adjustments(document, mapping, original_tests, expected_root):
    assert document['schema_version'] == 1
    assert document['baseline_commit'] == mapping['baseline_commit']
    assert document['failed_candidate'] == 'abceba9f3f45f5432ed24ed9ba3902f7bd5d5bbf'
    assert document['module_map_sha256'] == MAP_SHA
    assert document['adapter_module'] == PRIVATE_ADAPTER
    assert document['standalone_test_module'] == PRIVATE_ADAPTER_TEST
    paths = sorted(p for p, raw in original_tests.items() if b'private def approvedPrivateNames' in raw)
    assert len(paths) == 21 and [r['path'] for r in document['fixtures']] == paths
    owners = set(); approved_owners = set(); approved_count = retired_count = mapped_retired = 0
    canonical = {r['old_module']: r['new_module'] for r in mapping['implementation_modules']}
    expected = {}
    for record in document['fixtures']:
        relative = record['path']; raw = original_tests[relative]
        result, operations = expected_private_fixture(raw)
        # Recorded edits cannot grant arbitrary text substitutions: derive every
        # insertion from trusted baseline syntax and then require exact replay.
        assert record['insertions'] == operations, relative + ': unapproved edit operation'
        replay = raw
        for operation in record['insertions']:
            offset = operation['byte_offset']
            replay = replay[:offset] + operation['insert_utf8'].encode('utf-8') + replay[offset:]
        assert replay == result and sha(raw) == record['before_sha256'] and sha(result) == record['after_sha256']
        approved, approved_block = private_authority_rows(raw, 'approved')
        retired, retired_block = private_authority_rows(raw, 'retired')
        assert record['approved_rows'] == len(approved) and record['retired_rows'] == len(retired)
        assert record['approved_authority_sha256'] == sha(approved_block)
        assert record['retired_authority_sha256'] == sha(retired_block)
        assert record['public_probe_lines_sha256'] == sha(b''.join(public_probe_lines(raw)))
        assert all(owner in canonical for owner, _, _ in approved), 'unknown approved owner'
        owners.update(row[0] for row in approved + retired)
        approved_owners.update(row[0] for row in approved)
        approved_count += len(approved); retired_count += len(retired)
        mapped_retired += sum(row[0] in canonical for row in retired)
        expected[relative] = result
    pairs = [{'old_module': owner, 'new_module': canonical[owner]}
             for owner in sorted(owners & canonical.keys())]
    helper = document['helper']; test = document['standalone_test']
    assert helper['path'] == PRIVATE_ADAPTER.replace('.', '/') + '.lean'
    assert helper['owner_pairs'] == pairs, 'helper table is not the exact map-backed authority intersection'
    template = helper['template_utf8']
    assert sha(template.encode('utf-8')) == helper['template_sha256'] == PRIVATE_TEMPLATE_SHA
    assert template.count('__EXACT_OWNER_PAIRS__') == 1
    entries = ',\n'.join('  (' + json.dumps(p['old_module']) + ', ' + json.dumps(p['new_module']) + ')' for p in pairs)
    expected[helper['path']] = template.replace('__EXACT_OWNER_PAIRS__', entries).encode('utf-8')
    assert sha(expected[helper['path']]) == helper['sha256']
    assert test['path'] == PRIVATE_ADAPTER_TEST.replace('.', '/') + '.lean'
    expected[test['path']] = test['source_utf8'].encode('utf-8')
    assert sha(expected[test['path']]) == test['sha256'] == PRIVATE_TEST_SHA
    root = document['test_root']; root_operations = []
    assert root['path'] == 'NumStabilityTest.lean' and root['before_sha256'] == sha(expected_root)
    marker = b'import NumStabilityTest.Reorganization.R01'
    assert expected_root.count(marker) == 1
    newline = '\r\n' if b'\r\n' in expected_root else '\n'
    expected['NumStabilityTest.lean'] = private_insert(expected_root, expected_root.index(marker),
        'import ' + PRIVATE_ADAPTER_TEST + newline, 'standalone_adapter_test_import', root_operations)
    assert root['insertions'] == root_operations and root['after_sha256'] == sha(expected['NumStabilityTest.lean'])
    counts = {'fixtures': len(paths), 'approved_rows': approved_count, 'retired_rows': retired_count,
        'owner_pairs': len(pairs), 'approved_owners': len(approved_owners), 'mapped_retired_rows': mapped_retired}
    assert document['counts'] == counts
    return expected, counts


def private_adjustment_self_test(document, mapping, original_tests, expected_root):
    validate_private_adjustments(document, mapping, original_tests, expected_root)
    mutations = []
    changed = copy.deepcopy(document); changed['fixtures'][0]['insertions'][0]['byte_offset'] += 1
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['fixtures'][0]['insertions'].pop()
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['fixtures'][1]['insertions'].pop()
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['fixtures'][0]['approved_authority_sha256'] = '0' * 64
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['fixtures'][0]['public_probe_lines_sha256'] = '0' * 64
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['helper']['owner_pairs'][0]['new_module'] += '.Unapproved'
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['helper']['owner_pairs'].pop()
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['helper']['template_utf8'] = changed['helper']['template_utf8'].replace('throwError', 'pure')
    changed['helper']['template_sha256'] = sha(changed['helper']['template_utf8'].encode())
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['standalone_test']['source_utf8'] += '-- altered\n'
    changed['standalone_test']['sha256'] = sha(changed['standalone_test']['source_utf8'].encode())
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['test_root']['insertions'][0]['insert_utf8'] += 'import Unapproved\n'
    mutations.append(changed)
    changed = copy.deepcopy(document); changed['fixtures'].pop()
    mutations.append(changed)
    for mutation in mutations:
        try:
            validate_private_adjustments(mutation, mapping, original_tests, expected_root)
        except AssertionError:
            pass
        else:
            raise AssertionError('unapproved private-fixture mutation was accepted')
    print('Private fixture preservation self-test passed: 11 edit/map/authority/probe/template/coverage mutations rejected')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, help='Write the evidence JSON to this path.')
    parser.add_argument('--self-test', action='store_true', help='Test the strict live-fixture and public-instance insertion allowances without compiling Lean.')
    args = parser.parse_args()
    failures = []

    def verify(condition, message):
        if not condition:
            failures.append(message)

    map_raw = (DOCS / 'module-map.json').read_bytes()
    verify(sha(map_raw) == MAP_SHA, 'module-map.json differs from the reviewed immutable map')
    mapping = json.loads(map_raw)
    order_adjustment, order_manifest_sha = import_order_adjustment(mapping)
    header_adjustment, header_manifest_sha = forwarder_header_adjustment(mapping)
    instance_document, instance_manifest_sha = public_instance_adjustment(mapping)
    instance_adjustment = instance_document['adjustments'][0]
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
        if old == FORWARDER_HEADER_MODULE:
            expected_old = relocate_reviewed_forwarder_import(expected_old, header_adjustment)
        verify((ROOT / record['old_path']).read_bytes() == expected_old,
            record['old_path'] + ': forwarding source differs from the exact expected transformation')
        if old not in canonical:
            continue
        expected = canonical_bytes(before, record, canonical)
        if record['new_module'] == IMPORT_ORDER_MODULE:
            expected = permute_reviewed_import_header(expected, order_adjustment)
            verify(sha(expected_old) == order_adjustment['unchanged_forwarder_sha256'],
                record['old_path'] + ': documented import-order adjustment changed the forwarder')
        if record['new_module'] == PUBLIC_INSTANCE_MODULE:
            public_instance_before = expected
            expected = name_reviewed_public_instance(expected, instance_adjustment)
            verify(sha(expected_old) == instance_adjustment['unchanged_forwarder_sha256'],
                record['old_path'] + ': explicit public instance name changed the forwarder')
        actual = (ROOT / record['new_path']).read_bytes()
        verify(actual == expected, record['new_path'] + ': change outside exact import mapping, reviewed import permutation or baseline public-instance-name insertion')
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
    aggregate = fixtures['test_root_added_import']
    original_root = baseline['NumStabilityTest.lean'].decode('utf-8')
    insertion = header_imports(original_root)[0][-1]['end']
    expected_root = (original_root[:insertion] + '\nimport ' + aggregate + original_root[insertion:]).encode('utf-8')
    private_manifest_path = DOCS / 'live-private-name-adjustments.json'
    private_document = json.loads(private_manifest_path.read_text(encoding='utf-8'))
    private_expected, private_counts = validate_private_adjustments(private_document, mapping, original_tests, expected_root)
    instance_expected = validate_public_instance_regression(instance_document, private_expected['NumStabilityTest.lean'])
    if args.self_test:
        private_adjustment_self_test(private_document, mapping, original_tests, expected_root)
        public_instance_self_test(instance_document, mapping, public_instance_before, private_expected['NumStabilityTest.lean'])
    for relative, before in original_tests.items():
        verify((ROOT / relative).read_bytes() == private_expected.get(relative, before),
            relative + ': pre-existing test source differs outside exact private-owner adapter insertions')
    for relative, expected in {**private_expected, **instance_expected}.items():
        verify((ROOT / relative).is_file() and (ROOT / relative).read_bytes() == expected,
            relative + ': live identity regression differs from its exact replay/map-bound source')
    for relative, digest in fixtures['generated_files'].items():
        verify((ROOT / relative).is_file() and sha((ROOT / relative).read_bytes()) == digest,
            relative + ': generated regression fixture differs from its inventory hash')
    report = {'schema_version': 1, 'checked_at_utc': datetime.now(timezone.utc).isoformat(),
        'baseline_commit': mapping['baseline_commit'], 'module_map_sha256': sha(map_raw),
        'import_order_adjustments_sha256': order_manifest_sha,
        'forwarder_header_adjustments_sha256': header_manifest_sha,
        'live_private_name_adjustments_sha256': sha(private_manifest_path.read_bytes()),
        'public_instance_name_adjustments_sha256': instance_manifest_sha,
        'status': 'PASS' if not failures else 'FAIL',
        'claim': 'All canonical bytes are preserved except exact initial import module tokens, one documented 14-import header permutation, and one insertion explicitly preserving the baseline generated public instance name; mathematical bodies, authored names, documentation and attribution remain unchanged.',
        'counts': {'canonical_modules': len(implementations), 'historical_forwarders': len(records),
            'existing_wrapper_comment_bodies_preserved': len(historical),
            'canonical_import_tokens_rewritten': token_count, 'external_import_tokens_preserved': external_count,
            'import_order_adjusted_aggregates': 1, 'import_order_permuted_header_lines': 14,
            'generated_forwarder_imports_relocated_before_preserved_module_docs': 1,
            'baseline_public_instance_names_explicitly_preserved': 1,
            'public_instance_name_regression_test_files': 1,
            'new_wrappers_with_retained_license_notices': copyright_count,
            'existing_test_files_byte_preserved': len(original_tests) - private_counts['fixtures'],
            'existing_test_files_with_authority_content_preserved': len(original_tests),
            'live_private_name_fixtures_adapted': private_counts['fixtures'],
            'approved_private_names_checked_after_exact_owner_translation': private_counts['approved_rows'],
            'original_retired_private_name_absence_checks_preserved': private_counts['retired_rows'],
            'canonical_retired_private_name_absence_checks_added': private_counts['mapped_retired_rows'],
            'exact_private_owner_pairs': private_counts['owner_pairs'],
            'private_adapter_and_standalone_test_files': 2,
            'generated_test_files_checked': len(fixtures['generated_files']),
            'test_root_added_imports': 3},
        'limitations': ['This is a source preservation gate. Lean compilation and downstream behavior require separate validation.'],
        'import_order_adjustments': [{'module': IMPORT_ORDER_MODULE,
            'manifest': 'import-order-adjustments.json',
            'unchanged_body_sha256': order_adjustment['unchanged_body_sha256']}],
        'public_instance_name_adjustments': {'manifest': 'public-instance-name-adjustments.json',
            'module': PUBLIC_INSTANCE_MODULE, 'baseline_public_name': PUBLIC_INSTANCE_NAME,
            'scope': 'Only the exact identifier is inserted after the baseline anonymous instance keyword; type, proof, attributes, registration and all other bytes remain unchanged.',
            'standalone_test_sha256': PUBLIC_INSTANCE_TEST_SHA},
        'live_private_name_adjustments': {'manifest': 'live-private-name-adjustments.json',
            'scope': 'Only exact adapter imports/helper-call insertions; all authority row bytes, ordinals, authored suffixes, public probes and original retired absence checks remain unchanged.',
            'helper_template_sha256': PRIVATE_TEMPLATE_SHA, 'standalone_test_sha256': PRIVATE_TEST_SHA},
        'failures': failures, 'canonical_sources': source_records}
    if args.report:
        args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(json.dumps({k:v for k,v in report.items() if k != 'canonical_sources'}, indent=2))
    return 1 if failures else 0


if __name__ == '__main__':
    raise SystemExit(main())
