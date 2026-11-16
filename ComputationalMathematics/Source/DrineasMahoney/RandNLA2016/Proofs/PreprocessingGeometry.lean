import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.PreprocessingGeometry
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.CountSketch.OrthonormalEmbedding

/-! # Sparse signed-hash subspace embedding -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Proofs

open Targets

theorem sparseSignedHashSubspaceGeometry : Targets.sparseSignedHashSubspaceGeometry := by
  intro m d t ht U _hm hU ε δ hε _hε1 hδ _hδ1 hbudget
  exact countSketchProbability_eventProb_subspace_geometry_of_dimension ht U hU hε hδ hbudget

end NumStability.Source.DrineasMahoney.RandNLA2016.Proofs
