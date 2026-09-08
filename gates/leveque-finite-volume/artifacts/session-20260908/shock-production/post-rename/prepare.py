"""Prepare checks after the coordinator's import-only move; preserve prior evidence."""
from pathlib import Path
import hashlib
import json
import re

HERE=Path(__file__).resolve().parent
PRE=HERE.parent
REPO=PRE.parents[4]
rename=json.loads((PRE.parent/'production-rename-receipt.json').read_text(encoding='utf-8'))
lookup={r['old']:r for r in rename['files']}
modules=[]
files=[]
declarations=[]
for before in json.loads((PRE/'files-before-check.json').read_text(encoding='utf-8')):
    row=lookup[before['path']]
    assert before['sha256']==row['before_sha256']
    path=REPO/row['path']
    assert hashlib.sha256(path.read_bytes()).hexdigest()==row['sha256']
    body=path.read_text(encoding='utf-8')
    module=row['path'][:-5].replace('/','.')
    modules.append(module)
    files.append({'module':module,'path':row['path'],'sha256':row['sha256'],
                  'lines':len(body.splitlines())})
    namespace=re.search(r'^namespace (\S+)',body,re.MULTILINE).group(1)
    for m in re.finditer(r'^(def|theorem) ([A-Za-z0-9_]+)',body,re.MULTILINE):
        declarations.append({'name':namespace+'.'+m.group(2),'kind':m.group(1),
                             'module':module,'line':body[:m.start()].count('\n')+1})
old_decls=json.loads((PRE/'declarations.json').read_text(encoding='utf-8'))
assert [(r['name'],r['kind']) for r in declarations]==[(r['name'],r['kind']) for r in old_decls]
mapping=json.loads((PRE/'candidate-producer-map.json').read_text(encoding='utf-8'))
for value in mapping.values():
    value['module']=value['module'].replace('.ConservationLaw.','.ConservationLaws.')
for name,value in [('modules.json',modules),('files-before-check.json',files),
                   ('declarations.json',declarations),('candidate-producer-map.json',mapping)]:
    (HERE/name).write_text(json.dumps(value,indent=2)+'\n',encoding='utf-8')
checks='\n'.join('import '+m for m in modules)+'\n\n'
checks+='\n'.join('#check '+r['name']+'\n#print axioms '+r['name'] for r in declarations)+'\n'
(HERE/'Declarations.lean').write_text(checks,encoding='utf-8')
print(json.dumps({'modules':len(modules),'declarations':len(declarations),
                  'rename_receipt_sha256':hashlib.sha256((PRE.parent/'production-rename-receipt.json').read_bytes()).hexdigest()},indent=2))
