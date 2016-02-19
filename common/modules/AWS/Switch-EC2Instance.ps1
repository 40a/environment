function Switch-EC2Instance
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        # Справочное описание параметра 1
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $RunningInstance,

        # Справочное описание параметра 1
        [Parameter(Mandatory=$true,
                   Position=1)]
        [ValidateSet("running", "stopped")]
        [string]$State,

        # Справочное описание параметра 1
        [Parameter(Mandatory=$true)]
        [string]$Key,

        # Справочное описание параметра 1
        [Parameter(Mandatory=$true)]
        [string[]]$Value


    )

    Begin
    {
    }
    Process
    {
        #Write-Verbose $RunningInstance.state.name
        if ($RunningInstance.state.name -eq $State) {
            $RunningInstance.Tags | ForEach-Object { 
                if ($_.Key -eq $Key ) {
                    if ($Value -contains $_.Value ) { $RunningInstance }
                } 
            }
        }
    }
    End
    {
    }
}


$i = Get-EC2Instance

"x"
$i | Switch-EC2Instance -state running -Key test -Value "X"| select KeyName, InstanceID
"y"
$i | Switch-EC2Instance -state running -Key test -Value "y"| select KeyName, InstanceID
"x,y"
$i | Switch-EC2Instance -state running -Key test -Value x,Y | select KeyName, InstanceID

#Get-EC2Instance | Switch-EC2Instance -state running -Key test -Value x | Stop-EC2Instance -Confirm
"stopped"
$i | Switch-EC2Instance -state stopped -Key NextReviewDate -Value 20141201 | select KeyName, InstanceID

Get-ec2instance -Filter @{Name = 'tag:NextReviewDate'; Values = '20141201'} | ft