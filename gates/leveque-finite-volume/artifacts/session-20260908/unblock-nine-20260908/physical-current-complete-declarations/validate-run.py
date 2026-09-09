"""Validate an actual native receipt, standard axiom reports, and source post-pins."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json,os,re,subprocess
F=Path(__file__).resolve().parent;D=F.parent;S=D.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name=='posix'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
ap=argparse.ArgumentParser();ap.add_argument('kind',choices=['full_build','focused_build','complete_native']);args=ap.parse_args()
plan=read(F/'execution-plan.json');pre=read(F/'source-pre.json');manifest=read(F/'manifest.json')
run=next(x for x in plan['runs'] if x['kind']==args.kind)
receipt_path=S/(run['label']+'-exit.json');output_path=S/(run['label']+'-output.txt')
receipt=read(receipt_path);raw=output_path.read_bytes();output=raw.decode('utf-8')
assert receipt['exit_code']==0 and receipt['input_commit']==pre['input_commit']
assert receipt['output_sha256']==hashlib.sha256(raw).hexdigest()
assert receipt['capture_script_sha256']==plan['capture']['sha256']==sha(R/plan['capture']['path'])
assert receipt['argv']==['lake',*run['argv']]
assert receipt['command']=='lake '+' '.join(run['argv'])
policy_path=R/'docs/architecture/allowed-axioms.json'
assert sha(policy_path)=='7a2b5067a55abd72d36b2b4171e018dec48b3f2692958e91edc8220222ba617e'
allowed={x['name'] for x in read(policy_path)['allowed_axioms']}
assert allowed=={'propext','Classical.choice','Quot.sound'}
assert 'sorryAx' not in output and 'native_decide' not in output
normalize=lambda name:re.sub(r'\.\{[^{}]*\}$','',name.strip())
reports=[]
for match in re.finditer(r"'([^']+)' depends on axioms:\s*\[([^]]*)\]",output):
    name,body=match.groups()
    normalized_body=re.sub(r'\.\{[^{}]*\}','',body)
    axioms={normalize(x) for x in normalized_body.split(',') if x.strip()}
    assert axioms<=allowed,(name,axioms)
    reports.append({'printed_name':name,'declaration':normalize(name),'printed_axiom_body':body,'axioms':sorted(axioms),'empty':not axioms})
for match in re.finditer(r"'([^']+)' does not depend on any axioms",output):
    name=match.group(1);reports.append({'printed_name':name,'declaration':normalize(name),'printed_axiom_body':None,'axioms':[],'empty':True})
if args.kind=='complete_native':
    assert len(reports)==len({x['declaration'] for x in reports})==41
    assert {x['declaration'] for x in reports}==set(manifest['declarations'])
    check=(R/manifest['check_file']).read_text()
    assert sha(R/manifest['check_file'])==manifest['check_file_sha256']
    for name in manifest['declarations']:
        for directive in ('check','print axioms'):assert re.search(r'^#'+directive+r'\s+'+re.escape(name)+r'\s*$',check,re.M)
paths=sorted(set([p.relative_to(R).as_posix() for root in ('ComputationalMathematics','NumStability') for p in (R/root).rglob('*.lean')]+['ComputationalMathematics.lean','NumStability.lean']))
assert paths==sorted(pin['path'] for pin in pre['files'])
for pin in pre['files']+pre['configs']+manifest['files']+[pre['manifest'],pre['check']]:
    assert sha(R/pin['path'])==pin['sha256'],pin['path']
git=['git','--no-optional-locks','--no-replace-objects','rev-parse','HEAD']
p=subprocess.run(git,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);assert p.returncode==0
assert p.stdout.decode().strip()==pre['input_commit']
data=dict(schema=1,kind=args.kind,status='ACTUAL NATIVE0 AND SOURCE POST-PINS PASS',at_utc=datetime.now(timezone.utc).isoformat(),
    execution=dict(receipt=ref(receipt_path),output=ref(output_path),expected_command=receipt['command']),
    actual_exit=0,actual_elapsed_ms=receipt['elapsed_ms'],input_commit=pre['input_commit'],source_pre=ref(F/'source-pre.json'),
    source_count=len(paths),sources_and_configs_unchanged=True,source_set_unchanged=True,manifest=ref(F/'manifest.json'),
    axiom_policy=ref(policy_path),axiom_reports=reports,axiom_report_count=len(reports),
    axiom_union=sorted({a for report in reports for a in report['axioms']}),
    universe_display_names_normalized=sum(x['printed_name']!=x['declaration'] for x in reports),
    normalization='Only trailing displayed .{...} universe suffixes are removed from declaration/axiom names; complete target-set equality remains mandatory.',
    posix_head_post=dict(command=git,exit_code=0,stdout=p.stdout.decode(),stderr=p.stderr.decode()),
    selection_is_acceptance=False,source_acceptance=False)
out=F/(args.kind+'-verification.json')
with out.open('x',encoding='utf-8',newline='\n') as f:json.dump(data,f,indent=2);f.write('\n')
print(json.dumps({'verification':ref(out),'execution':data['execution'],'actual_exit':0,'axiom_reports':len(reports),'source_count':len(paths)},indent=2))
