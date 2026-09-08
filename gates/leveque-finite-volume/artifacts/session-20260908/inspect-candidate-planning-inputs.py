"""Inspect current candidate-planning inputs without asserting an epoch."""
from pathlib import Path
import json,subprocess,hashlib
S=Path(__file__).resolve().parent;R=S.parents[3]
G=json.loads((S/'architecture-graphs/checkpoint-eed529aaf.json').read_bytes())
print(json.dumps({'graph_top_keys':list(G),'types':{k:type(v).__name__ for k,v in G.items()}},indent=2))
for key in ['modules','declarations','declaration_graph','source_files']:
 if key in G:
  v=G[key]
  print(json.dumps({'key':key,'sample':(v[:1] if isinstance(v,list) else list(v.items())[:1])},indent=2)[:10000])

