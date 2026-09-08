from pathlib import Path
from hashlib import sha256
import datetime
import json
import subprocess
import sys
import time

HERE=Path(__file__).resolve().parent
SESSION=HERE.parent
REPO=SESSION.parents[3]
label, mode=sys.argv[1:]
mapping=json.loads((HERE/'placement-map.json').read_text(encoding='utf-8'))
files=[Path(row['path']) for row in mapping['new_files']]
digest=lambda p:sha256(p.read_bytes()).hexdigest()
output, receipt=HERE/(label+'.output.txt'),HERE/(label+'.receipt.json')
assert not output.exists() and not receipt.exists(), 'append-only native label'
modules=[str(path.relative_to(REPO).with_suffix('')).replace('\\','.') for path in files]
source=None
if mode=='build':
    command=['C:/Users/qed_s/.elan/bin/lake.exe','build']+modules
elif mode=='declarations':
    source=HERE/(label+'.lean')
    assert not source.exists()
    content='\n'.join('import '+x for x in modules)+'\n\n'
    content+='\n'.join(f"#check {row['canonical']}\n#print axioms {row['canonical']}" for row in mapping['declaration_map'])+'\n'
    source.write_text(content,encoding='utf-8',newline='\n')
    command=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',str(source)]
elif mode=='comparisons':
    source=HERE/(label+'.lean')
    assert not source.exists()
    frozen=Path(mapping['frozen_draft']['path'])
    assert digest(frozen)==mapping['frozen_draft']['sha256']
    prefix='\n'.join('import '+x for x in modules)+'\n\n'
    source.write_bytes(prefix.encode()+frozen.read_bytes()+b'\n\n'+(HERE/'Comparisons.lean.fragment').read_bytes())
    command=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',str(source)]
else:
    raise ValueError(mode)
before={str(p):digest(p) for p in files+[HERE/'run.py',REPO/'lean-toolchain',REPO/'lake-manifest.json']}
if source is not None: before[str(source)]=digest(source)
started,tick=datetime.datetime.now(datetime.timezone.utc).isoformat(),time.monotonic()
run=subprocess.run(command,cwd=REPO,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
output.write_bytes(run.stdout)
result=dict(command=command,cwd=str(REPO),started_utc=started,elapsed_seconds=round(time.monotonic()-tick,3),
            exit_code=run.returncode,inputs=before,inputs_unchanged=all(digest(Path(p))==h for p,h in before.items()),
            output=str(output),output_sha256=digest(output),mode=mode,
            source=None if source is None else str(source),
            scope='Four approved new information-method leaves; no aggregate/gate/audit/Git edits.')
receipt.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(dict(receipt=str(receipt),sha256=digest(receipt),exit_code=run.returncode)),flush=True)
if run.returncode:
    sys.stdout.buffer.write(run.stdout)
    sys.stdout.buffer.flush()
sys.exit(run.returncode)
