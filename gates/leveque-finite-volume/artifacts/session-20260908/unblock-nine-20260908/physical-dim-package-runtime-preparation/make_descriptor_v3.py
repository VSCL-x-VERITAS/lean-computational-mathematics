from pathlib import Path
import hashlib
import json
import sys
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
parent = P / 'runtime-descriptor-v2.json'
data = json.loads(parent.read_bytes())
data['parent_descriptor'] = {'path': parent.relative_to(R).as_posix(), 'sha256': sha(parent)}
data['native_python'] = {'path': str(Path(sys.executable).resolve()), 'sha256': sha(Path(sys.executable))}
capture = P / 'capture_environment.py'
data['environment_capture'] = {'path': capture.relative_to(R).as_posix(), 'sha256': sha(capture)}
out = P / 'runtime-descriptor-v3.json'
with out.open('x', encoding='utf-8') as stream:
    stream.write(json.dumps(data, indent=2) + '\n')
print(sha(out))
