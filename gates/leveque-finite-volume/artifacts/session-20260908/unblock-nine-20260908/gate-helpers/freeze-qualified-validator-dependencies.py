"""Additive dependency pin sidecar; no validator invocation or other mutation."""
import json
from pathlib import Path
import qualified_row_support_v2 as q


def main():
    h, s = q.HERE, q.SESSION
    expected = {
        h/'qualified_row_support_v2.py': 'c72831c1518610fe7c67bba22322b7418ced275a731bf3b474d9ed6ae8fe64da',
        h/'protected-baseline.json': q.BASELINE_SHA,
        s/'bind-audited-stronger-reused-row.py': q.BASE_SHA,
        s/'bind-audited-stronger-production-rows.py': '2b6e6d26931f831970479cfdae30f066d3712586363ef08e6ce0b830306782d6',
        s/'bind-variable-consensus-stronger-row.py': 'e4b0e2d242e7fc7e91e955e3c828bc43992cc4748493c2f4b0d2bea2716f8b4c',
    }
    for path, digest in expected.items():
        assert q.sha(path) == digest
    validator = h/'validate-closed-row-audits-v5.py'
    assert q.sha(validator) == 'ad6791fe5786f1b5660713e62c798c8a03e51c0210b59b98fc6f0582ef9bb59b'
    checker = q.ROOT.parent/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
    assert q.sha(checker) == q.CHECKER_SHA
    payload = {'schema': 1, 'status': 'DEPENDENCIES_ONLY_NO_OPERATIONAL_VALIDATION',
               'frozen_helper_receipt': q.reference(h/'qualified-refinement-v2-final-receipt.json'),
               'audit_validator': q.reference(validator),
               'validator_dependencies': [q.reference(path) for path in expected],
               'separate_bound_selection_inputs': [q.reference(q.SELECTION)] +
                   [{key: pin[key] for key in ('path', 'sha256')} for pin in q.REFINEMENTS.values()],
               'sealed_complete_validator': q.reference(q.ROOT/'.faithfulness-audit/scripts/validate_audit.py'),
               'external_released_gate_checker': {'workspace_relative_path': checker.relative_to(q.ROOT.parent).as_posix(),
                                                  'sha256': q.CHECKER_SHA},
               'producer': q.reference(Path(__file__)),
               'limits': 'Direct local dynamic-helper dependencies and baseline are enumerated; this is not a replacement for each exact sealed audit manifest/configuration/environment or the released complete validator dependencies. External gate checker uses a workspace-relative path, not a repository FileRef.'}
    path = h/'qualified-refinement-v2-validator-dependencies.json'
    with path.open('xb') as handle:
        handle.write(q.encode(payload))
    print(json.dumps({'sidecar': q.reference(path), **payload}, indent=2))


if __name__ == '__main__':
    main()
