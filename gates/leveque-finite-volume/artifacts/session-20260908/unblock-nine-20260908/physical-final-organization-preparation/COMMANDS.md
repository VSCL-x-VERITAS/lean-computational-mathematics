# Root-owned invocation forms

Use the unchanged native Python and POSIX launcher. Replace angle-bracket operands with actual pinned input values; these are templates, not records of commands already executed. Preserve every failed run and use fresh output directories.

```text
C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe -X utf8 -B
  C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py
  C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-final-organization-preparation/inspect_scope_v2.py
  --build-receipt <repository-relative actual current physical build receipt>
  --build-sha256 <its actual SHA256>
  --out scope-final-01
```

After current checker/native/fingerprint/manual-review inputs exist, fill a **new** ready-input file following `ready-inputs.pending.json`. Assemble with native Python; no Git or organization measurement runs inside this assembler:

```text
<native Python> -X utf8 -B <absolute physical-final-organization-preparation/assemble_config.py>
  --ready-inputs <absolute root-released ready-input JSON>
  --ready-sha256 <actual ready-input SHA256> --out assembled-final-01
```

For the existing source graph command, preserve its semantics and choose a new output name:

```text
<native Python> -X utf8 -B <absolute run_workflow_posix.py>
  <absolute repository tools/architecture/generate_baseline.py>
  --strict-source --no-build
  --output-dir gates/leveque-finite-volume/artifacts/session-20260908/architecture-graphs
  --name <new current physical source-graph name>
```

Actual checker commands under POSIX remain `/usr/bin/python3 tools/architecture/check_layout.py`, `check_tiers.py`, `check_compatibility.py`, and `check_placeholders.py`, each with the full respective path. Root records actual command/output/exit and explicitly reviews applicability. This packet does not rerun them.

After reviewing the assembled config, invoke the unchanged helpers through the POSIX launcher, with repository cwd and POSIX absolute `--repo`:

```text
<native Python> -X utf8 -B <absolute run_workflow_posix.py>
  <absolute D/final-organization-successor-preparation/capture_current_v2.py>
  --repo /c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics
  --config <repository-relative assembled-final-01/config.json> --config-sha256 <actual SHA256>
  --out gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-final-organization-preparation/capture-final-01

<native Python> -X utf8 -B <absolute run_workflow_posix.py>
  <absolute D/final-organization-successor-preparation/prepare_draft_v2.py>
  --repo /c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics
  --config <same repository-relative assembled config> --config-sha256 <same actual SHA256>
  --capture-manifest <repository-relative actual capture-manifest.json> --capture-sha256 <actual SHA256>
  --out gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-final-organization-preparation/draft-final-01
```

Preserve the draft unchanged. After root reviews and derives separately approved `reviewed-for-organization-measurement` / `reviewed-current-inputs` records, run the existing `D/final-candidate-epoch-preparation/prepare_organization.py` through the same launcher with `--root <POSIX repository> --inputs <actual reviewed input file> --inputs-sha256 <actual SHA256> --output <fresh output directory>`. This final measurement is not authorized for execution by this preparation subtask.
