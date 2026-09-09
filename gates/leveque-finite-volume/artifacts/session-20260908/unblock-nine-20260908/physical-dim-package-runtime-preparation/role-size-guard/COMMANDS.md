Use native Python `C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe` with `-X utf8 -B`. Let G be this directory's absolute `guard.py` path and C its absolute `staged.py` path:

`C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-package-runtime-preparation/role-size-guard/`

The new task ID is built into G. First require genuine successful released preparation and the new task's existing generated r.py/c.py, successful transport preflight and all six source images. No command below was run in this preparation task.

Prepare initial source and blind plans:

```text
PY -X utf8 -B G prepare source-contract s 25,26,27,28,125,126 --name source-01
PY -X utf8 -B G prepare blind-translation b "" --name blind-01
```

Preserve the empty blind pages argument using structured argv: `['prepare','blind-translation','b','','--name','blind-01']`. A size-overflow preparation exits 3 and keeps the exact full input; do not truncate it or execute it.

After root reviews each actual plan and its hash:

```text
PY -X utf8 -B G execute ACTUAL_PLAN_JSON --plan-sha256 ACTUAL_PLAN_SHA256
PY -X utf8 -B C collect --plan ACTUAL_PLAN_JSON ACTUAL_PLAN_SHA256 --name UNIQUE_COLLECTION_NAME
```

After validated source/blind collections, prepare direct and roundtrip plans with `direct-judge d 25,26,27,28,125,126 --name direct-01` and `roundtrip-judge r 25,26,27,28,125,126 --name roundtrip-01`; execute and collect only actual reviewed plans.

Check actual adjudication with all four SHA-bound collection receipts:

```text
PY -X utf8 -B C check-adjudication --name adjudication-check-01
  --collection SOURCE_COLLECTION_RECEIPT ACTUAL_SHA
  --collection BLIND_COLLECTION_RECEIPT ACTUAL_SHA
  --collection DIRECT_COLLECTION_RECEIPT ACTUAL_SHA
  --collection ROUNDTRIP_COLLECTION_RECEIPT ACTUAL_SHA
```

Only if the released check requires adjudication, prepare `adjudicator a 25,26,27,28,125,126 --name adjudicator-01`, then execute/collect that reviewed plan. Complete with C `finish --name completion-01 --check ACTUAL_CHECK_RECEIPT ACTUAL_SHA` and one `--collection ACTUAL_RECEIPT ACTUAL_SHA` for every required role. The staged helper runs released validators/finalizer through the unchanged POSIX launcher using the new task's configuration, captures all actual exits, and creates the aggregate only after complete success. Its successful execution may still describe an unaccepted decision.

Every stem and output name must be unused. Do not invoke q.py merely to obtain a receipt; it would bypass per-role size planning. These forms add no permission to launch a role before root review.
