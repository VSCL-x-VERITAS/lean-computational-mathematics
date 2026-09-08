from pathlib import Path
import hashlib
import json
import re
import subprocess

base = Path(__file__).resolve().parent
session = base.parent
repo = next(p for p in base.parents if (p / 'ComputationalMathematics').is_dir())
audit = session / 'audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def read(path):
    raw = path.read_bytes()
    return raw.decode('utf-16') if raw[:2] in (b'\xff\xfe', b'\xfe\xff') else raw.decode('utf-8-sig')

def write_once(path, obj):
    assert not path.exists(), path
    path.write_bytes((json.dumps(obj, indent=2) + '\n').encode('utf-8'))

queries = [
    (r'Real\.measurableSpace|Real\.borelSpace', ['.lake/packages/mathlib/Mathlib/MeasureTheory/Constructions/BorelSpace/Basic.lean']),
    (r'haarMeasure_self|noncomputable def haarMeasure', ['.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Haar/Basic.lean']),
    (r'irreducible_def stdOrthonormalBasis|toInnerProductSpaceReal|rclike_to_real',
     ['.lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace', '.lake/packages/mathlib/Mathlib/Analysis/RCLike']),
    (r'protected def ofReal|theorem toReal_ofReal', ['.lake/packages/mathlib/Mathlib/Data/ENNReal/Basic.lean']),
]
searches = []
for pattern, roots in queries:
    command = ['rg', '-n', '--glob', '*.lean', pattern, *roots]
    run = subprocess.run(command, cwd=repo, capture_output=True, encoding='utf-8')
    assert run.returncode in (0, 1), run.stderr
    searches.append({'command': command, 'exit_code': run.returncode,
                     'stdout': run.stdout, 'stderr': run.stderr})
write_once(base / 'additional-searches.json', searches)

blind = json.loads(read(audit / 'inputs/blind_dependency_inventory.json'))
entries = [entry for entry in blind['dependencies'] if entry['id'] in ('D028', 'D055')]
assert len(entries) == 2
assert next(entry for entry in entries if entry['id'] == 'D055')['body_readable'] == 'inferInstance'
write_once(base / 'frozen-dependency-entries.json', entries)

commands = [json.loads(read(base / name)) for name in
            ['first-exit.json', 'borel-exit.json', 'lean-version-exit.json', 'lean-deps-exit.json']]
assert all(item['exit_code'] == 0 for item in commands)
first = read(base / 'first-elaboration.txt')
borel = read(base / 'borel-elaboration.txt')
assert not re.search(r'\bsorryAx\b|\berror:', first + borel)
expected = [
    'Real.measureSpace', 'measureSpaceOfInnerProductSpace', 'Module.Basis.addHaar_def',
    'MeasureTheory.Measure.addHaarMeasure_self', 'Module.Basis.addHaar_self',
    'StieltjesFunction.measure_Ioc', 'Real.volume_eq_stieltjes_id', 'Real.volume_Icc',
    'Real.volume_Ioc', 'Real.volume_real_Icc_of_le', 'Real.volume_real_Ioc_of_le',
    'RealMeasureDependency.selectedInstance', 'RealMeasureDependency.selectedVolume',
    'RealMeasureDependency.stieltjesIdentity', 'RealMeasureDependency.unitInterval',
    'RealMeasureDependency.selectedBorel',
]
axioms = re.findall(r"'([A-Za-z0-9_.]+)' depends on axioms: \[(.*?)\]", first + '\n' + borel, re.S)
assert [name for name, _ in axioms] == expected
for name, values in axioms:
    assert {a.strip() for a in values.split(',')} <= {'propext', 'Classical.choice', 'Quot.sound'}, name
assert '@measureSpaceOfInnerProductSpace.{0} Real Real.normedAddCommGroup' in first
assert '@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace' in borel

source_files = [
    'Mathlib/MeasureTheory/Measure/MeasureSpaceDef.lean',
    'Mathlib/MeasureTheory/Constructions/BorelSpace/Basic.lean',
    'Mathlib/MeasureTheory/Measure/Haar/OfBasis.lean',
    'Mathlib/MeasureTheory/Measure/Haar/Basic.lean',
    'Mathlib/MeasureTheory/Measure/Stieltjes.lean',
    'Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean',
    'Mathlib/Analysis/InnerProductSpace/PiL2.lean',
    'Mathlib/Data/ENNReal/Basic.lean',
]
mathlib = repo / '.lake/packages/mathlib'
source_records = []
for name in source_files:
    source = mathlib / name
    compiled = mathlib / '.lake/build/lib/lean' / str(Path(name).with_suffix('.olean'))
    assert compiled.exists(), compiled
    source_records.append({'source_path': source.relative_to(repo).as_posix(), 'source_sha256': sha(source),
                           'compiled_path': compiled.relative_to(repo).as_posix(), 'compiled_sha256': sha(compiled)})
