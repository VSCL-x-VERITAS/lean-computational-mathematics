"""Create a separate audit input; preserve all earlier targets and role artifacts."""
from pathlib import Path
import copy, hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
old = S / 'audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/audit-task.json'
task = copy.deepcopy(json.loads(old.read_text()))
ident = 'LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-PRODUCTION-20260908'
task['task_id'] = ident
task['target'] = {'path': 'ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsRightModeAlgebraic.lean',
    'declaration': 'NumStability.leveque01_acousticsRightMode_of_pos_ratio'}
task['source']['locations'].append({'location': 'raw PDF page 23; printed Chapter 1 page 1',
    'anchor': 'Real space-time and actual partial-derivative conventions for the equations; main right-mode claim and positive-speed context remain on raw page 24.'})
task['source_group'] = 'leveque-chapter-01-acoustics-right-mode-algebraic-20260908'
task['audit_output'] = 'gates/leveque-finite-volume/artifacts/session-20260908/audits/' + ident + '/faithfulness'
path = S / 'audits' / ident / 'audit-task.json'
assert not path.exists()
assert hashlib.sha256((R / task['target']['path']).read_bytes()).hexdigest() == '143afa75803d27917e2a1226f56b221bf367899e141e705cf3d3d0b742b06ba9'
path.parent.mkdir(parents=True)
path.write_text(json.dumps(task, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
record = {'row': 'LEV-CH01-ACOUSTICS-RIGHT-MODE', 'task_id': ident, 'task': path.relative_to(R).as_posix(),
    'task_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
    'prior_nonaccepted_task_retained': 'LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908',
    'state_at_creation': 'Canonical placement done; canonical checks, sealed preparation and independent roles required.'}
(S / 'right-domain-audit-inputs.json').write_text(json.dumps(record, indent=2)+'\n', encoding='utf-8')
print(json.dumps(record))

