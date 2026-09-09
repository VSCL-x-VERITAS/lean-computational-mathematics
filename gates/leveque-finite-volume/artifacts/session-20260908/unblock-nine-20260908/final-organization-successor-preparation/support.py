"""Strict read-only input guards for additive organization draft helpers."""
from pathlib import Path, PurePosixPath
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys

CHECKS = ('layout', 'tiers', 'compatibility', 'hygiene')
SCOPE_KEYS = ('unexpected_changes', 'unclassified_modules', 'mixed_pending_split',
              'duplicate_wrappers', 'placeholder_findings', 'canonical_placement_pending')
PREFIXES = ('ComputationalMathematics.Source.LeVeque.Chapter01', 'NumStability.Source.LeVeque.Chapter01')
sha = lambda raw: hashlib.sha256(raw).hexdigest()
read = lambda p: json.loads(p.read_bytes())

def require(condition, message):
    if not condition:
        raise ValueError(message)

def digest(value, length=64):
    require(isinstance(value, str) and re.fullmatch('[0-9a-f]{%d}' % length, value), 'invalid digest')

def relative_path(value):
    require(isinstance(value, str) and value and '\\' not in value and ':' not in value,
            'FileRef paths must be repository-relative POSIX paths')
    p = PurePosixPath(value)
    require(not p.is_absolute() and '..' not in p.parts and '.' not in p.parts,
            'unsafe relative path')
    require(p.as_posix() == value, 'non-normalized relative path')
    return value

def file_ref(value):
    require(isinstance(value, dict) and set(value) == {'path', 'sha256'}, 'expected exact FileRef')
    relative_path(value['path']); digest(value['sha256'])

def all_refs(value):
    if isinstance(value, dict):
        if set(value) == {'path', 'sha256'}:
            file_ref(value); yield value
        else:
            for child in value.values():
                yield from all_refs(child)
    elif isinstance(value, list):
        for child in value:
            yield from all_refs(child)

def schema(c):
    require(isinstance(c, dict) and c.get('schema') == 1 and
            c.get('kind') == 'current-organization-draft-config', 'wrong config schema')
    require(c.get('pending_inputs') == [], 'pending future inputs must be resolved')
    digest(c.get('expected_head'), 40); digest(c.get('anchor'), 40)
    digest(c.get('source_tree_sha256'))
    require(isinstance(c.get('campaign_id'), str) and c['campaign_id'], 'campaign required')
    for key in ('topology', 'gate', 'organization_template', 'complete_declaration_manifest'):
        file_ref(c.get(key))
    require(set(c.get('graph', {})) == {'json', 'markdown'}, 'exact graph pair required')
    for value in c['graph'].values(): file_ref(value)
    counts = c.get('expected_counts', {})
    require(set(counts) == {'production_modules', 'native_constants', 'native_owners',
                           'total_rows', 'formalizable_rows', 'skipped_rows'}, 'expected counts missing')
    require(all(type(n) is int and n >= 0 for n in counts.values()), 'counts must be explicit integers')
    require(counts['production_modules'] > 0 and counts['native_constants'] > 0 and
            counts['native_owners'] > 0 and counts['formalizable_rows'] > 0, 'empty census forbidden')
    require(counts['total_rows'] == counts['formalizable_rows'] + counts['skipped_rows'], 'row census inconsistent')
    fps = c.get('fingerprints')
    require(isinstance(fps, list) and fps, 'fingerprints required')
    for item in fps:
        require(set(item) == {'inventory', 'expected_records', 'expected_files', 'provenance'}, 'fingerprint shape')
        file_ref(item['inventory'])
        require(all(type(item[k]) is int and item[k] > 0 for k in ('expected_records', 'expected_files')),
                'fingerprint counts required')
        require(isinstance(item['provenance'], list) and item['provenance'], 'native provenance refs required')
        for ref in item['provenance']: file_ref(ref)
    require(len({x['inventory']['path'] for x in fps}) == len(fps), 'duplicate fingerprint inventory')
    require(set(c.get('checker_executions', {})) == set(CHECKS), 'exact four checker inputs required')
    for key, item in [*c['checker_executions'].items(), ('declarations', c.get('complete_native'))]:
        require(isinstance(item, dict) and set(item) == {'receipt', 'output', 'expected_command',
                'applicability_rationale', 'evidence'}, 'execution shape: ' + key)
        file_ref(item['receipt']); file_ref(item['output'])
        command = item['expected_command']
        require((isinstance(command, str) and bool(command.strip())) or
                (isinstance(command, list) and command and all(isinstance(x, str) and x for x in command)),
                'exact actual command required')
        require(isinstance(item['applicability_rationale'], str) and item['applicability_rationale'].strip(),
                'root-reviewable applicability rationale required')
        require(isinstance(item['evidence'], list) and item['evidence'], 'applicability evidence required')
        for ref in item['evidence']: file_ref(ref)
    reviews = c.get('placement_reviews')
    require(isinstance(reviews, list) and reviews, 'placement/source-scope reviews required')
    for item in reviews:
        require(set(item) == {'evidence', 'rationale', 'covered_source_paths'}, 'placement review shape')
        file_ref(item['evidence'])
        require(isinstance(item['rationale'], str) and item['rationale'].strip(), 'placement rationale required')
        require(isinstance(item['covered_source_paths'], list), 'reviewed path coverage required')
        for path in item['covered_source_paths']: relative_path(path)
    assessment = c.get('scope_assessment')
    require(isinstance(assessment, dict) and set(assessment) == {'rationale', 'unit_scope'}, 'scope assessment required')
    require(isinstance(assessment['rationale'], str) and assessment['rationale'].strip(), 'scope rationale required')
    require(set(assessment['unit_scope']) == set(SCOPE_KEYS) and
            all(isinstance(x, list) for x in assessment['unit_scope'].values()), 'six explicit scope lists required')
    require(c.get('aggregate_boundaries') == ['ComputationalMathematics/Analysis.lean'],
            'preserve the reviewed single Analysis exposure boundary')

