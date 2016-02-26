Get-Date
# | Out-File c:\scripts\log.txt
$i = $input | ConvertFrom-JSON
$c = $i.Count
"$c items read"
if ($c -eq 0)
{ "Void" }
else
{ 
    iex (irm  "http://localhost:8500/v1/kv/infra/skynet/bootstrap?raw&token=$env:CONSUL_TOKEN") 
}

$uri = gc c:\scripts\slack.txt
$msg = "$env:COMPUTERNAME : $(irm http://169.254.169.254/latest/meta-data/hostname)"
if ($uri ) { irm -Body $msg -Method post -Uri $uri }
return 0
#test 4