"""Finalize the reviewed report; keep the later checkpoint observations separate."""
from pathlib import Path
import hashlib,json,os
S=Path(__file__).resolve().parent;R=S.parents[3];W=R.parent
def native(p):
 p=Path(p)
 return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
sha=lambda p:hashlib.sha256(native(p).read_bytes()).hexdigest()
read=lambda p:json.loads(native(p).read_bytes())
D=S/'chapter01-final-report-preparation-80f5'
for n,h in [('report-draft.md','053c2f724c40c50e387c0fe3f294a819316648c8754b7d76ae316e33209cd208'),('report-data.json','9a12c23b2fd82bcf2005ed3349affcf66699e094ca5c6f295f9bd5c01f039986'),('final-receipt.json','bcab948a65559318f4a1eddd7d17f977d7f939d2d66d9761e50653c7f73ae3a1')]:assert sha(D/n)==h
for ref in read(D/'final-receipt.json')['outputs']:assert sha(ref['path'])==ref['sha256']
for ref in read(D/'input-manifest.json')['inputs']:assert sha(ref['path'])==ref['sha256']
data=read(D/'report-data.json');gate=read(R/'gates/leveque-finite-volume/chapter-01.json')
assert len(data['accepted_rows'])==32 and data['status_counts']=={'REUSED':17,'PROVED':15,'HARD_BLOCKED':9,'SKIPPED':16}
assert data['gate_verdict']=='BLOCKED' and data['actionable_rows']==0
for row in data['accepted_rows']:
 actual=next(r for r in gate['rows'] if r['id']==row['id'])
 assert actual['status']==row['status'] and actual['lean_declarations']==row['lean_declarations']
md=(D/'report-draft.md').read_text(encoding='utf-8')
old=md.split('\n\n')[1]
closing=W/'workflow-v5.0.1-local/chapter01-final-checks/terminal-observations.json'
new='The installed gate and validation evidence are recorded at code checkpoint 80f5d4340d507dbc347a806717ff31c5a9aace72. This report is included in the subsequent retained BLOCKED checkpoint. Its final commit, queued request and after-commit validation outcomes are recorded separately in the [terminal checkpoint observations](<'+closing.as_posix()+'>), avoiding a self-referential commit hash. Campaign integration and PASS acceptance have not occurred.'
md=md.replace(old,new,1)
old=md[md.index('The exact hard blockers are the eight unanswered choices mapped above.'):]
new='The exact hard blockers are the eight unanswered choices mapped above. Root accepted the two bounded independent reviews and verified 999 input bindings before the exact installation. The source ambiguity remains recorded, and each selected future contract requires a fresh statement audit. The installed released gate certifies zero actionable rows and all eight verified global artifacts. The separate terminal checkpoint observations bind the final retained checkpoint, current question freshness, campaign and organization preflights, and reconciliation terminal check.\n'
md=md.replace(old,new)
needle='The final actual validation commands are recorded below.'
coordinate='**Coordinate updates and measured Cartesian geometry.** Searches used `TensorGrid|CartesianGrid|CartesianFiniteVolumeGrid|cellBox_volume|tangentialFaceBox_volume|cellVolume_eq_width_mul_area`, `advance_line_local`, `advance_mass_balance`, `finite_line_mass_balance`, `sweep_cons`, `sweep_two`, `riemannFiniteVolumeUpdate`, and `volume_pi_Ico_toReal`. Selected producers are the existing CoordinateLineBalance and CoordinateLineSweep operations, OneDimensionalFiniteVolumeGrid, adjacentCellRiemannProblem, riemannFiniteVolumeUpdate, RiemannInformationFluxMethod and its explicit field adapter, and Mathlib Real.volume_pi_Ico_toReal. The scoped grid-name search miss was not treated as global semantic absence. Redundant TensorGrid, Cell/line, stripe and method-family wrappers and a forwarding locality alias were rejected. Five canonical leaves add 41 declarations in 533 lines; their final comparison checked 199 declarations and transports. Together with the four information-method leaves, the integrated batch adds 65 public declarations in 856 lines. These reusable foundations do not adopt the pending geometry or accuracy convention. See the [reuse review](<'+(S/'information-coordinate-production/reuse-review.json').as_posix()+'>) and [production review](<'+(S/'information-coordinate-production/REVIEW.md').as_posix()+'>).\n\n'
assert needle in md;md=md.replace(needle,coordinate+needle,1)
data['kind']='chapter01-reviewed-final-report'
data['report_stage']='Installed released BLOCKED certificate; report accompanies retained evidence checkpoint. Later checkpoint observations are separate.'
data['terminal_checkpoint_observations']=closing.as_posix()
data['root_report_review']={'draft_sha256':sha(D/'report-draft.md'),'data_sha256':sha(D/'report-data.json'),'all_report_inputs_verified':True,'root_final_reviews_sha256':sha(S/'root-final-reviews-verification-80f5.json'),'coordinate_reuse_review_sha256':sha(S/'information-coordinate-production/reuse-review.json')}
data['final_durable_checkpoint']='See terminal_checkpoint_observations for exact after-commit facts.'
for name,payload in [('chapter01-final-report.md',md.encode()),('chapter01-final-report.json',(json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode())]:
 with (S/name).open('xb') as out:out.write(payload)
print(json.dumps({n:sha(S/n) for n in ['chapter01-final-report.md','chapter01-final-report.json']}))
