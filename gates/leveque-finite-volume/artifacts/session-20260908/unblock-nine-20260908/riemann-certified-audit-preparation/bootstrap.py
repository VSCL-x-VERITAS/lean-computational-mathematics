"""Create additive local probe helpers from exact reviewed predecessors."""
from pathlib import Path
import hashlib, json
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p/'lean-toolchain').is_file())
OLD = P.parent/'coordinate-high-resolution-audit-preparation'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: dict(path=p.relative_to(R).as_posix(), sha256=sha(p))
records = []
for name in ('run-native.py', 'run-prepare.py'):
    source, target = OLD/name, P/name
    with target.open('xb') as out: out.write(source.read_bytes())
    records.append({'source': ref(source), 'copy': ref(target), 'changes': []})
with (P/'helper-derivation.json').open('x', encoding='utf-8', newline='\n') as out:
    out.write(json.dumps({'schema':1, 'copies':records,
        'scope':'Local native probes and spec-only validation; no released prepare, roles or mutations.'}, indent=2)+'\n')
print(json.dumps(records, indent=2))
