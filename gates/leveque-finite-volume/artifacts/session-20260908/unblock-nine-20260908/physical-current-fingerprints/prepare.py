"""Prepare a current 29-owner export without changing the historical serializer or filter."""
from pathlib import Path
import hashlib
import json
import os
import re
import subprocess

F = Path(__file__).resolve().parent
D = F.parent
S = D.parent
R = next(p for p in F.parents if (p / 'lean-toolchain').exists())
assert os.name == 'posix'
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: dict(path=path.relative_to(R).as_posix(), sha256=sha(path))
read = lambda path: json.loads(path.read_bytes())


def write(name, value):
    with (F / name).open('x', encoding='utf-8', newline='\n') as stream:
        if isinstance(value, str): stream.write(value)
        else: json.dump(value, stream, indent=2, ensure_ascii=False); stream.write('\n')
    return ref(F / name)


assert sha(F / 'coverage.json') == 'caf20f888cf943e1871aa3fa50036b13abb4db0f1512da4957c85aefb0e61197'
coverage = read(F / 'coverage.json')
assert coverage['status'] == 'EXPECTED SCOPE ONLY' and not coverage['unexpected_stale_prior_owners']
priors = [entry['inventory'] for entry in coverage['prior_inventories']]
known = {}
for pin in priors:
    assert sha(R / pin['path']) == pin['sha256']
    for item in read(R / pin['path'])['files']:
        assert item['path'] not in known
        known[item['path']] = item
assert len(known) == 171
selected_paths = {item['path'] for item in coverage['selected_owners']}
retained = [item for path, item in sorted(known.items()) if path not in selected_paths]
assert len(retained) == 154
for item in retained:
    assert sha(R / item['path']) == item['sha256']

current_map = read(D / 'physical-dim-owner-proposals/attempt-06/mapping.json')
authored = {item['target_path']: item['declarations'] for item in current_map['files']}
old_dim_manifest = D / 'directional-high-resolution-production/production-files-frozen.json'
assert sha(old_dim_manifest) == 'cb7623870ad874124148177f971a30c9e18e6b0172d2e21e59c6ae135f9c4538'
for item in read(old_dim_manifest)['files']:
    authored.setdefault(item['path'], item['declarations'])
files = []
for item in coverage['selected_owners']:
    assert sha(R / item['path']) == item['sha256']
    files.append({key: item[key] for key in ('path', 'sha256', 'module')} | {
        'declarations': authored[item['path']],
        'lines': len((R / item['path']).read_text(encoding='utf-8').splitlines())})
assert len(files) == 29
expected = {name for item in files for name in item['declarations']}
assert len(expected) == sum(len(item['declarations']) for item in files) == 300
selected = [item['module'] for item in files]
closure = {}
environment = {}
queue = list(selected_paths)
while queue:
    path = queue.pop()
    if path in closure: continue
    source = R / path
    text = source.read_text(encoding='utf-8')
    imports = []
    for match in re.finditer(r'^(?:public\s+)?import\s+([^\n]+)', text, re.M):
        names = match.group(1).split('--', 1)[0].split()
        assert all(re.fullmatch(r'[A-Za-z_][A-Za-z_0-9.]*', name) for name in names)
        imports.extend(names)
    closure[path] = dict(**ref(source), imports=imports)
    compiled = R / '.lake/build/lib/lean' / Path(path).with_suffix('.olean')
    assert compiled.is_file(), compiled
    environment[compiled.relative_to(R).as_posix()] = ref(compiled)
    for module in imports:
        if module.startswith(('ComputationalMathematics.', 'NumStability.')):
            queue.append(module.replace('.', '/') + '.lean')
        elif module.startswith('Mathlib.'):
            for imported in (R / '.lake/packages/mathlib' / (module.replace('.', '/') + '.lean'),
                             R / '.lake/packages/mathlib/.lake/build/lib/lean' / (module.replace('.', '/') + '.olean')):
                assert imported.is_file(), imported
                environment[imported.relative_to(R).as_posix()] = ref(imported)
