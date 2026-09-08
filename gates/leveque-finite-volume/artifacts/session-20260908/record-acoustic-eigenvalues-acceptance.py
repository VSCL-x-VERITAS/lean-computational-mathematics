from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
A=S/'audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness'
expected={'manifest.json':'723dbdf4888faeaeec8ecd91825b175d40bf7daab57746a863d06ce8ae5e50d7','decision.json':'e1c0988ada33f693acf8cc68207d39891bca4afde70154c024b9203c2936638e','report.md':'16b4df39cd2ab888d0c6e9d1129aa8673999d8d47834398ea302acb8059dff44'}
for name,digest in expected.items():assert sha((A/name).read_bytes())==digest,name
d=json.loads((A/'decision.json').read_text());assert d['accepted'] is True and d['adjudicated'] is True
assert d['classification']=='faithful-equivalent' and not d['remaining_uncertainties']
assert all(x['verdict']=='yes' for x in d['implications'].values())
e=json.loads((S/'acoustic-eigenvalues-row-closure-exit.json').read_text());assert e['exit_code']==0
g=json.loads((R/'gates/leveque-finite-volume/chapter-01.json').read_text())
row=next(r for r in g['rows'] if r['id']=='LEV-CH01-ACOUSTICS-EIGENVALUES');assert row['status']=='REUSED' and row['adjudication_status']=='resolved'
ledger=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before=ledger.read_bytes();ident='LEV-C1-ACOUSTIC-SPECTRAL-CONTEXT-017';assert ident.encode() not in before
(S/('ledger-before-'+ident+'-'+sha(before)+'.bin')).write_bytes(before)
entry='| LEV-C1-ACOUSTIC-SPECTRAL-CONTEXT-017 | LEV-CH01-ACOUSTICS-EIGENVALUES | adjudicated physical domain and eigenvector orientation | The source identifies physical material density and positive sound speed; separate positivity is inherited context rather than a printed pair of inequalities | Independent adjudication confirms both eigenvalues, actual nonzero column eigenvectors, and the corresponding propagation signs; the name Left denotes the negative-speed vector, not a row-vector action | faithful-equivalent; accepted true after adjudication; both implications yes; no remaining uncertainty | manifest 723dbdf4888faeaeec8ecd91825b175d40bf7daab57746a863d06ce8ae5e50d7; decision e1c0988ada33f693acf8cc68207d39891bca4afde70154c024b9203c2936638e; report 16b4df39cd2ab888d0c6e9d1129aa8673999d8d47834398ea302acb8059dff44; root complete validator and baseline identity/axiom checks exit 0 | Row REUSED. Preserve the original roundtrip uncertainty and physical-context qualification; do not claim equivalence to arbitrary signed or degenerate material coefficients. |'
ledger.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
record={'schema':1,'audit':expected,'row':row['id'],'declarations':row['lean_declarations'],'status':row['status'],'classification':d['classification'],'adjudication':'resolved; original roles preserved','root_closure_output_sha256':sha((S/'acoustic-eigenvalues-row-closure-output.txt').read_bytes()),'source_ledger_sha256':sha(ledger.read_bytes())}
p=S/'acoustic-eigenvalues-acceptance-verification.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'verification_sha256':sha(p.read_bytes()),'closed_rows':len([r for r in g['rows'] if r['status'] in ['PROVED','REUSED','DISCREPANCY']])}))

