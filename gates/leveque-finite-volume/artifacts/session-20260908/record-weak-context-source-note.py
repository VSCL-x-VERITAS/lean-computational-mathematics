"""Preserve an auxiliary-source observation without adding a Chapter 11 obligation."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
contract=S/'audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json'
assert sha(contract.read_bytes())=='bf3ed35bde478adf764d2269a3d9963f0e3e80efb9bb0c26548c6f679da6f93c'
source=json.loads(contract.read_text());assert len(source['ambiguities'])==4
ledger=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before=ledger.read_bytes();ident='LEV-C1-AUXILIARY-WEAK-CONTEXT-011';assert ident.encode() not in before
(S/('source-ledger-before-weak-context-'+sha(before)+'.bin')).write_bytes(before)
entry='| LEV-C1-AUXILIARY-WEAK-CONTEXT-011 | LEV-CH01-EQ-1.3-ADVECTED-PROFILE, explanatory source context only | apparent typo and temporal-domain qualification in later context | The same book\'s printed p215 equation (11.33) shows the initial-data spatial integral from 0 to infinity, while its surrounding space integrals are over the whole real line; its time integral starts at 0, whereas Chapter 1 introduces real space and time | No Chapter 11 theorem or correction is added. Existing Chapter 1 production remains unchanged. | independently observed in source extraction and root image inspection; apparent contextual issue, not a refutation or closure of the selected Chapter 1 claim | fresh source-contract SHA-256 bf3ed35bde478adf764d2269a3d9963f0e3e80efb9bb0c26548c6f679da6f93c; immutable source PDF SHA-256 b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5; raw pp237-238 | Preserve the literal context and its qualifications in independent judging. Do not silently repair (11.33), infer a complete profile class from the typo, or turn the explanatory pages into additional selected-unit mathematics. |\n'
ledger.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode())
record={'schema':1,'source_role_sha256':sha(contract.read_bytes()),'ledger_sha256':sha(ledger.read_bytes()),
        'scope':'Auxiliary context observation only; no production/gate/profile/module/kit changes and no new formalization obligation.'}
dest=S/'weak-context-source-note.json';assert not dest.exists()
dest.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record))
