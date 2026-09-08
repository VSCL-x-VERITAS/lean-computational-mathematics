"""Bind completed full builds and the fresh dependency packet; preserve source uncertainty."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
record={'schema':1,'builds':[]}
for prefix in ['library-build-current-68d710e','library-build-quiet-68d710e']:
    epath=S/(prefix+'-exit.json');out=S/(prefix+'-output.txt')
    e=json.loads(epath.read_text(encoding='utf-8-sig'))
    assert e['exit_code']==0 and e['input_commit']=='68d710e84dbf830107f1faf47a0572327482341e'
    record['builds'].append({**e,'output_sha256':sha(out.read_bytes()),'exit_sha256':sha(epath.read_bytes()),
        'output_path':out.relative_to(R).as_posix()})
assert 'Build completed successfully (6593 jobs).' in (S/'library-build-current-68d710e-output.txt').read_text(encoding='utf-8-sig')
assert (S/'library-build-quiet-68d710e-output.txt').read_bytes()==b''
controlled=['ComputationalMathematics','NumStability','ComputationalMathematics.lean','NumStability.lean',
            'lean-toolchain','lake-manifest.json','lakefile.lean','docs/architecture/tiers.json']
head=subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip()
assert head=='68d710e84dbf830107f1faf47a0572327482341e'
for args in [['diff','--name-only','HEAD','--',*controlled],['ls-files','--others','--exclude-standard','--',*controlled]]:
    run=subprocess.run(['git','-c','core.longpaths=true',*args],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    assert run.returncode==0 and not run.stdout and not run.stderr
record['controlled_files_unchanged_from_build_commit']=controlled
record['quiet_build_reason']='Candidate replay compares exact output hashes. Native Lake help distinguishes progress suppression (--quiet) from successful-message filtering (--log-level=error); their combined completed run emitted zero bytes. This is not a cold pristine replay.'
A=S/'audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908'
construction=json.loads((A/'construction-receipt.json').read_text())
for path,expected in [(A/'audit-task.json',construction['task_sha256']),
    (R/construction['config_path'],construction['config_sha256']),
    (A/'dependency-environment-packet.json',construction['supplement_sha256'])]:assert sha(path.read_bytes())==expected
packet=json.loads((A/'dependency-environment-packet.json').read_text())
for item in packet['native_output_spans']:
    raw=(R/item['source_path']).read_bytes();assert sha(raw)==item['source_sha256']
    selected=raw[item['start_byte']:item['end_byte_exclusive']]
    assert sha(selected)==item['span_sha256'] and selected.decode('utf-8')==item['exact_text']
assert len(packet['native_output_spans'])==3 and len(packet['omissions'])==1
assert json.loads((S/'transport-context-root-prepared-exit.json').read_text())['exit_code']==0
record['fresh_context']={**construction,'root_prepared_output_sha256':sha((S/'transport-context-root-prepared-output.txt').read_bytes()),
    'review':'All three supplied spans equal their native byte slices. They contain definitions and checked theorem headers, with the printed Borel proof omitted. Old judgment narrative is not in this role packet. This is preparation/evidence review, not a source-faithfulness verdict.'}
old=S/'audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness'
assert sha((old/'decision.json').read_bytes())=='01e4efd1c1134ac2ce485180167b5008946be3dda116f50ba9888408a92eb9b9'
d=json.loads((old/'decision.json').read_text());assert not d['accepted'] and d['classification']=='undetermined' and d['adjudicated']
assert json.loads((S/'uniform-transport-nonaccepted-complete-exit.json').read_text())['exit_code']==0
ledger=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before=ledger.read_bytes();ident='LEV-C1-UNIFORM-TRANSPORT-CONTEXT-010';assert ident.encode() not in before
(S/('source-ledger-before-uniform-context-'+sha(before)+'.bin')).write_bytes(before)
entry='| LEV-C1-UNIFORM-TRANSPORT-CONTEXT-010 | LEV-CH01-EQ-1.2-ADVECTION | source solution-domain follow-up | The source gives uniform scalar transport while Chapter 1 leaves the full nonsmooth admissibility and mass-law time convention implicit | The uniform-transport target preserves scalar hyperbolicity, actual scalar/system equality and a noncircular kinematic model implying classical and rectangle conservation in their explicit domains | undetermined after independent adjudication; accepted false; both implications unclear; no source discrepancy certified | decision SHA-256 01e4efd1c1134ac2ce485180167b5008946be3dda116f50ba9888408a92eb9b9; report SHA-256 d41ea6c3ec96fb2a96096dc2c95dbd1ce3aacfa3173002c24c6639dc9180ecf9; root complete validator exit 0 | Preserve this result. First independently resolve the shared solution meaning using the fresh Eq1.3 context/environment audit, then use that actual outcome to choose a new Eq1.2 audit or the smallest remaining source-specific repair. No unaccepted role meaning is treated as a validated cache. |\n'
ledger.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode())
G=R/'gates/leveque-finite-volume/chapter-01.json';gb=G.read_bytes();g=json.loads(gb)
(S/('gate-before-uniform-context-'+sha(gb)+'.json')).write_bytes(gb)
row=next(r for r in g['rows'] if r['id']=='LEV-CH01-EQ-1.2-ADVECTION');assert row['status']=='READY'
row['next_foundation']='The uniform-transport successor is frozen nonaccepted/undetermined after independent adjudication. Its scalar, kinematic and nonvacuity content is confirmed; shared source profile/time conventions remain unresolved. Complete the fresh Eq1.3 context/environment audit before choosing a supported new Eq1.2 context audit or the smallest source-specific repair; retain the original omitted-claim and successor uncertainty evidence.'
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
record['source_ledger_sha256']=sha(ledger.read_bytes())
record['gate_sha256']=sha(G.read_bytes())
record['gate_global_evidence']='Still OPEN. Completed builds and preparation do not certify the remaining source rows.'
dest=S/'postcheckpoint-evidence-68d710e.json';assert not dest.exists()
dest.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt_sha256':sha(dest.read_bytes()),'full_build_jobs':6593,'quiet_build_output_bytes':0,'fresh_context_prepared':True,'formalized_rows_unchanged':6}))
