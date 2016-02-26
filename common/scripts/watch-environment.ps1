$i = $input | ConvertFrom-JSON
$c = $i.Count
"$c items read"
if (Test-Path c:\scripts\watch-lock.txt) {return 0}
Get-Date | Out-File c:\scripts\watch-lock.txt -Force
if ($c -eq 0)
{ "Void" }
else
{ 
    iex (irm  "http://localhost:8500/v1/kv/infra/skynet/bootstrap?raw&token=$env:CONSUL_TOKEN") 
}

$uri = gc c:\scripts\slack.txt
$msg = ">>> $(Get-Date) : $env:COMPUTERNAME : $(irm http://169.254.169.254/latest/meta-data/hostname)"
if ($uri ) { irm -Body $msg -Method post -Uri $uri }
sleep 5
Remove-Item c:\scripts\watch-lock.txt -Force
return 0
#test 8