from pathlib import Path
D=Path(__file__).resolve().parent
s=(D/'freeze.py').read_text()
changes=[
 ("with (D/'PhysicalRefinement.reviewed.snapshot').open('xb') as f:f.write(raw)",
  "assert (D/'PhysicalRefinement.reviewed.snapshot').read_bytes()==raw"),
 ("assert old_variation,'Draft changed before review freeze; preserve review and request a fresh comparison.'",
  "assert not old_variation and b'target_interior_nonempty' in raw and b'next physical lookup is absent' in raw"),
 ("'review':ref(D/'REVIEW.md'),","'original_review':ref(D/'REVIEW.md'),'review':ref(D/'UPDATE.md'),"),
 ("'draft_variation_boundary_counterexample':'incoming 1, after CFL-one shift 2; internal/boundary weighting mismatch',",
  "'draft_variation_boundary_counterexample':'resolved in newer snapshot; once-per-edge weighting; no full quality proof inferred',"),
 ("'selected_pins':len(before),","'selected_pins':len(before),'original_freeze_exit_code':1,'draft_changes_independently_reread':True,")]
for a,b in changes:
 assert a in s;s=s.replace(a,b)
with (D/'freeze-v2.py').open('x',encoding='utf-8',newline='') as f:f.write(s)
