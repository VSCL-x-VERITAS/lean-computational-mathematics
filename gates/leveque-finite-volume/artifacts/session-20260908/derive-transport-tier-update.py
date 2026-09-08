"""Prepare the next exact-tier update, to run only after the real owner-addition commit."""
from pathlib import Path
S = Path(__file__).resolve().parent
text = (S / 'classify-committed-production.py').read_text()
text = text.replace('receipt=json.loads((S/"production-rename-receipt.json").read_text())',
    'receipt=json.loads((S/"transport-intro-proof-verification.json").read_text())')
text = text.replace('production-organization-review.md', 'transport-production-organization-review.md')
text = text.replace('tiers-before-production-', 'tiers-before-transport-')
text = text.replace('json.dumps(manifest,indent=2,ensure_ascii=False)', 'json.dumps(manifest,indent=1,ensure_ascii=False)')
start = text.index('# Add only the new leaves')
text = text[:start] + '''record={"schema":1,"introduction_commit":intro,"new_exact_rules":len(new_modules),
 "counts":manifest["counts"],
 "verification":"Exact records cite the actual eight-file addition commit. Aggregates were already connected and checked; run current unchanged tier/layout/compatibility validators."}
(S/"transport-tier-update.json").write_text(json.dumps(record,indent=2)+"\\n",encoding="utf-8")
print(json.dumps(record,indent=2))
'''
(S / 'classify-committed-transport.py').write_text(text, encoding='utf-8', newline='\n')
print('Wrote classify-committed-transport.py; no tier mutation performed.')
