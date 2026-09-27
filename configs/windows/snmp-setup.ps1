# Windows Server - supplementary SNMP target setup
# Run as Administrator

# Install the SNMP Windows feature
Install-WindowsFeature -Name SNMP-Service

# Add the read-only community (lab-only, not a production secret)
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" `
  -Name "SNMPLab" -PropertyType Dword -Value 4

# Restrict SNMP to accept requests only from the Ubuntu monitoring server
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" `
  -Name "2" -PropertyType String -Value "192.168.50.2"

Restart-Service SNMP

# Allow inbound SNMP (UDP 161) from the Ubuntu monitoring server only
New-NetFirewallRule -DisplayName "SNMP Lab UDP 161" -Direction Inbound -Protocol UDP `
  -LocalPort 161 -RemoteAddress 192.168.50.2 -Action Allow
