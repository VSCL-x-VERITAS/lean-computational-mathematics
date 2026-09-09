"""Build an exact scratch concatenation; never imports mutable scratch modules."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
files = [D.parent / 'dim-cfl1-witness/Candidate.lean', D / 'Candidate.lean']
imports, bodies = [], []
for path in files:
    lines = path.read_text().splitlines(keepends=True)
    imports += [line for line in lines if line.startswith('import ') and line not in imports]
    bodies.append(''.join(line for line in lines if not line.startswith('import ')))
text = ''.join(imports) + '\n' + ''.join(bodies) + (D / 'Connection.lean.fragment').read_text()
(D / 'Connected.lean').write_bytes(text.encode())
records = [{'path': str(p), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
           for p in files + [D / 'Connection.lean.fragment']]
(D / 'connection-input-map.json').write_bytes((json.dumps({'inputs': records,
    'construction': 'Deduplicated exact import lines; exact remaining input lines in order; append exact connection fragment. No mutable imports.'}, indent=2) + '\n').encode())
