from pathlib import Path
S=Path(__file__).resolve().parent
text=(S/'record-interpreted-organization.py').read_text()
text=text.replace('four-owner','seven-owner').replace('interpreted-organized','general-organized').replace('interpreted-default-full-build','general-default-full-build').replace('interpreted-tier-update','general-tier-update')
text=text.replace('4a29be754145fb1099e35feb679df6d4e524acc8','eed529aaf650561fb72318c5264bb074c1652ce3').replace('5925','5932').replace("tier['new_exact_rules']==2","tier['new_exact_rules']==5").replace("len(rebindings)==8","len(rebindings)==10").replace('4929','4934')
text=text.replace('interpreted-transport-production-verification','general-propagation-discontinuity-verification').replace('gate-before-interpreted-organization','gate-before-general-organization').replace('interpreted-organization-verification','general-organization-verification')
text=text.replace("'general-organized-rebind-right']","'general-organized-rebind-right','general-organized-equation02-rebind','general-organized-equation03-rebind','quasilinear-row-closure']")
p=S/'record-general-organization.py';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
