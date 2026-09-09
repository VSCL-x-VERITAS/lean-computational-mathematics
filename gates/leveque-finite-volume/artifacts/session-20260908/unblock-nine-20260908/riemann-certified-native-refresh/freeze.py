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
inputs=read(F/'inputs.json');v=read(F/'packet-validation.json');native=read(F/'native-01/receipt.json')
assert v['actual_native_exit']==native['exit_code']==0 and native['inputs_unchanged']
assert v['report_count']==36 and v['old_primary_text_exactly_equal']
for pin in read(F/'native-environment.json')['environment_files']:assert sha(R/pin['path'])==pin['sha256']
for key in ('prior_packet','prior_environment','prior_native_receipt','probe_bytes_identical_to','source_target','context_templates_unchanged'):
    pin=inputs[key];assert sha(R/pin['path'])==pin['sha256']
review=write('README.md',f'''# Certified Riemann current native evidence refresh

The exact previous `CompleteTypesReadable.lean` probe was copied byte for byte (SHA5262c093cf4715c766788cb38f0784f95dc7a497e7229b294c80235fc487c117) and rechecked against the current compiled project. Native Lean exited0 in {native['elapsed_ms']:,}ms with unchanged input pins and empty stderr. All36 exact declarations produced allowed axiom reports. The complete output is byte-identical to the earlier packet:68,720 characters/70,777 UTF-8 bytes. No native definition or theorem statement was added, removed or narrowed.

The target remains `NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract`, source SHA3ea14df37c089e35fb4a7e780ad927c4ca838630484764017833d06bd5ade027. The supplied native probe contains the original joint applicability proof so Lean can check it; the emitted dossier retains `pp.proofs=false` and exposes only types/definition bodies with proof terms hidden, as before. All generic operator and norm/integral spans, all probe commands, and all mathematical scope/omission text are unchanged JSON values.

Rechecking the previous283 environment references found exactly five changes: the extended `ConservationLaws.Hyperbolicity` source and the compiled files for it, `BiasedLocalRiemannRoutine`, `LocalRiemannInformation`, and the source wrapper. Every changed compiled owner lies in the actual32-project-owner import closure. Current native source/compiled pins are captured before and after the run; stale historical bindings are preserved in the previous packet and explicitly mapped to their current counterparts in `inputs.json`.

The refreshed environment has307 unique exact pins. `additional-supplement.json` contains the packet/environment FileRefs expected by the existing preparer. Validation executed only the extracted read-only `load_additional_supplement` function from the exact reviewed long-path preparer SHAfc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e. It checked every native span and configured hash. The preparer's top-level code and all model roles were not executed.

The packet records fresh current native receipts and distinguishes older production receipts as historical. It also references the completed current full/focused/41 checks. The original context-successor templates and all earlier packet/audit bytes remain unchanged. No operational audit spec, new source context, literal reply, representative/certificate convention, or source-acceptance claim was created. The pending interpretation remains root's separate responsibility.

The unchanged inherited native runner was launched through a small wrapper that applies the already reviewed process-local extended-path I/O support; logical paths and probe bytes remain unchanged. The helper, wrapper, runner and their hashes are retained. No production, gate, ledger, Git/index or released helper was edited. Preparation, native execution and packet validation passed on their first attempts in this folder.
''')
files=[]
for path in sorted(F.rglob('*')):
    if path.is_file():
        assert not path.is_symlink()
        if '__pycache__' not in path.parts and path.suffix not in {'.pyc','.olean','.ilean'}:files.append(ref(path))
syntax=[]
for p in sorted(F.glob('*.py')):
    text=p.read_text();ast.parse(text);compile(text,str(p),'exec');syntax.append(ref(p))
manifest=write('manifest.json',dict(schema=1,files=files,syntax_checks=syntax,source_acceptance=False))
receipt=write('final-receipt.json',dict(manifest=manifest,review=review,additional_supplement=ref(F/'additional-supplement.json'),
    native_packet=ref(F/'native-packet.json'),environment=ref(F/'native-environment.json'),validation=ref(F/'packet-validation.json'),
    native_receipt=ref(F/'native-01/receipt.json'),native_output=native['output'],actual_native_exit=0,axiom_reports=36,
    native_output_bytes_identical_to_prior=True,characters=68720,bytes=70777,environment_pins=307,
    source_target=inputs['source_target'],source_context_unchanged=True,interpretation_pending=True,source_acceptance=False))
print(json.dumps({'receipt':receipt,'manifest':manifest,'packet':ref(F/'native-packet.json'),'environment':ref(F/'native-environment.json'),
    'native_elapsed_ms':native['elapsed_ms'],'native_output':native['output']},indent=2))
