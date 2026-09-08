"""Preserve frozen diagnostic bytes and distinguish their framing from live-source hygiene."""
from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve();A=P.parent.parent;R=A.parents[4]
sha=lambda b:hashlib.sha256(b).hexdigest()
def run(*args):return subprocess.run(['git','-c','core.longpaths=true',*args],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
def good(*args):
 v=run(*args);assert v.returncode==0,(args,v.returncode,v.stderr.decode(errors='replace'));return v.stdout
old=json.loads((A/'staged-verification.json').read_bytes())
for v in old['files']:assert sha(good('show',':'+v['path']))==v['staged_sha256']
bad=run('diff','--cached','--check');assert bad.returncode==2
with (A/'default-whitespace-check-output.txt').open('xb') as f:f.write(bad.stdout+bad.stderr)
lines=bad.stdout.decode('utf-8').splitlines();diagnostics=[l for l in lines if ': trailing whitespace.' in l or ': new blank line at EOF.' in l]
assert diagnostics and all(l.startswith(A.relative_to(R).as_posix()+'/') for l in diagnostics)
# Verify reported trailing whitespace is solely a CR in preserved CRLF, not a hidden text edit.
for line in diagnostics:
 if line.endswith(': trailing whitespace.'):
  loc=line[:-len(': trailing whitespace.')];file,number=loc.rsplit(':',1)
  raw=(R/file).read_bytes().split(b'\n')[int(number)-1]
  assert raw.endswith(b'\r') and raw[:-1]==raw[:-1].rstrip(b' \t'),line
outside=run('diff','--cached','--check','--','.',':(exclude)'+A.relative_to(R).as_posix()+'/**');assert outside.returncode==0
# Per-command framing interpretation for archived Windows bytes; no config/attributes are changed.
framed=run('-c','core.whitespace=blank-at-eol,space-before-tab,cr-at-eol,-blank-at-eof','diff','--cached','--check');assert framed.returncode==0
ledger=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
before=ledger.read_bytes();assert b'LEV-SKILL-ARCHIVE-WHITESPACE-069' not in before
row='| LEV-SKILL-ARCHIVE-WHITESPACE-069 | codex-start-1-v5-0-1-20260908 | recurrence evidence staging postcheck | Default git diff --check flagged preserved Windows CRLF receipt bytes and terminal blank lines in frozen diagnostic scripts after every selected blob was verified | Preserve raw failure and all hashed input bytes; verify every warning is confined to archive framing, run default check outside archive and a one-command CRLF/archive framing check | resolved without changing frozen evidence | recover-staging.py records actual default exit 2 and both bounded checks exit 0; no Git config or attributes changed | This is diagnostic byte preservation, not a Lean source whitespace exemption. Initial staged-verification.json remains an exact historic blob receipt; final recovery verifies all newly staged bytes separately. |'
newline=b'\r\n' if b'\r\n' in before else b'\n'
with ledger.open('ab') as f:f.write((b'' if before.endswith(b'\n') else newline)+row.encode()+newline)
rec={'kind':'frozen-diagnostic-whitespace-framing-review','default_check_exit':bad.returncode,'default_output_sha256':sha(bad.stdout+bad.stderr),'diagnostic_count':len(diagnostics),'diagnostics':diagnostics,'outside_archive_default_check_exit':outside.returncode,'archive_framing_check_exit':framed.returncode,'git_config_or_attributes_changed':False,'frozen_bytes_changed':False,'ledger_before_sha256':sha(before),'ledger_after_sha256':sha(ledger.read_bytes()),'appended_issue':'LEV-SKILL-ARCHIVE-WHITESPACE-069'}
with (A/'whitespace-framing-recovery.json').open('xb') as f:f.write((json.dumps(rec,indent=2)+'\n').encode())
files=sorted(p for p in A.rglob('*') if p.is_file())+[ledger];records=[]
for p in files:
 raw=p.read_bytes();expected=raw.replace(b'\r\n',b'\n') if p==ledger else raw
 records.append({'path':p.relative_to(R).as_posix(),'worktree_sha256':sha(raw),'staged_sha256':sha(expected)})
for off in range(0,len(records),40):good('add','--',*[v['path'] for v in records[off:off+40]])
actual=set(good('diff','--cached','--name-only','-z','--no-renames').decode().strip('\x00').split('\x00'));assert actual=={v['path'] for v in records}
for v in records:assert sha(good('show',':'+v['path']))==v['staged_sha256']
result={'kind':'complete-recurrence-staging-recovery','files':records,'count':len(records),'scope':'Only recurrence diagnostic archive and Process068-069; all frozen originals unchanged.'}
out=A/'recovered-staged-verification.json';data=(json.dumps(result,indent=2)+'\n').encode()
with out.open('xb') as f:f.write(data)
good('add','--',out.relative_to(R).as_posix());assert good('show',':'+out.relative_to(R).as_posix())==data
good('-c','core.whitespace=blank-at-eol,space-before-tab,cr-at-eol,-blank-at-eof','diff','--cached','--check')
print(json.dumps({'status':'STAGING_RECOVERED','files':len(records)+1,'default_frozen_framing_warning_count':len(diagnostics),'receipt_sha256':sha(data)}))
