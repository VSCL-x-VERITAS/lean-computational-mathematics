"""Bind the completed artifact-only overlay evidence without publishing caches."""
import hashlib,json,os
from datetime import datetime,timezone
from pathlib import Path
R=Path(r"C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics")
P=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-five-owner-overlay'
native=lambda path:str(path) if str(path).startswith('\\\\?\\') else '\\\\?\\'+os.path.abspath(path)
def raw(path):
 with open(native(path),'rb') as stream:return stream.read()
def load(path):return json.loads(raw(path))
def ref(path):
 data=raw(path)
 return {'path':Path(path).relative_to(R).as_posix(),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
def put(name,data):
 if not isinstance(data,bytes):data=(json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode()
 with open(native(P/name),'xb') as stream:stream.write(data)

verification=load(P/'verification-v2.json');plan=load(P/'plan.json')
assert verification['result']=='PASS_OVERLAY_PROOF_REPLAY'
command_receipt=load(P/'verification-exit-v2.json');assert command_receipt['exit_code']==0
assert load(P/'runs04/lake-launch04/receipt.json')['exit_code']==0
native_outputs=[]
for entry in verification['native_runs']:
 receipt=load(R/entry['receipt']['path'])
 assert receipt['exit_code']==0
 native_outputs.append({'label':entry['label'],'receipt':entry['receipt'],
     'stdout':receipt['stdout'],'stderr':receipt['stderr'],'elapsed_seconds':receipt['elapsed_seconds']})
modules=[]
for name in plan['affected_modules_topological']:
 owner=next(x for x in plan['owners'] if x['module']==name)
 base=P/'overlay/lib03'/name.replace('.','/')
 outputs=[]
 for suffix in ['.olean','.olean.private','.olean.server','.ilean']:
  path=Path(str(base)+suffix)
  if os.path.isfile(native(path)):outputs.append(ref(path))
 assert outputs
 modules.append({'module':name,'source':owner['overlay_source'],'selected':owner['selected'],
                 'original_source_unchanged':owner['original'],'overlay_outputs':outputs})
put('compiled-module-map.json',{'schema':1,'overlay_only':True,'modules':modules})
warnings=[]
for item in native_outputs:
 text=raw(R/item['stdout']['path']).decode('utf-8',errors='replace')
 if 'warning:' in text:warnings.append(item['label'])

review=f'''# Five-owner C∞ proposal: isolated full-family proof replay

The exact five-owner proposal compiled successfully in an artifact-only canonical-module overlay. All nine affected modules were rebuilt, and the original complete SourceJoint and CanonicalChecks inputs replayed successfully. The selected regularity is C∞, and the explicit stability-rate body retains the same chosen real by a checked `rfl` equality. This is proof replay evidence before production placement, not canonical final validation or a source-faithfulness result.

The bound proposal is `7326cc0da682528a8e79630ed1d527a8f5079a640b06a444639549e4254bba8b`; the root review is `06ba04c7496fc54e3ea24c85f0682f00e26795ca982bcf42b9403340734bf934`. All 16 source owners were copied under `overlay/` with canonical paths, substituting exactly the five approved copies. Four proposals correct nine explicit regularity annotations; LocalRectangleReference also names the genuine FTaylorSeries import, and RefiningLineMethod exposes the same chosen stability rate. No proof body outside those exact approved copies was repaired or weakened to make this run pass.

## Isolation and native execution

The child was launched through native `lake env`. Only its LEAN_PATH was changed, with `overlay/lib03` first. Every affected compilation explicitly supplies native Lean's `-R` source root and `-o`/`-i` paths under that overlay. No Lake build command was run, and no production output path was a compilation destination.

Three preserved diagnostic boundaries explain the concrete Windows/search-path adjustments:

- The first `--deps` invocation failed before compilation because the deep ordinary source path could not be opened. An explicit Windows extended-path probe then exited 0. All subsequent source, root, output, and overlay search paths use the extended prefix at I/O.
- The second attempt compiled LocalRectangleReference successfully, then its guard rejected a missing unchanged dependency. Pinned Lean.Util.Path selects the first search root containing the **package prefix**, without per-module fallback. Therefore the final fresh overlay includes byte-exact copies of the {verification['unchanged_compiled_copy_modules']} unchanged compiled project owners in the verified {verification['project_import_closure_owners']}-owner closure. None of the nine affected old `.olean` files was copied. They were all rebuilt in topological order. No links, junctions, original cache moves, or original cache overwrites were used.

- After all module and proof replays passed, the auxiliary import-closure probe failed on an unqualified `liftIO` identifier. A new probe changes only that diagnostic identifier to `Lean.Elab.Command.liftIO` and exits 0 under the same lake environment and unchanged lib03 outputs. The runs03 parent exit 1 and failed diagnostic are retained; the successful final diagnostic/parent receipts are in runs04.

Every native `--deps` result is retained and bound. A separate semantic probe verifies both smooth-reference definitions against the explicit inner infinity by `Iff.rfl`, verifies the chosen rate against `Classical.choose quality.stability` by `rfl`, and prints the actual resolver paths of all 16 selected owners. All resolve under `overlay/lib03`. The final imported-environment probe reports and hashes {verification['full_compiled_import_modules']} actual compiled module paths, including all nine rebuilt owners. The project source closure check found no other used project owner whose imported definitions required rebuilding.

All original captured source and compiled files matched their before hashes after every successful module build and replay, and again during final verification. `compiled-module-map.json` separates original sources, selected proposal sources, overlay sources, and new compiled outputs. Copied unchanged dependencies are separately mapped in `unchanged-compiled-copies-v3.json`.

## Actual results

All final native module builds, dependency resolutions, IsolationProbe, SourceJoint, CanonicalChecks, and ImportClosureProbe exited 0. The complete original SourceJoint has 42 exact axiom commands, CanonicalChecks has 149, and the isolation probe has 3. All {verification['checked_axiom_reports']} reports were matched by declaration and order; {verification['empty_axiom_reports']} have no axioms, and every remaining axiom is among `propext`, `Classical.choice`, and `Quot.sound`. Universe-displayed names are normalized only for comparison to their exact check commands. Final native-output warning labels: {json.dumps(warnings)}.

This replays the full refining scalar advection quality family over the broader C∞ local-reference domain, its coordinate consumers, the unchanged primary theorem/source wrapper, and the original full joint applicability proof. It does not substitute separate inhabitants for the complete source application. The source-wrapper bytes themselves remain unchanged; its imported effective definitions in this overlay differ deliberately from the frozen original audit.

## Limits and handoff

The original production tree, original compiled outputs, and original audit remain frozen. The overlay is neither a new canonical placement nor a replacement for a future native build, fingerprint extraction, organization review, and independent source audit after controlled placement. In particular, this replay does not resolve the separate LineRealization/physical-geometry domain question and does not depend on root's new capacity bridge or Laplace's mutable Fin 2 fixture.

The `.olean`/`.ilean` files are generated local replay products, explicitly identified in the evidence. This task performs no Git staging or publication decision; any later publication must follow the repository's cache/asset policy rather than treating generated caches as authored Lean owners. All failures and successful raw outputs remain append-only in this folder.
'''
put('REVIEW.md',review.encode('utf-8'))
files=[]
for directory,dirs,names in os.walk(native(P)):
 assert '__pycache__' not in dirs
 for name in names:
  path=Path(str(Path(directory)/name).removeprefix('\\\\?\\'))
  if path.name in {'manifest.json','receipt.json'} and path.parent==P:continue
  assert not os.path.islink(native(path)),str(path)
  files.append(ref(path))
files.sort(key=lambda x:x['path'])
put('manifest.json',{'schema':1,'kind':'artifact-only-five-owner-canonical-module-overlay',
                    'source_acceptance':False,'canonical_placement':False,'files':files,
                    'created_at_utc':datetime.now(timezone.utc).isoformat()})
put('receipt.json',{'schema':1,'result':'PASS_OVERLAY_PROOF_REPLAY','source_acceptance':False,
                   'canonical_placement':False,'manifest':ref(P/'manifest.json'),
                   'review':ref(P/'REVIEW.md'),'verification':ref(P/'verification-v2.json'),
                   'actual_verification_command':ref(P/'verification-exit-v2.json'),
                   'actual_lake_child_receipt':ref(P/'runs04/lake-launch04/receipt.json'),
                   'module_map':ref(P/'compiled-module-map.json'),
                   'affected_modules':9,'copied_sources':16,'axiom_reports':verification['checked_axiom_reports'],
                   'native_outputs':native_outputs})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),
                  'review':ref(P/'REVIEW.md'),'files':len(files)}))
