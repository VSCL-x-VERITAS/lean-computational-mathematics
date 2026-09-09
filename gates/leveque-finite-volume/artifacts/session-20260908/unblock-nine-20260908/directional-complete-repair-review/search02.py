from pathlib import Path
import hashlib,json,subprocess,time
P=Path(__file__).resolve().parent;S=P.parent.parent
source=S/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(source)=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
command=['C:/Users/qed_s/bin/pdftotext.EXE','-layout',str(source),str(P/'source.txt')]
start=time.monotonic();r=subprocess.run(command,capture_output=True)
(P/'source-extraction-output.txt').write_bytes(r.stdout+r.stderr)
(P/'source-extraction-receipt.json').write_text(json.dumps({'command':command,'actual_exit_code':r.returncode,'elapsed_ms':int((time.monotonic()-start)*1000),'source_sha256':sha(source),'text_sha256':sha(P/'source.txt'),'output_sha256':sha(P/'source-extraction-output.txt')},indent=2)+'\n',encoding='utf-8')
assert r.returncode==0
hits=[]
for i,text in enumerate((P/'source.txt').read_text(encoding='utf-8').split('\f')):
    low=text.lower()
    if 'high-resolution' in low and any(x in low for x in ('second-order','second order','smooth regions','smooth parts')):
        positions=[low.find(x) for x in ('high-resolution','second-order','second order','smooth regions','smooth parts') if x in low]
        hits.append({'raw_page':i+1,'excerpts':[text[max(0,j-180):j+650] for j in positions]})
(P/'source-search.json').write_text(json.dumps({'source_sha256':sha(source),'hits':hits},indent=2)+'\n',encoding='utf-8')
print(json.dumps(hits[:9],ensure_ascii=False,indent=2))
