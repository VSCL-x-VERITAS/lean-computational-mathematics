from pathlib import Path
import hashlib
import json

base = Path(__file__).resolve().parent
repo = next(p for p in base.parents if (p / 'ComputationalMathematics').is_dir())
mathlib = repo / '.lake/packages/mathlib'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def write_once(path, obj):
    if path.exists():
        assert json.loads(path.read_text(encoding='utf-8')) == obj, path
        return
    path.write_bytes((json.dumps(obj, indent=2) + '\n').encode())

provenance = json.loads((base / 'input-runtime-provenance.json').read_text(encoding='utf-8'))
extras = []
for name in ['Mathlib/Analysis/InnerProductSpace/Basic.lean',
             'Mathlib/Analysis/RCLike/Lemmas.lean', 'Mathlib/Analysis/RCLike/Basic.lean',
             'Mathlib/Analysis/Normed/Group/Real.lean']:
    source = mathlib / name
    compiled = mathlib / '.lake/build/lib/lean' / str(Path(name).with_suffix('.olean'))
    assert source.exists() and compiled.exists()
    extras.append({'source_path': source.relative_to(repo).as_posix(), 'source_sha256': sha(source),
                   'compiled_path': compiled.relative_to(repo).as_posix(), 'compiled_sha256': sha(compiled)})
provenance['selected_source_and_compiled_files'].extend(extras)
provenance['previous_provenance_sha256'] = sha(base / 'input-runtime-provenance.json')
write_once(base / 'input-runtime-provenance-v2.json', provenance)
text = (base / 'supplementary-declaration-dossier.md').read_text(encoding='utf-8')
text = text.replace('Two checked\ndefinitional equalities', 'Three checked\ndefinitional equalities')
text = text.replace('`input-runtime-provenance.json`', '`input-runtime-provenance-v2.json`')
rows = '\n'.join('| `' + item['source_path'].removeprefix('.lake/packages/mathlib/') + '` | `' + item['source_sha256'] + '` |' for item in extras)
text = text.replace('\nBoth native probes exited zero.', '\n' + rows + '\n\nBoth native probes exited zero.')
out = base / 'supplementary-declaration-dossier-v2.md'
assert not out.exists()
out.write_bytes(text.encode())
prior = json.loads((base / 'final-verification.json').read_text(encoding='utf-8'))
prior['prior_receipt_sha256'] = sha(base / 'final-verification.json')
prior['revision_scope'] = 'Corrected three-equality count; added selected RCLike and real norm source/compiled hashes. Lean probes and outputs unchanged.'
prior['revision_script_failure'] = 'First documentation revision failed reading UTF-8 under Windows cp1252, after writing additive provenance only. Repaired with explicit UTF-8; original frozen files unchanged.'
prior['final_dossier'] = out.name
prior['evidence'].extend({'path': name, 'sha256': sha(base / name)} for name in
                         ['input-runtime-provenance-v2.json', out.name, 'refine_dossier.py',
                          'refine-dossier-first-failed.py', 'revision-first-exit.json'])
write_once(base / 'final-verification-v2.json', prior)
print(json.dumps({'final_receipt_sha256': sha(base / 'final-verification-v2.json'),
                  'final_dossier_sha256': sha(out),
                  'final_provenance_sha256': sha(base / 'input-runtime-provenance-v2.json')}, indent=2))
