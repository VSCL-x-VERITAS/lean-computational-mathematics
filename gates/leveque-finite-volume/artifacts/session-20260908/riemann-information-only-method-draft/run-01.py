"""Native Lean execution with retained exact attempts and dependency bindings."""
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
record = lambda p: dict(path=str(p), sha256=digest(p))
fragments = [HERE / f'{name}.lean.fragment' for name in ('Core', 'Accuracy', 'Examples')]
names = []
for fragment in fragments:
    scopes = []
    for line in fragment.read_text(encoding='utf-8').splitlines():
        namespace = re.match(r'^namespace\s+(\S+)', line)
        declaration = re.match(r'^(?:noncomputable )?(?:def|theorem|structure)\s+(\w+)', line)
        if namespace:
            scopes.append(namespace.group(1))
        elif re.match(r'^end(?:\s|$)', line) and scopes:
            scopes.pop()
        if declaration:
            names.append('.'.join(scopes + [declaration.group(1)]))
reused = ['NumStability.norm_sub_oneDimensionalCellAverage_le_of_trace',
          'NumStability.riemannFiniteVolumeUpdate_error_le',
          'NumStability.StationaryRiemannField.reference_rectangle',
          'NumStability.StationaryRiemannField.stationary_trace_eq_reference',
          'NumStability.StationaryRiemannField.nonexact_instance']
prefix = ('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxError\n'
          'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField\n\n').encode()
checks = '\n'.join(f'#check {name}\n#print axioms {name}' for name in names + reused)
checks += '\n#print NumStability.InformationOnlyRiemannDraft.Method\n'
checks += '#print NumStability.InformationOnlyRiemannDraft.Witness.OrderedResult\n'
checks += '#print NumStability.InformationOnlyRiemannDraft.Method.selectedResult\n'
checks += '#print NumStability.InformationOnlyRiemannDraft.Method.interfaceFlux\n'
source.write_bytes(prefix + b'\n\n'.join(p.read_bytes() for p in fragments) + b'\n\n' + checks.encode())
pending = re.findall(r'^import (ComputationalMathematics\.[\w.]+)', source.read_text(encoding='utf-8'), re.M)
modules = {}
while pending:
    module = pending.pop()
    if module in modules:
        continue
    path = REPO / (module.replace('.', '/') + '.lean')
    olean = REPO / '.lake/build/lib/lean' / (module.replace('.', '/') + '.olean')
    modules[module] = dict(source=record(path), compiled=record(olean))
    pending += re.findall(r'^import (ComputationalMathematics\.[\w.]+)', path.read_text(encoding='utf-8'), re.M)
inputs = [record(p) for p in fragments + [HERE / 'run.py', REPO / 'lean-toolchain', REPO / 'lake-manifest.json']]
all_bound = inputs + [row[k] for row in modules.values() for k in ('source', 'compiled')]
before = digest(source)
command = ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', str(source)]
started, tick = datetime.datetime.now(datetime.timezone.utc).isoformat(), time.monotonic()
run = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
output.write_bytes(run.stdout)
result = dict(command=command, cwd=str(REPO), started_utc=started,
              elapsed_seconds=round(time.monotonic()-tick, 3), exit_code=run.returncode,
              source=str(source), source_sha256_before=before, source_sha256_after=digest(source),
              output=str(output), output_sha256=digest(output),
              source_unchanged=before == digest(source),
              dependencies_unchanged=all(digest(Path(row['path'])) == row['sha256'] for row in all_bound),
              inputs=inputs, canonical_import_closure=modules,
              new_declarations=names, reused_declaration_checks=reused,
              scope='Unselected information-only Riemann routine with optional finite-step comparison.')
receipt.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(receipt=str(receipt), sha256=digest(receipt), exit_code=run.returncode, new_declarations=len(names))))
if run.returncode:
    print(run.stdout.decode('utf-8', errors='replace'))
sys.exit(run.returncode)
