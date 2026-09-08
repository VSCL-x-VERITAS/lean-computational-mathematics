"""Record scoped reuse and immutable context before composing a prospective capstone."""
from pathlib import Path
from hashlib import sha256
import datetime, json, subprocess

here=Path(__file__).resolve().parent
session=here.parent
repo=here.parents[4]
bind=lambda p:dict(path=str(p),sha256=sha256(p.read_bytes()).hexdigest())
searches=[
 ['rg','-n','InformationInterfaceDraft|normalized_spatial_average|finite_step_reference_comparison','ComputationalMathematics'],
 ['rg','-n','PureInterfaceContract|normalized_interface_execution|returned_field_comparison_contract',str(session/'returned-field-interface-capstone-draft/Candidate.lean')],
 ['rg','-n','cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage|interface_execution|interface_error_le|update_error_le|selected_flux_eq_reference_average|hasDerivAt_mass_ae','ComputationalMathematics/Analysis/PartialDifferentialEquations'],
 ['rg','-n','theorem (volume_Ioc|setAverage_const)|lemma (volume_Ioc|setAverage_const)|integral_of_le|intervalIntegrable_const','.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/Average.lean','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean'],
 ['rg','-n','OneDimensionalFiniteVolumeGrid where|oneDimensionalCellAverage.*const|riemannData_intervalIntegrable','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume']]
records=[]
for i,command in enumerate(searches,1):
 run=subprocess.run(command,cwd=repo,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 path=here/f'search-{i:02d}.txt';assert not path.exists();path.write_bytes(run.stdout)
 assert run.returncode in [0,1], (command,run.returncode)
 records.append(dict(command=command,cwd=str(repo),exit_code=run.returncode,output=bind(path)))
old=session/'returned-field-interface-capstone-draft'
context=[session/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf',
 old/'preparation.json',old/'Candidate.lean',old/'REVIEW.md',old/'final-receipt.json',
 session/'information-method-production/final-receipt.json',session/'information-method-production/manifest.json',
 session/'current-thread-clarification-provenance-batch9.json',repo/'AGENTS.md',repo/'lean-toolchain',repo/'lake-manifest.json']
assert bind(context[0])['sha256']=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
assert bind(session/'information-method-production/final-receipt.json')['sha256']=='5f602458855faa07f2b770cd42e832e72f704ace3862025b53b15e87810b3645'
pages=[]
for n in [26,27,28]:
 pages.append(dict(raw_pdf_page=n,printed_page=n-22,role='continuation context only' if n==28 else 'selected context',
                   image=bind(old/f'page-{n:03d}.png'),text_navigation=bind(old/f'page-{n:03d}.txt'),
                   viewed_with='native view_image in this bounded task; rendering commands/provenance in prior frozen preparation.json'))
receipt=dict(created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_acceptance=False,
             searches=records,context=[bind(p) for p in context],pages=pages,
             reuse='Canonical information routine, actual selected execution, normalized volume/interval bridge, temporal AE theorem, two-face conditional estimates and left-state example. No reproof of generic integral/error estimates.',
             source_scope='Prospective assembly only. Adopted rectangle + AE convention retained; Q7 accuracy remains pending. No compulsory full returned field or all-real trace integrability.')
target=here/'preparation.json';assert not target.exists();target.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(bind(target)))
