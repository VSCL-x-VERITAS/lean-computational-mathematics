from pathlib import Path
S=Path(__file__).resolve().parent
text=(S/'classify-committed-interpreted.py').read_text()
text=text.replace('interpreted-transport-production-verification.json','general-propagation-discontinuity-verification.json').replace('interpreted-transport-organization-review.md','general-propagation-discontinuity-organization-review.md')
text=text.replace('tiers-before-interpreted-','tiers-before-general-').replace('interpreted-tier-update.json','general-tier-update.json')
text=text.replace('four-file addition commit, classifying only the two new reusable owners','seven-file addition commit, classifying only the five new reusable owners')
p=S/'classify-committed-general.py';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
