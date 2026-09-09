"""Prepare split proof-free probe sources only. No Lean, sealed preparation or roles."""
from pathlib import Path
import hashlib,json,re,sys
P=Path(__file__).resolve().parent;D=P.parent;R=D.parents[4]
assert len(sys.argv)==2 and re.fullmatch(r'probe-sources-[0-9]+',sys.argv[1])
OUT=P/sys.argv[1]
assert not OUT.exists()
OUT.mkdir()
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def write(name,data):
 p=OUT/name;assert not disk(p).exists(),str(p)
 if not isinstance(data,str):data=json.dumps(data,indent=2,ensure_ascii=False)+'\n'
 disk(p).write_text(data,encoding='utf-8');return ref(p)
mapping_path=D/'physical-dim-owner-proposals/attempt-06/mapping.json'
assert ref(mapping_path)['sha256']=='6b8d51bf7ab2bf4fd585a92ff76c3845488f3119c87fbc8df820a6db978cf498'
mapping=json.loads(read(mapping_path))
current=[];exports={};deltas=[]
allowed={
 'FiniteLineCoordinates.lean':'import Mathlib.Analysis.Normed.Group.Real\n',
 'PhysicalRefinementQuality.lean':'import Mathlib.Analysis.Calculus.ContDiff.Defs\n',
}
for owner in mapping['files']:
 path=R/owner['target_path'];proposed=R/owner['proposed']['path']
 actual=read(path);old=read(proposed)
 assert hashlib.sha256(old).hexdigest()==owner['proposed']['sha256']
 if actual!=old:
  added=allowed[path.name].encode();assert actual.count(added)==1
  assert actual.replace(added,b'',1)==old,(str(path),'non-import delta')
  deltas.append({'owner':ref(path),'proposal':ref(proposed),'added_import_exact':added.decode()})
 current.append({'file':ref(path),'module':owner['module']})
 for e in owner['exports']:
  assert e['name'] not in exports
  exports[e['name']]={'kind':e['kind'],'owner':ref(path)}

fv='NumStability.FiniteCoordinate.'
quality='NumStability.PhysicalRefinementQuality.Family'
sweep='NumStability.PhysicalHighResolutionSweep.'
method='NumStability.CapacityCoordinate.Method'
physical='NumStability.FiniteCoordinate.PhysicalLine.'
cart='NumStability.FiniteCartesian.'
grid='NumStability.CartesianGrid.'
example='NumStability.ZeroFluxCartesianRefinement.'
refining='NumStability.RefiningCartesianGrid.'
target='NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'

