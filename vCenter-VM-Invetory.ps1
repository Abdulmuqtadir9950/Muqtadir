$ErrorActionPreference = "Stop"

Write-Host "=== VM Inventory Start ==="

Import-Module VMware.VimAutomation.Core -Force

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false | Out-Null
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null

Write-Host "Connecting to vCenter: $env:VC_SERVER"

$securePass = ConvertTo-SecureString $env:VC_PASS -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($env:VC_USER, $securePass)

Connect-VIServer -Server $env:VC_SERVER -Credential $cred

$vms = Get-VM | Select Name, PowerState, NumCpu, MemoryGB

$vms | Export-Csv "$env:WORKSPACE/vcenter_vm_list.csv" -NoTypeInformation

Disconnect-VIServer * -Confirm:$false

Write-Host "DONE"
