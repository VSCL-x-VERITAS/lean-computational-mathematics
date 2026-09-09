"""Print actual repository commit/tree via POSIX Git only; write nothing."""
from pathlib import Path
import json, os, subprocess
assert os.name != 'nt'
R = Path(__file__).resolve().parents[6]
git = lambda *args: subprocess.check_output(['git', '--no-replace-objects', *args], cwd=R).decode().strip()
head = git('rev-parse', 'HEAD')
print(json.dumps({'head': head, 'tree': git('rev-parse', head + '^{tree}')}))
