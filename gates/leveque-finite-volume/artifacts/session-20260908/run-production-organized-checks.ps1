$ErrorActionPreference = 'Stop'
$directory = 'gates/leveque-finite-volume/artifacts/session-20260908'
& lake build ComputationalMathematics.Source.LeVeque.Chapter01 NumStability.Source.LeVeque.Chapter01 2>&1 | Tee-Object -FilePath "$directory/production-organized-build-output.txt"
$buildExit = $LASTEXITCODE
[ordered]@{command='lake build ComputationalMathematics.Source.LeVeque.Chapter01 NumStability.Source.LeVeque.Chapter01';exit_code=$buildExit} | ConvertTo-Json | Set-Content -LiteralPath "$directory/production-organized-build-exit.json" -Encoding utf8
if ($buildExit -ne 0) { exit $buildExit }
& lake env lean "$directory/production-organized-declarations.lean" 2>&1 | Tee-Object -FilePath "$directory/production-organized-declarations-output.txt"
$checkExit = $LASTEXITCODE
[ordered]@{command='lake env lean gates/leveque-finite-volume/artifacts/session-20260908/production-organized-declarations.lean';exit_code=$checkExit} | ConvertTo-Json | Set-Content -LiteralPath "$directory/production-organized-declarations-exit.json" -Encoding utf8
exit $checkExit