manifest = json.loads(read(repo / 'lake-manifest.json'))
mathlib_package = next(pkg for pkg in manifest['packages'] if pkg['name'] == 'mathlib')
assert mathlib_package['rev'] == 'e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
assert read(repo / 'lean-toolchain').strip() == 'leanprover/lean4:v4.29.0-rc3'
version = read(base / 'lean-version-output.txt').strip()
assert '4.29.0-rc3' in version
dependency_paths = [Path(line.strip()) for line in read(base / 'lean-deps-output.txt').splitlines() if line.strip()]
assert len(dependency_paths) == 3
binary = dependency_paths[0].parents[2] / 'bin/lean.exe'
assert binary.exists()
target = repo / 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation03TransportSolution.lean'
receipt_inputs = [audit / 'decision.json', audit / 'agent_outputs/adjudicator.json',
                  audit / 'inputs/blind_dependency_inventory.json', audit / 'inputs/dependency_inventory.json',
                  audit / 'manifest.json', target, repo / 'lean-toolchain', repo / 'lake-manifest.json']
write_once(base / 'input-runtime-provenance.json', {
    'lean_runtime_version': version, 'lean_binary': str(binary), 'lean_binary_sha256': sha(binary),
    'mathlib_package': mathlib_package,
    'direct_runtime_imports': [{'path': str(path), 'sha256': sha(path)} for path in dependency_paths],
    'selected_source_and_compiled_files': source_records,
    'immutable_inputs': [{'path': path.relative_to(repo).as_posix(), 'sha256': sha(path)} for path in receipt_inputs],
})

