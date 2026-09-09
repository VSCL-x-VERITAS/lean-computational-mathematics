"""POSIX-only read-only Git census and artifact-only exposure proposal constructor."""
from pathlib import Path
import argparse
import collections
import copy
import datetime
import difflib
import hashlib
import json
import os
import re
import subprocess


def sha(content):
    return hashlib.sha256(content).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repo', required=True, type=Path)
    parser.add_argument('--config', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    assert os.name == 'posix', 'Run through the prepared POSIX launcher, never native Git'
    root = args.repo.resolve()
    package = Path(__file__).resolve().parent
    output = args.output.resolve()
    assert output.parent == package and not output.exists(), 'Only a fresh immediate artifact subdirectory is permitted'
    config_bytes = args.config.read_bytes()
    config = json.loads(config_bytes)
    assert config['schema'] == 1
    output.mkdir()

    def file_ref(path):
        content = path.read_bytes()
        return {'path': path.relative_to(root).as_posix(), 'sha256': sha(content), 'bytes': len(content)}

    def bound(item):
        path = root / item['path']
        assert path.resolve().is_relative_to(root), item['path']
        assert file_ref(path)['sha256'] == item['sha256'], 'Changed bound input: ' + item['path']
        return path

    def put(name, value):
        path = output / name
        content = value if isinstance(value, bytes) else (
            value.encode('utf-8') if isinstance(value, str) else
            (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode())
        with path.open('xb') as stream:
            stream.write(content)
        return file_ref(path)

    commands = []

    def git(label, arguments):
        command = ['git', '--no-optional-locks', *arguments]
        result = subprocess.run(command, cwd=root, capture_output=True)
        record = {'command': command, 'cwd': str(root), 'actual_exit': result.returncode,
                  'stdout': put(label + '-stdout.bin', result.stdout),
                  'stderr': put(label + '-stderr.bin', result.stderr)}
        commands.append(record)
        assert result.returncode == 0, label
        return result.stdout

    observed_head = git('head-before', ['rev-parse', 'HEAD']).decode().strip()
    assert observed_head == config['recorded_input_head']
    pinned = {key: bound(config[key]) for key in (
        'analysis', 'tiers', 'owner_mapping', 'root_adoption', 'proposal_review',
        'check_tiers', 'project_roots')}
    analysis_bytes = pinned['analysis'].read_bytes()
    tiers_bytes = pinned['tiers'].read_bytes()
    tiers = json.loads(tiers_bytes)
    original = copy.deepcopy(tiers)
    mapping = json.loads(pinned['owner_mapping'].read_bytes())
    selected = [item for item in mapping['files'] if item['change'] == 'new']
    assert len(selected) == 12
    assert all(item['role'] == 'reusable' and item['target_path'].startswith(
        'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/') for item in selected)
    modules = sorted((item['module'] for item in selected), key=str.casefold)
    assert len(set(modules)) == 12
    assert modules == sorted(config['modules'], key=str.casefold)
    current_files = []
    for item in selected:
        path = root / item['target_path']
        assert path.is_file() and not path.is_symlink()
        current = file_ref(path)
        current_files.append({'module': item['module'], 'file': current,
                              'original_proposal': item['proposed'],
                              'matches_original_proposal': current['sha256'] == item['proposed']['sha256']})

    # Same two exact production roots/pathspecs as check_tiers.production_modules.
    roots = ('ComputationalMathematics', 'NumStability')
    pathspecs = [spec for name in roots for spec in (name + '/*.lean', name + '.lean')]
    tracked_raw = git('tracked-production', ['ls-files', '-z', '--', *pathspecs])
    tracked_paths = [item.decode('utf-8') for item in tracked_raw.split(b'\0') if item]
    assert len(tracked_paths) == len(set(tracked_paths))
    assert all(path.endswith('.lean') and any(path == name + '.lean' or path.startswith(name + '/')
               for name in roots) for path in tracked_paths)
    tracked = sorted(path[:-5].replace('/', '.') for path in tracked_paths)
    prospective = sorted(set(tracked) | set(modules))
    missing_from_index = sorted(set(modules) - set(tracked))

    text = analysis_bytes.decode('utf-8')
    assert '\r' not in text
    imports = re.findall(r'(?m)^import\s+(\S+)\s*$', text)
    assert imports == sorted(set(imports), key=str.casefold), 'Existing Analysis imports are not casefold-sorted/unique'
    assert not set(modules) & set(imports), 'A proposed import already exists'
    new_imports = sorted(set(imports) | set(modules), key=str.casefold)
    lines = text.splitlines(keepends=True)
    first = next(index for index, line in enumerate(lines) if line.startswith('import '))
    preserved = [line for line in lines if not line.startswith('import ')]
    preserved.insert(first, ''.join('import ' + module + '\n' for module in new_imports))
    proposed_analysis = ''.join(preserved)
    assert [line for line in proposed_analysis.splitlines(keepends=True) if not line.startswith('import ')] == [
        line for line in lines if not line.startswith('import ')]

    now = datetime.datetime.now(datetime.timezone.utc).isoformat()
    prefixes = {item['prefix']: item['tier'] for item in tiers['prefixes']}

    def prefix_hits(module):
        return sorted((prefix for prefix in prefixes if module == prefix or module.startswith(prefix + '.')),
                      key=len, reverse=True)

    additions = []
    for module in modules:
        assert module not in tiers['exact']
        rule_id = 'exact:' + module
        assert not any(item['rule_id'] == rule_id for item in tiers['exact_rules'])
        rule = {'rule_id': rule_id, 'match_kind': 'exact', 'module': module,
                'role': 'reusable', 'rationale': config['rationales'][module],
                'introduction': {'commit': observed_head, 'date': now,
                                 'determined_by': 'current_worktree_addition_at_recorded_input_commit'},
                'review': {'reviewer': 'Codex root adopting the reviewed twelve-owner physical DIM organization',
                           'status': 'accepted', 'review_date': now,
                           'evidence': config['root_adoption']['path']},
                'exception': None, 'file_present': True}
        hits = prefix_hits(module)
        if hits:
            prefix = hits[0]
            if prefixes[prefix] == 'reusable':
                rule['extends'] = 'prefix:' + prefix
            else:
                rule['override_of'] = 'prefix:' + prefix
                rule['override_rationale'] = config['rationales'][module]
        additions.append(rule)
        tiers['exact'][module] = 'reusable'
    tiers['exact'] = dict(sorted(tiers['exact'].items()))
    tiers['exact_rules'] = sorted(tiers['exact_rules'] + additions, key=lambda item: item['rule_id'])
    assert [item for item in tiers['exact_rules'] if item['module'] not in modules] == original['exact_rules']
    assert {key: value for key, value in tiers['exact'].items() if key not in modules} == original['exact']
    assert {key: value for key, value in tiers.items() if key not in {'counts', 'exact', 'exact_rules'}} == {
        key: value for key, value in original.items() if key not in {'counts', 'exact', 'exact_rules'}}

    roles = collections.Counter()
    deciding = collections.Counter()
    for module in prospective:
        if module in tiers['exact']:
            role, rule_id = tiers['exact'][module], 'exact:' + module
        else:
            hits = prefix_hits(module)
            assert hits, 'Unclassified prospective module: ' + module
            role, rule_id = prefixes[hits[0]], 'prefix:' + hits[0]
        assert role != 'mixed'
        roles[role] += 1
        deciding[rule_id] += 1
    absent = [item['module'] for item in tiers['exact_rules']
              if not (root / (item['module'].replace('.', '/') + '.lean')).is_file()]
    tiers['counts'] = {**original['counts'], 'by_role': dict(sorted(roles.items())),
                       'production_modules': len(prospective), 'exact_rules': len(tiers['exact_rules']),
                       'prefix_rules': len(tiers['prefix_rules']), 'exact_rules_with_absent_file': len(absent),
                       'prefix_rules_deciding_nothing': sum(deciding['prefix:' + prefix] == 0 for prefix in prefixes)}
    analysis = put('Analysis.lean', proposed_analysis)
    proposed_tiers = put('tiers.json', (json.dumps(tiers, ensure_ascii=False, indent=1) + '\n').encode())
    put('Analysis.diff', ''.join(difflib.unified_diff(text.splitlines(True), proposed_analysis.splitlines(True),
        fromfile=config['analysis']['path'], tofile='PROPOSAL/' + config['analysis']['path'])))
    put('tier-rule-additions.json', additions)
    put('Analysis.before.lean', analysis_bytes)
    put('tiers.before.json', tiers_bytes)
    snapshot = put('census-and-bindings.json', {
        'status': 'READ-ONLY SNAPSHOT AND PROSPECTIVE UNION; not final tracked census',
        'observed_head': observed_head, 'historical_recorded_counts': original['counts'],
        'actual_tracked_paths': tracked_paths, 'actual_tracked_modules': tracked,
        'actual_tracked_count': len(tracked), 'selected_not_yet_tracked': missing_from_index,
        'prospective_modules_after_exact_twelve_presence': prospective,
        'prospective_count': len(prospective), 'proposed_counts': tiers['counts'],
        'absent_exact_rule_paths_observed': absent, 'current_selected_files': current_files,
        'original_map_and_current_bytes_are_distinct': True,
        'application_precondition': 'After root build/staging, rerun a fresh proposal and require the actual tracked set to equal this prospective set; review every intentional current source change before application.'})
    assert git('head-after', ['rev-parse', 'HEAD']).decode().strip() == observed_head
    for key in pinned:
        bound(config[key])
    for item in current_files:
        assert file_ref(root / item['file']['path'])['sha256'] == item['file']['sha256'], 'Concurrent selected-owner change'
    assert args.config.read_bytes() == config_bytes
    receipt = put('receipt.json', {
        'schema': 1, 'status': 'PROPOSAL ONLY; root review/application/official validators pending',
        'config': file_ref(args.config), 'script': file_ref(Path(__file__).resolve()),
        'commands': commands, 'source_inputs': config,
        'proposed_analysis': analysis, 'proposed_tiers': proposed_tiers, 'snapshot': snapshot,
        'added_imports': modules, 'added_exact_rules': 12,
        'old_imports_preserved': True, 'old_rule_objects_preserved': True,
        'official_validator_run': False, 'production_written': False,
        'index_changed': False, 'source_acceptance': False})
    print(json.dumps(receipt, indent=2))


if __name__ == '__main__':
    main()
