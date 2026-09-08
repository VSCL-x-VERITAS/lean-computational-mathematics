"""Freeze reviewed source inventory content separately from changing row statuses."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
gate = json.loads((R / 'gates/leveque-finite-volume/chapter-01.json').read_text())
assert len(gate['rows']) == 57
rows = []
for row in sorted(gate['rows'], key=lambda r: r['id']):
    fields = {k: row[k] for k in ['id', 'source_label', 'printed_page', 'pdf_page', 'row_kind', 'depends_on']}
    if row['status'] == 'SKIPPED':
        fields['disposition'] = {k: v for k,v in row.items() if k.startswith('skip') or k in ['status','reason','coverage_links']}
    else:
        fields['disposition'] = {'formalizable': True}
    rows.append(fields)
reviews = []
for name in ['source-review.md', 'independent-inventory-review-final.md', 'independent-inventory-reconciliation.md']:
    path = S / name
    reviews.append({'path': path.relative_to(R).as_posix(), 'sha256': sha(path.read_bytes())})
assert reviews[1]['sha256'] == 'd7511e5d60cff72ca6126d8ffecf969728cb75200ac59008d5076cbf8b940d78'
source = S / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
assert sha(source.read_bytes()) == 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
record = {'schema': 1, 'source_path': source.relative_to(R).as_posix(),
    'source_sha256': sha(source.read_bytes()), 'printed_pages': [1,11], 'raw_pdf_pages': [23,33],
    'procedure': 'The root and independent source-only reviewers inspected all eleven primary-source renderings. The preserved reconciliation accepted the independent coverage findings and added the three distinct objects. This snapshot binds the resulting exact inventory content; it does not judge any Lean target.',
    'reviews': reviews, 'rows': rows, 'source_record_count': 57,
    'formalizable_count': sum(r['disposition'].get('formalizable', False) for r in rows),
    'skipped_count': sum(r['disposition'].get('status') == 'SKIPPED' for r in rows),
    'page_without_object': {'printed': 9, 'raw_pdf': 31, 'reason': 'Software paths, download guidance and references; independently reviewed as containing no mathematical object.'},
    'numbered_equations': ['1.'+str(i) for i in range(1,12)],
    'exercises_figures_tables': 'No exercises, figures or numerical tables in the inspected chapter range.'}
assert record['formalizable_count'] == 41 and record['skipped_count'] == 16
target = S / 'chapter01-source-inventory-coverage.json'
assert not target.exists()
target.write_text(json.dumps(record, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
print(json.dumps({'source_records':57,'formalizable':41,'skipped':16,'receipt_sha256':sha(target.read_bytes())}))

