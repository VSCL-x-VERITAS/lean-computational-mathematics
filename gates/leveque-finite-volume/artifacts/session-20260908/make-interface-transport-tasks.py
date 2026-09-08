"""Write two new immutable audit selections for the checked successor drafts."""
from pathlib import Path
import copy, hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
base = json.loads((S / 'audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/audit-task.json').read_text())
specs = [
 ('LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908',
  'LEV-CH01-EQ-1.3-ADVECTED-PROFILE',
  'ComputationalMathematics/Source/LeVeque/Chapter01/Equation03TransportSolution.lean',
  'NumStability.leveque01_equation03_transportSolution',
  [{'location': 'raw PDF page 23; printed Chapter 1 page 1',
    'anchor': 'Equations (1.2)-(1.3) and the following arbitrary-profile, constant-speed, unchanged-shape solution assertion'},
   {'location': 'raw PDF pages 26-27; printed Chapter 1 pages 4-5',
    'anchor': 'Section 1.1.2 Discontinuous Solutions: sufficiently smooth differential form, and integral conservation for discontinuous solutions'}]),
 ('LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908',
  'LEV-CH01-RIEMANN-INTERFACE-FLUX',
  'ComputationalMathematics/Source/LeVeque/Chapter01/RectangleRiemannInterfaceFlux.lean',
  'NumStability.leveque01_rectangleRiemannInterfaceFlux_sourceContract',
  [{'location': 'raw PDF pages 26-27; printed Chapter 1 pages 4-5',
    'anchor': 'Sections 1.1.2 and 1.2: integral conservation for discontinuous solutions, normalized cell averages, and the interface Riemann-solve/information/flux/update workflow following (1.11)'}])]
records = []
for ident, row, target, decl, locations in specs:
    task = copy.deepcopy(base)
    task['task_id'] = ident
    task['target'] = {'path': target, 'declaration': decl}
    task['source']['locations'] = locations
    task['source_group'] = ident.lower()
    task['audit_output'] = (S / 'audits' / ident / 'faithfulness').relative_to(R).as_posix()
    out = S / 'audits' / ident / 'audit-task.json'
    assert not out.exists()
    out.parent.mkdir(parents=True)
    data = (json.dumps(task, indent=2, ensure_ascii=False)+'\n').encode('utf-8')
    out.write_bytes(data)
    records.append({'row': row, 'task_id': ident, 'task': out.relative_to(R).as_posix(),
        'task_sha256': hashlib.sha256(data).hexdigest(), 'prepared': False,
        'next_action': 'Canonical placement, native exact import checks, then sealed preparation and independent roles.'})
(S / 'interface-transport-audit-inputs.json').write_text(json.dumps({'schema': 1, 'tasks': records}, indent=2)+'\n')
print(json.dumps(records, indent=2))
