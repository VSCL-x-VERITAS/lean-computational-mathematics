from pathlib import Path
h=Path(__file__).resolve().parent
imports='''import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

'''
parts=['Mesh.lean.fragment','Capacity.lean.fragment','Method.lean.fragment','Geometry.lean.fragment','Boundary.lean.fragment','Execution.lean.fragment','Nonconstant.lean.fragment','Reference.lean.fragment','ReferenceConnection.lean.fragment','Checks.lean.fragment']
(h/'Candidate.lean').write_text(imports+'\n'.join((h/p).read_text(encoding='utf-8') for p in parts),encoding='utf-8',newline='\n')
