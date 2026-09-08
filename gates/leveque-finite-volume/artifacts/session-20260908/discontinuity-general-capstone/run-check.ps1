param([string]$Label, [string]$CheckFile = 'candidate.lean')
$ErrorActionPreference = 'Stop'
$taskDirectory = $PSScriptRoot
$repoDirectory = (Resolve-Path (Join-Path $taskDirectory '../../../../..')).Path
$leanPath = Join-Path $taskDirectory $CheckFile
$stdoutPath = Join-Path $taskDirectory ($Label + '.stdout.txt')
$stderrPath = Join-Path $taskDirectory ($Label + '.stderr.txt')
$lakeExecutable = (Get-Command lake).Source
$arguments = @('env', 'lean', ('"' + $leanPath + '"'))
$process = Start-Process -FilePath $lakeExecutable -ArgumentList $arguments -WorkingDirectory $repoDirectory -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
$receipt = [ordered]@{
  executable = $lakeExecutable
  arguments = $arguments
  working_directory = $repoDirectory
  exit_code = $process.ExitCode
  check_file = $leanPath
  check_file_sha256 = (Get-FileHash -LiteralPath $leanPath -Algorithm SHA256).Hash.ToLowerInvariant()
  stdout_sha256 = (Get-FileHash -LiteralPath $stdoutPath -Algorithm SHA256).Hash.ToLowerInvariant()
  stderr_sha256 = (Get-FileHash -LiteralPath $stderrPath -Algorithm SHA256).Hash.ToLowerInvariant()
}
[System.IO.File]::WriteAllText((Join-Path $taskDirectory ($Label + '.exit.json')), ($receipt | ConvertTo-Json -Depth 6) + "`n", [System.Text.UTF8Encoding]::new($false))
Get-Content -LiteralPath $stdoutPath
Get-Content -LiteralPath $stderrPath
exit $process.ExitCode
