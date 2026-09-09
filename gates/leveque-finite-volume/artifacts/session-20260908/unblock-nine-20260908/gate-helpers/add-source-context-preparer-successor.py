"""Retain tested original helper bytes and bind the reviewed long-path preparer too."""
from pathlib import Path
import hashlib
import json
H = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
changes = [
 ("SOURCE_CONTEXT_PREPARER_SHA = 'f0f27bc5757411a7363fcc70a18c78b2d5bf8011920f9e7c9ee2ebc2013f4ce2'",
  "SOURCE_CONTEXT_PREPARERS = {\n"
  "    'f0f27bc5757411a7363fcc70a18c78b2d5bf8011920f9e7c9ee2ebc2013f4ce2': 'prepare-successor-audit-with-source-context.py',\n"
  "    'fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e': 'prepare-successor-audit-with-source-context-long-paths.py',\n}"
  "\nSOURCE_CONTEXT_RECOVERY = {\n"
  "    'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/fv-local-domain-review/fv-partial-preparation-recovery.json',\n"
  "    'sha256': 'c09ae07dfec56808608e51f249e68196bebf78bdd0ce0ffb5009079c6a5c47a7',\n}"),
 ("    preparer = SESSION/'unblock-nine-20260908/prepare-successor-audit-with-source-context.py'\n"
  "    require(lineage['preparer_sha256'] == SOURCE_CONTEXT_PREPARER_SHA == sha(preparer), 'source-context preparer changed')\n",
  "    preparer_name = SOURCE_CONTEXT_PREPARERS.get(lineage['preparer_sha256'])\n"
  "    require(preparer_name is not None, 'unreviewed source-context preparer')\n"
  "    preparer = SESSION/'unblock-nine-20260908'/preparer_name\n"
  "    require(lineage['preparer_sha256'] == sha(preparer), 'source-context preparer changed')\n"),
 ("    return {'refs': refs, 'extension': extension, 'packet': packet, 'lineage': lineage, 'provenance': provenance}\n",
  "    recovery_ref = lineage.get('partial_recovery_manifest')\n"
  "    if recovery_ref is not None:\n"
  "        require(recovery_ref == SOURCE_CONTEXT_RECOVERY, 'unreviewed partial-preparation recovery')\n"
  "        recovery = source_context_json(source_context_ref(recovery_ref))\n"
  "        require(recovery['format'] == 'two-file-unsealed-audit-preparation-recovery-1'\n"
  "                and recovery['task_path'] == task_dir.relative_to(ROOT).as_posix()\n"
  "                and recovery['failure_stage'] == 'before-released-route'\n"
  "                and recovery['spec']['sha256'] == lineage['spec_sha256'], 'recovery provenance differs from this preparation')\n"
  "        require({item['path'] for item in recovery['existing_files']} ==\n"
  "                {request['task']['path'], request['interpretation_packet']['path']}, 'recovery changed the exact two-file scope')\n"
  "        provenance += [recovery_ref, recovery['spec'], recovery['preparer_parent'], *recovery['existing_files']]\n"
  "        for item in provenance:\n"
  "            bound(item)\n"
  "    return {'refs': refs, 'extension': extension, 'packet': packet, 'lineage': lineage, 'provenance': provenance}\n"),
]
records = []
snapshot = H/'source-context-initial-helper-snapshots'; snapshot.mkdir()
for name in ('qualified_row_support_v3.py', 'source-context-validation.fragment.py'):
    path = H/name; raw = path.read_bytes()
    with (snapshot/(name+'.snapshot')).open('xb') as handle: handle.write(raw)
    text = raw.decode()
    for before, after in changes:
        assert text.count(before) == 1, (name, before)
        text = text.replace(before, after)
    compile(text, name, 'exec')
    path.write_text(text, encoding='utf-8', newline='\n')
    records.append({'path': name, 'initial_snapshot': 'source-context-initial-helper-snapshots/'+name+'.snapshot',
                    'before_sha256': hashlib.sha256(raw).hexdigest(), 'after_sha256': sha(path)})
with (H/'source-context-preparer-successor-derivation.json').open('xb') as handle:
    handle.write((json.dumps({'schema': 1, 'files': records, 'exact_replacements': [{'before': a, 'after': b} for a,b in changes],
                             'operational_invocations': 0}, indent=2)+'\n').encode())
print(json.dumps(records, indent=2))
