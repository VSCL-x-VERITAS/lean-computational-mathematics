"""Generate a byte-exact candidate prefix and check every scratch declaration."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent
candidate=(P/'Candidate.lean').read_bytes()
names=re.findall(r'^(?:theorem|def)\s+(\w+)',candidate.decode(),re.M)
qualified=['NumStability.HeterogeneousVolumeDraft.'+x for x in names]
checks=candidate+b'\nset_option pp.universes true\n'+''.join(
 f'#check {x}\n#print axioms {x}\n' for x in qualified).encode()
out=P/'Checks.lean';assert not out.exists();out.write_bytes(checks)
(P/'declarations.json').write_bytes((json.dumps(dict(
 declarations=qualified,candidate_sha256=hashlib.sha256(candidate).hexdigest(),
 checks_sha256=hashlib.sha256(checks).hexdigest(),exact_candidate_prefix=True),indent=2)+'\n').encode())
print(len(names))
