"""Freeze an additive coordinator interpretation, not native dependency evidence."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent;R=S.parents[3]
T=S/'audits/LEV-CH01-RIEMANN-DEFINITION-INTERPRETED-PRODUCTION-20260908'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def create(p,v):
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(v,f,indent=2,ensure_ascii=False);f.write('\n')
selection=D/'selected-interpretations.json'
assert sha(selection)=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
assert sha(T/'faithfulness/decision.json')=='c8d7f8191a30ba12edc3bc15b74e73a62df4cb6e3880ee9690d229fb75078930'
chosen=json.loads(selection.read_bytes());q9=next(c for c in chosen['choices'] if c['choice_id']=='Q9')
target=R/'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannProblemDataClassification.lean'
assert sha(target)=='1c9647b69667c8b60e21165121352a5096e680d2cf6bb8a1b4fcdcb6b77a577c'
task=json.loads((T/'audit-task.json').read_bytes())
packet={
  'format':'coordinator-selected-interpretation-refinement-1',
  'status':'selected-for-fresh-independent-audit',
  'refinement_id':'Q9-DECLARED-FIRST-ORDER-MODEL-20260908',
  'recorded_at_utc':datetime.now(timezone.utc).isoformat(),
  'scope_row':'LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION',
  'prior_choice_id':'Q9',
  'authority':chosen['authority'],
  'exact_user_objective':chosen['exact_user_objective'],
  'goal_observation_sha256':chosen['goal_observation_sha256'],
  'coordinator_authorization':'The root coordinator explicitly selected this additive refinement under the existing user goal. It is not a literal detailed user answer, printed-source assertion, independent audit verdict, or change to the original interpretation receipt.',
  'prior_selection_receipt':pin(selection),
  'prior_choice_exact':q9,
  'prior_task':pin(T/'audit-task.json'),
  'prior_undetermined_decision':pin(T/'faithfulness/decision.json'),
  'source':task['source'],
  'unchanged_target':{**task['target'],'sha256':sha(target)},
  'selected_model':{
    'positive_dimension':'Use n = m + 1 for m a natural number, with real vector states in R^n and square real n-by-n principal matrices.',
    'governing_law_identity':'The governing-law data are the triple (Omega, A, b). Omega is a fixed declared set of admissible states and is part of the law, rather than an independent filter added to a law identified only by A and b. Different declared sets can therefore represent different governing-law data even when their total coefficient functions coincide.',
    'state_domain':'Omega may be any fixed subset of R^n. This is a classification of candidate problem data: the empty set may be stored, but it admits no Riemann problem because the two side states must belong to Omega. No openness, convexity, global integrability, or regularity of Omega is imposed.',
    'coordinate_domain':'Use one real spatial coordinate and one real time coordinate. The coefficient data are supplied on all R x R, and spectral hyperbolicity means at every real x and t, for every state in Omega. This chooses a global coefficient-data model; it is not a claim of solution existence for all real times or a representation theorem for arbitrary coordinate domains.',
    'principal_and_forcing':'A is an arbitrary supplied function R x R x R^n -> Matrix(n,n,R). b is an arbitrary supplied function R x R x R^n -> R^n. The explicit first-order equation is q_t + A(x,t,q) q_x = b(x,t,q). Nonzero forcing is permitted, with no sign, continuity, differentiability, integrability, or physical rate-law constraint. Homogeneous equations are the special case b = 0. No conservative-flux representation is required.',
    'spectral_condition':'For each admissible state at each real x,t, the actual matrix A(x,t,state) has a complete real eigenbasis with real eigenvalues. Eigenvalues need not be distinct; no uniform diagonalization bound, symmetrizer, or coefficient regularity is asserted.',
    'total_function_representation':'Lean stores total coefficient functions on the ambient state space. The governing-law domain is Omega. The residual equivalence in the target is an algebraic identity of that stored expression for arbitrary arguments; it does not impose equation solutionhood outside Omega or add a law that a solution must satisfy at every ambient state.',
    'problem_data':'A candidate initial-value problem consists of this governing law and an independently supplied initial state function q0 : R -> R^n. It is in the selected Riemann family exactly when the governing law satisfies the stated spectral condition and there exist left and right states in Omega with q0(x)=left for every x<0 and q0(x)=right for every x>0.',
    'interface_and_degeneracy':'The interface is represented at coordinate zero. The value q0(0) is wholly unspecified, including no requirement that it lie in Omega; the problem-data predicate deliberately tests only the two strict half-lines. Equal side states are admitted as a degenerate member of the two-state family. The genuine-jump subfamily additionally requires unequal side states. No quotient or equivalence of solutions under single-point changes is asserted.',
    'no_solution_theorem':'This is governing-law/problem-data classification only. It neither selects a classical, weak, entropy, or rectangle solution notion nor asserts existence, uniqueness, regularity, self-similarity, wave structure, or a numerical approximation guarantee.'
  },
  'source_ambiguities_preserved':[
    'The printed definition does not explicitly identify its full equation class with every triple (Omega,A,b) in this selected model.',
    'The printed passage does not specify an arbitrary stored state-domain predicate or its role in governing-law identity.',
    'The printed passage does not settle the global coefficient-coordinate domain or arbitrary-forcing generality at the precision used here.',
    'The prose calls the separation a jump, while the formula does not expressly exclude equal states; admission of the degenerate case remains interpretation-qualified.'
  ],
  'required_audit_qualification':'Compare the original source definition under the original Q9 selection plus this exact additional model convention. Any accepted contract must explicitly retain this selected equation/domain/forcing scope and both interpretation hashes. Do not describe it as an unqualified representation theorem for every conceivable hyperbolic equation.',
  'independence':'Source extraction receives only source evidence. Blind translation receives only its new exact masked target packet. Direct, round-trip and triggered adjudication receive this separately labeled interpretation input according to the sealed role protocol. No prior judgment is reused or requested verdict supplied.',
  'preservation':chosen['preservation'],
  'no_production_or_native_supplement_change':True
}
create(P/'interpretation-refinement.json',packet)
create(P/'minimal-refinement-receipt.json',{'status':'FROZEN-ADDITIVE-COORDINATOR-INTERPRETATION',
    'packet':pin(P/'interpretation-refinement.json'),'source_selection':pin(selection),'target':pin(target),
    'prior_decision':pin(T/'faithfulness/decision.json'),'helper':pin(Path(__file__)),
    'semantic_roles_launched':False,'source_acceptance':False,'production_changed':False})
print(json.dumps({'packet':pin(P/'interpretation-refinement.json'),'receipt':pin(P/'minimal-refinement-receipt.json')}))
