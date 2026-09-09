"""Hash-pinned reuse of the existing local structural helper, not released code."""
import importlib.util
import os
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
SESSION = HERE.parents[1]
BASE = SESSION / 'final-epoch-asset-helper-draft/prepare_asset_bundle.py'
BASE_SHA256 = '9f4effac0ee75b5477cdc5f7d5f97b156be8e885247d913db692861ab782eb67'
import hashlib
if hashlib.sha256(BASE.read_bytes()).hexdigest() != BASE_SHA256:
    raise SystemExit('REFUSED: frozen structural helper bytes changed')
spec = importlib.util.spec_from_file_location('frozen_structural_helper', BASE)
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)
InputError, require, canonical, digest = base.InputError, base.require, base.canonical, base.digest
decode_json, load, exact_keys, schema_check = base.decode_json, base.load, base.exact_keys, base.schema_check

class GitObjects(base.GitObjects):
    """Only read-only object/ref queries. Run this helper via the POSIX launcher."""
    allowed = {'rev-parse', 'ls-tree', 'cat-file', 'merge-base', 'rev-list', 'show', 'diff', 'ls-files'}
    def run(self, *args):
        require(args and args[0] in self.allowed, 'non-read-only Git command refused')
        require(not any(str(a).startswith(('--output', '--ext-diff', '--textconv')) for a in args),
                'external/output Git option refused')
        return super().run(*args)

    def tree(self, commit):
        result = {}
        for record in self.run('ls-tree', '-r', '-z', commit).split(b'\0'):
            if not record: continue
            head, path = record.split(b'\t', 1)
            mode, kind, oid = head.decode().split()
            require(kind == 'blob', 'non-blob tree entry requires separate review')
            result[path.decode()] = {'mode': mode, 'oid': oid}
        return result

class BlobBatch:
    def __init__(self, git):
        self.git, self.cache, self.hashes = git, {}, {}
        # This process reads objects only; it never writes Git state.
        self.proc = subprocess.Popen(['git', '--no-replace-objects', '-c', 'core.longpaths=true',
            '-C', str(git.repository), 'cat-file', '--batch'], env=git.environment,
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    def get(self, oid, data=False):
        if oid not in self.hashes or data and oid not in self.cache:
            self.proc.stdin.write((oid + '\n').encode()); self.proc.stdin.flush()
            header = self.proc.stdout.readline().decode().strip().split()
            require(len(header) == 3 and header[0] == oid and header[1] == 'blob', 'bad batch blob response')
            left = int(header[2]); h = hashlib.sha256(); chunks = []
            while left:
                chunk = self.proc.stdout.read(min(left, 1024 * 1024))
                require(bool(chunk), 'truncated blob')
                h.update(chunk); left -= len(chunk)
                if data: chunks.append(chunk)
            require(self.proc.stdout.read(1) == b'\n', 'bad batch terminator')
            self.hashes[oid] = h.hexdigest()
            if data: self.cache[oid] = b''.join(chunks)
        return self.cache[oid] if data else self.hashes[oid]
    def close(self):
        self.proc.stdin.close()
        require(self.proc.wait() == 0, 'batch object read failed')

def write_new(path, value):
    path = Path(path)
    require(path.parent.is_dir(), 'output parent must already exist')
    with path.open('x', encoding='utf-8', newline='\n') as f:
        import json
        json.dump(value, f, indent=2, ensure_ascii=True); f.write('\n')

def checked_lanes(topology, git_factory=GitObjects):
    items = topology['instances']
    instances = {i['id']: i for i in items}
    require(len(instances) == len(items), 'duplicate topology instance')
    lanes = {k: v for k, v in instances.items() if v['role'] in ('formalization', 'reorganization')}
    require(len(lanes) == 2, 'bounded helper requires exactly two work lanes')
    for i in instances.values():
        g = git_factory(i['repository'])
        require(g.text('rev-parse', i['ref'] + '^{commit}') == i['head'], 'configured ref drift: ' + i['id'])
    return instances, lanes
