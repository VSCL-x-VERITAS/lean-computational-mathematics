# Renderer interface

Run native Python with `-X utf8 -B` on `render_suite.py` using all three required options:

```text
--extension <actual repository-relative finalized compiler extension path>
--extension-sha256 <actual SHA256 of that extension>
--output-name <new direct child name under suite>
```

The angle-bracket values are required real inputs, not fabricated pins. There is deliberately no ready operational invocation before the parent freezes the adapter and extension. `--output-name` permits only letters, digits, hyphens and underscores. An existing output directory, a path outside `suite`, changed parents, an unpinned extension, or changed extension inputs is rejected.

The closed extension object requires exactly:

```text
format = exact-package-command-extension-1
task_id = LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908
row_id = LEV-CH01-DIMENSIONAL-SPLITTING
target_file = ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean
target_declaration = NumStability.leveque01_coordinateHighResolutionMethods_sourceContract
adapter = FileRef
descriptor = FileRef
environment_files = nonempty list of unique FileRefs
command = ['python3', '-B', adapter.path, '--descriptor', descriptor.path,
           '--descriptor-sha256', descriptor.sha256]
```

`FileRef` has exactly `path` and lowercase 64-character `sha256`. Paths are normalized repository-relative POSIX paths. The implementation rejects traversal, empty path components, absolute/drive paths, symlink files and paths resolving outside the repository, duplicate JSON keys, duplicate declared environment paths, and conflicting pins. The extension, adapter and descriptor are always included in the bound environment even when they are not repeated in `environment_files`.

The audit spec adds exactly `compiler_command_extension: FileRef` to the existing roots-v2 spec. Its root extension, source context, target, Q10 selection and other fields retain their existing guards. `spec-extension.json` in a render output supplies the actual pointer used for that rendering.

The future installed names are:

```text
D/prepare-successor-audit-with-package-command-v1.py
H/qualified_row_support_package_command_v1.py
H/bind-qualified-row-package-command-v1.py
H/validate-closed-row-audits-package-command-v1.py
H/validate-closed-row-audits-rebind-package-command-v1.py
H/rebind-accepted-row-batch-package-command-v1.py
H/bind-final-global-evidence-package-command-v1.py
H/source-context-package-command-v1-validator-dependencies.json
```

`H` is `D/gate-helpers`. The renderer only writes corresponding review copies under `<output-name>/prospective`; it never creates those installed files. Once root/parent explicitly adopts the actual output, their separate installation must preserve each byte and verify the manifest's proposed installed hashes before any use. The synthetic output is excluded from installation.

Actual fixture invocation already completed:

```text
C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe -X utf8 -B <suite>/test_suite.py
```

It used exclusive `synthetic-fixture-01` and `synthetic-render-01` directories. Re-running it unchanged intentionally fails rather than overwriting evidence. Its actual stdout, stderr and process receipt are preserved under `checks-run-01`.