instance_block = first[:first.index('@[implicit_reducible] def measureSpaceOfInnerProductSpace')].strip()
measure_block = first[first.index('def MeasureTheory.MeasureSpace.volume'):first.index('@[irreducible] def Module.Basis.addHaar')].strip()
haar_block = first[first.index('def MeasureTheory.Measure.addHaarMeasure'):first.index('MeasureTheory.Measure.addHaarMeasure_self.')].strip()
file_table = '\n'.join('| `' + item['source_path'].removeprefix('.lake/packages/mathlib/') + '` | `' + item['source_sha256'] + '` |' for item in source_records)
dossier = f'''# Supplementary declaration dossier: real volume

This proof-free supplement addresses only frozen dependency D055
(`Real.measureSpace`) and its use through D028 (`MeasureSpace.volume`) in
`LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908`. It supplies runtime
definition evidence and existing normalization theorem statements. It makes no
source-faithfulness decision and does not resolve the separate profile-class or
temporal weak-conservation questions. No frozen audit or production file was edited.

## Exact stored instance and projection

The following is the actual `pp.all` output from the pinned runtime. The argument
to `inferInstance` is exposed; its meaning is not inferred from the surface syntax.

```lean
{instance_block}
```

The selected normed group is the ordinary real normed group; the selected inner
product and finite-dimensional structures are the displayed `RCLike` instances
specialized to `Real.instRCLike`. The measurable structure is `Real.measurableSpace`,
whose printed body is `borel ℝ`; `Real.borelSpace` certifies that choice.

```lean
{measure_block}
```

Thus the target's canonical volume is the projection of this exact fixed instance.
It is not an arbitrary measure supplied by a free theorem parameter. Two checked
definitional equalities expose its selected fields (proofs omitted here):

```lean
Real.measureSpace = measureSpaceOfInnerProductSpace (E := ℝ)
Real.measureSpace.toMeasurableSpace = borel ℝ
(volume : Measure ℝ) = (stdOrthonormalBasis ℝ ℝ).toBasis.addHaar
```

## Construction and normalization

`measureSpaceOfInnerProductSpace` preserves its supplied measurable space and sets
the volume field to `(stdOrthonormalBasis ℝ E).toBasis.addHaar`. Its source is
`Haar/OfBasis.lean:309`; the standard orthonormal basis is a selected orthonormal
basis, not an unnormalized arbitrary basis (`PiL2.lean:1037`).

`Module.Basis.addHaar` is an `irreducible_def`: its raw printed body is a generated
wrapper projection. The checked defining equation, rather than that opaque-looking
projection alone, supplies the meaningful next step:

```lean
Module.Basis.addHaar_def (b : Module.Basis ι ℝ E) :
  b.addHaar = MeasureTheory.Measure.addHaarMeasure b.parallelepiped
```

The readable header above suppresses its ordinary finite-dimensional/basis and
Borel-space instance binders; the full checked header is in the raw output.
`Basis.parallelepiped` packages the image of the unit coefficient cube under the
basis-coordinate map as a compact set with nonempty interior.

The additive Haar declaration is generated by `to_additive` from `haarMeasure`
at `Haar/Basic.lean:512–517`. The actual generated body printed by Lean is:

```lean
{haar_block}
```

The inverse mass factor fixes the scale. Existing checked normalization headers
(all theorem proofs omitted) include:

```lean
MeasureTheory.Measure.addHaarMeasure_self :
  (MeasureTheory.Measure.addHaarMeasure K₀) K₀ = 1
Module.Basis.addHaar_self (b : Module.Basis ι ℝ E) :
  b.addHaar (parallelepiped b) = 1
Real.volume_eq_stieltjes_id :
  (volume : Measure ℝ) = StieltjesFunction.id.measure
```

The first two are readable schematic headers with their ambient typeclass
binders suppressed; their complete signatures are in `first-elaboration.txt`.
The last is an equality of the complete measures. `StieltjesFunction.id` has
underlying function `x ↦ x`. The existing `StieltjesFunction.measure_Ioc` says
`f.measure (Set.Ioc a b) = ENNReal.ofReal (f b - f a)`.

Consequently the selected measure is normalized ordinary real length measure,
identified in this pinned Mathlib with the identity Stieltjes measure. This is
established by whole-measure equality and exact interval formulas, not merely by
a library name or by the fact that one interval has mass one.

## Exact interval meaning

These existing headers were checked, and their axiom lists were printed:

```lean
Real.volume_Icc {{a b : ℝ}} :
  volume (Set.Icc a b) = ENNReal.ofReal (b - a)
Real.volume_Ioc {{a b : ℝ}} :
  volume (Set.Ioc a b) = ENNReal.ofReal (b - a)
Real.volume_real_Icc_of_le {{a b : ℝ}} (hab : a ≤ b) :
  volume.real (Set.Icc a b) = b - a
Real.volume_real_Ioc_of_le {{a b : ℝ}} (hab : a ≤ b) :
  volume.real (Set.Ioc a b) = b - a
```

The second probe's `pp.all` output explicitly binds these real-volume formulas
to `@MeasureSpace.volume ℝ Real.measureSpace`. `ENNReal.ofReal r` is the
nonnegative extended-real embedding of `max r 0`; the source also states
`(ENNReal.ofReal r).toReal = max r 0`. Thus reversed endpoints give empty interval
mass zero, while ordered endpoints give length `b-a`. A small checked application
of the existing `volume_Ioc` formula gives the explicit normalization
`(@MeasureSpace.volume ℝ Real.measureSpace) (Set.Ioc 0 1) = 1`.

The measurable-space field is Borel. This dossier does not identify it with a
completed sigma algebra or claim that all subsets are measurable.

## Provenance and limits

Runtime: `{version}`.
Pinned Mathlib revision: `{mathlib_package['rev']}`.
The probe imports the actual current `Equation03TransportSolution` module plus
the selected Mathlib Lebesgue owner. `lean --deps` records the actual imported
compiled files. Source and corresponding compiled-owner hashes, the Lean binary
hash, and frozen dependency/decision hashes are in `input-runtime-provenance.json`.
This is selected dependency evidence, not an exhaustive rebuild or audit of every
transitive Mathlib foundation.

| Selected Mathlib source | SHA-256 |
|---|---|
{file_table}

Both native probes exited zero. The first has one stylistic `unnecessarySimpa`
warning, retained unchanged. All 16 printed axiom lists contain only `propext`,
`Classical.choice`, and `Quot.sound`. The five small evidence declarations are
definitional links or direct applications of existing measure theorems, not new
measure-construction proofs. The supplementary dossier omits their proofs.

The original adjudication remains nonaccepted and undetermined. Resolving this
definition evidence does not settle which nonsmooth profiles the source admits,
nor select a temporal interpretation of its integral conservation equation.
Root controls any future use through the supported sealed audit workflow.
'''
(base / 'supplementary-declaration-dossier.md').write_bytes(dossier.encode('utf-8'))
evidence = ['probe.lean', 'borel-probe.lean', 'first-elaboration.txt', 'first-exit.json',
            'borel-elaboration.txt', 'borel-exit.json', 'lean-version-output.txt', 'lean-version-exit.json',
            'lean-deps-output.txt', 'lean-deps-exit.json', 'reuse-searches.json', 'additional-searches.json',
            'frozen-dependency-entries.json', 'input-runtime-provenance.json',
            'supplementary-declaration-dossier.md', 'freeze.py']
write_once(base / 'final-verification.json', {
    'status': 'selected_measure_implementation_and_normalization_checked',
    'commands': commands, 'checked_axiom_declarations': expected,
    'source_correspondence_verdict': 'not assessed',
    'frozen_audit_production_kit_config_mutations': [],
    'evidence': [{'path': name, 'sha256': sha(base / name)} for name in evidence],
})
print(json.dumps({'receipt_sha256': sha(base / 'final-verification.json'),
                  'dossier_sha256': sha(base / 'supplementary-declaration-dossier.md'),
                  'runtime_provenance_sha256': sha(base / 'input-runtime-provenance.json'),
                  'probe_output_sha256': sha(base / 'first-elaboration.txt'),
                  'borel_output_sha256': sha(base / 'borel-elaboration.txt'),
                  'native_exits': [item['exit_code'] for item in commands]}, indent=2))
