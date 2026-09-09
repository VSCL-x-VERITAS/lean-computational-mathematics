from pathlib import Path
import fitz,json,hashlib,subprocess
P=Path(__file__).resolve().parent;R=P.parents[5];S=P.parent.parent
source=S/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
assert hashlib.sha256(source.read_bytes()).hexdigest()=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
doc=fitz.open(source);hits=[]
for i in range(len(doc)):
    text=doc[i].get_text()
    low=text.lower()
    if 'high-resolution' in low and any(x in low for x in ('second-order','second order','smooth regions','smooth parts')):
        positions=[low.find(x) for x in ('high-resolution','second-order','second order','smooth regions','smooth parts') if x in low]
        hits.append({'raw_page':i+1,'excerpts':[text[max(0,j-180):j+650] for j in positions]})
(P/'source-search.json').write_text(json.dumps({'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'hits':hits},indent=2)+'\n',encoding='utf-8')
print(json.dumps(hits[:12],ensure_ascii=False,indent=2))
