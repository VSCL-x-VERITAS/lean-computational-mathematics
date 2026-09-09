"""Freeze the separately authorized Q6 analytic interpretation refinement."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent;R=S.parents[3]
T=S/'audits/LEV-CH01-SOURCE-TERMS-INTERPRETED-PRODUCTION-20260908'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def create(p,v):
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(v,f,indent=2,ensure_ascii=False);f.write('\n')
selection=D/'selected-interpretations.json'
assert sha(selection)=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
assert sha(T/'faithfulness/decision.json')=='ba8a6782c2a7871123d788343252b34821a3d60a3f6621bc5705657b7779fd7a'
chosen=json.loads(selection.read_bytes());q6=next(c for c in chosen['choices'] if c['choice_id']=='Q6')
task=json.loads((T/'audit-task.json').read_bytes());target=R/task['target']['path']
dependency=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/RectangleBalance.lean'
packet={
 'format':'coordinator-selected-interpretation-refinement-1',
 'status':'selected-for-fresh-independent-audit',
 'refinement_id':'Q6-FIXED-REPRESENTATIVE-ITERATED-BALANCE-20260908',
 'recorded_at_utc':datetime.now(timezone.utc).isoformat(),
 'scope_row':'LEV-CH01-NONCONSERVATION-SOURCE-TERMS',
 'prior_choice_id':'Q6','authority':chosen['authority'],'exact_user_objective':chosen['exact_user_objective'],
 'goal_observation_sha256':chosen['goal_observation_sha256'],
 'coordinator_authorization':'The root coordinator explicitly selected this separate analytic refinement under the existing user goal. It is not a literal detailed user answer, printed-source assertion, proof-strengthening claim, or independent audit verdict.',
 'prior_selection_receipt':pin(selection),'prior_choice_exact':q6,'prior_task':pin(T/'audit-task.json'),
 'prior_undetermined_decision':pin(T/'faithfulness/decision.json'),
 'source':task['source'],'unchanged_target':{**task['target'],'sha256':sha(target)},
 'defining_dependency':{'declaration':'NumStability.IsRectangleBalanceLawSolution','dossier_id':'D001',
     'owner':pin(dependency),'dossier':pin(T/'faithfulness/inputs/declaration_dossier.md')},
 'selected_model':{
  'field_and_flux':'Use fixed pointwise functions q and production from real space x real time to R^1 (represented as Fin 1 -> R), and a supplied constant real speed. The contaminant flux is speed times the supplied state, with no sign restriction on production or speed.',
  'representatives':'The supplied q and production are the actual pointwise representatives used in all hypotheses, boundary evaluations and integrals. They are not equivalence classes modulo two-dimensional space-time null sets. No exceptional-time slice is silently replaced before classification or theorem application.',
  'measure_and_endpoints':'Use ordinary one-dimensional Lebesgue volume and its oriented interval integrals for every real finite spatial pair a,b and temporal pair s,t. Reversed endpoints are included with the usual oriented-integral sign; no finite global-space or global-time integral is required.',
  'mass_slice_condition':'For every real a,b,t, x -> q(x,t) is interval integrable on a..b. This is an every-time requirement on the fixed mass representative.',
  'boundary_flux_condition':'For every real x,s,t, tau -> speed * q(x,tau) is interval integrable on s..t. The actual value on each chosen spatial boundary is used; no quotient by space-time null sets identifies arbitrary boundary traces.',
  'production_slice_condition':'For every real a,b,t, x -> production(x,t) is interval integrable on a..b. This includes every exceptional time, not merely almost every time.',
  'iterated_production_condition':'For every real a,b,s,t, tau -> integral(a..b, production(x,tau) dx) is interval integrable on s..t. This is integrability of the signed spatial aggregate; it is not a hypothesis that the time integral of the spatial integral of the absolute production density is finite.',
  'domain_not_joint_L1':'These exact slice and signed-aggregate conditions define the selected analytic domain. Do not replace them by bare jointly space-time L1_loc, by an L1 equivalence class with chosen good slices, or by joint L1_loc plus unstated representative corrections. No equivalence between these different domains is asserted.',
  'balance_hypothesis':'For every real a,b,s,t, interval mass at t minus interval mass at s equals the time integral from s to t of speed*q(a,tau)-speed*q(b,tau), plus the time integral from s to t of the spatial production integral over a..b. The theorem assumes this actual sourced rectangle balance for the supplied fields.',
  'nonconservation_meaning':'Within that selected sourced model, failure of homogeneous rectangle conservation means that some finite oriented rectangle has nonzero integrated production. A nonzero raw production value at an isolated point is not the nonconservation criterion, and a changing mass in one interval is adjusted for its actual boundary exchange.',
  'mass_rate_scope':'For each fixed real a,b, the interval-mass function has derivative speed*q(a,t)-speed*q(b,t)+integral(a..b,production(x,t) dx) for almost every real t. The exceptional null set may depend on a,b. No derivative identity at every time, one common exceptional set for all intervals, or spatial differentiability of q is imposed.',
  'logical_scope':'The exact mass-defect identity and the two homogeneous/nonhomogeneous biconditionals are consequences inside the supplied sourced rectangle model. This does not assert existence of an admissible production density for every arbitrary nonconserving field, a chemical rate law, or pointwise uniqueness of production.',
  'exclusions':'General singular production measures remain outside Q6. No positivity, spatial classical derivative, joint regularity, or global integrability condition is added.'
 },
 'source_ambiguities_preserved':[
  'The printed contaminant paragraph requires source terms when mass changes beyond transport, but does not specify a production function space, a sourced rectangle equation, representative treatment, or a nonzero criterion at this level of precision.',
  'The original Q6 phrase locally integrable production densities did not distinguish joint space-time local integrability from exact every-time slices and temporally integrable signed spatial aggregates.',
  'The reported exceptional-time-slice example remains an effective-domain distinction; it is not a counterexample to the conditional theorem and not evidence of genuine theorem strengthening.',
  'The almost-everywhere temporal convention and rectangle biconditionals remain interpretation-qualified and are not attributed as literal additional printed hypotheses or conclusions.'
 ],
 'required_audit_qualification':'Compare the original source claim under Q6 refined to these fixed-representative, every-slice and signed-iterated-integral conditions. Any acceptance must retain both interpretation hashes and this analytic scope explicitly, without relabeling the choice as an unqualified stronger theorem or full joint-L1 correspondence.',
 'independence':'Source extraction receives only source evidence; blind translation only its new exact masked target packet. Direct, round-trip and triggered adjudication receive this separately labeled interpretation according to the sealed role protocol. Prior classifications remain unchanged and no verdict is requested.',
 'preservation':chosen['preservation'],'no_production_or_native_supplement_change':True
}
create(P/'q6-interpretation-refinement.json',packet)
create(P/'q6-minimal-refinement-receipt.json',{'status':'FROZEN-ADDITIVE-COORDINATOR-ANALYTIC-INTERPRETATION',
    'packet':pin(P/'q6-interpretation-refinement.json'),'source_selection':pin(selection),'target':pin(target),
    'prior_decision':pin(T/'faithfulness/decision.json'),'defining_dependency':pin(dependency),'helper':pin(Path(__file__)),
    'semantic_roles_launched':False,'source_acceptance':False,'production_changed':False})
print(json.dumps({'packet':pin(P/'q6-interpretation-refinement.json'),'receipt':pin(P/'q6-minimal-refinement-receipt.json')}))
