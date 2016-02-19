#Requires -Version 3.0

$VerbosePreferenceOri = $VerbosePreference
$VerbosePreference = 'Continue'

Import-Module AWSPowerShell -ErrorAction SilentlyContinue
if (!$?) {
    
    while (-not (Get-Command Install-Module -ErrorAction SilentlyContinue) )
    {
        Write-Verbose "Need to install PowerShellGet first!"
        Read-Host -Prompt "Press Enter to Continue, Ctrl-C to exit" 
        
        
        $x86 = 'https://download.microsoft.com/download/4/1/A/41A369FA-AA36-4EE9-845B-20BCC1691FC5/PackageManagement_x86.msi'
        $x64 = 'https://download.microsoft.com/download/4/1/A/41A369FA-AA36-4EE9-845B-20BCC1691FC5/PackageManagement_x64.msi'
    
        switch ($env:PROCESSOR_ARCHITECTURE)
        {
            'x86' {$version = $x86}
            'AMD64' {$version = $x64}
        }
    
        
        if ((ls $env:TEMP\$Filename -ErrorAction SilentlyContinue).Length -ne 651264)
        {
    
            Write-Verbose "Downloading..."
        
            $Request = [System.Net.WebRequest]::Create($version)
            $Request.Timeout = "100000000"
            $URL = $Request.GetResponse()
            $Filename = $URL.ResponseUri.OriginalString.Split("/")[-1]
            $url.close()
            $WC = New-Object System.Net.WebClient
            $WC.DownloadFile($version,"$env:TEMP\$Filename")
            $WC.Dispose()
            
            Write-Verbose "Installing..."
            msiexec.exe /package "$env:TEMP\$Filename"
            
            Start-Sleep 5
        }
        "Waiting..."
        Remove-Item "$env:TEMP\$Filename" -ErrorAction SilentlyContinue
    }
    
    Install-Module AWSPowerShell -Force; 
    Import-Module AWSPowerShell
    
    
}


if ($env:AWSACCESSKEY)  { $AccessKey = $env:AWSACCESSKEY } else { $AccessKey = Read-Host -Prompt "Enter AccessKey: " }
if ($env:AWSSECRETKEY)  { $SecretKey = $env:AWSSECRETKEY } else { $SecretKey = Read-Host -Prompt "Enter SecretKey: " }
Set-AWSCredentials -AccessKey $AccessKey -SecretKey $SecretKey -StoreAs AWSProfile
Initialize-AWSDefaults -ProfileName AWSProfile -Region us-west-2
$VerbosePreference = $VerbosePreferenceOri