"""Bind the actual root-released sorted outputs; preserve the pending packet."""
from pathlib import Path
import hashlib
import json

P=Path(__file__).resolve().parent
R=P.parents[5]
S=P.parent.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
x=json.loads((P/'ready-inputs.pending.json').read_bytes())
x['status']='ACTUAL_INPUTS_ROOT_RELEASED_FOR_CAPTURE_DRAFT'
x['root_release_text']='Root releases actual sorted inputs for readonly organization capture/draft now. Finalsortedlayout0 S/unblock-nine-final-sorted-layout-exit.json elapsed302870/outputbb17b8f0ad20c12432902bcb11646bc82a67b5fff8ccfc2fc9059bb8cc6e37c9. Finalsortedgraph0 S/unblock-nine-final-sorted-source-graphs-exit.json elapsed166300/output962497ee2608947a1706c8ef668c8aeca08daa9d2cccbcb15a42869d577a1ad0 (two createdpaths,nonempty). ActualJSON architecture-graphs/unblock-nine-certified-high-resolution-sorted-source.json1f3166bd4e0a6e568d0da4b3e45c36877156ff64270aae1ea6aea5ae2e22b4e7;MD82450e6bda5aa55afe1a173439347b71f84f09425c5f7e3ed3ee08178308f89e. Root readentire prepare-config.py/run-phase.py and relevantunchangedsupport nofinding. Fillnewready-inputs exactpins, freezeconfig, execute prepare/capture/draft withactual0receipts. RootholdsGate/HEAD/source unchanged throughyourguardedruns; do notadoptmeasurementstatuses. Ifactualfailurepreserveandreportbeforeadditiverepair.'
for key,path,wanted in [
    ('layout_output',S/'unblock-nine-final-sorted-layout-output.txt','bb17b8f0ad20c12432902bcb11646bc82a67b5fff8ccfc2fc9059bb8cc6e37c9'),
    ('graph_output',S/'unblock-nine-final-sorted-source-graphs-output.txt','962497ee2608947a1706c8ef668c8aeca08daa9d2cccbcb15a42869d577a1ad0'),
    ('graph_json',S/'architecture-graphs/unblock-nine-certified-high-resolution-sorted-source.json','1f3166bd4e0a6e568d0da4b3e45c36877156ff64270aae1ea6aea5ae2e22b4e7'),
    ('graph_markdown',S/'architecture-graphs/unblock-nine-certified-high-resolution-sorted-source.md','82450e6bda5aa55afe1a173439347b71f84f09425c5f7e3ed3ee08178308f89e')]:
    assert sha(path)==wanted
    x[key]=pin(path)
for key,path,output,elapsed in [
    ('layout_receipt',S/'unblock-nine-final-sorted-layout-exit.json','layout_output',302870),
    ('graph_receipt',S/'unblock-nine-final-sorted-source-graphs-exit.json','graph_output',166300)]:
    receipt=json.loads(path.read_bytes())
    assert type(receipt['exit_code']) is int and receipt['exit_code']==0
    assert receipt['output_sha256']==x[output]['sha256'] and receipt['elapsed_ms']==elapsed
    x[key]=pin(path)
with (P/'ready-inputs.json').open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(x,indent=2)+'\n')
print(json.dumps({'ready_inputs':pin(P/'ready-inputs.json'),'status':x['status']}))
