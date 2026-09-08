# Transport and Riemann interface placement review

The eight new modules have five reusable owners and three source wrappers.
They extend the existing semantic PDE families and preserve all previously
declared owners. The new Transport directory does not collide with a declaration
file. No module, class or namespace is renamed, and no historical forwarder is
removed. All eight leaves are imported by the appropriate canonical aggregate
in the repository's required casefold order.

The reusable interface modules certify the ordered initial trace and the full
rectangle conservation law on an explicit solver domain. The finite-volume
workflow uses actual normalized cell integrals, adjacent cell order, certified
solves, extracted information and the existing conservative update. The linear
instance is inhabited on all ordered state pairs, using the already checked
eigenbasis Riemann solution and a genuine matrix-flux derivative. The source
wrapper preserves domain and positive-time hypotheses. It asserts no general
nonlinear solvability, entropy uniqueness, CFL condition, convergence or error
estimate.

The characteristics module separates arbitrary-profile transport identities
from the exact classical regularity characterization. The rectangle
characterization is owned by ConservationLaws. The uniform-advection module
uses a kinematic trajectory condition, not a PDE assumption, and derives actual
classical or rectangle satisfaction from the appropriate initial regularity.
The two source wrappers reuse these owners and retain the previous scalar
equation and profile contracts while extending their substantive coverage.
Old weaker source wrappers are retained as public declarations; the new wrappers
have distinct propositions and do not duplicate their proofs.

All 24 new declarations pass their exact canonical imports and axiom checks.
Both prototypes and the final production bytes are preserved by manifests and
raw native exit evidence. Independent source audits remain open, including the
two stronger successors to nonaccepted audits; this organization review does
not certify source equivalence.

The first tier scan reports five unclassified reusable owners and three new
source leaves covered by the existing source prefix, for 5,919 production
modules. Eight exact rules will be added after the files have an actual
introduction commit; metadata will cite that real commit. Existing roles,
import ceilings, compatibility targets, exceptions and released validators
remain unchanged. Final current layout/tier checks are required afterward.
