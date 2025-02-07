$env:RUBY_DLL_PATH = Get-Location
Write-Output "RUBY_DLL_PATH set to $env:RUBY_DLL_PATH"
ruby main.rb