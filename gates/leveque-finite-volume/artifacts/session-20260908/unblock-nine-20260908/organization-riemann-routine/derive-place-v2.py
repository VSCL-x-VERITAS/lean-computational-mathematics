"""Include exact staged new leaves in the architecture tool's tracked census."""
from pathlib import Path
import hashlib
import json
F = Path(__file__).resolve().parent
old = F / 'place.py'
text = old.read_text(encoding='utf-8')
before = "assert head == '5e3f63594aa964263469ada134aee2809559d50d'\n"
after = before + "# The existing architecture census intentionally lists tracked files only.\ngit('add', '--', *[item['path'] for item in files])\nfor item in files:\n    assert git('show', ':' + item['path']) == (R / item['path']).read_bytes()\n"
assert text.count(before) == 1
text = text.replace(before, after)
new = F / 'place-v2.py'
compile(text, new.name, 'exec')
with new.open('xb') as stream:
    stream.write(text.encode())
result = {'parent': {'path': old.name, 'sha256': hashlib.sha256(old.read_bytes()).hexdigest()},
          'successor': {'path': new.name, 'sha256': hashlib.sha256(new.read_bytes()).hexdigest()},
          'exact_replacement': {'before': before, 'after': after},
          'prior_failure': 'The current check_tiers.production_modules census excludes untracked files. The first attempt exited 1 before changing source, tiers or index. The successor stages only the four already verified leaves before asking that unchanged census to classify them.'}
with (F / 'placement-derivation.json').open('xb') as stream:
    stream.write((json.dumps(result, indent=2) + '\n').encode())
print(json.dumps(result))
