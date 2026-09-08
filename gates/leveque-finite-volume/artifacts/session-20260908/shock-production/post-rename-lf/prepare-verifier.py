"""Adapt the preserved post-rename verifier to the separate LF-bound final pass."""
from pathlib import Path

HERE=Path(__file__).resolve().parent
PRE=HERE.parent
text=(PRE/'post-rename/freeze.py').read_text(encoding='utf-8')
text=text.replace("lookup={r['path']:r for r in rename['files']}",
    "normalization=read_json(PRE/'lf-normalization/receipt.json')\nlookup={r['path']:r for r in normalization['files']}")
text=text.replace("assert digest(path)==row['sha256']==lookup[row['path']]['sha256']",
    "assert digest(path)==row['sha256']==lookup[row['path']]['sha256']\n    assert b'\\r' not in path.read_bytes()")
start=text.index("old_focused=read_json(PRE/'focused-exits.json')")
stop=text.index("build=record(HERE",start)
text=text[:start]+'''post_focused=read_json(HERE/'focused-exits.json')
assert len(post_focused)==10
focused=[record(HERE,r,'lake env lean '+f['path']) for r,f in zip(post_focused,files)]
'''+text[stop:]
text=text.replace('/shock-production/post-rename/Declarations.lean',
                  '/shock-production/post-rename-lf/Declarations.lean')
text=text.replace("'prepare.py','run-focused.ps1','freeze.py'",
                  "'prepare.py','prepare-verifier.py','run-focused.ps1','freeze.py'")
text=text.replace("'reused_unchanged_file_checks':reused,'post_rename_file_checks':focused",
                  "'final_lf_file_checks':focused")
text=text.replace("'rename_receipt_sha256':digest(SESSION/'production-rename-receipt.json'),",
    "'rename_receipt_sha256':digest(SESSION/'production-rename-receipt.json'),\n    'lf_normalization_receipt_sha256':digest(PRE/'lf-normalization/receipt.json'),\n    'session_attributes_sha256':digest(SESSION/'.gitattributes'),")
text=text.replace('production-extraction-verification-2','production-extraction-verification-3')
(HERE/'freeze.py').write_bytes(text.encode('utf-8'))
print('Prepared final LF verifier without changing earlier verification evidence.')
