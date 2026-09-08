"""Freeze successful full source and compiled-dependency graph replay evidence."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
checks=[]
for label in ['interpreted-architecture-graph-capture','interpreted-architecture-graph-check']:
    op=S/(label+'-output.txt');ep=S/(label+'-exit.json')
    e=json.loads(ep.read_text());assert e['exit_code']==0
    assert sha(op.read_bytes())==e['raw_output_sha256']
    checks.append({**e,'output':op.relative_to(R).as_posix(),'exit_sha256':sha(ep.read_bytes())})
assert (S/'interpreted-architecture-graph-check-output.txt').read_bytes()==b''
paths=[S/'architecture-graphs/checkpoint-4a29be754.json',S/'architecture-graphs/checkpoint-4a29be754.md']
b=json.loads(paths[0].read_text());source=b['source'];tier=source['tier_audit'];decl=b['declarations']
assert b['metadata']['commit']=='4a29be754145fb1099e35feb679df6d4e524acc8'
assert b['metadata']['library_source_clean'] is True and not b['metadata']['library_source_dirty_paths']
assert source['module_count']==5925 and source['unresolved_project_import_count']==0
assert source['import_graph']['cyclic_strong_component_count']==0
assert tier['classified_module_count']==5925 and tier['unclassified_module_count']==0
assert tier['classification_complete'] and tier['tier_separation_complete'] and tier['physical_source_target_gate_satisfied']
assert tier['forbidden_reusable_reachability_count']==0
assert decl['format_version']==2 and decl['declaration_count']==60347
assert decl['edge_counts']['signature']==272296 and decl['edge_counts']['body_or_proof']==393185
record={'schema':1,'checks':checks,'artifacts':[{'path':p.relative_to(R).as_posix(),'sha256':sha(p.read_bytes())} for p in paths],
    'source_tree_sha256':source['source_tree_sha256'],'source_tree_normalization':source['source_tree_sha256_normalization'],
    'counts':{'modules':5925,'declarations':60347,'signature_edges':272296,'body_or_proof_edges':393185},
    'organization':'No unresolved project imports, import cycles, unclassified modules or forbidden reusable-to-source/mixed reachability.',
    'limits':'The second actual native extraction reproduced the complete recorded baseline measurements; this is current-worktree replay, not the final pristine candidate replay.'}
dest=S/'interpreted-architecture-replay-verification.json';assert not dest.exists()
dest.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt_sha256':sha(dest.read_bytes()),'counts':record['counts'],'source_tree_sha256':record['source_tree_sha256']}))
