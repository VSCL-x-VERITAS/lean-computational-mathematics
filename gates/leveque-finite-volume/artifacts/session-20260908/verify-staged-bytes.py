"""Verify index blob bytes equal current files in explicitly named evidence roots."""
import argparse
import hashlib
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('roots', nargs='+', type=Path)
args = parser.parse_args()
if os.name == 'nt':
    raise RuntimeError('Run via the prepared POSIX launcher: native recursive traversal may omit deep artifact paths.')
root = Path(__file__).resolve().parents[4]
checked = []
for selected in args.roots:
    selected = (root / selected).resolve()
    selected.relative_to(root)
    paths = sorted(selected.rglob('*')) if selected.is_dir() else [selected]
    for path in paths:
        if not path.is_file():
            continue
        relative = path.relative_to(root).as_posix()
        content = path.read_bytes()
        blob = subprocess.run(['git', '-c', 'core.longpaths=true', 'show', ':' + relative],
                              cwd=root, capture_output=True, check=True).stdout
        if blob != content:
            raise ValueError(f'Index bytes differ from worktree: {relative}')
        checked.append((relative, hashlib.sha256(content).hexdigest()))
print(f'PASS exact staged byte identity: {len(checked)} files')
for path, digest in checked:
    print(digest + '  ' + path)
