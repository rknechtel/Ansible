<#
.SYNOPSIS
  Does Base64 Encoding/Decoding
  
.DESCRIPTION
  This script will Enable TLS 1.2 on a Windows System for use with Ansible

	
.INPUTS Function
.INPUTS NONE

  
.OUTPUTS
  This script will Enable TLS 1.2 on a Windows System for use with Ansible
  
.NOTES
  Script Name: EnableTLS12.ps1
  Version:        1.0
  Author:         Richard Knechtel
  Creation Date:  02/13/2021
  Purpose/Change: Initial script development

.LICENSE
 This script is in the public domain, free from copyrights or restrictions.
  
.EXAMPLE
  Run in Admin PowerShell:
  .\EnableTLS12.ps1

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------
# NONE

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = '1.0'


#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Enable-TLS12 {
    param(
        [ValidateSet("Server", "Client")]
        [String]$Component = "Server"
    )

    $protocols_path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
    New-Item -Path "$protocols_path\TLS 1.2\$Component" -Force
    New-ItemProperty -Path "$protocols_path\TLS 1.2\$Component" -Name Enabled -Value 1 -Type DWORD -Force
    New-ItemProperty -Path "$protocols_path\TLS 1.2\$Component" -Name DisabledByDefault -Value 0 -Type DWORD -Force
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

try 
{
  Enable-TLS12 -Component Server

  # Not required but highly recommended to enable the Client side TLS 1.2 components
  Enable-TLS12 -Component Client

  Restart-Computer

)
catch
{
  # Catch any errors and report them
  $ErrorMessage = $_.Exception.Message;
  $FailedItem = $_.Exception.ItemName;
  Write-Host "Error in EnableTLS12: $ErrorMessage";

}
finally
{

}

