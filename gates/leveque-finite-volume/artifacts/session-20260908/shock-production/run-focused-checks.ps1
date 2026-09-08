$ErrorActionPreference = 'Stop'
$directory = 'gates/leveque-finite-volume/artifacts/session-20260908/shock-production'
$modules = Get-Content -LiteralPath "$directory/modules.json" -Raw | ConvertFrom-Json
$records = @()
$index = 0
foreach ($module in $modules) {
  $index += 1
  $path = $module.Replace('.', '/') + '.lean'
  $outputName = 'module-' + $index.ToString('00') + '-elaboration.txt'
  & lake env lean $path 2>&1 | Tee-Object -FilePath "$directory/$outputName"
  $compileExit = $LASTEXITCODE
  $records += [ordered]@{command="lake env lean $path";exit_code=$compileExit;output=$outputName}
  $records | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath "$directory/focused-exits.json" -Encoding utf8
  Write-Output "Focused module $index exited $compileExit : $module"
  if ($compileExit -ne 0) { exit $compileExit }
}
$checkPath = "$directory/Declarations.lean"
& lake env lean $checkPath 2>&1 | Tee-Object -FilePath "$directory/declarations-output.txt"
$compileExit = $LASTEXITCODE
[ordered]@{command="lake env lean $checkPath";exit_code=$compileExit;output='declarations-output.txt'} |
  ConvertTo-Json | Set-Content -LiteralPath "$directory/declarations-exit.json" -Encoding utf8
exit $compileExit
