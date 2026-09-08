from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
pins={
 'returned-field-coordinate-sweep-draft/full03-input.lean':'c3eca6eb759afc3f1298a46455621b468200c91e2e8b3f418c167fb12aeeeb54',
 'returned-field-coordinate-sweep-draft/Core.lean.fragment':'9eb686053e36bcb0d206098abcff29a938da9a0b93fa434de2d10d2ae1b3c2aa',
 'returned-field-coordinate-sweep-draft/Specializations.lean.fragment':'41d6d5c2cf1878755a5e8817422ec545e35e9eab3cbfce68a1fb1dbc79f268a6',
 'returned-field-coordinate-sweep-draft/final-receipt.json':'b306ba9a0b673635208f0e868cdc9e1dd416cbdf6fec7fb1fe8d0e75a3b5730f',
 'returned-field-coordinate-sweep-draft/verification.json':'467127618ce6ab48ff0c97e84ecadc9e22a91f4c13d52285d5890939c7f6d13d',
 'returned-field-coordinate-sweep-draft/REVIEW.md':'e854c769416897556c6483e1038b8d50c7105d2a9201d872264b843ef327fe35',
 'riemann-information-only-method-draft/Candidate.lean':'3d090a899d6a93ac19783ee2533f763084e9cac459e5e0e14f2b0058ffcfc466',
 'riemann-information-only-method-draft/final-receipt.json':'9fb9b60408c939a0ab22af27d01710c022f1a3a0665e0966732a8860f6f292a2'}
for p,h in pins.items():assert sha(S/p)==h,p
commands=[['rg','-n','InformationCoordinateSweepDraft|RiemannInformation.*sweep|sweep.*RiemannInformation|StageAdmitted','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean'],['rg','-n','normalFaceFlux|advance_line_local|finite_line_mass_balance|sweep_cons|sweep_two_mass_balance','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CoordinateLineBalance.lean','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CoordinateLineSweep.lean']]
searches=[]
for i,cmd in enumerate(commands):
 p=P/f'search-{i+1}.txt';assert not p.exists()
 r=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);assert r.returncode==(1 if i==0 else 0)
 p.write_bytes(r.stdout);searches.append(dict(command=cmd,exit_code=r.returncode,output=bind(p)))
v=dict(schema=1,status='unselected_scratch_preparation',source_acceptance=False,frozen_inputs=[bind(S/p) for p in pins],searches=searches,production_information_api='await separately frozen native-ready receipt; no mutable imports used',reuse='Compose existing normalFaceFlux/advance/sweep and mass/locality producers; preserve prior full-field proof packet and demonstrate its explicit specialization.')
p=P/'preparation.json';assert not p.exists();p.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(sha(p))
