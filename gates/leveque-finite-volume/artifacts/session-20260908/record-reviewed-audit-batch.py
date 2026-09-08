"""Append reviewed frozen audit notes, preserving previous ledgers and decisions."""
from pathlib import Path
import argparse,hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('spec',type=Path);a=p.parse_args()
read=lambda p:json.loads(p.read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
spec=read(a.spec);label=spec['label'];assert label.replace('-','').isalnum()
dest=S/(label+'-audit-records.json');assert not dest.exists()
G=R/'gates/leveque-finite-volume/chapter-01.json';before=G.read_bytes();g=read(G);records=[]
ledger=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
additions={ledger:[],process:spec.get('process_entries',[])}
for item in spec['audits']:
 taskdir=S/'audits'/item['task'];out=taskdir/'faithfulness';decision=read(out/'decision.json')
 assert sha(out/'decision.json')==item['decision_sha256']
 row=next(r for r in g['rows'] if r['id']==item['row'])
 if item.get('closure_label'):
  receipt=S/(item['closure_label']+'-exit.json');exit=read(receipt)
  assert type(exit['exit_code']) is int and exit['exit_code']==0
  assert sha(S/(item['closure_label']+'-output.txt'))==exit['raw_output_sha256']
  assert row['status'] in {'PROVED','REUSED'} and decision['accepted'] is True
  assert (R/row['faithfulness_task']).resolve()==(taskdir/'audit-task.json').resolve()
 else:
  assert decision['accepted'] is False and row['status'] in {'READY','IN_PROGRESS'}
  assert item.get('next_foundation')
  row['next_foundation']=item['next_foundation']
 entry=item['ledger_entry'];assert entry.startswith('| ') and entry.endswith(' |')
 additions[ledger].append(entry)
 records.append({'task':item['task'],'row':item['row'],'classification':decision['classification'],
  'accepted':decision['accepted'],'decision_sha256':sha(out/'decision.json'),'report_sha256':sha(out/'report.md'),
  'manifest_sha256':sha(out/'manifest.json'),'findings':decision['findings'],
  'remaining_uncertainties':decision['remaining_uncertainties'],'closure_label':item.get('closure_label')})
for path,entries in additions.items():
 original=path.read_bytes()
 for entry in entries:
  ident=entry.split('|')[1].strip();assert ident.encode() not in original
 if not entries:continue
 backup=S/(label+'-before-'+('book' if path==ledger else 'process')+'-ledger-'+sha(path)+'.bin')
 assert not backup.exists();backup.write_bytes(original)
 path.write_bytes(original.rstrip(b'\r\n')+b'\n'+('\n'.join(entries)+'\n').encode())
updated=(json.dumps(g,indent=2,ensure_ascii=False)+'\n').encode()
if updated!=before:
 prior=S/(label+'-prior-gate-'+hashlib.sha256(before).hexdigest()+'.json');assert not prior.exists();prior.write_bytes(before)
 assert G.read_bytes()==before;G.write_bytes(updated)
record={'schema':1,'spec_sha256':sha(a.spec),'audits':records,'gate_sha256':sha(G),
 'book_ledger_sha256':sha(ledger),'process_ledger_sha256':sha(process)}
dest.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'path':dest.relative_to(R).as_posix(),'sha256':sha(dest),'gate_sha256':sha(G)}))