missing = sorted(set(closure) - set(known) - selected_paths)
if missing:
    write('unexpected-dependency-owners.json', {'paths': missing, 'status': 'STOP BEFORE EXPORT'})
    raise AssertionError('Unfingerprinted dependency owners beyond approved scope')
for item in closure.values():
    environment[item['path']] = {key: item[key] for key in ('path', 'sha256')}
for name in ('lean-toolchain', 'lake-manifest.json', 'lakefile.toml'):
    environment[name] = ref(R / name)

git = lambda *args: subprocess.check_output(['git', '--no-optional-locks', '--no-replace-objects', *args], cwd=R).decode().strip()
head = git('rev-parse', 'HEAD')
tree = git('rev-parse', head + '^{tree}')
assert head == coverage['input_commit']
template = S / 'export-one-step-declaration-expressions.lean'
parser = S / 'freeze-chapter01-expression-fingerprints-v3.py'
assert sha(template) == '7558eecccba14ecfa22874b8eb6bee3438146a5578bb21a34cf0ae9a7becb063'
assert sha(parser) == 'fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702'
text = template.read_text(encoding='utf-8').replace('import ComputationalMathematics\nimport NumStability\n',
    ''.join('import ' + module + '\n' for module in selected), 1)
start = text.index('private def selectedModules : Array String := #[')
end = text.index('\n]\n', start) + 3
text = text[:start] + 'private def selectedModules : Array String := #[\n' + ',\n'.join(
    '  ' + json.dumps(module) for module in selected) + '\n]\n' + text[end:]
raw = (F / 'native-expression-stream.jsonl').relative_to(R).as_posix()
assert text.count('.lake/chapter01-one-step-expressions.jsonl') == 1
text = text.replace('.lake/chapter01-one-step-expressions.jsonl', raw)
exporter = write('ExportCurrentDeclarations.lean', text)
base = read(R / priors[0]['path'])
manifests = [ref(F / 'coverage.json'), coverage['current_build'], ref(old_dim_manifest),
    ref(D / 'physical-dim-owner-proposals/attempt-06/mapping.json'),
    ref(D / 'physical-production-promotion/five-owner-placement/receipt.json'),
    ref(D / 'physical-production-promotion/real-norm-import-repair-01/receipt.json'),
    ref(D / 'physical-production-promotion/contdiff-import-repair-01/receipt.json')]
inputs = dict(schema=1, input_commit=head, input_commit_tree=tree,
    scope='Current old-DIM16 + new physical12 + extended Hyperbolicity: 29 owners, freshly exported as whole owner units.',
    files=files, selected_modules=selected, expected_authored_declarations=sorted(expected),
    prior_fingerprints=priors, prior_owners=retained,
    retained_prior_owner_count=154, old_owner_count=171, old_constant_count=1426,
    project_import_closure=list(closure.values()), lean_environment=list(environment.values()),
    unfingerprinted_dependency_owners_outside_requested_scope=missing,
    normalization=base['normalization'], counting_note=base['counting_note'], hash_encoding=base['hash_encoding'],
    prior_exporter=ref(template), parser=ref(parser), exporter_path=exporter['path'], exporter_sha256=exporter['sha256'],
    raw_stream_path=raw, input_manifests=manifests,
    compiled_provenance_scope='Recursive current project source/olean closure and directly imported Mathlib source/olean entries, plus pinned Lake manifests, matching the inherited exporter workflow. This does not claim a new exhaustive upstream compiled-file census.',
    replacement_policy='Omit all old records whose module belongs to selected_modules, including the five moved names at old owners; then merge exact unchanged retained records with current fresh records. Preserve per-owner provenance and detect duplicate names/owners.',
    commit_scope='Actual HEAD5e3 plus exact current worktree/compiled owner pins. No future commit, candidate, source acceptance or semantic equivalence is asserted.')
for item in files + retained + list(environment.values()) + manifests:
    assert sha(R / item['path']) == item['sha256']
assert git('rev-parse', 'HEAD') == head
result = write('inputs.json', inputs)
print(json.dumps({'inputs': result, 'selected_owners': 29, 'expected_explicit_authors': 300,
                  'retained_owners': 154, 'project_closure': len(closure), 'exporter': exporter}, indent=2))
