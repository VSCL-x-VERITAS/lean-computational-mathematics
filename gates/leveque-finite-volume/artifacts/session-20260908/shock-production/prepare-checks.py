"""Enumerate every new public declaration and prepare exact resolution checks."""
import hashlib
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[4]
modules = json.loads((HERE / 'modules.json').read_text(encoding='utf-8'))
rows = []
files = []
for module in modules:
    path=REPO/(module.replace('.','/')+'.lean')
    body=path.read_text(encoding='utf-8')
    namespace=re.search(r'^namespace (\S+)',body,re.MULTILINE).group(1)
    for match in re.finditer(r'^(def|theorem) ([A-Za-z0-9_]+)',body,re.MULTILINE):
        rows.append({'name':namespace+'.'+match.group(2),'kind':match.group(1),
                     'module':module,'line':body[:match.start()].count('\n')+1})
    files.append({'module':module,'path':path.relative_to(REPO).as_posix(),
                  'lines':len(body.splitlines()),
                  'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
assert len({r['name'] for r in rows}) == len(rows)
checks='\n'.join('import '+m for m in modules)+'\n\n'
checks+='\n'.join('#check '+r['name']+'\n#print axioms '+r['name'] for r in rows)+'\n'
(HERE/'Declarations.lean').write_text(checks,encoding='utf-8')
(HERE/'declarations.json').write_text(json.dumps(rows,indent=2)+'\n',encoding='utf-8')
(HERE/'files-before-check.json').write_text(json.dumps(files,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'modules':len(modules),'declarations':len(rows),
                  'theorems':sum(r['kind']=='theorem' for r in rows),'files':files},indent=2))
