"""Prepare exact native type/axiom probes for canonical local Riemann information."""
from pathlib import Path
import hashlib,json
I=Path(__file__).resolve().parent;D=I.parent;R=I.parents[5]
owners={
 'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalInformationInterface.lean':'713c7c9908e0d5757a147895cc64c7258ebaa94a6c2d5b2e67befabfb0632730',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformation.lean':'ba7190f2a87957bbe87ba2c095398cb56106a06f71e70480d89f98f4eff990ec',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformationUpdate.lean':'f6969c39f2d3052cc59516c4a07ed1e2299e4155afad2d48ea9395c632efeb76',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalCellErrorBounds.lean':'1d4916271a563a9e970ace21deff6e69a7d7ad0d16065c95f9320c521d77d14e'}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
files=[]
for rel,digest in owners.items():
 assert sha(R/rel)==digest
 files.append({'path':rel,'sha256':digest})
for rel in [*owners,'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Hyperbolicity.lean']:
 if rel not in owners:files.append({'path':rel,'sha256':sha(R/rel)})
 binary='.lake/build/lib/lean/'+rel[:-5]+'.olean'
 files.append({'path':binary,'sha256':sha(R/binary)})
local=['Law','Law.mk','Law.positive_dimension','Law.states','Law.flux','Law.hyperbolic',
 'Problem','Problem.mk','Reference','Reference.mk','Reference.initial','Reference.admissible',
 'Reference.spatial_integrable','Reference.face_integrable','Reference.rectangle','Reference.meanFlux',
 'Method','Method.mk','Method.domain','Method.solve','Method.extract','Method.numericalFlux',
 'Method.errorBound','Method.accurate','Method.consistent','Method.flux','Method.reference_comparison',
 'adjacentProblem','local_interface_contract']
decls=['NumStability.LocalRiemannInformation.'+name for name in local]+[
 'NumStability.IsHyperbolicFluxAt','NumStability.IsHyperbolicFluxOn',
 'NumStability.isHyperbolicFluxOn_iff_independent_real_eigenvectors',
 'NumStability.finiteVolumeLocalCell_error_contract',
 'NumStability.leveque01_localRiemannInformationInterface_sourceContract']
probe='import ComputationalMathematics.Source.LeVeque.Chapter01.RiemannLocalInformationInterface\n\nset_option pp.universes true\n\n'
probe+='\n\n'.join('#check @'+name+'\n#print axioms '+name for name in decls)+'\n'
path=I/'CanonicalTypes.lean'
with path.open('x',encoding='utf-8',newline='\n') as f:f.write(probe)
manifest={'schema':1,'scope':'Exact canonical types and constructors, with axiom reports only; no proof bodies.',
 'files':files,'probe':{'path':path.relative_to(R).as_posix(),'sha256':sha(path)},'declarations':decls}
with (I/'native-inputs.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(manifest,f,indent=2);f.write('\n')
print(json.dumps({'declarations':len(decls),'source_and_olean_pins':len(files),'probe_sha256':sha(path)}))
