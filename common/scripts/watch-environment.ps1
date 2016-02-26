$i = $input | ConvertFrom-JSON
$c = $i.Count
"$c items read"
#if (Test-Path c:\scripts\watch-lock.txt) {return 0}
#Get-Date | Out-File c:\scripts\watch-lock.txt -Force
$diff = (Get-Date).Ticks - [int64](gc C:\Scripts\watch-last.txt -ea SilentlyContinue)
if ($c -eq 0)
{ "Void" }
else
{ 
    iex (irm  "http://localhost:8500/v1/kv/infra/skynet/bootstrap?raw&token=$env:CONSUL_TOKEN") 
}

$uri = gc c:\scripts\slack.txt
$msg = ">>> $(Get-Date) : $env:COMPUTERNAME : $(irm http://169.254.169.254/latest/meta-data/hostname) : $diff"
if ($uri ) { irm -Body $msg -Method post -Uri $uri }
#Remove-Item c:\scripts\watch-lock.txt -Force
(Get-Date).Ticks | Out-File -LiteralPath C:\Scripts\watch-last.txt -Force
return 0
#test 9