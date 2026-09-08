"""Install only exact independently reviewed prepared gate bytes under a local lock.

Run through the prepared POSIX launcher. This operation is not a terminal
certificate: the separate released verify-installed command is still required.
"""
from pathlib import Path
import argparse,fcntl,hashlib,importlib.util,json,os,stat,tempfile
S=Path(__file__).resolve().parent
B=S/'blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py'
EXPECTED='dbfb374e263b7b0a2f25e9d1b8815a3e65d4e4e0e693581c24a881299fa017a9'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--preparation',type=Path,required=True)
p.add_argument('--preparation-sha256',required=True)
p.add_argument('--proposed-sha256',required=True)
p.add_argument('--label',required=True)
a=p.parse_args()
assert os.name!='nt' and sha(B)==EXPECTED
spec=importlib.util.spec_from_file_location('reviewed_blocked_binder',B)
b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
b.require(b.re.fullmatch(r'[a-z0-9][a-z0-9-]*',a.label),'unsafe installation label')
for x in [a.preparation_sha256,a.proposed_sha256]:
 b.require(b.re.fullmatch(r'[0-9a-f]{64}',x),'invalid reviewed digest')
out=S/'blocked-gate-installation'/a.label
b.require(not out.exists(),'installation output already exists')
lock_path=S/'blocked-gate-installation.lock'
b.require(not lock_path.is_symlink(),'symlink lock')
with lock_path.open('a+b') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX)
 reader=b.Reader(b.ROOT);checker=b.load_checker(reader)
 reader.raw(Path(__file__).resolve())
 prep=b.parse(reader.raw(a.preparation.absolute(),a.preparation_sha256))
 b.require(prep.get('kind')=='prepared-blocked-gate-proposal' and prep.get('status')=='PREPARED_UNVERIFIED','not an unverified preparation')
 original=reader.raw(b.GATE)
 b.require(b.digest(original)==prep['base_gate_sha256'],'operational gate changed since preparation')
 proposal=reader.bound(prep['proposed_gate'],as_json=False)
 b.require(b.digest(proposal)==a.proposed_sha256,'proposal differs from independent review')
 for item in prep['input_files']:
  reader.raw(Path(item['path']),item['sha256'])
 request=b.parse(reader.raw(Path(prep['request']['path']),prep['request']['sha256']))
 b.require(request['question_projection']==prep['question_projection'],'question projection changed')
 b.require(reader.bound(request['base_gate'],as_json=False)==original,'base snapshot differs')
 base=b.parse(original);proposed=b.parse(proposal)
 context=checker.current_context(b.GATE,1)
 b.require(prep['bindings']==context['bindings'] and prep['input_commit']==context['lean_current_head'],'controlled context changed')
 identities=b.parse(reader.raw(b.PINS['row_set'][0]))
 b.check_header(base,context,checker)
 b.check_transition(base,proposed['rows'],identities,checker)
 b.check_provenance(request,proposed['rows'],context,reader,checker,identities)
 organization=proposed['verification_loops']['organization_completeness']
 cross_gate_before=checker.cross_gate_state(b.ROOT,organization)
 b.require(not cross_gate_before[1],'cross-gate organization mismatch')
 complete=b.validate_proposed(proposed,context,checker,reader)
 b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed during validation')
 reader.unchanged()
 b.require(checker.current_context(b.GATE,1)==context,'context changed before installation')
 b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed before installation')
 b.require(b.GATE.read_bytes()==original,'gate changed before installation')
 out.mkdir(parents=True)
 backup=out/'prior-gate.json'
 with backup.open('xb') as f:
  f.write(original);f.flush();os.fsync(f.fileno())
 mode=stat.S_IMODE(b.GATE.stat().st_mode)
 fd,tmp=tempfile.mkstemp(prefix='.chapter01-reviewed-',suffix='.tmp',dir=b.GATE.parent)
 temporary=Path(tmp)
 try:
  with os.fdopen(fd,'wb') as f:
   f.write(proposal);f.flush();os.fsync(f.fileno())
  os.chmod(temporary,mode)
  b.require(temporary.read_bytes()==proposal,'temporary proposal bytes differ')
  reader.unchanged()
  b.require(checker.current_context(b.GATE,1)==context and b.GATE.read_bytes()==original,'context/gate changed at write boundary')
  b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed at write boundary')
  os.replace(temporary,b.GATE)
  directory_fd=os.open(b.GATE.parent,os.O_RDONLY)
  try:os.fsync(directory_fd)
  finally:os.close(directory_fd)
 finally:
  if temporary.exists():temporary.unlink()
 b.require(b.GATE.read_bytes()==proposal,'installed gate bytes differ')
 result=dict(kind='exact-reviewed-blocked-gate-installation',status='INSTALLED_UNVERIFIED',
  preparation_sha256=a.preparation_sha256,proposed_gate_sha256=a.proposed_sha256,
  prior_gate=dict(path=backup.relative_to(b.ROOT).as_posix(),sha256=sha(backup)),
  installer_sha256=sha(Path(__file__).resolve()),binder_sha256=EXPECTED,
  input_commit=context['lean_current_head'],bindings=context['bindings'],
  reviewed_payload_checks=complete,
  operational_writes=[b.GATE.relative_to(b.ROOT).as_posix()],
  concurrency='Exclusive installer lock plus repeated exact-byte/context checks; root owns all operational gate writers.',
  terminal_verification='NOT_RUN: run the frozen helper verify-installed and released reconciliation/campaign checks separately.')
 target=out/'installation.json'
 with target.open('xb') as f:
  f.write(b.encode(result));f.flush();os.fsync(f.fileno())
 print(json.dumps(dict(status='INSTALLED_UNVERIFIED',receipt=b.make_ref(target))))

