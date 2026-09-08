"""Observe exact local dependency source/olean bytes and pinned native runtime."""
from pathlib import Path
from hashlib import sha256
import datetime, json, re, subprocess

here = Path(__file__).resolve().parent
repo = here.parents[4]
mapping = json.loads((here/'placement-map.json').read_bytes())
digest = lambda p: sha256(p.read_bytes()).hexdigest()
bind = lambda p: dict(path=str(p), sha256=digest(p))
pending = [Path(x['path']) for x in mapping['new_files']]
local, mathlib = {}, {}
while pending:
    path = pending.pop()
    module = '.'.join(path.relative_to(repo).with_suffix('').parts)
    if module in local: continue
    text = path.read_text(encoding='utf-8')
    imports = re.findall(r'^import\s+(\S+)', text, re.M)
    olean = repo/'.lake/build/lib/lean'/path.relative_to(repo).with_suffix('.olean')
    assert olean.is_file(), olean
    local[module] = dict(source=bind(path), olean=bind(olean), imports=imports)
    for imp in imports:
        assert not imp.startswith(('Source.', 'NumStability.')), imp
        if imp.startswith('ComputationalMathematics.'):
            pending.append(repo/Path(*imp.split('.')).with_suffix('.lean'))
        elif imp.startswith('Mathlib.'):
            src = repo/'.lake/packages/mathlib'/Path(*imp.split('.')).with_suffix('.lean')
            obj = repo/'.lake/packages/mathlib/.lake/build/lib/lean'/Path(*imp.split('.')).with_suffix('.olean')
            mathlib[imp] = dict(source=bind(src), olean=bind(obj))
command = ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', '--version']
run = subprocess.run(command, cwd=repo, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
out = here/'native-version.output.txt'
assert not out.exists()
out.write_bytes(run.stdout)
assert run.returncode == 0
manifest = json.loads((repo/'lake-manifest.json').read_bytes())
package = next(x for x in manifest['packages'] if x['name'] == 'mathlib')
result = dict(observed_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
              local_import_closure=local, direct_mathlib_imports=mathlib,
              package=package, toolchain=bind(repo/'lean-toolchain'),
              lake_manifest=bind(repo/'lake-manifest.json'),
              immutable_source=bind(here.parent/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'),
              runtime=dict(command=command, cwd=str(repo), exit_code=run.returncode, output=bind(out)),
              scope='Complete project-local import closure, its direct Mathlib source/olean imports, and pinned package; not a full transitive Mathlib file census.')
target = here/'dependency-provenance.json'
assert not target.exists()
target.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(path=str(target), sha256=digest(target), local_modules=len(local), direct_mathlib_modules=len(mathlib))))
