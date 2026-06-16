# ===============================
# vCenter VM Inventory Script
# ===============================

# Stop on errors
$ErrorActionPreference = "Stop"

# vCenter details (passed from Jenkins or hardcoded for testing)
$vcServer = $env:VC_SERVER
$vcUser   = $env:VC_USER
$vcPass   = $env:VC_PASS

# If environment variables not used, fallback (optional)
if (-not $vcServer) { $vcServer = "vcenter.local" }

Write-Host "Connecting to vCenter: $vcServer"

# Ignore invalid certs (lab environment)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false | Out-Null

# Import VMware module
Import-Module VMware.PowerCLI

# Connect to vCenter
Connect-VIServer -Server $vcServer -User $vcUser -Password $vcPass

# Get VM inventory
$vmList = Get-VM | Select-Object `
    Name,
    PowerState,
    NumCpu,
    MemoryGB,
    VMHost,
    Version

# Output file
$outputFile = "vcenter_vm_list.csv"

# Export to CSV
$vmList | Export-Csv -Path $outputFile -NoTypeInformation -Force

Write-Host "VM Inventory exported to $outputFile"

# Disconnect session
Disconnect-VIServer -Server $vcServer -Confirm:$false

Write-Host "Completed successfully"
