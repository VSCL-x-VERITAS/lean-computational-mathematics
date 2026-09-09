from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
choices=json.loads((D/'selected-interpretations.json').read_bytes())
g=json.loads((R/'gates/leveque-finite-volume/chapter-01.json').read_bytes())
book=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
prior={}
for p,name in ((book,'book'),(process,'process')):
 prior[name]=sha(p)
 with (D/(name+'-issues-before-resumption.md')).open('xb') as f:f.write(p.read_bytes())
entries=[]
for i,row in enumerate([r for r in g['rows'] if r['status']=='IN_PROGRESS'],80):
 c=next(c for c in choices['choices'] if row['id'] in c['rows'])
 ident='LEV-C1-INTERPRETATION-RESUMED-'+str(i).zfill(3)
 assert ident.encode() not in book.read_bytes()
 entries.append('| '+ident+' | '+row['id']+' | explicit coordinator-selected source interpretation | Original printed ambiguity remains unchanged | '+c['selected_interpretation']+' | IN_PROGRESS; selected under the user goal, fresh audits required | selected-interpretations.json SHA256 '+sha(D/'selected-interpretations.json')+'; active-gate-validated-receipt.json SHA256 '+sha(D/'active-gate-validated-receipt.json')+' | Prepare and independently audit the full selected statement; preserve previous source-only decisions and do not count completion from selection alone. |')
book.write_bytes(book.read_bytes().rstrip(b'\r\n')+b'\n'+('\n'.join(entries)+'\n').encode())
pe='| LEV-SKILL-REOPENED-GLOBAL-EVIDENCE-072 | codex-start-1-v5-0-1-20260908 | resuming all nine formerly blocked rows | The first resumed gate check correctly rejected old global artifacts because they bind the complete prior row subject | Preserve the failed check and mark aggregate evidence pending before obtaining fresh evidence | resolved ACTIVE transition; final aggregate validation remains required | reopened-gate-receipt.json actual exit 1; active-gate-validated-receipt.json actual exit 0, gate 49e8e4674b23a37fa0139969237805ebeec35cb0f0b03e70f66b6b4e213a78f1 | The goal authorizes coordinator selection of the documented conventions; no detailed literal user reply or audit verdict is fabricated. |'
assert b'LEV-SKILL-REOPENED-GLOBAL-EVIDENCE-072' not in process.read_bytes()
process.write_bytes(process.read_bytes().rstrip(b'\r\n')+b'\n'+pe.encode()+b'\n')
out={'book_added':9,'process_added':1,'before_sha256':prior,'after_sha256':{'book':sha(book),'process':sha(process)}}
with (D/'resumption-ledgers-receipt.json').open('xb') as f:f.write((json.dumps(out,indent=2)+'\n').encode())
print(json.dumps(out))
