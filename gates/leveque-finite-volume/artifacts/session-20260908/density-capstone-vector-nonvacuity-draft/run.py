"""Assemble an exact frozen base plus additive witness; capture native checks."""
from pathlib import Path
from hashlib import sha256
import datetime
import json
import re
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
label = sys.argv[1]
source, output, receipt = [HERE / (label + suffix) for suffix in ('.lean', '.output.txt', '.receipt.json')]
assert not any(p.exists() for p in (source, output, receipt)), 'append-only native label'
digest = lambda p: sha256(p.read_bytes()).hexdigest()
base = SESSION / 'prospective-density-material-riemann-capstones-draft/Capstones.lean'
assert digest(base) == 'dc65d2f7412a99594efbe8b0936ee59685d71e3fd8cd1ec3501cd73dd19a5ec7'
fragment = HERE / 'Witness.lean.fragment'
names = ['NumStability.DensityCapstoneVectorWitness.' + x for x in
         re.findall(r'^(?:noncomputable )?(?:def|theorem)\s+(\w+)', fragment.read_text(encoding='utf-8'), re.M)]
reused = ['NumStability.ProspectiveSourceAlternatives.density_rectangle_capstone',
          'NumStability.linearAmplitude_isRectangleBalanceLawSolution',
          'NumStability.riemannData_intervalIntegrable', 'NumStability.riemannStep_signed_source_integral',
          'intervalIntegral.integral_smul_const']
checks = '\n'.join(f'#check {name}\n#print axioms {name}' for name in names + reused).encode()
source.write_bytes(base.read_bytes() + b'\n\n' + fragment.read_bytes() + b'\n\n' + checks + b'\n')
frozen = json.loads((SESSION / 'prospective-density-material-riemann-capstones-draft/evidence-manifest.json').read_text())
dependencies = []
for row in frozen['canonical_import_closure']:
    dependencies += [row, row['observed_built_olean']]
dependencies += frozen['selected_measure_sources']
for row in dependencies:
    assert digest(REPO / row['path']) == row['sha256']
before = digest(source)
command = ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', str(source)]
started, tick = datetime.datetime.now(datetime.timezone.utc).isoformat(), time.monotonic()
run = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
output.write_bytes(run.stdout)
result = dict(command=command, cwd=str(REPO), started_utc=started,
              elapsed_seconds=round(time.monotonic()-tick, 3), exit_code=run.returncode,
              source=str(source), source_sha256_before=before, source_sha256_after=digest(source),
              output=str(output), output_sha256=digest(output),
              frozen_base=dict(path=str(base), sha256=digest(base)),
              fragment_sha256=digest(fragment), runner_sha256=digest(Path(__file__)),
              source_unchanged=before == digest(source),
              dependencies_unchanged=all(digest(REPO / row['path']) == row['sha256'] for row in dependencies),
              dependencies=dependencies, new_declarations=names, reused_declaration_checks=reused,
              scope='Literal Fin 1 witness of the frozen prospective target; no source convention adopted.')
receipt.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(receipt=str(receipt), sha256=digest(receipt), exit_code=run.returncode)))
if run.returncode:
    print(run.stdout.decode('utf-8', errors='replace'))
sys.exit(run.returncode)
