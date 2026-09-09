from pathlib import Path
import hashlib, json, mmap, re
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
inputs=json.loads((F/'inputs.json').read_bytes())
selected=set(inputs['selected_modules'])
old={r['name']:r for p in inputs['prior_fingerprints'] for r in json.loads((R/p['path']).read_bytes())['records'] if r['module'] in selected}
with (F/'native-expression-stream.jsonl').open('rb') as stream:
    with mmap.mmap(stream.fileno(),0,access=mmap.ACCESS_READ) as data:
        names=[m.group(1).decode() for m in re.finditer(rb'"name"\s*:\s*"([^"\\]+)"',data)]
assert len(names)==len(set(names))==560
missing=sorted(set(old)-set(names))
result={'diagnostic_only':True,'fresh_names':560,'old_selected_names':len(old),'missing':[old[n] for n in missing]}
with (F/'missing-names-diagnostic.json').open('x',encoding='utf-8',newline='\n') as out:json.dump(result,out,indent=2);out.write('\n')
print(json.dumps({'missing_names':missing,'old_selected':len(old),'sha256':hashlib.sha256((F/'missing-names-diagnostic.json').read_bytes()).hexdigest()},indent=2))
