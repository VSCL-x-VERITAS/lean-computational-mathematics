"""Close the exact independently accepted equation (1.10) interpretation."""
from pathlib import Path
import hashlib,importlib.util,json,os,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
adapter=S/'bind-equation10-interpreted-proved-row.py'
assert sha(adapter)=='f30c1703dc968d8aacff63c4c152202c164e46c867ba494058095f797435b594'
taskpath=S/'audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/audit-task.json'
task=read(taskpath);manifest=read(R/task['audit_output']/'manifest.json')
config=S/'audit-equation10-interpreted-rectangle.config.json'
assert sha(config)=='f15d2e876b6ca63c38f70ded24431f948a9e1dd9ad1298902e3eaf531ded8340'
assert any(x['path']==config.relative_to(R).as_posix() and x['sha256']==sha(config) for x in manifest['audit_setup'])
proof=S/'definition-repairs-production-inputs.json'
assert sha(proof)=='8789c90061b970c3a4160dd00574dac41d3a0f0957d3c6f51f224e0bab59d0aa'
log=S/'definition-repairs-production-declarations-output.txt';receipt=S/'definition-repairs-production-declarations-exit.json'
assert read(receipt)['exit_code']==0 and read(receipt)['output_sha256']==sha(log)
command=[sys.executable,'-B',str(adapter),'--gate-checker',sys.argv[1],'--gate',str(R/'gates/leveque-finite-volume/chapter-01.json'),
 '--task',str(taskpath),'--row','LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION',
 '--resolution-log',str(log),'--resolution-exit',str(receipt),'--resolution-manifest',str(proof),
 '--check-file',str(S/'definition-repairs-production-checks.lean'),
 '--interpretation',str(S/'user-discontinuity-interpretation-20260908.json'),
 '--interpretation-sha256','b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030']
raise SystemExit(subprocess.run(command,cwd=R,env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG=str(config))).returncode)
