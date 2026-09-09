from pathlib import Path
h=Path(__file__).resolve().parent
header='''import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

'''
parts=['Base.lean.fragment','ConstantFlux.lean.fragment','Geometry.lean.fragment','Boundary.lean.fragment','Execution.lean.fragment','Nonconstant.lean.fragment','Family.lean.fragment','Checks.lean.fragment']
(h/'Candidate.lean').write_text(header+'\n'.join((h/p).read_text(encoding='utf-8') for p in parts),encoding='utf-8',newline='\n')