class Guard:
    def __init__(self, repo):
        self.repo = repo.resolve(); self.observed = {}
    def path(self, text):
        relative_path(text)
        p = self.repo / text
        require(p.resolve().is_relative_to(self.repo), 'path escapes repository')
        require(not any(x.is_symlink() for x in [p, *p.parents] if x.is_relative_to(self.repo)),
                'symlink FileRef forbidden')
        require(p.is_file(), 'missing input: ' + text)
        return p
    def bind(self, value):
        file_ref(value); p = self.path(value['path']); raw = p.read_bytes()
        require(sha(raw) == value['sha256'], 'hash mismatch: ' + value['path'])
        if p in self.observed: require(self.observed[p] == value['sha256'], 'conflicting pin')
        self.observed[p] = value['sha256']; return p
    def pin(self, path):
        p = self.path(path.relative_to(self.repo).as_posix())
        value = {'path': p.relative_to(self.repo).as_posix(), 'sha256': sha(p.read_bytes())}
        self.bind(value); return value
    def unchanged(self):
        for p, expected in self.observed.items():
            require(sha(self.path(p.relative_to(self.repo).as_posix()).read_bytes()) == expected,
                    'input changed during run: ' + str(p))

def git(repo, *args):
    require(os.name != 'nt', 'Use the unchanged POSIX workflow launcher; no native Git')
    return subprocess.check_output(['git', '-c', 'core.longpaths=true', *args], cwd=repo)

def changed_sources(repo, anchor, by_path):
    data = git(repo, 'diff', '--name-only', '-z', anchor, '--')
    data += git(repo, 'ls-files', '--others', '--exclude-standard', '-z')
    return sorted({p.decode('utf-8') for p in data.split(b'\0') if p and p.decode('utf-8') in by_path})

