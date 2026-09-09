"""Read-only POSIX Git identity and additive bounded native-export preparation."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, re, subprocess

F = Path(__file__).resolve().parent
S = F.parents[1]
R = S.parents[3]
OLD = S / 'chapter01-current-expression-fingerprints-24b3.json'
OLD_SHA = 'c27b9c4b5b0bf1c6fa6f26300045423512118a24c0b24eff2b57f65d77f09400'
PARSER = S / 'freeze-chapter01-expression-fingerprints-v3.py'
PARSER_SHA = 'fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702'
PRIOR_EXPORTER = S / 'export-one-step-declaration-expressions.lean'
PRIOR_EXPORTER_SHA = '7558eecccba14ecfa22874b8eb6bee3438146a5578bb21a34cf0ae9a7becb063'
MANIFEST = F.parent / 'complete-declaration-manifest.json'
MANIFEST_SHA = '428b893a5ce1ed1b24a7f7c12f55d9b5e50323feedc61677282a9958678dc653'
sha = lambda data: hashlib.sha256(data).hexdigest()
load = lambda path: json.loads(path.read_text(encoding='utf-8'))

def write_new(path, data):
    with path.open('xb') as stream: stream.write(data)

def encode(data):
    return (json.dumps(data, indent=2, ensure_ascii=False) + '\n').encode()

def main():
    assert os.name != 'nt', 'Use the prepared POSIX launcher; no native Git'
    for path, expected in ((OLD, OLD_SHA), (PARSER, PARSER_SHA), (PRIOR_EXPORTER, PRIOR_EXPORTER_SHA), (MANIFEST, MANIFEST_SHA)):
        assert sha(path.read_bytes()) == expected, str(path)
    old, manifest = load(OLD), load(MANIFEST)
    known = {f['path']: f for f in old['files']}
    assert len(known) == 111
    for p, item in known.items(): assert sha((R / p).read_bytes()) == item['sha256'], p
    added = sorted([f for f in manifest['files'] if f['path'] not in known], key=lambda f: f['path'])
    assert len(added) == 8
    for item in added:
        assert sha((R / item['path']).read_bytes()) == item['sha256']
        names = re.findall(r'^theorem\s+(\S+)', (R / item['path']).read_text(encoding='utf-8'), re.M)
        item['declarations'] = ['NumStability.' + name for name in names]
    assert sum(len(f['declarations']) for f in added) == 10
    closure, edges = set(), {}
    queue = [f['path'] for f in added]
    while queue:
        path = queue.pop()
        if path in closure: continue
        closure.add(path)
        imports = re.findall(r'^import\s+(ComputationalMathematics\S*)', (R / path).read_text(encoding='utf-8'), re.M)
        edges[path] = sorted(i.replace('.', '/') + '.lean' for i in imports)
        queue.extend(edges[path])
    new_paths = {f['path'] for f in added}
    missing = sorted(closure - set(known) - new_paths)
    assert len(closure) == 45 and len(missing) == 13
    files = sorted(added + [{'path': p, 'sha256': sha((R / p).read_bytes())} for p in missing], key=lambda f: f['path'])
    selected = [f['path'][:-5].replace('/', '.') for f in files]
    assert len(selected) == 21 and not set(selected) & set(old['selected_modules'])
    git = lambda *args: subprocess.check_output(['git', '--no-replace-objects', '-c', 'core.longpaths=true', *args], cwd=R)
    head = git('rev-parse', 'HEAD').decode().strip()
    tree = git('rev-parse', head + '^{tree}').decode().strip()
    ancestor = subprocess.run(['git', '--no-replace-objects', 'merge-base', '--is-ancestor', old['input_commit'], head], cwd=R)
    assert ancestor.returncode == 0
    anchor = '9e2225705fed906b1120d55105d607baabef57c9'
    baseline_reusable = []
    for p in missing:
        actual = (R / p).read_bytes()
        assert git('show', anchor + ':' + p) == actual, p
        assert git('show', head + ':' + p) == actual, p
        baseline_reusable.append({'path': p, 'sha256': sha(actual), 'equal_anchor_and_input_commit': True})
    template = PRIOR_EXPORTER.read_text(encoding='utf-8')
    exporter = template.replace('import ComputationalMathematics\nimport NumStability\n',
                                ''.join('import ' + f['path'][:-5].replace('/', '.') + '\n' for f in added), 1)
    start = exporter.index('private def selectedModules : Array String := #[')
    finish = exporter.index('\n]\n', start) + 3
    exporter = exporter[:start] + 'private def selectedModules : Array String := #[\n' + ',\n'.join(
        '  ' + json.dumps(module) for module in selected) + '\n]\n' + exporter[finish:]
    raw_relative = (F / 'native-expression-stream.jsonl').relative_to(R).as_posix()
    assert exporter.count('.lake/chapter01-one-step-expressions.jsonl') == 1
    exporter = exporter.replace('.lake/chapter01-one-step-expressions.jsonl', raw_relative)
    exporter_path = F / 'ExportFinalDeclarations.lean'
    write_new(exporter_path, exporter.encode())
    result = {'schema': 1, 'prepared_at_utc': datetime.now(timezone.utc).isoformat(),
        'input_commit': head, 'input_commit_tree': tree, 'scope': 'Eight new source wrappers and thirteen absent reusable dependency owners only.',
        'files': files, 'selected_modules': selected, 'new_source_files': added,
        'expected_authored_new_declarations': sorted(n for f in added for n in f['declarations']),
        'new_source_module_count': 8, 'authored_new_declaration_count': 10,
        'project_import_closure': [{'path': p, 'sha256': sha((R / p).read_bytes()), 'imports': edges[p],
            'fingerprint_source': 'prior24b3' if p in known else 'additional-native-export'} for p in sorted(closure)],
        'missing_reusable_owners': baseline_reusable, 'prior_owner_file_count': 111,
        'prior_fingerprints': {'path': OLD.relative_to(R).as_posix(), 'sha256': OLD_SHA},
        'prior_fingerprint_input_commit': old['input_commit'], 'prior_is_ancestor_of_input': True,
        'normalization': old['normalization'], 'hash_encoding': old['hash_encoding'],
        'parser': {'path': PARSER.relative_to(R).as_posix(), 'sha256': PARSER_SHA},
        'prior_exporter': {'path': PRIOR_EXPORTER.relative_to(R).as_posix(), 'sha256': PRIOR_EXPORTER_SHA},
        'exporter_path': exporter_path.relative_to(R).as_posix(), 'exporter_sha256': sha(exporter.encode()),
        'raw_stream_path': raw_relative, 'native_source_manifest': {'path': MANIFEST.relative_to(R).as_posix(), 'sha256': MANIFEST_SHA},
        'lean_environment': [{'path': p, 'sha256': sha((R / p).read_bytes())} for p in ('lean-toolchain', 'lake-manifest.json')],
        'commit_scope': 'Input commit is the actual current HEAD. New staged worktree producer bytes are separately pinned; no future commit identity is asserted.'}
    assert git('rev-parse', 'HEAD').decode().strip() == head
    write_new(F / 'inputs.json', encode(result))
    print(json.dumps({'input_commit': head, 'inputs_sha256': sha((F / 'inputs.json').read_bytes()),
        'modules': 21, 'new_wrappers': 8, 'new_authored_declarations': 10, 'missing_reusable_owners': 13,
        'prior_owners_unchanged': 111, 'exporter_sha256': result['exporter_sha256']}))

if __name__ == '__main__': main()
