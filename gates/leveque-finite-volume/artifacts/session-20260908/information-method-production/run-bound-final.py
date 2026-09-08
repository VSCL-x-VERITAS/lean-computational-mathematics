"""One final native check with exact local source/olean dependency pre/post binding."""
from pathlib import Path
from hashlib import sha256
import datetime, json, subprocess, sys, time

here = Path(__file__).resolve().parent
repo = here.parents[4]
digest = lambda p: sha256(p.read_bytes()).hexdigest()
mapping = json.loads((here/'placement-map.json').read_bytes())
provenance = json.loads((here/'dependency-provenance.json').read_bytes())
previous = json.loads((here/'comparisons-02.receipt.json').read_bytes())
assert previous['exit_code'] == 0 and previous['inputs_unchanged']
source, output, receipt = [here/('final-check-01'+suffix) for suffix in ['.lean','.output.txt','.receipt.json']]
assert not any(p.exists() for p in [source, output, receipt])
checks = '\n'.join(f"#check {row['canonical']}\n#print axioms {row['canonical']}" for row in mapping['declaration_map'])+'\n'
source.write_bytes((here/'comparisons-02.lean').read_bytes()+b'\n'+checks.encode())
paths = [source, Path(__file__).resolve(), here/'dependency-provenance.json', here/'placement-map.json',
         here/'comparisons-02.receipt.json', repo/'lean-toolchain', repo/'lake-manifest.json']
for family in ['local_import_closure','direct_mathlib_imports']:
    for entry in provenance[family].values():
        for key in ['source','olean']:
            p = Path(entry[key]['path'])
            assert digest(p) == entry[key]['sha256'], p
            paths.append(p)
before = {str(p):digest(p) for p in paths}
command = ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', str(source)]
started,tick = datetime.datetime.now(datetime.timezone.utc).isoformat(),time.monotonic()
run = subprocess.run(command,cwd=repo,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
output.write_bytes(run.stdout)
result = dict(command=command,cwd=str(repo),started_utc=started,elapsed_seconds=round(time.monotonic()-tick,3),
              exit_code=run.returncode,inputs=before,inputs_unchanged=all(digest(Path(p))==h for p,h in before.items()),
              output=str(output),output_sha256=digest(output),source=str(source),
              expected_canonical_reports=24,expected_frozen_draft_reports=29,expected_comparison_reports=52,
              scope='Native placement verification only; no source acceptance or audit role.')
receipt.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(dict(receipt=str(receipt),sha256=digest(receipt),exit_code=run.returncode)),flush=True)
if run.returncode: sys.stdout.buffer.write(run.stdout)
sys.exit(run.returncode)
