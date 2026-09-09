from pathlib import Path
import hashlib, json
P = Path(__file__).resolve().parent
source = (P / 'run.py').read_text(encoding='utf-8')
new = source.replace('P = Path(__file__).resolve().parent',
    "P = Path(__file__).resolve().parent.parent / 'ftaylor-options-03'\nP.mkdir(exist_ok=False)")
new = new.replace("overlay = P / 'source'", 'overlay = P')
with (P / 'run-v3.py').open('xb') as f: f.write(new.encode())
with (P / 'v3-derivation.json').open('xb') as f:
    f.write((json.dumps({'original_sha256':hashlib.sha256((P/'run.py').read_bytes()).hexdigest(),
      'successor_sha256':hashlib.sha256((P/'run-v3.py').read_bytes()).hexdigest(),
      'changes':['Fresh short sibling scratch directory ftaylor-options-03, itself the exact Mathlib module root, to avoid Win32 long-path limitation in Lean.'],
      'prior_failure':'native-02 dependency probe actual exit 1: source path exceeded Windows path limit. It never reached source elaboration. Actual stderr and exit sidecar are retained.'},indent=2)+'\n').encode())
