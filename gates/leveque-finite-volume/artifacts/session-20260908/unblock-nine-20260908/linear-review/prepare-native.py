from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;S=P.parents[1];R=S.parents[3]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
left=R/'ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsLeftSolutionDomains.lean'
riemann=R/'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannProblemDataClassification.lean'
eigen=R/'ComputationalMathematics/Source/LeVeque/Chapter01/EigenvaluePropagation.lean'
files=[dict(**bind(p),module=p.relative_to(R).as_posix()[:-5].replace('/','.'),declarations=[n],lines=len(p.read_text(encoding='utf-8').splitlines()),new_source=p!=eigen) for p,n in [(left,'NumStability.leveque01_acousticsLeftSolutionDomains'),(riemann,'NumStability.leveque01_riemannProblemDataClassification'),(eigen,'NumStability.leveque01_eigenvalues_completeWavePropagation')]]
frozenLeft=S/'left-mode-alternative-evidence/Candidate.lean';frozenRiemann=S/'prospective-density-material-riemann-capstones-draft/Capstones.lean'
assert sha(frozenLeft)=='9a641179c8cb3c88bed78c3d99e5331968088d2063819b5ebfc07b41bdc5bbe9'
assert sha(frozenRiemann)=='dc65d2f7412a99594efbe8b0936ee59685d71e3fd8cd1ec3501cd73dd19a5ec7'
original=frozenRiemann.read_bytes();start=original.index(b'/-- Positive component dimension');end=original.index(b'#check density_rectangle_capstone')
span=original[start:end];fragment=P/'FrozenRiemannSpan.lean.fragment';assert not fragment.exists();fragment.write_bytes(span)
target=riemann.read_text(encoding='utf-8');statement=target[target.index('theorem leveque01_riemannProblemDataClassification'):target.index(' := by',target.index('theorem leveque01_riemannProblemDataClassification'))]
expected=statement.replace('theorem leveque01_riemannProblemDataClassification','theorem expectedRiemannComposition',1)+''' := by
  refine ⟨ProspectiveSourceAlternatives.positive_dimensional_problem_capstone problem, Iff.rfl, ?_⟩
  intro leftState origin rightState hhyper hleft hright
  exact ProspectiveSourceAlternatives.equal_or_distinct_initial_states
    problem.governing hhyper leftState origin rightState hleft hright
'''
checks='''
namespace NumStability.UnblockLinearChecks
open FirstOrderInitialValueProblem
'''+expected+'''
theorem left_type_and_value : @leveque01_acousticsLeftSolutionDomains =
    @LeftModeDomainsDraft.leftMode_solutionDomains := rfl

theorem riemann_type_and_value : @leveque01_riemannProblemDataClassification =
    @expectedRiemannComposition := rfl

end NumStability.UnblockLinearChecks
'''
names=[n for f in files for n in f['declarations']]+['NumStability.ProspectiveSourceAlternatives.'+n for n in ['positive_dimensional_problem_capstone','equal_or_distinct_initial_states','scalarEquation','scalarEquation_hyperbolic','scalar_problem_fixture']]+['NumStability.UnblockLinearChecks.'+n for n in ['expectedRiemannComposition','left_type_and_value','riemann_type_and_value']]
checks+='\n'.join('#check '+n+'\n#print axioms '+n for n in names)+'\n'
checks+='''
-- Concrete applications reuse the frozen nonconstant acoustic and scalar problem fixtures.
#check NumStability.leveque01_acousticsLeftSolutionDomains
  NumStability.LeftModeAlternativeEvidence.acousticFixture (by norm_num) (by norm_num)
#check NumStability.leveque01_riemannProblemDataClassification (m := 0)
  (NumStability.FirstOrderInitialValueProblem.fromStates
    NumStability.ProspectiveSourceAlternatives.scalarEquation
    (fun _ => 0) (fun _ => 7) (fun _ => 1))
#check NumStability.leveque01_riemannProblemDataClassification (m := 0)
  (NumStability.FirstOrderInitialValueProblem.fromStates
    NumStability.ProspectiveSourceAlternatives.scalarEquation
    (fun _ => 0) (fun _ => 7) (fun _ => 0))
'''
data=(''.join('import '+f['module']+'\n' for f in files)+'\n').encode()+frozenLeft.read_bytes()+b'\nnamespace NumStability.ProspectiveSourceAlternatives\nopen FirstOrderInitialValueProblem\n'+span+b'\nend NumStability.ProspectiveSourceAlternatives\n'+checks.encode()
output=P/'Checks.lean';assert not output.exists();output.write_bytes(data)
expected_names=re.findall(r'^#print axioms (\S+)',data.decode(),re.M)
assert len(expected_names)==len(set(expected_names))
plan=dict(schema=1,files=files,frozen_left=bind(frozenLeft),frozen_left_complete_bytes_included=True,frozen_riemann=bind(frozenRiemann),riemann_span=dict(**bind(fragment),byte_start=start,byte_end=end),check_input=bind(output),expected_axiom_declarations=expected_names,comparisons=['Exact full type/value equality against frozen LEFT domain composition','Exact full type/value equality against positive-dimensional and equal/distinct frozen RIEMANN compositions'],new_declaration_count=2,unchanged_selected_eigen_declaration=True)
dest=P/'native-plan.json';assert not dest.exists();dest.write_bytes((json.dumps(plan,indent=2)+'\n').encode());print(json.dumps(dict(plan=bind(dest),check=bind(output),axiom_reports=len(expected_names))))
