"""Derive additive qualification helpers; never invoke operational entry points."""
from pathlib import Path
import hashlib
import json

H = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
fragment = (H/'source-context-validation.fragment.py').read_text(encoding='utf-8')
plans = [
 ('qualified_row_support_v2.py', 'c72831c1518610fe7c67bba22322b7418ced275a731bf3b474d9ed6ae8fe64da',
  'qualified_row_support_v3.py', [
   ('def validate_request(request_path, complete=False):', fragment+'\n\ndef validate_request(request_path, complete=False):'),
   ("    refinement = validate_refinement(packet, task, manifest, read(config))\n",
    "    refinement = validate_refinement(packet, task, manifest, read(config))\n"
    "    source_context = validate_source_context(request, task, manifest, read(config))\n"),
   ("    audit_hashes = {str(path): sha(path) for path in checked_files}\n",
    "    if source_context is not None:\n"
    "        checked_files += [bound(item) for item in source_context['provenance']]\n"
    "    audit_hashes = {str(path): sha(path) for path in checked_files}\n"),
   ("            'refinement': refinement}\n", "            'refinement': refinement, 'source_context': source_context}\n"),
   ("    return contract\n\n\ndef validate_bound_row", "    return append_source_context_contract(contract, validated.get('source_context'))\n\n\ndef validate_bound_row"),
   ("    for key, value in validated['fields'].items():\n",
    "    context = validated['source_context']\n"
    "    if context is not None:\n"
    "        require(all(row.get(key) == value for key, value in context['refs'].items()),\n"
    "                'row inherited-source context references differ from the exact audited qualification')\n"
    "    else:\n"
    "        require(not any(key in row for key in SOURCE_CONTEXT_KEYS), 'unextended row retains stale inherited source context')\n"
    "    for key, value in validated['fields'].items():\n"),
  ]),
 ('bind-qualified-row-v2.py', 'b0f17dcecf41c15d72571c3aea3e4f1a0790be3323b6ff917014592e12d9ba4a',
  'bind-qualified-row-v3.py', [
   ('import qualified_row_support_v2 as q', 'import qualified_row_support_v3 as q'),
   ("                'reuse_source', 'reuse_audit', 'interpretation_refinement_ref'):\n",
    "                'reuse_source', 'reuse_audit', 'interpretation_refinement_ref', *q.SOURCE_CONTEXT_KEYS):\n"),
   ("    if request['status'] == 'REUSED':\n        row.update(reuse_source=",
    "    if v['source_context'] is not None:\n        row.update(v['source_context']['refs'])\n"
    "    if request['status'] == 'REUSED':\n        row.update(reuse_source="),
  ]),
 ('validate-closed-row-audits-v5.py', 'ad6791fe5786f1b5660713e62c798c8a03e51c0210b59b98fc6f0582ef9bb59b',
  'validate-closed-row-audits-v6.py', [
   ('import qualified_row_support_v2 as qualified', 'import qualified_row_support_v3 as qualified'),
   ("            if classification == 'faithful-stronger':\n                record['strengthening_evidence']",
    "            if checked['source_context'] is not None:\n                record.update(checked['source_context']['refs'])\n"
    "            if classification == 'faithful-stronger':\n                record['strengthening_evidence']"),
  ]),
]
derivations = []
for parent, expected, child, changes in plans:
    assert sha(H/parent) == expected, parent
    text = (H/parent).read_text(encoding='utf-8')
    for before, after in changes:
        assert text.count(before) == 1, (parent, before)
        text = text.replace(before, after)
    compile(text, child, 'exec')
    with (H/child).open('xb') as handle: handle.write(text.encode())
    derivations.append({'source': {'path': parent, 'sha256': expected},
        'output': {'path': child, 'sha256': sha(H/child)},
        'exact_replacements': [{'before': a, 'after': b} for a,b in changes]})
with (H/'source-context-helper-derivation.json').open('xb') as handle:
    handle.write((json.dumps({'schema': 1, 'operational_invocations': 0,
        'fragment': {'path': 'source-context-validation.fragment.py', 'sha256': sha(H/'source-context-validation.fragment.py')},
        'derivations': derivations}, indent=2)+'\n').encode())
print(json.dumps([item['output'] for item in derivations], indent=2))
