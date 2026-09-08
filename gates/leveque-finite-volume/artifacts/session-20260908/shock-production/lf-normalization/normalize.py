"""Normalize only the ten coordinator-authorized new Lean files, preserving bytes."""
import hashlib
import json
import os
from pathlib import Path

HERE=Path(__file__).resolve().parent
PRE=HERE.parent
REPO=PRE.parents[4]
rows=json.loads((PRE/'post-rename/files-before-check.json').read_text(encoding='utf-8'))
assert len(rows)==10
snapshot=HERE/'snapshots'
snapshot.mkdir(exist_ok=True)
receipt=[]
for row in rows:
    path=REPO/row['path']
    original=path.read_bytes()
    before=hashlib.sha256(original).hexdigest()
    assert before==row['sha256'],path
    normalized=original.replace(b'\r\n',b'\n')
    assert b'\r' not in normalized,path
    preserved=snapshot/(before+'.lean')
    assert not preserved.exists()
    preserved.write_bytes(original)
    assert preserved.read_bytes()==original
    temp=path.with_suffix('.lean.lf-normalization-tmp')
    assert not temp.exists()
    temp.write_bytes(normalized)
    os.replace(temp,path)
    assert path.read_bytes()==normalized
    receipt.append({'path':row['path'],'before_sha256':before,
                    'sha256':hashlib.sha256(normalized).hexdigest(),
                    'before_bytes':len(original),'after_bytes':len(normalized),
                    'crlf_count':original.count(b'\r\n'),
                    'snapshot':preserved.relative_to(PRE).as_posix()})
record={'schema':1,'operation':'CRLF to LF only; no declarations or imports changed',
        'files':receipt,'producer_count':10}
target=HERE/'receipt.json'
target.write_bytes((json.dumps(record,indent=2)+'\n').encode('utf-8'))
print(json.dumps({'status':'PASS','files':len(receipt),
                  'receipt_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),
                  'source_wrapper_sha256':receipt[-1]['sha256']},indent=2))
