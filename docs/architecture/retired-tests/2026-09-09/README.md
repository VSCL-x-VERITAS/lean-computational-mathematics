# Consolidated duplicate import probes

This archive preserves the exact original bytes of 390 redundant import-only
tests retired from the live `NumStabilityTest` tree on 2026-09-09. The source
revision is `b8ccf0d8bd610b599b13708e8c8518771bcf71ab`.

Each retired file contains exactly one import and comments. Its replacement is
one of 372 retained standalone tests importing the same exact module. The
retained tests are unchanged. Ten test aggregators replace the 390 retired
import edges with imports of those retained probes, sorted and deduplicated;
every byte outside their import lines is preserved. The test root's complete
import closure is unchanged except for the retired duplicate test modules.
No production module, declaration, proof, example, `#check`, or option is
removed or changed by this consolidation.

`manifest.json` maps every original path to its retained probe and isolated
import. It records the original byte count, SHA-256, Git blob, and the retained
probe's SHA-256 and Git blob at the source revision. `import-probes.zip` contains
the original relative paths and complete original bytes, including all comments
and license notices. The ZIP uses stored entries, a fixed timestamp, fixed file
permissions, and sorted paths so it can be recreated deterministically.

The historical phase and delivery records remain unchanged. Their original
paths describe their pinned historical Git trees, as required by
[`PROCESS.md`](../../PROCESS.md). Existing phase checkers continue to validate
those trees; this portable archive also preserves the retired source bytes
without requiring the old checkout.

Validate the archive, original source hashes, current isolated replacements,
their reachability from `NumStabilityTest`, and absence of live imports of the
retired test modules from the repository root:

```text
python tools/architecture/check_retired_tests.py
```

With full Git history available, also compare every archived source with the
source revision and verify the historical retained-probe hashes:

```text
python tools/architecture/check_retired_tests.py --verify-history
```

The gate's adversarial fixtures cover archive corruption, source-hash mismatch,
changed replacement imports, orphaned replacements, dangling retired imports,
nested comments, quoted text, and rejection of probes containing multiple
imports or other commands:

```text
python tools/architecture/check_retired_tests.py --self-test
```

For inspection or historical replay, extract selected ZIP members into a
separate directory and use their original relative paths. Do not restore all
members into the current live test tree: the manifest deliberately requires
the duplicate probes to remain retired. Their retained counterparts continue
to be compiled through `NumStabilityTest`.
