from pathlib import Path
import hashlib, json, os
P = Path(__file__).resolve().parent
shim = P.parent / 'fv-local-domain-review/native-long-path-io.py'
source = (P / 'run.py').read_text(encoding='utf-8')
assert source.count('P = Path(__file__).resolve().parent') == 1
assert source.count('R = P.parents[5]') == 1
new = source.replace('P = Path(__file__).resolve().parent',
    shim.read_text(encoding='utf-8') + "\nP = Path(__file__).resolve().parent / 'native-02'\nP.mkdir(exist_ok=False)")
new = new.replace('R = P.parents[5]', 'R = P.parents[6]')
with (P / 'run-v2.py').open('xb') as f: f.write(new.encode())
with (P / 'attempt-01-failure.json').open('xb') as f:
    f.write((json.dumps({'exit_code':1,'command':['python','-X','utf8','-B',str(P/'run.py')],
      'actual_tool_chunk':'71f565','actual_wall_time_seconds':0.380417667,
      'source_sha256':hashlib.sha256((P/'run.py').read_bytes()).hexdigest(),
      'failure':'FileNotFoundError at target.open(xb), run.py line 22, Windows long path. No Lean invocation occurred.',
      'provenance':'Transcribed actual tool result, not a subprocess stdout capture.'},indent=2)+'\n').encode())
with (P / 'v2-derivation.json').open('xb') as f:
    f.write((json.dumps({'changes':['Use already reviewed process-local Path I/O long-path shim without changing logical strings.','Use fresh native-02 output directory.'],
      'shim':str(shim),'shim_sha256':hashlib.sha256(shim.read_bytes()).hexdigest(),
      'original':hashlib.sha256((P/'run.py').read_bytes()).hexdigest(),
      'successor':hashlib.sha256((P/'run-v2.py').read_bytes()).hexdigest()},indent=2)+'\n').encode())
