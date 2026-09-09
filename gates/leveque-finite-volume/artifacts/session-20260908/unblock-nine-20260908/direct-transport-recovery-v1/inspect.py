from pathlib import Path
import os,json,hashlib
D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
T=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
P=T/'faithfulness/orchestration'
tr=json.loads((P/'d_transport.json').read_bytes())
raw=(P/'d_input.txt').read_bytes()
canonical=(T/'faithfulness/inputs/direct_review_packet.md').read_text(encoding='utf-8')
result={'original_chars':len(raw.decode()),'documents':[]}
for item in tr['inputs']:
 p=Path(item['path']);b=p.read_bytes();assert hashlib.sha256(b).hexdigest()==item['sha256']
 row={'name':p.name,'bytes':len(b)}
 if p.suffix=='.json':
  obj=json.loads(b);c=json.dumps(obj,ensure_ascii=False,separators=(',',':'))
  strings=[]
  def walk(x,path):
   if isinstance(x,str) and len(x)>256:strings.append((path,x))
   elif isinstance(x,dict):
    for k,v in x.items():walk(v,path+'/'+k)
   elif isinstance(x,list):
    for i,v in enumerate(x):walk(v,path+'/'+str(i))
  walk(obj,'')
  matches=[(path,len(x)) for path,x in strings if x in canonical]
  row.update(compact_chars=len(c),long_strings=len(strings),in_packet_count=len(matches),in_packet_chars=sum(n for _,n in matches),largest_matching=sorted(matches,key=lambda x:-x[1])[:8])
 result['documents'].append(row)
print(json.dumps(result,indent=2))
x=json.loads((T/'dependency-environment-packet.json').read_bytes())
def show(x,p):
 if isinstance(x,str) and len(x)>500:print(p,len(x),repr(x[:75]))
 elif isinstance(x,dict):
  for k,v in x.items():show(v,p+'/'+k)
 elif isinstance(x,list):
  for i,v in enumerate(x):show(v,p+'/'+str(i))
show(x,'')
import difflib
big=x['native_output_spans'][3]['exact_text']
a=canonical.splitlines(keepends=True);b=big.splitlines(keepends=True)
blocks=difflib.SequenceMatcher(None,a,b,autojunk=False).get_matching_blocks()
print('native3_common_full_line_chars',sum(len(''.join(b[v.b:v.b+v.size])) for v in blocks if len(''.join(b[v.b:v.b+v.size]))>160))
from collections import Counter
c=Counter(a);print('direct_duplicate_line_chars',sum((v-1)*len(k) for k,v in c.items() if v>1 and len(k)>160))
