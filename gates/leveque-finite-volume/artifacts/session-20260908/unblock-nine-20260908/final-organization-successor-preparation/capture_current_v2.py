"""Additive configurable successor: read-only current source/Git capture, never certification."""
import collections
import json
import re
from support import *

def main():
    args, R, P, c, config_ref, guard, head, template, campaign, engine = setup('capture')
    source, modules = engine.scan_sources(R)
    graph = read(guard.bind(c['graph']['json']))
    require(source['source_tree_sha256'] == graph['source']['source_tree_sha256'] == c['source_tree_sha256'],
            'current scanner, graph, and config source hashes differ')
    require(len(modules) == c['expected_counts']['production_modules'], 'production count mismatch')
    by_name, by_path = {m.name:m for m in modules}, {m.path:m for m in modules}
    all_pins = [guard.pin(R/m.path) for m in modules]
    starts = {n for n in by_name if any(n == prefix or n.startswith(prefix+'.') for prefix in PREFIXES)}
    require(starts, 'empty Chapter01 source census')
    records, owners = {}, {}
    for entry in c['fingerprints']:
        fp = read(guard.bind(entry['inventory']))
        require(len(fp['records']) == entry['expected_records'] and len(fp['files']) == entry['expected_files'],
                'per-inventory native count mismatch')
        require(len({x['path'] for x in fp['files']}) == len(fp['files']), 'duplicate native owner in inventory')
        require(len({x['name'] for x in fp['records']}) == len(fp['records']), 'duplicate native record in inventory')
        for item in fp['files']:
            owner_ref = {'path':item['path'], 'sha256':item['sha256']}
            guard.bind(owner_ref)
            require(item['path'] in by_path, 'native owner outside actual production census')
            owners[item['path']] = item['sha256']
        for record in fp['records']:
            require(record['module'] in by_name and by_name[record['module']].path in owners,
                    'native constant has no pinned owner')
            if record['name'] in records: require(records[record['name']] == record, 'conflicting native records')
            records[record['name']] = record
    require(len(records) == c['expected_counts']['native_constants'] and
            len(owners) == c['expected_counts']['native_owners'], 'merged native counts mismatch')
    closure, todo = set(), list(starts | {by_path[p].name for p in owners})
    while todo:
        name = todo.pop()
        if name in closure: continue
        closure.add(name)
        todo.extend(n for n in by_name[name].imports if n in by_name and n not in closure)
    unit_paths = sorted(by_name[n].path for n in closure)
    changed = changed_sources(R, c['anchor'], by_path)
    require(set(changed) <= set(unit_paths) | set(c['aggregate_boundaries']), 'changed source outside unit/exposure scope')
    covered = {p for item in c['placement_reviews'] for p in item['covered_source_paths']}
    require(set(changed) <= covered, 'actual changed paths lack explicit reviewed-placement coverage')
    require(covered <= set(by_path), 'reviewed coverage names nonexistent production paths')
    executions = {key:execution(guard, c['checker_executions'][key], head, template['tools'][key]['path']) for key in CHECKS}
    gate = read(guard.bind(c['gate']))
    rows = gate['rows']
    require(len({row['id'] for row in rows}) == len(rows), 'duplicate gate row')
    skipped = [row for row in rows if row['status'] == 'SKIPPED']
    formal = [row for row in rows if row['status'] != 'SKIPPED']
    counts = c['expected_counts']
    require((len(rows), len(formal), len(skipped)) == (counts['total_rows'], counts['formalizable_rows'], counts['skipped_rows']),
            'full gate row census mismatch')
    prospective = read(guard.bind(c['complete_declaration_manifest']))
    require(set(prospective['rows']) == {row['id'] for row in formal}, 'complete declaration row set differs')
    declaration_owners = {}
    for item in prospective['files']:
        guard.bind({'path':item['path'], 'sha256':item['sha256']})
        require(item['path'] in by_path, 'target owner outside source census')
        for name in item['declarations']:
            require(name not in declaration_owners, 'duplicate declaration owner')
            declaration_owners[name] = item['path']
    require(set(prospective['declarations']) == set(declaration_owners) and
            len(prospective['declarations']) == len(declaration_owners), 'complete declaration list mismatch')
    check_ref = {'path':prospective['check_file'], 'sha256':prospective['check_file_sha256']}
    check_text = guard.bind(check_ref).read_text()
    complete_execution = execution(guard, c['complete_native'], head, check_ref['path'])
    output = guard.bind(c['complete_native']['output']).read_text()
    reports = {}
    for name, body in re.findall(r"'([^']+)' depends on axioms: \[([^]]*)\]", output):
        require(name not in reports, 'repeated native axiom report')
        reports[name] = {x.strip() for x in body.split(',') if x.strip()}
    for name in re.findall(r"'([^']+)' does not depend on any axioms", output):
        require(name not in reports, 'repeated empty native axiom report'); reports[name] = set()
    allowed = {x['name'] for x in read(guard.bind(template['tools']['axiom_policy']))['allowed_axioms']}
    require('sorryAx' not in allowed and 'sorryAx' not in output, 'forbidden placeholder axiom')
    target_rows = []
    for row in formal:
        target = prospective['rows'][row['id']]
        name, path = target['declaration'], target['path']
        require(declaration_owners.get(name) == path, 'row target/owner mismatch')
        require(name in records and records[name]['module'] == by_path[path].name, 'target absent from native fingerprint closure')
        require(name in reports and reports[name] <= allowed, 'missing or unapproved target axioms')
        for directive in ('check', 'print axioms'):
            require(re.search(r'^#'+directive+r'\s+'+re.escape(name)+r'\s*$', check_text, re.M), 'native check input omits exact target')
        target_rows.append({'row_id':row['id'], 'current_gate_status_observed':row['status'],
            'proposed_owner':path, 'proposed_declaration':name, 'classification_observed':row.get('classification'),
            'source_contract_sha256_observed':row.get('source_contract_sha256'),
            'current_gate_declarations_observed':row.get('lean_declarations', [])})
    groups = collections.defaultdict(list)
    for rec in records.values():
        if any(rec['module'] == prefix or rec['module'].startswith(prefix+'.') for prefix in PREFIXES):
            groups[(rec['type_sha256'], rec['value_sha256'])].append(rec['name'])
    same = [sorted(names) for names in groups.values() if len(names)>1]
    policy_path = guard.bind(template['tools']['layout_policy'])
    baseline_raw = git(R, 'show', c['anchor']+':'+policy_path.relative_to(R).as_posix())
    analysis = R/c['aggregate_boundaries'][0]
    old_analysis = git(R, 'show', head+':'+analysis.relative_to(R).as_posix())
    new_analysis = analysis.read_bytes()
    def imports(raw): return engine.IMPORT_RE.findall(engine.remove_lean_comments(raw.decode('utf-8-sig')))
    def nonimports(raw): return '\n'.join(x for x in raw.decode('utf-8-sig').splitlines() if not x.startswith('import '))
    delta = {'path':analysis.relative_to(R).as_posix(), 'input_head':head, 'before_sha256':sha(old_analysis),
             'after_sha256':sha(new_analysis), 'added_imports':sorted(set(imports(new_analysis))-set(imports(old_analysis))),
             'removed_imports':sorted(set(imports(old_analysis))-set(imports(new_analysis))),
             'non_import_lines_equal':nonimports(old_analysis)==nonimports(new_analysis)}
    final_guard(R, c, guard, engine, source, changed)
    P.mkdir()
    for name, raw in [('protected-anchor-layout-exceptions.json',baseline_raw),
                      ('current-layout-exceptions.json',policy_path.read_bytes()),
                      ('Analysis-at-input-head.lean.txt',old_analysis),('Analysis-current.lean.txt',new_analysis)]:
        with (P/name).open('xb') as f: f.write(raw)
    write(P,'all-production-source-pins.json',{'status':'current-snapshot-root-review-required', 'source_tree_sha256':source['source_tree_sha256'],'files':all_pins})
    write(P,'unit-source-pins.json',{'status':'current-snapshot-root-review-required',
        'scope':'All canonical/compatibility Chapter01 owners, all native fingerprint owners, and their complete transitive project import closure.',
        'source_tree_sha256':source['source_tree_sha256'],'files':[guard.pin(R/p) for p in unit_paths],
        'starts':sorted(starts),'native_owner_count':len(owners),'native_constant_count':len(records)})
    write(P,'current-source-observation.json',{'status':'current-snapshot-root-review-required','input_commit':head,
        'anchor':c['anchor'],'production_source_tree_sha256':source['source_tree_sha256'],
        'production_module_count':len(modules),'unit_module_count':len(unit_paths),'actual_changed_source_paths':changed,
        'changed_paths_outside_unit_dependency_closure':sorted(set(changed)-set(unit_paths)),
        'topology_sha256':c['topology']['sha256'],'campaign_owner':campaign['owner'],
        'graph_json':c['graph']['json'],'graph_markdown':c['graph']['markdown'],
        'protected_anchor_legacy_sets':json.loads(baseline_raw)['legacy'],'current_legacy_sets':read(policy_path)['legacy'],
        'fingerprint_inputs':[x['inventory'] for x in c['fingerprints']], 'source_changes_during_capture':[],
        'total_rows':len(rows),'formalizable_rows':len(formal),'skipped_rows':len(skipped)})
    write(P,'actual-four-executions.json',{'status':'actual-successful-receipts-applicability-root-review-required','executions':executions})
    write(P,'complete-native-observation.json',{'status':'actual-successful-native-check-root-review-required',
        'manifest':c['complete_declaration_manifest'],'execution':complete_execution,'target_count':len(target_rows)})
    write(P,'analysis-only-import-delta.json',delta)
    write(P,'selected-and-prospective-targets.json',{'status':'organizational-observation-no-new-acceptance','rows':target_rows,
        'same_native_type_and_value_groups_in_source_scope':same,
        'limits':'Equal native fingerprints are search signals, not semantic equivalence or source acceptance.'})
    final_guard(R, c, guard, engine, source, changed)
    freeze_outputs(P,guard,'capture-manifest.json',config_ref,head)
    print(json.dumps({'status':'root-review-required','capture_manifest':guard.pin(P/'capture-manifest.json'),
                      'production_modules':len(modules),'native_constants':len(records),'native_owners':len(owners)},indent=2))

if __name__ == '__main__': main()
