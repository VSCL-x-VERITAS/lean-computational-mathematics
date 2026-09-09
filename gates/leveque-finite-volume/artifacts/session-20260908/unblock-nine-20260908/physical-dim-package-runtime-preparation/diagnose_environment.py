from pathlib import Path
import subprocess
import json
import hashlib
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
descriptor = P / 'fixture-01/fixture-descriptor.json'
command = ['lake', 'env', 'python3', '-B', str(P / 'lean_runtime.py'), '--descriptor', str(descriptor), '--descriptor-sha256', hashlib.sha256(descriptor.read_bytes()).hexdigest(), '--capture-environment']
result = subprocess.run(command, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
(P / 'environment-failure-stderr.txt').write_bytes(result.stderr)
# stdout may contain environment paths; preserve it privately, never print.
(P / 'environment-failure-stdout.private.txt').write_bytes(result.stdout)
print(json.dumps({'exit': result.returncode, 'stderr': result.stderr.decode(errors='replace'), 'stdout_bytes': len(result.stdout)}))
