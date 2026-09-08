"""Select a stronger acoustic source target without changing the rejected audit."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
old = S / 'audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/audit-task.json'
task = json.loads(old.read_text())
ident = 'LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908'
task['task_id'] = ident
task['target'] = {'path': 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation04AcousticModel.lean',
    'declaration': 'NumStability.leveque01_equation04_acousticOneWayModel'}
task['source']['locations'] = [
    {'location': 'raw PDF page 24; printed Chapter 1 page 2',
     'anchor': 'Right-going sound-wave paragraph and equation (1.4), with the actual pressure/particle-velocity combination and acoustic sound speed given following (1.6)'},
    {'location': 'raw PDF page 25; printed Chapter 1 page 3',
     'anchor': 'Continuation of the constant linear acoustic two-mode interpretation'}]
task['source_group'] = ident.lower()
task['audit_output'] = (S / 'audits' / ident / 'faithfulness').relative_to(R).as_posix()
path = S / 'audits' / ident / 'audit-task.json'
assert not path.exists()
path.parent.mkdir(parents=True)
path.write_text(json.dumps(task, indent=2)+'\n', encoding='utf-8')
record = {'row': 'LEV-CH01-EQ-1.4-ONE-WAY-WAVE', 'task_id': ident,
    'task': path.relative_to(R).as_posix(), 'task_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
    'prepared': False, 'production_placement': 'pending; checked draft remains outside production'}
(S / 'equation04-acoustic-audit-inputs.json').write_text(json.dumps(record, indent=2)+'\n')
print(json.dumps(record))
