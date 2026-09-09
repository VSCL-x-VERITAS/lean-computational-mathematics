from pathlib import Path
import hashlib,json
G=Path(__file__).resolve().parent;R=G.parents[5]
receipt=json.loads((G/'joint01-receipt.json').read_text());assert receipt['actual_exit_code']==0 and receipt['dependencies_unchanged']
generic=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/HighResolutionCoordinateSweep.lean'
target=R/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean';assert not target.exists()
t=generic.read_text();start=t.index('namespace NumStability.HighResolutionCoordinateSweep');body=t[start:].split(' := by',1)[0]
body=body.replace('namespace NumStability.HighResolutionCoordinateSweep','namespace NumStability').replace('theorem coordinate_highResolution_specification','theorem leveque01_coordinateHighResolutionMethods_sourceContract')
proof=''' := by
  exact HighResolutionCoordinateSweep.coordinate_highResolution_specification hm hD
    method direction quality initial physical steps amplification localDefect splittingDefect
    initialError leftError rightError href hinitial hactual hrefadmit hamplification hleft hright
    hlocal hsplit hschedule

end NumStability
'''
header='''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep

/-!
Chapter 1 coordinate splitting under the recorded logical-grid interpretation
and the separately adopted high-resolution convention. The latter requires
uniform order greater than one for smooth local references, perturbation
stability, and quantitative oscillation control. This is an explicit selected
interpretation, not a claim that the book states these analytic quantifiers.

The theorem uses the supplied methods on their actual extracted lines, keeps
boundary data and splitting defects explicit, and identifies actual Cartesian
measures and fluxes when the same physical data has that realization. It does
not assert higher temporal order for a Lie-split composite or existence of
high-resolution solvers for arbitrary laws.
-/

'''
target.write_text(header+body+proof,encoding='utf-8',newline='\n')
joint=(G/'Joint.lean').read_text().replace('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep','import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods')
joint=joint.replace('NumStability.HighResolutionCoordinateSweep.coordinate_highResolution_specification','NumStability.leveque01_coordinateHighResolutionMethods_sourceContract')
joint+='\n#check NumStability.leveque01_coordinateHighResolutionMethods_sourceContract\n#print axioms NumStability.leveque01_coordinateHighResolutionMethods_sourceContract\n'
joint+='\ntheorem source_type_preserved : @NumStability.leveque01_coordinateHighResolutionMethods_sourceContract = @NumStability.HighResolutionCoordinateSweep.coordinate_highResolution_specification := rfl\n#check source_type_preserved\n#print axioms source_type_preserved\n'
(G/'SourceJoint.lean').write_text(joint,encoding='utf-8',newline='\n')
(G/'source-placement.json').write_text(json.dumps({'path':target.relative_to(R).as_posix(),'module':target.relative_to(R).as_posix()[:-5].replace('/','.'),'sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'declarations':['NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'],'declaration_kinds':[{'name':'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract','kind':'theorem'}],'lines':len(target.read_text().splitlines()),'joint_prerequisite':{'path':(G/'joint01-receipt.json').relative_to(R).as_posix(),'sha256':hashlib.sha256((G/'joint01-receipt.json').read_bytes()).hexdigest()}},indent=2)+'\n',encoding='utf-8',newline='\n')
