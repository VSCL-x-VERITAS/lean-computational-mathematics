from pathlib import Path
import hashlib,json,ast
P=Path(__file__).resolve().parent
old=(P/'run-defs-v5.py').read_bytes()
text=old.decode().replace("'defs-setup-05'","'defs-setup-06'")
needle="setup={'name':'Mathlib.Analysis.Calculus.ContDiff.Defs','isModule':True,"
assert text.count(needle)==1
text=text.replace(needle,needle+"\n       'dynlibs':[],'plugins':[],'options':{},'imports':None,'package':None,")
ast.parse(text)
with (P/'run-defs-v6.py').open('xb') as f:f.write(text.encode())
with (P/'defs-v6-derivation.json').open('xb') as f:
    f.write((json.dumps({'original_sha256':hashlib.sha256(old).hexdigest(),
      'successor_sha256':hashlib.sha256(text.encode()).hexdigest(),
      'changes':['Fresh output directory','Explicit JSON defaults required by Lean ModuleSetup parser; imports remains null so original source header controls imports.'],
      'prior_actual_failure':'setup parser rejected missing dynlibs array before imports/elaboration; no positive compile was attempted.'},indent=2)+'\n').encode())
