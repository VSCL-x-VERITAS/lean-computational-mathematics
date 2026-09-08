"""Bind exact completed native/released checks to the current legacy gate subject.

This projects actual successful command receipts. It neither creates semantic
judgments nor changes a source-row status. All inputs and outputs are hash checked.
Run through the prepared POSIX workflow launcher.
"""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,re,tomllib
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--label',required=True);p.add_argument('--gate-checker',type=Path,required=True)
a=p.parse_args();assert os.name!='nt' and a.label.replace('-','').isalnum()
read=lambda p:json.loads(p.read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
encode=lambda v:(json.dumps(v,indent=2,ensure_ascii=False)+'\n').encode()
G=R/'gates/leveque-finite-volume/chapter-01.json';original=G.read_bytes();g=read(G)
spec=importlib.util.spec_from_file_location('gate_check',a.gate_checker);checker=importlib.util.module_from_spec(spec);spec.loader.exec_module(checker)
context=checker.current_context(G,1);assert g['bindings']==context['bindings']
m=read(S/(a.label+'-inputs.json'));assert m['bindings']==context['bindings']
assert m['rows_sha256']==checker.canonical_sha256(g['rows'])
for f in m['files']:assert sha(R/f['path'])==f['sha256']
checkfile=R/m['check_file'];assert sha(checkfile)==m['check_file_sha256']
names=sorted({n for row in g['rows'] if row['status'] in checker.CLOSED_LEAN_STATUSES for n in row['lean_declarations']})
assert names==m['declarations'] and len(names)==m['count']
receipts={};outputs={}
def consume(suffix):
 label=a.label+'-'+suffix;e=read(S/(label+'-exit.json'));data=(S/(label+'-output.txt')).read_bytes()
 assert type(e['exit_code']) is int and e['exit_code']==0,label
 assert e.get('raw_output_sha256',e.get('output_sha256'))==hashlib.sha256(data).hexdigest(),label
 receipts[suffix]=e;outputs[suffix]=data.decode('utf-8-sig');return e
for suffix in ['source-inventory','layout','tiers','compatibility','hygiene','audits','declarations','focused-build','full-build']:consume(suffix)
def python_command(suffix,relative,tail=()):
 command=receipts[suffix]['command'];assert isinstance(command,list)
 assert command[0].endswith('python3') or command[0].endswith('python.exe')
 assert (R/command[1]).resolve()==(R/relative).resolve(),command
 assert command[2:]==list(tail),command
python_command('source-inventory',(S/'verify-reviewed-source-coverage.py').relative_to(R))
python_command('layout','tools/architecture/check_layout.py')
python_command('tiers','tools/architecture/check_tiers.py')
python_command('compatibility','tools/architecture/check_compatibility.py')
python_command('hygiene','tools/architecture/check_placeholders.py')
python_command('audits',(S/'validate-closed-row-audits-v2.py').relative_to(R),['--validate'])
assert receipts['declarations']['argv']==['lake','env','lean',checkfile.relative_to(R).as_posix()]
assert receipts['focused-build']['argv']==['lake','--quiet','--log-level=error','build','ComputationalMathematics.Source.LeVeque.Chapter01']
assert receipts['full-build']['argv']==['lake','--quiet','--log-level=error','build']
assert tomllib.loads((R/'lakefile.toml').read_text())['defaultTargets']==['ComputationalMathematics','NumStability']
for suffix in ['declarations','focused-build','full-build']:
 assert receipts[suffix]['input_commit']==m['input_commit'],suffix
 assert type(receipts[suffix]['elapsed_ms']) is int and receipts[suffix]['elapsed_ms']>=0
layout=outputs['layout']
for expected in ['unclassified modules: 0','mixed modules: 0','modules missing module docs: 0','legacy naming exceptions: 0','declaration-bearing umbrellas: 0','unsorted aggregate imports: 0','Layout contract satisfied']:
 assert expected in layout,expected
assert all(x==0 for x in g['verification_loops']['organization_completeness'].values())
audit= json.loads(outputs['audits']);assert audit['mode']=='released-complete-validation'
closed=sorted([r for r in g['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES],key=lambda r:r['id'])
assert audit['closed_rows']==len(closed) and [x['row'] for x in audit['records']]==[r['id'] for r in closed]
for record,row in zip(audit['records'],closed,strict=True):
 assert record['exit_code']==0 and record['decision_sha256']==sha(R/row['faithfulness_decision'])
axioms=[]
for name in names:
 match=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',outputs['declarations'])
 assert match,name
 found=sorted({x.strip() for x in match.group(1).split(',') if x.strip()});assert set(found)<=set(checker.ALLOWED_AXIOMS)
 axioms.append({'name':name,'axioms':found})
assert not re.search(r'(?m)^.*\.lean:\d+:\d+: error:',outputs['declarations'])
organization=g['verification_loops']['organization_completeness'];paths,mismatches=checker.cross_gate_state(R,organization);assert not mismatches
subject=checker.canonical_sha256({'book_id':checker.BOOK_ID,'unit_kind':'chapter','unit':1,'chapter':1,
 'source_unit_sha256':checker.PINNED_SOURCE_SHA256,'mode':'default','excluded_rows':[],'rows':g['rows']})
bindings=checker.global_artifact_bindings(1,context,subject)
payloads={
 'source_inventory':{'row_ids':sorted(r['id'] for r in g['rows']),
  'page_coverage':[{'row_id':r['id'],'printed_page':r['printed_page'],'pdf_page':r['pdf_page']} for r in sorted(g['rows'],key=lambda r:r['id'])],
  'printed_page_range':list(context['printed_range']),'pdf_page_range':list(context['pdf_range'])},
 'organization_scan':{'counters':organization,'unit_report':{'gate_path':G.relative_to(R).as_posix(),'chapter':1,
  'unit_audit_epoch':context['bindings']['unit_audit_epoch'],'unit_index_sha256':context['bindings']['unit_index_sha256'],'counters':organization},
  'cross_gate_consistency':{'gate_paths':paths,'counters':organization,'mismatches':[]}},
 'faithfulness_audit':{'rows':[{'row_id':r['id'],**{k:checker.text(r,k) for k in ['contract_hash','source_contract_sha256','blind_sha256','direct_sha256','round_trip_sha256','adjudication_sha256']}} for r in closed]},
 'declaration_resolution':{'declarations':names},'axiom_check':{'declarations':axioms},
 'hygiene_check':{'findings':[],'scanned_paths':context['lean_changed_paths']},
 'focused_build':{'passed':['ComputationalMathematics.Source.LeVeque.Chapter01']},
 'full_build':{'passed':['ComputationalMathematics','NumStability']}}
counts={'source_inventory':len(g['rows']),'organization_scan':len(paths),'faithfulness_audit':len(closed),
 'declaration_resolution':len(names),'axiom_check':len(names),'hygiene_check':0,'focused_build':1,'full_build':2}
primary={'source_inventory':'source-inventory','organization_scan':'layout','faithfulness_audit':'audits',
 'declaration_resolution':'declarations','axiom_check':'declarations','hygiene_check':'hygiene',
 'focused_build':'focused-build','full_build':'full-build'}
destination=S/(a.label+'-global-evidence');assert not destination.exists();destination.mkdir()
for name in checker.EVIDENCE_NAMES:
 command=receipts[primary[name]]['command'];command=command if isinstance(command,str) else json.dumps(command)
 artifact={'schema_version':1,'check':name,'bindings':bindings,'command':command,'exit_code':0,'count':counts[name],'payload':payloads[name]}
 path=destination/(name+'.json');path.write_bytes(encode(artifact))
 g['verification_evidence'][name]={'command':command,'artifact':path.relative_to(G.parent).as_posix(),
  'artifact_sha256':sha(path),'exit_code':0,'count':counts[name]}
defects,complete=checker.evidence_defects(g['verification_evidence'],gate_path=G,chapter=1,context=context,
 rows=g['rows'],organization=organization,used_artifacts=set())
assert not defects and all(complete.values()),defects
assert G.read_bytes()==original,'Gate changed during verification.'
(destination/'prior-gate.json').write_bytes(original)
(destination/'consumed-receipts.json').write_bytes(encode({'input_manifest_sha256':sha(S/(a.label+'-inputs.json')),
 'gate_subject_sha256':subject,'receipts':receipts,'output_sha256':{k:v.get('raw_output_sha256',v.get('output_sha256')) for k,v in receipts.items()},
 'qualification':'Audit acceptance is supplied by the exact sealed decisions, including separately recorded user interpretations.'}))
G.write_bytes(encode(g))
print(json.dumps({'bound_global_checks':len(complete),'closed_rows':len(closed),'declarations':len(names),'gate_sha256':sha(G),
 'scope':'All eight evidence records validate against the current rows; the released gate determines the chapter verdict.'}))
