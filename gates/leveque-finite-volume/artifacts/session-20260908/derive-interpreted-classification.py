from pathlib import Path
S=Path(__file__).resolve().parent
text=(S/'classify-committed-transport.py').read_text()
text=text.replace('transport-intro-proof-verification.json','interpreted-transport-production-verification.json')
text=text.replace('files=[f["path"] for f in receipt["files"]]','files=[f["path"] for f in receipt["files"] if not f["path"].startswith("ComputationalMathematics/Source/")]')
text=text.replace('transport-production-organization-review.md','interpreted-transport-organization-review.md')
text=text.replace('tiers-before-transport-','tiers-before-interpreted-')
text=text.replace('transport-tier-update.json','interpreted-tier-update.json')
text=text.replace('actual eight-file addition commit','actual four-file addition commit, classifying only the two new reusable owners')
assert 'indent=1' in text and 'new_exact_rules' in text
dest=S/'classify-committed-interpreted.py';assert not dest.exists();dest.write_text(text,encoding='utf-8',newline='\n')
print(dest)

