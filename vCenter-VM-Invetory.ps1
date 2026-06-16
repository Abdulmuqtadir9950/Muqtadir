$ErrorActionPreference = 'Stop'

Write-Host "=== Starting PowerCLI Script ==="

Import-Module VMware.VimAutomation.Core -Force

Set-PowerCLIConfiguration -Scope User -InvalidCertificateAction Ignore -Confirm:$false | Out-Null
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null

Write-Host "Connecting to vCenter..."

$securePass = ConvertTo-SecureString $env:VC_PASS -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($env:VC_USER, $securePass)

Connect-VIServer -Server $env:VC_SERVER -Credential $cred

Write-Host "Fetching VM list..."

$vms = Get-VM | Select-Object Name, PowerState, NumCpu, MemoryGB

$vms | Export-Csv -Path "$env:WORKSPACE/vcenter_vm_list.csv" -NoTypeInformation

Disconnect-VIServer * -Confirm:$false

Write-Host "DONE - CSV generated"
