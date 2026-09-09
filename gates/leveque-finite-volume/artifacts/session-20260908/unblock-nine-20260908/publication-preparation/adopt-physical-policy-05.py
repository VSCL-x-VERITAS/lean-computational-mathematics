"""Include the actually started fresh audit and retain exact private exclusions."""
from pathlib import Path
import copy
import hashlib
import json
import os
assert os.name != 'nt'
P = Path(__file__).resolve().parent
D = P.parent
S = D.parent
R = next(p for p in P.parents if (p / 'lean-toolchain').exists())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
base = P / 'policy-final-physical-04.json'
assert sha(base) == '6abede50dd48561b72e2f4f04b0cd48c8b41f230bcf07e5e9191884da949d4f1'
old = json.loads(base.read_bytes())
new = copy.deepcopy(old)
task_id = 'LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908'
task_dir = S / 'audits' / task_id
task = json.loads((task_dir / 'audit-task.json').read_bytes())
route = json.loads((task_dir / 'route-exit.json').read_bytes())
assert task['task_id'] == task_id and route['exit_code'] == 0
assert task['target']['declaration'] == 'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'
prefix = task_dir.relative_to(R).as_posix() + '/'
assert prefix not in new['allow_prefixes']
new['allow_prefixes'].append(prefix)
private = D / 'physical-dim-package-runtime-preparation/environment-failure-stdout.private.txt'
assert private.is_file()
private_ref = ref(private)
assert private_ref['path'] not in new['exclude_exact']
new['exclude_exact'][private_ref['path']] = 'Private environment-capture diagnostic retained locally; exact SHA256 ' + private_ref['sha256']
assert {k for k in old if old[k] != new[k]} == {'allow_prefixes', 'exclude_exact'}
out = P / 'policy-final-physical-05.json'
with out.open('xb') as f:
    f.write((json.dumps(new, indent=2) + '\n').encode())
record = {'kind': 'root-actual-fresh-audit-publication-policy-extension',
    'policy': ref(out), 'parent': ref(base), 'existing_started_audit': ref(task_dir / 'audit-task.json'),
    'actual_route': ref(task_dir / 'route-exit.json'), 'added_task_prefix': prefix,
    'private_exclusion': private_ref, 'private_contents_disclosed': False,
    'source_paths_and_archives_unchanged': True, 'audit_acceptance_claimed': False,
    'official_publication_check_run': False, 'staging_run': False}
receipt = P / 'policy-final-physical-05-adoption.json'
with receipt.open('xb') as f:
    f.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'policy': ref(out), 'receipt': ref(receipt)}))
