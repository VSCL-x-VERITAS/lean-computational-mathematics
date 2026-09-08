"""Prepare final checks against the exact LF production bytes."""
from pathlib import Path
import hashlib
import json
import re

HERE=Path(__file__).resolve().parent
PRE=HERE.parent
REPO=PRE.parents[4]
normalization=json.loads((PRE/'lf-normalization/receipt.json').read_text(encoding='utf-8'))
rows=normalization['files']
files=[]
modules=[]
declarations=[]
for row in rows:
    path=REPO/row['path']
    raw=path.read_bytes()
    assert b'\r' not in raw and hashlib.sha256(raw).hexdigest()==row['sha256']
    body=raw.decode('utf-8')
    module=row['path'][:-5].replace('/','.')
    modules.append(module)
    files.append({'module':module,'path':row['path'],'sha256':row['sha256'],
                  'lines':len(body.splitlines())})
    namespace=re.search(r'^namespace (\S+)',body,re.MULTILINE).group(1)
    for m in re.finditer(r'^(def|theorem) ([A-Za-z0-9_]+)',body,re.MULTILINE):
        declarations.append({'name':namespace+'.'+m.group(2),'kind':m.group(1),
                             'module':module,'line':body[:m.start()].count('\n')+1})
old=json.loads((PRE/'declarations.json').read_text(encoding='utf-8'))
assert [(r['name'],r['kind']) for r in declarations]==[(r['name'],r['kind']) for r in old]
mapping=json.loads((PRE/'post-rename/candidate-producer-map.json').read_text(encoding='utf-8'))
for name,value in [('modules.json',modules),('files-before-check.json',files),
                   ('declarations.json',declarations),('candidate-producer-map.json',mapping)]:
    (HERE/name).write_bytes((json.dumps(value,indent=2)+'\n').encode('utf-8'))
checks='\n'.join('import '+m for m in modules)+'\n\n'
checks+='\n'.join('#check '+r['name']+'\n#print axioms '+r['name'] for r in declarations)+'\n'
(HERE/'Declarations.lean').write_bytes(checks.encode('utf-8'))
runner=(PRE/'post-rename/run-focused.ps1').read_text(encoding='utf-8')
runner=runner.replace('/shock-production/post-rename', '/shock-production/post-rename-lf')
runner=runner.replace('$index = 4;', '$index = 0;')
(HERE/'run-focused.ps1').write_bytes(runner.encode('utf-8'))
review=(PRE/'extraction-review.md').read_text(encoding='utf-8')
review=review.replace('ConservationLaw/', 'ConservationLaws/').replace('.ConservationLaw.', '.ConservationLaws.')
review+='''\n## Controlled path and line-ending corrections\n\nThe coordinator moved only newly added nested law modules to `ConservationLaws/`,\npreserving the existing declaration-bearing `ConservationLaw.lean` owner.\nThe shared rectangle import and Huber family imports follow that new owner.\n`production-rename-receipt.json` binds the complete move and unchanged existing\nowners. The old build, ten direct elaborations and all 56 declaration checks\npassed and remain separate pre-rename evidence.\n\nStaging then identified CRLF production files. `lf-normalization/receipt.json`\nbinds snapshots and an atomic CRLF-to-LF change on exactly the ten new Huber\nproduction files, with no declaration or import changes. This directory binds\nfresh checks to the final LF bytes. Session `.gitattributes` uses `* -text` so\nraw compiler outputs, snapshots and hash receipts remain exact in Git.\n'''
(HERE/'extraction-review.md').write_bytes(review.encode('utf-8'))
print(json.dumps({'modules':len(modules),'declarations':len(declarations),
                  'source_sha256':files[-1]['sha256']},indent=2))
