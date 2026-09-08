"""Extract the checked uniform-transport model without changing existing owners."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
D = S / 'equation02-transport'
sha = lambda b: hashlib.sha256(b).hexdigest()
candidate = (D / 'candidate.lean').read_bytes()
exit_record = json.loads((D / 'first-exit.json').read_text(encoding='utf-8-sig'))
assert exit_record['exit_code'] == 0
text = candidate.decode('utf-8')
start = text.index('/-- Uniform advection')
split = text.index('/-- Real-scalar hyperbolicity')
end = text.index('\nend NumStability', split)
header = '/-\nSPDX-License-Identifier: MIT\n-/\n\n'
files = [
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/Transport/UniformAdvection.lean',
  header + 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal\n'
  + 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle\n\n'
  + '/-!\n# Uniform transport and advection equations\n\nThe kinematic condition keeps the field constant along material trajectories of\na constant-velocity flow. It determines the translated initial profile and\nimplies the classical PDE or rectangle law on their explicit regularity domains.\n-/\n\n'
  + 'open MeasureTheory\n\nnamespace NumStability\n\n' + text[start:split].rstrip() + '\n\nend NumStability\n',
  ['IsUniformAdvection', 'isUniformAdvection_iff_eq_travelingWave', 'IsUniformAdvection.isLinearAdvectionSolution', 'IsUniformAdvection.isRectangleConservationLawSolution']),
 ('ComputationalMathematics/Source/LeVeque/Chapter01/Equation02UniformTransport.lean',
  header + 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection\n'
  + 'import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02\n'
  + 'import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity\n\n'
  + '/-!\n# LeVeque Chapter 1, equation (1.2): uniform transport model\n\nRandall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, printed page\n1 (raw PDF page 23), the scalar specialization and constant-velocity contaminant\ntransport discussion, equations (1.1)–(1.3). Section 1.1.2, printed pages 4–5,\ndistinguishes classical and integral solutions.\n\nThe kinematic premise says each material trajectory carries the same field\nvalue. It implies actual solution satisfaction, with differentiability or\ninterval integrability stated explicitly. Scalar hyperbolicity and the earlier\nscalar/system equation correspondence are retained. No empirical model error\nor additional physical constitutive law is asserted.\n-/\n\n'
  + 'open MeasureTheory\n\nnamespace NumStability\n\n' + text[split:end].rstrip() + '\n\nend NumStability\n',
  ['leveque01_equation02_uniformTransportModel'])]
records = []
for path, content, decls in files:
    p = R / path
    assert not p.exists()
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_bytes(content.encode('utf-8'))
    records.append({'path': path, 'sha256': sha(p.read_bytes()), 'declarations': ['NumStability.' + d for d in decls]})
checks = '\n'.join('import ' + f['path'][:-5].replace('/', '.') for f in records) + '\n\n'
checks += '\n'.join('#check ' + d + '\n#print axioms ' + d for f in records for d in f['declarations']) + '\n'
check_path = S / 'equation02-transport-production-checks.lean'
check_path.write_text(checks, encoding='utf-8', newline='\n')
manifest = {'schema': 1, 'files': records, 'check_file_sha256': sha(check_path.read_bytes()),
    'candidate_sha256': sha(candidate), 'candidate_output_sha256': sha((D / 'first-output.txt').read_bytes()),
    'candidate_exit_sha256': sha((D / 'first-exit.json').read_bytes()),
    'canonical_validation': 'pending'}
(S / 'equation02-transport-production-inputs.json').write_text(json.dumps(manifest, indent=2)+'\n')
task = json.loads((S / 'audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/audit-task.json').read_text())
ident = 'LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908'
task['task_id'] = ident
task['target'] = {'path': records[1]['path'], 'declaration': records[1]['declarations'][0]}
task['source']['locations'] = [
    {'location': 'raw PDF page 23; printed Chapter 1 page 1',
     'anchor': 'Scalar specialization paragraph, real-scalar hyperbolicity, and constant-velocity contaminant transport in equations (1.1)-(1.3)'},
    {'location': 'raw PDF pages 26-27; printed Chapter 1 pages 4-5',
     'anchor': 'Section 1.1.2: sufficiently smooth classical equations and integral conservation for discontinuous solutions'}]
task['source_group'] = ident.lower()
task['audit_output'] = (S / 'audits' / ident / 'faithfulness').relative_to(R).as_posix()
out = S / 'audits' / ident / 'audit-task.json'
assert not out.exists()
out.parent.mkdir(parents=True)
out.write_text(json.dumps(task, indent=2)+'\n', encoding='utf-8')
(S / 'equation02-transport-audit-inputs.json').write_text(json.dumps({'row': 'LEV-CH01-EQ-1.2-ADVECTION',
    'task_id': ident, 'task': out.relative_to(R).as_posix(), 'task_sha256': sha(out.read_bytes()),
    'prepared': False}, indent=2)+'\n')
print(json.dumps({'placed_files': 2, 'declarations': 5, 'task_id': ident}))
