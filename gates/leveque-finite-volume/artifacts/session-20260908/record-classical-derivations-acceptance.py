from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
specs=[('LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908','1fc5c546c61d2f06ebcfea5d01c7c73781a7699112f028482956bfe432aa2720'),('LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908','0eb19bc7cc705d06d7fc3fbadf7805a0e2fd3f3c7649b323376f48dd9330b2c2')]
records=[]
for ident,expected in specs:
 p=S/'audits'/ident/'faithfulness/decision.json';assert sha(p.read_bytes())==expected
 d=json.loads(p.read_text());assert d['accepted'] and d['classification']=='faithful-equivalent'
 records.append({'task':ident,'decision_sha256':expected,'adjudicated':d['adjudicated'],'findings':d['findings']})
path=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
ident='LEV-C1-CLASSICAL-DERIVATION-SCOPE-021'
entry='| LEV-C1-CLASSICAL-DERIVATION-SCOPE-021 | LEV-CH01-EQ-1.7-WAVE-EQUATION; LEV-CH01-EQ-1.9-QUASILINEAR-FORM | classical scope made explicit | The printed derivations use implicit classical regularity and inherited acoustic material context | Eq1.7 uses the given acoustic system, actual derivative witnesses and mixed derivative equality; Eq1.9 is a local finite-dimensional chain-rule equivalence | Both accepted faithful-equivalent with both directions yes; Eq1.7 independently adjudicated and original roundtrip UND preserved | decisions 1fc5c546c61d2f06ebcfea5d01c7c73781a7699112f028482956bfe432aa2720 and 0eb19bc7cc705d06d7fc3fbadf7805a0e2fd3f3c7649b323376f48dd9330b2c2; root complete validations exit 0 | Acceptance does not assert arbitrary open-domain or nonphysical acoustic generalizations, velocity reconstruction, a weak chain rule, or the neighboring hyperbolicity statement. The Eq1.7 reused historical dependency identifier is resolved from exact current constructor evidence; its note remains in the audit. |'
before=path.read_bytes();assert ident.encode() not in before
(S/('ledger-before-'+ident+'-'+sha(before)+'.bin')).write_bytes(before)
path.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
p=S/'classical-derivations-acceptance-verification.json';assert not p.exists();p.write_text(json.dumps({'schema':1,'accepted':records},indent=2)+'\n')
print(json.dumps({'receipt_sha256':sha(p.read_bytes())}))
