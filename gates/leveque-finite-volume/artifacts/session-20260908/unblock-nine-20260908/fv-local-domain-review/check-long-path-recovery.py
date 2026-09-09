"""Test exact native long-path writes in scratch and read-only operational recovery pins."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,sys
F=Path(__file__).resolve().parent;D=F.parent;R=F.parents[5];S=D.parent
helper=D/'prepare-successor-audit-with-source-context-long-paths.py'
source=helper.read_text();tree=ast.parse(source)
ns={'Path':Path,'hashlib':hashlib,'json':json,'os':os,'D':D}
needed={'install_native_long_path_io','load_partial_recovery','verify_partial_recovery','create'}
nodes=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in needed]
assert len(nodes)==4
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper),'exec'),ns)
ns['install_native_long_path_io']()
specpath=D/'finite-volume-local-flux-update-audit-spec.json';spec=json.loads(specpath.read_bytes())
operational=S/'audits'/spec['task_id'];mp=F/'fv-partial-preparation-recovery.json'
digest=hashlib.sha256(mp.read_bytes()).hexdigest()
pins=ns['load_partial_recovery'](R,operational,specpath,mp,digest)
before={name:(hashlib.sha256((operational/name).read_bytes()).hexdigest(),(operational/name).stat().st_mtime_ns) for name in pins}
# Compute the original two payloads through the frozen preparer's actual prefix, without its writes.
parent=D/'prepare-successor-audit-with-source-context.py'
prefix=parent.read_text().split("T.mkdir();writej(T/'audit-task.json',task)")[0]
prefix=prefix.replace('assert not T.exists(),T','assert T.exists(),T')
saved=sys.argv;sys.argv=['prepare',str(specpath)];original={'__file__':str(parent)}
try:exec(compile(prefix,'read-only-preparation-prefix','exec'),original)
finally:sys.argv=saved
parent_ast=ast.parse(parent.read_text())
interpretation=next(n for n in parent_ast.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='interpretation' for t in n.targets))
exec(compile(ast.Module(body=[interpretation],type_ignores=[]),'read-only-interpretation-expression','exec'),original)
encoded=lambda obj:(json.dumps(obj,indent=2,ensure_ascii=False)+'\n').encode()
assert encoded(original['task'])==(operational/'audit-task.json').read_bytes()
assert encoded(original['interpretation'])==(operational/'user-interpretation-packet.json').read_bytes()
fixture=F/'native-long-path-recovery-fixture'/'audits'/spec['task_id'];fixture.mkdir(parents=True)
for name in pins:
 with (fixture/name).open('xb') as f:f.write((operational/name).read_bytes())
ns.update(T=fixture,recovery_pins=pins,recovery_started=False)
fixture_before={name:(fixture/name).stat().st_mtime_ns for name in pins}
ns['create'](fixture/'audit-task.json',encoded(original['task']))
ns['create'](fixture/'user-interpretation-packet.json',encoded(original['interpretation']))
assert {name:(fixture/name).stat().st_mtime_ns for name in pins}==fixture_before
output=fixture/'inherited-source-interpretation-packet.json'
data=encoded(original['context_data']['packet']);assert len(str(output))>260
ns['create'](output,data)
assert output.read_bytes()==data
assert output.relative_to(fixture).as_posix()=='inherited-source-interpretation-packet.json'
assert not str(output).startswith('\\\\?\\'),'Logical paths must stay normal.'
assert output.resolve()==output
rejections=[]
try:ns['create'](fixture/'audit-task.json',b'tampered')
except AssertionError:rejections.append('changed regenerated existing bytes')
else:raise AssertionError('tamper accepted')
try:ns['verify_partial_recovery'](fixture,pins,True)
except AssertionError:rejections.append('unexpected third partial-task file')
else:raise AssertionError('unexpected entry accepted')
try:ns['load_partial_recovery'](R,operational,specpath,mp,'0'*64)
except AssertionError:rejections.append('wrong recovery manifest hash')
else:raise AssertionError('wrong manifest hash accepted')
badpins={**pins,'audit-task.json':'0'*64}
try:ns['verify_partial_recovery'](operational,badpins)
except AssertionError:rejections.append('changed original pinned bytes')
else:raise AssertionError('wrong input pin accepted')
ns['verify_partial_recovery'](operational,pins,True)
after={name:(hashlib.sha256((operational/name).read_bytes()).hexdigest(),(operational/name).stat().st_mtime_ns) for name in pins}
assert before==after
receipt={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'helper_sha256':hashlib.sha256(helper.read_bytes()).hexdigest(),'recovery_manifest_sha256':digest,
 'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
 'scratch_write_path':str(output),'scratch_write_path_characters':len(str(output)),
 'exact_inherited_packet_sha256':hashlib.sha256(data).hexdigest(),
 'logical_path_semantics_preserved':True,'regenerated_two_payloads_exact':True,
 'existing_files_not_rewritten':True,'rejection_checks':rejections,
 'operational_directory_unchanged':True,'released_commands_run':False,'roles_invoked':False}
with (F/'long-path-recovery-checks.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(receipt,f,indent=2);f.write('\n')
print(json.dumps(receipt))
