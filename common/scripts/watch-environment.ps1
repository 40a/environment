Get-Date
$i = $input | ConvertFrom-JSON
$c = $i.Count
"$c items read"
if ($c -eq 0)
{ "Void" }
else
{ 
	iex (irm  "http://localhost:8500/v1/kv/infra/skynet/bootstrap?raw&token=$env:CONSUL_TOKEN") 
}
