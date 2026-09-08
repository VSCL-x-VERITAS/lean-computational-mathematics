"""Read-only replay of all frozen source/output/dependency bindings."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
j=json.loads((P/'final-receipt.json').read_bytes());rows=j['artifacts']+j['support']
for row in rows:assert sha(Path(row['path']))==row['sha256'],row['path']
assert j['native_exit_code']==0 and j['checked_declarations']==24 and j['no_warnings']
print(json.dumps(dict(status='PASS',bindings=len(rows),unique_paths=len({x['path'] for x in rows}),
 receipt_sha256=sha(P/'final-receipt.json'))))
