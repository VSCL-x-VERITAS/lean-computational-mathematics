"""Read-only verification of the frozen draft and its evidence bindings."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
receipt=json.loads((P/'final-receipt.json').read_bytes())
bindings=receipt['artifacts']+receipt['support']
for row in bindings:assert sha(Path(row['path']))==row['sha256'],row['path']
assert receipt['native_exit_code']==0 and receipt['checked_declarations']==15
assert (P/'Checks.lean').read_bytes().startswith((P/'Candidate.lean').read_bytes()+b'\n')
print(json.dumps(dict(status='PASS',bindings=len(bindings),unique_paths=len({x['path'] for x in bindings}),
 receipt_sha256=sha(P/'final-receipt.json'))))
