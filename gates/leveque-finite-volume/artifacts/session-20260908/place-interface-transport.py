"""Place the six reviewed canonical drafts after their organization checkpoint."""
from pathlib import Path
import hashlib, json, subprocess
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda data: hashlib.sha256(data).hexdigest()
head = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'rev-parse', 'HEAD'], cwd=R, text=True).strip()
assert head != 'f18f2f7dc39568971d2dc80b841271e0464c7571'
report_path = (S / 'production-organized-increment.md').relative_to(R).as_posix()
assert subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', 'HEAD:' + report_path], cwd=R) == (R / report_path).read_bytes()
source_records = []
for item in json.loads((S / 'rectangle-riemann-interface/canonical-drafts-manifest.json').read_text()):
    source_records.append({'path': item['canonical_path'],
        'draft': 'rectangle-riemann-interface/' + item['draft_path'].replace('\\', '/'),
        'sha256': item['sha256'], 'declarations': item['declarations']})
source_records.extend(json.loads((S / 'equation03-transport/canonical-drafts-manifest.json').read_text())['files'])
assert len(source_records) == 6
for item in source_records:
    assert not (R / item['path']).exists(), item['path']
    assert sha((S / item['draft']).read_bytes()) == item['sha256'], item['draft']
for item in source_records:
    target = R / item['path']
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes((S / item['draft']).read_bytes())
modules = [item['path'][:-5].replace('/', '.') for item in source_records]
decls = [d for item in source_records for d in item['declarations']]
assert len(decls) == len(set(decls)) == 19
check = '\n'.join('import ' + m for m in modules) + '\n\n'
check += '\n'.join('#check ' + d + '\n#print axioms ' + d for d in decls) + '\n'
check_path = S / 'interface-transport-production-checks.lean'
check_path.write_text(check, encoding='utf-8', newline='\n')
record = {'schema': 1, 'prior_organization_commit': head, 'files': source_records,
    'check_file_sha256': sha(check_path.read_bytes()), 'declaration_count': len(decls),
    'build_modules': modules, 'validation': 'pending exact native canonical build and checks'}
(S / 'interface-transport-production-inputs.json').write_text(json.dumps(record, indent=2)+'\n')
relative = S.relative_to(R).as_posix()
ps = "$ErrorActionPreference = 'Stop'\n"
build = 'lake build ' + ' '.join(modules)
ps += '& ' + build + ' 2>&1 | Tee-Object -FilePath \'' + relative + "/interface-transport-production-build-output.txt'\n"
ps += '$checkExit = $LASTEXITCODE\n'
ps += "[ordered]@{command='" + build + "';exit_code=$checkExit} | ConvertTo-Json | Set-Content -LiteralPath '" + relative + "/interface-transport-production-build-exit.json' -Encoding utf8\n"
ps += 'if ($checkExit -ne 0) { exit $checkExit }\n'
command = 'lake env lean ' + check_path.relative_to(R).as_posix()
ps += '& ' + command + ' 2>&1 | Tee-Object -FilePath \'' + relative + "/interface-transport-production-checks-output.txt'\n"
ps += '$checkExit = $LASTEXITCODE\n'
ps += "[ordered]@{command='" + command + "';exit_code=$checkExit} | ConvertTo-Json | Set-Content -LiteralPath '" + relative + "/interface-transport-production-checks-exit.json' -Encoding utf8\n"
ps += 'exit $checkExit\n'
(S / 'run-interface-transport-production-checks.ps1').write_text(ps, encoding='utf-8', newline='\n')
print(json.dumps({'placed_files': len(source_records), 'declarations': len(decls), 'prior_organization_commit': head}))
