"""Freeze completed actual builds and the exact41 target check; no acceptance claim."""
from pathlib import Path
import ast,hashlib,json
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:
        if isinstance(value,str):out.write(value)
        else:json.dump(value,out,indent=2);out.write('\n')
    return ref(F/name)
manifest=read(F/'manifest.json');pre=read(F/'source-pre.json')
assert len(manifest['rows'])==41 and len(manifest['declarations'])==41
verifications={kind:read(F/(kind+'-verification.json')) for kind in ('full_build','focused_build','complete_native')}
for kind,v in verifications.items():
    assert v['actual_exit']==0 and v['sources_and_configs_unchanged'] and v['source_set_unchanged']
    assert v['input_commit']==pre['input_commit'] and v['source_count']==6024
    for key in ('receipt','output'):
        pin=v['execution'][key];assert sha(R/pin['path'])==pin['sha256']
assert verifications['complete_native']['axiom_report_count']==41
assert {x['declaration'] for x in verifications['complete_native']['axiom_reports']}==set(manifest['declarations'])
for pin in pre['files']+pre['configs']+manifest['files']:assert sha(R/pin['path'])==pin['sha256']
assert (F/'native-tools-post.json').is_file()
executions=write('execution-descriptors.json',{'schema':1,'complete_declaration_manifest':ref(F/'manifest.json'),
    **{kind:v['execution'] for kind,v in verifications.items()},'input_commit':pre['input_commit'],
    'usage':'receipt/output/expected_command fields are directly usable by organization support.execution; raw capture receipts are unchanged.',
    'all_actual_exit_codes_zero':True,'selection_is_acceptance':False})
times={k:v['actual_elapsed_ms'] for k,v in verifications.items()}
review=write('README.md',f'''# Current41 target native verification

The full both-root build, focused Chapter01 build, and exact41 declaration/axiom probe each completed with actual exit0. Their elapsed times were {times['full_build']:,}, {times['focused_build']:,}, and {times['complete_native']:,} milliseconds respectively. Commands and raw output are captured by the unchanged `capture-check.py`; `execution-descriptors.json` supplies exact receipt/output references and expected commands for organization consumers.

The manifest preserves all41 previous row-to-declaration mappings and binds the current source files. The observed gate had39 closed rows (22 PROVED,17 REUSED), two IN_PROGRESS rows, and16 skipped rows. The new physical DIM specification selects its current changed source contract. The prior certified Info specification still selects its unchanged target while the accepted-context question remains unresolved. Selection is not acceptance; this packet supplies no semantic-audit verdict and changes no gate row.

All6,024 actual filesystem production Lean source hashes, the exact source set, and toolchain/Lake/tiers configuration hashes were checked against the frozen pre-run snapshot after each run and again at final freeze. This is a source-stability check, not a new tracked-layout census. The runtime post-check matches the native binaries from the frozen syntax-fingerprint export; its temporal scope is recorded explicitly.

The complete probe contains one `#check` and one `#print axioms` for each target. All41 exact target reports were present. Only `propext`, `Classical.choice`, and `Quot.sound` are allowed by the hash-pinned repository axiom policy. Empty reports and displayed universe suffixes are handled explicitly; only the trailing `.{{...}}` display suffix is normalized. No placeholder or additional axiom is accepted. Full/focused build outputs were also checked for reported nonstandard axioms.

The first preparation stopped before any native run because it looked for tiers at the repository root. Its script, partial target manifest, and actual failure facts are preserved. The additive completion verified those files and used the actual `docs/architecture/tiers.json`; the original artifacts were not overwritten. The tool transcript preserves that traceback, while `prepare-01-failure.json` expressly records transcribed failure facts rather than claiming a subprocess-captured log.

All native builds/checks passed on their first runs. No production source, old evidence, Git/index, gate, audit, or ledger was modified by this task. Actual HEAD was `{pre['input_commit']}`; any later source change requires a new applicability review or run.
''')
syntax=[]
for p in sorted(F.glob('*.py')):
    text=p.read_text();ast.parse(text);compile(text,str(p),'exec');syntax.append(ref(p))
verification=write('verification.json',dict(schema=1,status='CURRENT41 NATIVE VERIFICATION PASS; ACCEPTANCE NOT ASSERTED',
    manifest=ref(F/'manifest.json'),source_pre=ref(F/'source-pre.json'),executions=executions,
    checks={k:ref(F/(k+'-verification.json')) for k in verifications},runtime_post=ref(F/'native-tools-post.json'),
    source_count=6024,target_count=41,observed_gate_statuses=manifest['current_gate_statuses'],all_source_pins_unchanged=True,
    actual_exit_codes={k:0 for k in verifications},axiom_reports=41,syntax_checks=syntax,readme=review,
    source_acceptance=False,production_mutation=False,git_mutation=False))
receipt=write('final-receipt.json',dict(manifest=ref(F/'manifest.json'),verification=verification,execution_descriptors=executions,readme=review,
    input_commit=pre['input_commit'],actual_exit_codes={k:0 for k in verifications},target_count=41,source_acceptance=False))
print(json.dumps({'receipt':receipt,'manifest':ref(F/'manifest.json'),'execution_descriptors':executions,'verification':verification},indent=2))