groups=[
 {'file':'Contract.lean','scope':'Full primary, actual Family and nested reference/quality/certificate domains; final execution Specification and positive admitted substeps.',
  'print':[quality,quality+'.referenceGhost',quality+'.projected',quality+'.SmoothReference',
    quality+'.AccuracyCertificate',quality+'.variation',quality+'.HasHighResolution',
    sweep+'coordinates',sweep+'method',sweep+'execution',sweep+'Specification',sweep+'ValidSubsteps'],
  'check':[target,quality+'.HasHighResolution.two_state_available',
    quality+'.AccuracyCertificate.available_at_threshold',quality+'.AccuracyCertificate.perturbed_at',
    sweep+'specification',sweep+'admitted_specification']},
 {'file':'Operators.lean','scope':'Same numerical flux, time-dependent admission, lookup/ghost extraction, capacity update, once-edge variation and sequential error recurrence.',
  'print':[fv+'LineCoordinates',fv+'LineCoordinates.extract',fv+'LineCoordinates.withGhost',
    physical+'Incidence',physical+'capacity',physical+'faceRule',physical+'lineAdvance',
    method,method+'.rule',method+'.Admitted',method+'.StableAt',method+'.withGhost',
    'NumStability.CapacityCoordinate.Sweep.step','NumStability.CapacityCoordinate.Sweep.run',
    fv+'advance','NumStability.finiteVolumeCellAverageUpdate','NumStability.orderedOperatorSweep',
    fv+'netFluxDefect',fv+'LineCoordinates.onceEdgeVariation',
    'NumStability.SequentialError.execution','NumStability.SequentialError.errorBudget',
    'NumStability.FiniteVolumeCellPartition.mesh'],
  'check':[physical+'capacity_cell',physical+'projection_cell',method+'.advance_withGhost_eq',
    method+'.coordinate_stability_withGhost','NumStability.CapacityCoordinate.Sweep.run_physical_error',
    fv+'advance_error_le_net']},
 {'file':'Geometry.lean','scope':'Actual physical partition, measures, all-subinterval reference balance, normal flux hyperbolicity and Cartesian cells/faces/normalization.',
  'print':['NumStability.FiniteVolumeCellPartition','NumStability.cellVolumeAverage',
    fv+'PhysicalData',fv+'PhysicalData.cellVolume',fv+'PhysicalData.cellMean',fv+'PhysicalData.faceFlux',
    fv+'PhysicalData.ReferenceOn','NumStability.IsHyperbolicFluxAt','NumStability.IsHyperbolicFluxOn',
    cart+'CartesianIdentification',cart+'cells',cart+'faceMeasure',cart+'data',
    'NumStability.OneDimensionalFiniteVolumeGrid','NumStability.OneDimensionalFiniteVolumeGrid.cellVolume',
    grid+'cellBox',grid+'cellVolume',grid+'faceArea',grid+'tangentialFaceBox',grid+'facePoint'],
  'check':['NumStability.isHyperbolicFluxAt_iff_independent_real_eigenvectors',
    'NumStability.isHyperbolicFluxOn_iff_independent_real_eigenvectors',
    cart+'CartesianIdentification.cellVolume_eq',cart+'CartesianIdentification.cellMean_eq',
    cart+'CartesianIdentification.faceFlux_lift',cart+'CartesianIdentification.rectangle_balance_lift',
    cart+'data_face_measure',cart+'data_normal_flux',grid+'cellBox_volume',grid+'tangentialFaceBox_volume',
    'MeasureTheory.volume_pi','MeasureTheory.Measure.pi_pi','Real.volume_Ico','Real.volume_pi_Ico_toReal',
    'MeasureTheory.Measure.map_apply_of_aemeasurable','MeasureTheory.integral_map']},
 {'file':'Regularity.lean','scope':'Exact C-infinity constructor and ContDiffOn -> ContDiffWithinAt -> Taylor-series regularity, distinct from the outer analytic top.',
  'print':['ContDiffOn','ContDiffWithinAt','HasFTaylorSeriesUpToOn'],
  'check':['WithTop.coe_ne_top']},
 {'file':'Joint.lean','scope':'Full canonical source application, growing physical geometry and nonconstant genuine smooth reference. Prints data definitions, never proof-valued application bodies.',
  'print':[refining+'h',refining+'active',refining+'axes',refining+'target',refining+'region',
    refining+'boundaryIndex',refining+'boundaryRegion',refining+'coord',
    example+'zeroFlux',example+'data',example+'coordinates',example+'method',example+'family',example+'stationary',
    'PhysicalDIMCanonicalJoint.direction','PhysicalDIMCanonicalJoint.duration',
    'PhysicalDIMCanonicalJoint.ghost','PhysicalDIMCanonicalJoint.initial'],
  'check':[example+'family_quality',example+'family_stable',example+'stationary_smooth',
    example+'stationary_nonconstant',example+'stationary_reference',example+'stationary_in_reference_class',
    example+'stationary_certificates',example+'nonconstant_full_quality',
    *['PhysicalDIMCanonicalJoint.'+n for n in ['schedule','actual_substeps','full_application',
      'actual_references','cartesian','reference_boundary_exact','numerical_step_identity',
      'execution_identity','physical_error_zero','joint_applicability']]]},
]

joint_path=D/'physical-dim-canonical-comparisons/generated-01/Joint.lean'
assert ref(joint_path)['sha256']=='1253686e2f15cb05ff91526319994661ea474ea4cdd7d92f30f532f19db7cb3f'
joint_text=read(joint_path).decode()
joint_body=''.join(line for line in joint_text.splitlines(keepends=True)
 if not line.startswith(('import ','#check ','#print ','set_option ')))
