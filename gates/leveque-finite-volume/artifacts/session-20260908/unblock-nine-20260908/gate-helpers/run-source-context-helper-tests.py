"""Capture actual synthetic-test attempts, including failures; no audit invocation."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys
H = Path(__file__).resolve().parent
label = sys.argv[1]
assert re.fullmatch(r'source-context-tests-[0-9]{2}', label)
out = H/label; out.mkdir()
script = H/'test-source-context-helpers.py'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
before = sha(script)
(out/'test-input.py.snapshot').write_bytes(script.read_bytes())
command = [sys.executable, '-B', str(script)]
result = subprocess.run(command, cwd=H, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
(out/'output.txt').write_bytes(result.stdout)
record = {'schema': 1, 'scope': 'synthetic source-context guard tests only', 'command': command,
          'exit_code': result.returncode, 'output_sha256': sha(out/'output.txt'),
          'input_sha256_before': before, 'input_sha256_after': sha(script),
          'helper_sha256': sha(H/'qualified_row_support_v3.py'), 'operational_validations': 0,
          'gate_mutated': False, 'model_roles': 0}
(out/'receipt.json').write_text(json.dumps(record, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(record, indent=2))
assert before == sha(script)
raise SystemExit(result.returncode)