def execution(guard, item, head, required_path):
    r = read(guard.bind(item['receipt'])); output = guard.bind(item['output']).read_bytes()
    require(type(r.get('exit_code')) is int and r['exit_code'] == 0, 'not an actual successful receipt')
    require(r.get('output_sha256') == sha(output), 'receipt/output disagreement')
    require(r.get('input_commit') == head, 'receipt at a different input HEAD')
    require(r.get('command') == item['expected_command'], 'actual command differs from explicit expected command')
    require(type(r.get('elapsed_ms')) is int and r['elapsed_ms'] >= 0, 'actual elapsed time unavailable')
    command = r['command']
    argv = r.get('argv', command if isinstance(command, list) else None)
    if argv is not None:
        require(isinstance(argv, list) and any(x == required_path or x.endswith('/' + required_path)
                for x in argv if isinstance(x, str)), 'required checker/check file absent from actual argv')
    else:
        require(command.endswith(' ' + required_path), 'check file absent from actual command')
    return {'receipt': item['receipt'], 'output': item['output'], 'command': command,
            'actual_elapsed_ms': r['elapsed_ms'], 'input_commit': head}

def setup(stage):
    parser = argparse.ArgumentParser()
    parser.add_argument('--repo', required=True); parser.add_argument('--config', required=True)
    parser.add_argument('--config-sha256', required=True); parser.add_argument('--out', required=True)
    if stage == 'draft':
        parser.add_argument('--capture-manifest', required=True); parser.add_argument('--capture-sha256', required=True)
    args = parser.parse_args()
    require(os.name != 'nt', 'Use the unchanged POSIX workflow launcher')
    repo = Path(args.repo).resolve(); guard = Guard(repo)
    guard.pin(Path(__file__).resolve())
    guard.pin(Path(sys.argv[0]).resolve())
    config_ref = {'path': relative_path(args.config), 'sha256': args.config_sha256}
    config = read(guard.bind(config_ref)); schema(config)
    for value in all_refs(config): guard.bind(value)
    session = repo/'gates/leveque-finite-volume/artifacts/session-20260908'
    out = repo/relative_path(args.out)
    require(out.resolve().is_relative_to(session.resolve()) and not out.exists(), 'output must be a fresh session directory')
    require(out.parent.is_dir() and not out.parent.is_symlink(), 'output parent must already exist without symlinks')
    head = git(repo, 'rev-parse', 'HEAD').decode().strip()
    require(head == config['expected_head'], 'current HEAD differs from config')
    template = read(guard.bind(config['organization_template']))
    require(template.get('schema_version') == 1 and template.get('kind') == 'organization-measurement-inputs', 'wrong template')
    require(template.get('campaign_id') == config['campaign_id'], 'template campaign mismatch')
    for value in template['tools'].values(): guard.bind(value)
    top = read(guard.bind(config['topology']))
    require(top['shared_anchor'] == config['anchor'], 'protected anchor differs from actual topology')
    campaigns = [x for x in top['campaigns'] if x['id'] == config['campaign_id']]
    require(len(campaigns) == 1, 'campaign not uniquely present')
    sys.dont_write_bytecode = True
    sys.path.insert(0, str(repo/'tools/architecture'))
    import generate_baseline as engine
    require(guard.pin(repo/'tools/architecture/generate_baseline.py') == template['tools']['graph_engine'], 'scanner pin mismatch')
    return args, repo, out, config, config_ref, guard, head, template, campaigns[0], engine

def write(out, name, value):
    with (out/name).open('x', encoding='utf-8', newline='\n') as f:
        f.write(json.dumps(value, indent=2, ensure_ascii=True)+'\n')

def final_guard(repo, config, guard, engine, original_source, changed):
    guard.unchanged()
    source, modules = engine.scan_sources(repo)
    require(source['source_tree_sha256'] == original_source['source_tree_sha256'] and
            len(modules) == config['expected_counts']['production_modules'], 'source census changed during run')
    require(changed_sources(repo, config['anchor'], {m.path:m for m in modules}) == changed,
            'changed-source set changed during run')
    require(git(repo, 'rev-parse', 'HEAD').decode().strip() == config['expected_head'], 'HEAD changed during run')

def freeze_outputs(out, guard, name, config_ref, head):
    files = [guard.pin(p) for p in sorted(out.iterdir()) if p.is_file()]
    write(out, name, {'schema':1, 'status':'root-review-required', 'config':config_ref,
                     'helpers':[guard.pin(Path(__file__).resolve()), guard.pin(Path(sys.argv[0]).resolve())],
                     'input_commit':head, 'files':files, 'operational_measurement_run':False})
