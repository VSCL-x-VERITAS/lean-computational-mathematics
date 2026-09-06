# Faithfulness audit: HDP-02-EX-2.5.5A

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The source and Lean proposition concern the same standard-normal square-exponential moment, with the same real parameter, integrand, symmetry, and finite-versus-divergent boundary behavior. Lean's canonical measure gaussianReal 0 1 faithfully represents X distributed as N(0,1), and Integrable is used to distinguish a finite real expectation from divergence. The target goes beyond the printed qualitative exercise by proving the exact critical radius and exact finite integral value. Therefore Lean implies the source, the literal source conclusion does not imply the full Lean proposition, and the correct accepted classification is faithful-stronger. All dependencies and semantic checks are resolved, so adjudication is not requested.

## Implications

- **Lean implies source:** `yes`. The Lean theorem proves that the expectation is finite exactly on the bounded open neighborhood (-1/sqrt(2), 1/sqrt(2)) and nonintegrable at every parameter outside it. This directly entails the exercise's qualitative bounded-neighborhood finiteness claim for a standard normal law.
- **Source implies lean:** `no`. The printed exercise states only qualitative finiteness in some bounded neighborhood. It does not itself assert the maximal radius 1/sqrt(2), divergence exactly at the endpoints, or the quantitative identity E exp(lambda^2 X^2) = 1/sqrt(1-2 lambda^2). Those are correct analytic consequences/strengthenings but are not entailed by the stated qualitative conclusion alone.

## Findings