header='\n'.join([
 'import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods',
 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.ZeroFluxCartesianRefinement',
 'import Mathlib.Analysis.Calculus.ContDiff.Defs',
 'import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries',
 'import Mathlib.MeasureTheory.Integral.Pi',
 'set_option pp.proofs false','set_option pp.fullNames true','set_option pp.deepTerms true',
 'set_option pp.maxSteps 10000000','set_option pp.universes false',
 'set_option maxRecDepth 4096','set_option maxHeartbeats 1600000','',
])
prepared=[]
for g in groups:
 assert len(set(g['print']+g['check']))==len(g['print']+g['check']),g['file']
 for n in g['print']:
  if n in exports:assert exports[n]['kind'] in {'def','abbrev','structure','class'},(n,exports[n])
  assert n not in {target,'PhysicalDIMCanonicalJoint.full_application','PhysicalDIMCanonicalJoint.joint_applicability'}
 for n in g['check']:
  if n in exports:assert exports[n]['kind'] in {'theorem','lemma','def'},(n,exports[n])
 body=header+'\n/- '+g['scope']+' -/\n\n'
 if g['file']=='Joint.lean':body+=joint_body+'\n'
 commands=['#print '+n+'\n#print axioms '+n for n in g['print']]
 commands+=['#check @'+n+'\n#print axioms '+n for n in g['check']]
 if g['file']=='Regularity.lean':
  commands+=['set_option pp.all true in\n#check (⊤ : WithTop ℕ∞)',
             'set_option pp.all true in\n#check ((⊤ : ℕ∞) : WithTop ℕ∞)']
 body+='\n\n'.join(commands)+'\n'
 file=write(g['file'],body)
 prepared.append({**g,'input':file,'expected_axiom_reports':len(g['print'])+len(g['check']),
                  'commands':commands,'native_status':'not-run'})

reuse=[]
operator=D/'measure-operator-evidence/dependency-packet.json'
norm=D/'fv-norm-complete-evidence/dependency-packet.json'
for packet,indices in [(operator,None),(norm,[-2,-1])]:
 content=json.loads(read(packet));spans=content['native_output_spans']
 if indices is None:indices=list(range(len(spans)))
 selected=[]
 for index in indices:
  s=spans[index];raw=read(R/s['source_path'])
  assert hashlib.sha256(raw).hexdigest()==s['source_sha256']
  exact=s['exact_text'].encode()
  assert exact==raw[s['start_byte']:s['end_byte_exclusive']]
  assert hashlib.sha256(exact).hexdigest()==s['span_sha256']
  selected.append({'index':index,'label':s.get('label'),'source_path':s['source_path'],
    'source_sha256':s['source_sha256'],'start_byte':s['start_byte'],'end_byte_exclusive':s['end_byte_exclusive'],
    'span_sha256':s['span_sha256'],'bytes':len(exact)})
 reuse.append({'packet':ref(packet),'selected_spans':selected,
   'reason':'Exact generic operator/norm evidence only; no prior FV target or verdict.'})
context_refs=[
 D/'topology-dependency-packet.json',
 D.parent/'real-measure-dependency/supplementary-declaration-dossier-v2.md',
 D.parent/'real-measure-dependency/final-verification-v2.json',
 D/'dim-inherited-hyperbolicity-context/source-context-v3.json',
 D/'user-high-resolution-interpretation-20260908.json',
]
legacy=[D/'coordinate-high-resolution-audit-preparation/build-full-probe.py',
 D/'coordinate-high-resolution-audit-preparation/GeometrySemantics.lean',
 D/'coordinate-high-resolution-audit-preparation/prepare-spec.py',
 D/'dim-blind-evidence-repair/Probe.lean']
inventory=write('probe-inventory.json',{'schema':1,'status':'PROBE INPUTS ONLY; no native run or prepared audit',
 'proposal_mapping':ref(mapping_path),'current_owners':current,'import_only_placement_deltas':deltas,
 'canonical_joint_input':ref(joint_path),'canonical_joint_native_receipt':ref(D/'physical-dim-canonical-comparisons/final-receipt.json'),
 'groups':prepared,'generic_span_reuse_candidates':reuse,
 'separate_existing_context_references':[ref(p) for p in context_refs],
 'prior_probe_derivation_references':[ref(p) for p in legacy],
 'pp_policy':{'proofs':False,'fullNames':True,'deepTerms':True,'maxSteps':10000000},
 'output_sizes':None,'prompt_size_validation':None,
 'pending':['actual native capture of all five inputs','exact axiom report and no-semantic-ellipsis inspection',
  'pin proof-free output spans and environment only under supported successor schema',
  'root-created fresh task/config and sealed blind-packet inspection',
  'actual complete role stdin byte measurement below 1048576 without truncation'],
 'isolation':'No supplemental or source material added to blind stdin; root must use released exact masked packet. Direct/adjudicator supplement uses exact proof-free native outputs only.',
 'source_acceptance':False})
receipt=write('preparation-receipt.json',{'schema':1,'status':'five proof-free probe sources generated; native capture pending',
 'generator':ref(P/'prepare-probes.py'),'inventory':inventory,'inputs':[g['input'] for g in prepared],
 'native_run':False,'audit_prepare_run':False,'roles_run':False,'production_written':False,'source_acceptance':False})
print(json.dumps(receipt,indent=2))
