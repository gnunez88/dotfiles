oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/paradox.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine
Set-PSReadLineOption -EditMode vi -BellStyle None
