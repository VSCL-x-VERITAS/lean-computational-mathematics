from pathlib import Path
S=Path(__file__).resolve().parent
t=(S/'verify-interpreted-transport-production.py').read_text()
t=t.replace('exact four-file','exact seven-file').replace('interpreted-transport-production','general-propagation-discontinuity')
t=t.replace("len(m['files'])==4","len(m['files'])==7").replace("'declarations':4","'declarations':sum(len(f['declarations']) for f in m['files'])")
t=t.replace('The two interpreted correspondences require fresh independent audits; generic mass differentiation is a source-independent prerequisite.','The two new correspondences require fresh independent audits. The discontinuity comparison uses the separately recorded user interpretation; the full propagation target has explicit joint differentiability.')
p=S/'verify-general-production.py';assert not p.exists();p.write_text(t,encoding='utf-8',newline='\n')
