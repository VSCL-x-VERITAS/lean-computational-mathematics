"""Extract exactly four approved new LF leaves from the frozen information draft."""
from pathlib import Path
from hashlib import sha256
import datetime
import json
import re
import subprocess

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
DRAFT = SESSION / 'riemann-information-only-method-draft'
FV = REPO / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
assert not (HERE / 'placement-map.json').exists(), 'append-only placement'
digest = lambda p: sha256(p.read_bytes()).hexdigest()
record = lambda p: dict(path=str(p), sha256=digest(p))
assert digest(DRAFT / 'final-receipt.json') == '9fb9b60408c939a0ab22af27d01710c022f1a3a0665e0966732a8860f6f292a2'
assert digest(DRAFT / 'Candidate.lean') == '3d090a899d6a93ac19783ee2533f763084e9cac459e5e0e14f2b0058ffcfc466'
commands = [
    ['rg', '-n', 'RiemannInformationFluxMethod|RiemannFieldFluxMethodInformation|RiemannInformationFluxError|LeftStateInformationFlux', 'ComputationalMathematics'],
    ['rg', '-n', 'structure RiemannFieldFluxMethod|norm_sub_oneDimensionalCellAverage_le_of_trace|riemannFiniteVolumeUpdate_error_le', 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'],
    ['rg', '-n', 'nominally distinct|fromDraft|toDraft|type_comparison', 'gates/leveque-finite-volume/artifacts/session-20260908/returned-field-production/prepare_comparisons.py'],
]
searches = []
for index, command in enumerate(commands, 1):
    run = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = HERE / f'search-{index:02}.txt'
    output.write_bytes(run.stdout)
    searches.append(dict(command=command, exit_code=run.returncode, output=record(output)))
assert searches[0]['exit_code'] == 1 and not (HERE / 'search-01.txt').read_bytes()
core = (DRAFT / 'Core.lean.fragment').read_text(encoding='utf-8')
accuracy = (DRAFT / 'Accuracy.lean.fragment').read_text(encoding='utf-8')
examples = (DRAFT / 'Examples.lean.fragment').read_text(encoding='utf-8')
marker = '/-- Forget the extra field obligations'
core_body = core[core.index('namespace NumStability.InformationOnlyRiemannDraft'):core.index(marker)]
core_body += 'end Method\nend NumStability.InformationOnlyRiemannDraft\n'
adapter_body = core[core.index(marker):core.index('end Method\nend NumStability.InformationOnlyRiemannDraft')]
adapter_body = ('namespace NumStability.RiemannInformationFluxMethod\n\n'
                'variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}\n'
                'variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}\n\n' + adapter_body +
                'end NumStability.RiemannInformationFluxMethod\n')
def rename(text):
    text = text.replace('NumStability.InformationOnlyRiemannDraft.Witness', 'NumStability.LeftStateInformationFlux')
    text = text.replace('NumStability.InformationOnlyRiemannDraft.Method', 'NumStability.RiemannInformationFluxMethod')
    text = text.replace('NumStability.InformationOnlyRiemannDraft', 'NumStability')
    return re.sub(r'\bMethod\b', 'RiemannInformationFluxMethod', text)
def module(imports, title, doc, body, opened=''):
    return ('/-\nSPDX-License-Identifier: MIT\n-/\n\n' + ''.join('import ' + x + '\n' for x in imports) +
            '\n/-!\n# ' + title + '\n\n' + doc + '\n-/\n\n' + opened + rename(body))
base = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
specs = [
    ('RiemannInformationFluxMethod.lean', module([base+'RiemannInterface'],
       'Riemann routines returning information',
       'A routine on an explicit problem domain returns a dependent result, extracts\ninformation and computes a constant-consistent flux. No returned field or PDE\ncertificate is required. Consistency alone does not assert physical accuracy.', core_body), 5, 'reusable execution interface; minimal existing problem/grid owner'),
    ('RiemannFieldFluxMethodInformation.lean', module([base+'RiemannFieldFluxMethod',base+'RiemannInformationFluxMethod'],
       'Information interface of a field-returning Riemann method',
       'The adapter preserves the original dependent result, solve function, extractor\nand flux. A finite-interval trace fact can be recovered separately from the\nstronger field method; it is not an information-interface obligation.', adapter_body, 'open MeasureTheory\n\n'), 6, 'reusable adapter; field obligations imported only here'),
    ('RiemannInformationFluxError.lean', module([base+'CellAverageTraceEstimate',base+'FluxUpdateErrorBounds',base+'RiemannInformationFluxMethod'],
       'Conditional errors for information-returning Riemann routines',
       'An optional flux trace of the selected result requires integrability only on\nthe chosen finite step. Extraction and physical-reference errors imply face\nand cell-update bounds; only the two used faces carry update hypotheses.', accuracy[accuracy.index('namespace NumStability.'):], 'open MeasureTheory\n\n'), 2, 'reusable conditional estimates; no accuracy convention'),
    ('Examples/LeftStateInformationFlux.lean', module([base+'CellAverageTraceEstimate',base+'Examples.StationaryRiemannField',base+'RiemannFieldFluxMethodInformation'],
       'A left-state information flux',
       'The result stores only the two ordered state vectors. Selecting the left\nphysical flux is constant-consistent for the supplied law, without a generic\naccuracy claim. Separate unit-speed transport evidence identifies its average\nreference flux, and an existing field method embeds without changing its result.', examples[examples.index('namespace NumStability.'):], 'open MeasureTheory\n\n'), 11, 'reusable mathematical examples; not called upwind for arbitrary laws'),
]
def declarations(text):
    scopes, names = [], []
    for line in text.splitlines():
        ns = re.match(r'^namespace\s+(\S+)', line)
        dec = re.match(r'^(?:noncomputable )?(?:structure|def|theorem)\s+(\w+)', line)
        if ns: scopes.append(ns.group(1))
        elif re.match(r'^end(?:\s|$)', line) and scopes: scopes.pop()
        if dec: names.append('.'.join(scopes + [dec.group(1)]))
    return names
for rel, content, expected, _ in specs:
    path = FV / rel
    assert not path.exists() and not path.with_suffix('').exists(), 'new-only path collision'
    assert len(declarations(content)) == expected
    assert 'InformationOnlyRiemannDraft' not in content
    assert '\r' not in content
records = []
mapping = []
for rel, content, expected, reason in specs:
    path = FV / rel
    path.write_text(content, encoding='utf-8', newline='\n')
    names = declarations(content)
    for name in names:
        if name.startswith('NumStability.LeftStateInformationFlux.'):
            old = name.replace('NumStability.LeftStateInformationFlux.', 'NumStability.InformationOnlyRiemannDraft.Witness.')
        else:
            old = name.replace('NumStability.RiemannInformationFluxMethod', 'NumStability.InformationOnlyRiemannDraft.Method')
        mapping.append(dict(draft=old, canonical=name, path=str(path)))
    records.append(dict(**record(path), lines=len(content.splitlines()), declaration_count=expected,
                        declarations=names, role='reusable', rationale=reason,
                        imports=re.findall(r'^import (\S+)', content, re.M)))
payload = dict(placed_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
               frozen_draft=record(DRAFT / 'Candidate.lean'), frozen_receipt=record(DRAFT / 'final-receipt.json'),
               source_fragments=[record(DRAFT / f'{x}.lean.fragment') for x in ('Core','Accuracy','Examples')],
               new_files=records, declaration_map=mapping, searches=searches,
               nominal_policy='Method and OrderedResult are distinct nominal types; explicit field maps and bridges are required.',
               compatibility='Scratch namespace remains frozen; no existing public production declaration is renamed or removed.',
               reuse_notes=['Existing problem owner is sufficient for the core.', 'Existing norm/average/update proofs remain their canonical owners.',
                            'Comparison construction reuses the previous explicit-nominal placement approach.'],
               deferred_to_root=['aggregate exposure', 'tiers', 'full build', 'organization', 'audit binding', 'Git'],
               support=[record(REPO/'AGENTS.md'), record(REPO/'lean-toolchain'), record(REPO/'lake-manifest.json'),
                        record(SESSION/'returned-field-production/prepare_comparisons.py')])
(HERE / 'placement-map.json').write_text(json.dumps(payload,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(dict(map=record(HERE/'placement-map.json'), files=records)))