- **note / genuine-strengthening:** The target is a correct, nonvacuous strengthening of the selected source result. It remains accepted under the protocol, but should not be described as a verbatim-equivalent formalization of the exercise's displayed wording.
- **note / genuine-strengthening:** This is a nonvacuous strengthening that implies the selected source result; it is not a loss of source content or a reduction in applicability.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `fail` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `57` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `57` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/agent_outputs/agent_runs.json` (`9020fb812f596e6037dc37cb6c30550e89b4677e5fe4cd3fcfa8c2533f393ffa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/agent_outputs/blind_translation.json` (`19d7ee57f7a717ecceb6dde4a9c140ff93b63c5b3ca8f9d825f47ad02371f258`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/agent_outputs/direct_judge.json` (`6f5eba7d57ca67cae72e53e8030f1127990d48c734b9ca3d996dd98e8e16e764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/agent_outputs/roundtrip_judge.json` (`97722d18e16e81ad74b48857f63b944a7de8297388a945c821a452d9ff277e64`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/agent_outputs/source_contract.json` (`d31bd84316d213b35ffc41424a674c85e81e0591eef73bf3285e867d34312a40`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/decision.json` (`acac69223ceb29df747b663bebb03585f469e1ccdcfd04b07bec6d6a011d03b9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T134551Z/inputs/blind_dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T134551Z/inputs/blind_dossier.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T134551Z/inputs/blind_review_packet.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T134551Z/inputs/declaration_dossier.md` (`b44076596224b843b4dc6e982902cbd80c3ad384db4b1385719d8abb10d7305c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T134551Z/inputs/dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T134551Z/inputs/direct_review_packet.md` (`8329563eb6b7d9434fac9c5ade91bd72d300606c9c7226da4162dc0ad360b700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T134551Z/inputs/source_locator.json` (`e3e5b2a5b9c9a308a81fa2674868228eadbf38a0f36c5ec5d3a46a5d13c69b26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/agent_outputs/agent_runs.json` (`09571bd1bb4a2e3c6582bc322191f8e69829c463bb3150ae2c5dcdc7f8a56631`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/agent_outputs/blind_translation.json` (`19d7ee57f7a717ecceb6dde4a9c140ff93b63c5b3ca8f9d825f47ad02371f258`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/agent_outputs/direct_judge.json` (`6f5eba7d57ca67cae72e53e8030f1127990d48c734b9ca3d996dd98e8e16e764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/agent_outputs/roundtrip_judge.json` (`97722d18e16e81ad74b48857f63b944a7de8297388a945c821a452d9ff277e64`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/agent_outputs/source_contract.json` (`d31bd84316d213b35ffc41424a674c85e81e0591eef73bf3285e867d34312a40`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/decision.json` (`47f1ae2bb345a023e5c70a0e604859063338189c020005cdd5220dade4ff05f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/inputs/blind_dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/inputs/blind_dossier.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/inputs/blind_review_packet.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/inputs/declaration_dossier.md` (`b44076596224b843b4dc6e982902cbd80c3ad384db4b1385719d8abb10d7305c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/inputs/dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/inputs/direct_review_packet.md` (`8329563eb6b7d9434fac9c5ade91bd72d300606c9c7226da4162dc0ad360b700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T145455Z/inputs/source_locator.json` (`e3e5b2a5b9c9a308a81fa2674868228eadbf38a0f36c5ec5d3a46a5d13c69b26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/agent_outputs/agent_runs.json` (`09571bd1bb4a2e3c6582bc322191f8e69829c463bb3150ae2c5dcdc7f8a56631`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/agent_outputs/blind_translation.json` (`19d7ee57f7a717ecceb6dde4a9c140ff93b63c5b3ca8f9d825f47ad02371f258`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/agent_outputs/direct_judge.json` (`6f5eba7d57ca67cae72e53e8030f1127990d48c734b9ca3d996dd98e8e16e764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/agent_outputs/roundtrip_judge.json` (`97722d18e16e81ad74b48857f63b944a7de8297388a945c821a452d9ff277e64`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/agent_outputs/source_contract.json` (`d31bd84316d213b35ffc41424a674c85e81e0591eef73bf3285e867d34312a40`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/decision.json` (`f42ff5236d7d949cef608116e5e4268cb25f62a79de4435d61fa46f6b529567a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/inputs/blind_dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/inputs/blind_dossier.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/inputs/blind_review_packet.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/inputs/declaration_dossier.md` (`b44076596224b843b4dc6e982902cbd80c3ad384db4b1385719d8abb10d7305c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/inputs/dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/inputs/direct_review_packet.md` (`8329563eb6b7d9434fac9c5ade91bd72d300606c9c7226da4162dc0ad360b700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260830T153229Z/inputs/source_locator.json` (`e3e5b2a5b9c9a308a81fa2674868228eadbf38a0f36c5ec5d3a46a5d13c69b26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/agent_outputs/agent_runs.json` (`09571bd1bb4a2e3c6582bc322191f8e69829c463bb3150ae2c5dcdc7f8a56631`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/agent_outputs/blind_translation.json` (`19d7ee57f7a717ecceb6dde4a9c140ff93b63c5b3ca8f9d825f47ad02371f258`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/agent_outputs/direct_judge.json` (`6f5eba7d57ca67cae72e53e8030f1127990d48c734b9ca3d996dd98e8e16e764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/agent_outputs/roundtrip_judge.json` (`97722d18e16e81ad74b48857f63b944a7de8297388a945c821a452d9ff277e64`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/agent_outputs/source_contract.json` (`d31bd84316d213b35ffc41424a674c85e81e0591eef73bf3285e867d34312a40`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/decision.json` (`a85af350904362ba86c0fcb2f12325f83b78a386e5a63daa5ed89e3ce0f677a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/inputs/blind_dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/inputs/blind_dossier.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/inputs/blind_review_packet.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/inputs/declaration_dossier.md` (`b44076596224b843b4dc6e982902cbd80c3ad384db4b1385719d8abb10d7305c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/inputs/dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/inputs/direct_review_packet.md` (`8329563eb6b7d9434fac9c5ade91bd72d300606c9c7226da4162dc0ad360b700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T084350Z/inputs/source_locator.json` (`e3e5b2a5b9c9a308a81fa2674868228eadbf38a0f36c5ec5d3a46a5d13c69b26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/agent_outputs/agent_runs.json` (`9020fb812f596e6037dc37cb6c30550e89b4677e5fe4cd3fcfa8c2533f393ffa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/agent_outputs/blind_translation.json` (`19d7ee57f7a717ecceb6dde4a9c140ff93b63c5b3ca8f9d825f47ad02371f258`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/agent_outputs/direct_judge.json` (`6f5eba7d57ca67cae72e53e8030f1127990d48c734b9ca3d996dd98e8e16e764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/agent_outputs/roundtrip_judge.json` (`97722d18e16e81ad74b48857f63b944a7de8297388a945c821a452d9ff277e64`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/agent_outputs/source_contract.json` (`d31bd84316d213b35ffc41424a674c85e81e0591eef73bf3285e867d34312a40`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/decision.json` (`6a06e41495d5b25d38dd76e632c37c9e4d233b31a17d47f5e6247bea98691b25`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/inputs/blind_dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/inputs/blind_dossier.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/inputs/blind_review_packet.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/inputs/declaration_dossier.md` (`b44076596224b843b4dc6e982902cbd80c3ad384db4b1385719d8abb10d7305c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/inputs/dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/inputs/direct_review_packet.md` (`8329563eb6b7d9434fac9c5ade91bd72d300606c9c7226da4162dc0ad360b700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/history/20260831T101532Z/inputs/source_locator.json` (`e3e5b2a5b9c9a308a81fa2674868228eadbf38a0f36c5ec5d3a46a5d13c69b26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/inputs/blind_dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/inputs/blind_dossier.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/inputs/blind_review_packet.md` (`c5d2f339de8ea40de0accf0b33444a3d16fce601ef9413cd8de2b0032c6a5f90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/inputs/declaration_dossier.md` (`1ce5182a3dd4a8561f1b703049a12cef4976eff0dbf365b0bcd943854c2d8b4f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/inputs/dependency_inventory.json` (`971042fe8da9eb794f0de8a5dd91e0376fb71d4d90691d7026ce67f88fcde649`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/inputs/direct_review_packet.md` (`8329563eb6b7d9434fac9c5ade91bd72d300606c9c7226da4162dc0ad360b700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5A/faithfulness/inputs/source_locator.json` (`e3e5b2a5b9c9a308a81fa2674868228eadbf38a0f36c5ec5d3a46a5d13c69b26`)
