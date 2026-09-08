"""Freeze the actual user's domain choice; it is not a source or operator receipt."""
from pathlib import Path
import datetime,hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
out=S/'user-transport-interpretation-20260908.json';assert not out.exists()
question='For Chapter 1 equations (1.2)–(1.3), should I adopt the explicit convention described above—geometric translation for every real profile, classical solutions for differentiable profiles, and rectangle conservation for locally integrable profiles—or retain the original analytic-scope question as unresolved? Either way, I’ll preserve the source ambiguity and continue the other obligations.'
answer='Adopt the explicit convention and audit under that recorded interpretation'
record={'schema':1,'kind':'explicit-user-interpretation','task_id':'01a07fae-4a67-7770-98b0-b95c4e393705',
 'captured_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'provenance':'Actual user reply in this task to the request_user_input_async question; capture time is not claimed as the reply event time.',
 'question_item_id':'["request_user_input_async","call_Y2sqv6fyDugzXxzv3TlRkG6y",0]',
 'question':question,'answer':answer,'scope':['LEV-CH01-EQ-1.2-ADVECTION','LEV-CH01-EQ-1.3-ADVECTED-PROFILE'],
 'adopted_interpretation':[
 'The translated field preserves geometric transport for every real-valued profile and every real constant speed.',
 'Classical solutionhood of the translated profile is characterized exactly by everywhere differentiability of the profile.',
 'Integral conservation is interpreted by finite-rectangle balance with ordinary real length measure, on exactly locally interval-integrable profiles.'
 ],
 'limitations':[
 'The pinned PDF does not itself explicitly specify this complete analytic profile class; original source ambiguity and all earlier nonaccepted audits remain evidence.',
 'Future source extraction and semantic judging must distinguish the book facts from this adopted interpretation and must audit fresh exact targets under the recorded interpretation.',
 'This does not alter source/profile/module audit hashes, settle other source-row interpretations, or authorize any remote write, campaign integration, promotion or operator receipt.'
 ],
 'source_sha256':'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5',
 'context_review_sha256':'ec5198495494ed4d2c13b11099e71154704a5ab7d795d5158ca1436ccb7ae6be'}
out.write_text(json.dumps(record,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
search=S/'transport-domain-draft'/'search-evidence.json';assert not search.exists()
queries=[['rg','-n','solutionDomains|transportSolution.*iff|travelingWave_isLinearAdvectionSolution_iff|travelingWave_isRectangleConservationLawSolution_iff','ComputationalMathematics','.lake/packages/mathlib/Mathlib'],
 ['rg','-n','isUniformAdvection_iff_eq_travelingWave|uniformTransportModel|scalarEquation_isHyperbolic|equation02_isOneDimensionalSpecialization','ComputationalMathematics']]
runs=[]
for argv in queries:
 r=subprocess.run(argv,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert r.returncode in [0,1]
 runs.append({'argv':argv,'exit_code':r.returncode,'stdout':r.stdout.decode('utf-8'),'stderr':r.stderr.decode('utf-8')})
search.write_text(json.dumps({'schema':1,'runs':runs,'selection':'Reuse the exact existing classical iff, rectangle iff, kinematic characterization, scalar hyperbolicity and scalar/system reduction producers. New wrappers only compose those established statements; no duplicated calculus proofs. The older sufficient-direction wrappers are retained and do not supply the new necessary-direction contract.','absence_claim':'Scoped lexical results only; no claim of global semantic absence.'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'interpretation_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'search_sha256':hashlib.sha256(search.read_bytes()).hexdigest()}))
