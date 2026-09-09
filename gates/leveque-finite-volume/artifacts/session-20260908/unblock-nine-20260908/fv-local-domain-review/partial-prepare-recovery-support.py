def load_partial_recovery(root, task_dir, spec_path, manifest_path, expected_digest):
 """Accept only the exact two-file failure before any released command ran."""
 raw=manifest_path.read_bytes();assert hashlib.sha256(raw).hexdigest()==expected_digest
 manifest=json.loads(raw)
 assert set(manifest)=={'format','task_path','spec','preparer_parent','existing_files','failure_stage'}
 assert manifest['format']=='two-file-unsealed-audit-preparation-recovery-1'
 assert manifest['failure_stage']=='before-released-route'
 assert task_dir.relative_to(root).as_posix()==manifest['task_path']
 assert manifest['spec']['path']==spec_path.resolve().relative_to(root).as_posix()
 assert manifest['spec']['sha256']==hashlib.sha256(spec_path.read_bytes()).hexdigest()
 assert manifest['preparer_parent']=={'path':D.relative_to(root).as_posix()+'/prepare-successor-audit-with-source-context.py','sha256':'f0f27bc5757411a7363fcc70a18c78b2d5bf8011920f9e7c9ee2ebc2013f4ce2'}
 assert hashlib.sha256((root/manifest['preparer_parent']['path']).read_bytes()).hexdigest()==manifest['preparer_parent']['sha256']
 expected_names={'audit-task.json','user-interpretation-packet.json'}
 assert isinstance(manifest['existing_files'],list) and len(manifest['existing_files'])==2
 pins={}
 for item in manifest['existing_files']:
  assert set(item)=={'path','sha256'}
  name=Path(item['path']).name
  assert name in expected_names and item['path']==(task_dir/name).relative_to(root).as_posix()
  assert name not in pins
  pins[name]=item['sha256']
 assert set(pins)==expected_names
 verify_partial_recovery(task_dir,pins,True)
 return pins


def verify_partial_recovery(task_dir,pins,initial=False):
 assert task_dir.is_dir() and not task_dir.is_symlink()
 if initial:assert {p.name for p in task_dir.iterdir()}==set(pins),'Unexpected partial-task entry.'
 for name,digest in pins.items():
  path=task_dir/name
  assert path.is_file() and not path.is_symlink()
  assert hashlib.sha256(path.read_bytes()).hexdigest()==digest,(name,'partial input changed')
