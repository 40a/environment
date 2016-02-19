#Get-Module AWSPowerShell -ListAvailable

#Set-AWSCredentials -StoredCredentials AWSProfile
#Set-DefaultAWSRegion us-west-2
$VerbosePreference = 'Continue'

$i = Get-AWSRegion | %{Write-Progress -PercentComplete -1 -Activity "Serching region $_"; Get-EC2Instance -Region $_}
Write-Progress -Completed -Activity *
$t = $i | Where-Object {$_.RunningInstance.state.Name -eq 'running'} | select -ExpandProperty RunningInstance | select -ExpandProperty Tags

$filters = $t | select @{ Expression = { "$($_.Key): $($_.Value)" }; Label ="Tag"} , @{ Expression ={$_}; Label = "Hash"}  -unique | select -ExpandProperty Hash | sort Key | ogv -PassThru -Title "Select tags to proceed:"

if ($filters)
{ 
    $list = @()

    foreach ($filter in $filters) {
        $list += $i | Where-Object {$_.RunningInstance.Tags.Key -contains $filter.Key -and $_.RunningInstance.Tags.Value -contains $filter.Value}
    }
     
    if ($list.Count -gt 0) 
    {
        "You have selected:"
        $list.RunningInstance.KeyName | select -Unique
        
        $InstanceID = $list.RunningInstance.InstanceID | select -Unique
        $result = $InstanceID | Stop-EC2Instance -Confirm -Verbose
        if ($result)
        {
            $result | ForEach-Object { Write-Verbose ($_.InstanceId.ToString() + ' was: ' + $_.PreviousState.Name + ' now: ' + $_.CurrentState.Name)  }
        }
        else
        {
            Write-Verbose "$InstanceID : operation skipped"
        }
    
    }
    else
    {
        Write-Error "instances not found"
    }
}
else
{
    Write-Verbose "filters skipped"
}
