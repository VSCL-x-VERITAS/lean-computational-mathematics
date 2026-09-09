from pathlib import Path
import datetime,hashlib,json
h=Path(__file__).resolve().parent
source=h/'freeze.py';target=h/'freeze_v2.py'
assert not target.exists()
old=source.read_text(encoding='utf-8')
a=" line=raw[apos:end].decode().strip()\n"
b=""" line=raw[apos:end].decode().strip()
 if 'depends on axioms: [' in line and not line.endswith(']'):
  close=raw.find(b']',apos);assert close>=apos
  newline=raw.find(b'\\n',close);end=len(raw) if newline<0 else newline+1
  line=' '.join(raw[apos:end].decode().split())
"""
assert old.count(a)==1
target.write_text(old.replace(a,b),encoding='utf-8')
(h/'freeze-v1-failure.json').write_text(json.dumps({
 'recorded_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'actual_parent_command_exit_code':1,'native_command_exit_code_unchanged':0,
 'observed_error':"AssertionError: 'SharedAccuracyCertificateDraft.Certificate.projected_input_exists' depends on axioms: [propext,",
 'cause':'Postprocessing assumed a single-line axiom report; native report legitimately wrapped.',
 'failed_helper':{'path':str(source),'sha256':hashlib.sha256(source.read_bytes()).hexdigest()},
 'successor':{'path':str(target),'sha256':hashlib.sha256(target.read_bytes()).hexdigest()},
 'change':'Read the exact axiom bracket through its closing bracket; normalize whitespace only for the allowed-name comparison. Preserve original byte type spans.',
 'native_proof_or_output_changed':False},indent=2)+'\n',encoding='utf-8')
