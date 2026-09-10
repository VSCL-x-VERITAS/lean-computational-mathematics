# Archived machine data

The machine-readable data of this record - the TSV inventories, JSON manifests,
patches, compressed projections and the one-off Python tools that produced them -
was retired from the tree on 2026-09-10. The narrative documents beside this
file are kept, so links from the repository's own documentation still resolve,
but their sibling data files do not.

The campaign these records describe is complete and merged, and nothing in CI
reads them any longer: the four phase checkers were retired with the data.

Recover any of it in full:

```bash
git show afb25bab1:<path>
git restore --source afb25bab1 -- <directory>
```

See `docs/architecture/reviews/2026-09-working-record-retirement.md`.
