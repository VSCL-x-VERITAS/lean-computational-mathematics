"""Capture the failed native default-codepage attempt and UTF-8 successor exactly."""
from pathlib import Path
import hashlib
import json
import os
import subprocess
import sys
H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\' + str(H0)) if os.name == 'nt' else H0
script = H0 / 'prepare-companion-drafts.py'
for label, options, expected in [('default-codepage', [], 1), ('utf8', ['-X', 'utf8'], 0)]:
    output = H / label; output.mkdir()
    command = [sys.executable, *options, '-B', str(script)]
    result = subprocess.run(command, cwd=H0, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    with (output / 'output.txt').open('xb') as f: f.write(result.stdout)
    receipt = {'schema': 1, 'command': command, 'exit_code': result.returncode,
               'input_sha256': hashlib.sha256(script.read_bytes()).hexdigest(),
               'output_sha256': hashlib.sha256(result.stdout).hexdigest(),
               'scope': 'Read-only input validation and additive local packet drafts only'}
    with (output / 'receipt.json').open('xb') as f: f.write((json.dumps(receipt, indent=2) + '\n').encode())
    print(json.dumps(receipt), flush=True)
    assert result.returncode == expected
