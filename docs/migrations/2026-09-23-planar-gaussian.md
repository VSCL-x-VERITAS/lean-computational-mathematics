# Planar Gaussian reusable API promotion

The source-independent two-dimensional Gaussian density calculations formerly
proved inside the Higham Chapter 28 source module now have canonical reusable
producers in
`ComputationalMathematics.Analysis.Probability.Gaussian.Planar`.

| Existing declaration | Canonical producer | Compatibility decision |
| --- | --- | --- |
| `NumStability.gaussianReal_prod_real_apply` | `NumStability.Analysis.Probability.Gaussian.gaussianRealProd_real_apply` | Retained with its exact statement as a forwarding theorem. |
| `NumStability.gaussianPDFReal_zero_one_prod_polar` | `NumStability.Analysis.Probability.Gaussian.standardGaussianPairPDF_polar` | Retained with its exact statement as a forwarding theorem. |

No existing declaration name, type, namespace, or import path is removed. The
canonical module is classified `reusable` and is re-exported by the Gaussian
analysis aggregate. New reusable consumers should import the canonical module;
source-facing Higham consumers remain compatible.
