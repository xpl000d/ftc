##Install Azure module 
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force


#Deploy Linux VM - Ubuntu 18.08 with Docker CE for Mstunnel deployment
# Sign in to your Azure subscription
$sub = Get-AzSubscription -ErrorAction SilentlyContinue
if(-not($sub))
{
    Connect-AzAccount
}

# If you have multiple subscriptions, set the one to use
#Select-AzSubscription -SubscriptionId "SUBSCRIPTIONID"

#Create Azure Resource Group for MSTunnel 
$resourceGroupName = "FTCMStunnel"
$location = "NorthEurope"

New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri "https://raw.githubusercontent.com/xpl000d/ftc/main/Ubuntu_dock.json"

#Create NSG rules to allow TCP/UDP Inbound/Outbound traffic to the VM 
Get-AzNetworkSecurityGroup -Name "FTC-NSG" -ResourceGroupName "FTCmstunnel" | Add-AzNetworkSecurityRuleConfig -Name "Allow-TCP-443" -Description "Allow-TCP-443" -Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority 100 -SourceAddressPrefix "*" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "443" | Set-AzNetworkSecurityGroup
Get-AzNetworkSecurityGroup -Name "FTC-NSG" -ResourceGroupName "FTCmstunnel" | Add-AzNetworkSecurityRuleConfig -Name "Allow-UDP-443" -Description "Allow-UDP-443" -Access "Allow" -Protocol "UDP" -Direction "Inbound" -Priority 101 -SourceAddressPrefix "*" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "443" | Set-AzNetworkSecurityGroup
Get-AzNetworkSecurityGroup -Name "FTC-NSG" -ResourceGroupName "FTCmstunnel" | Add-AzNetworkSecurityRuleConfig -Name "Allow-TCP-Outbound-443" -Description "Allow-TCP-443" -Access "Allow" -Protocol "Tcp" -Direction "Outbound" -Priority 102 -SourceAddressPrefix "*" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "443" | Set-AzNetworkSecurityGroup





