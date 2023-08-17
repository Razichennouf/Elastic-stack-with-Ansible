# Enable PowerShell remoting
Enable-PSRemoting -Force


# Configure WinRM Client (More secure block "client" auths)
	Set-Item -Path 'WSMan:\localhost\Client\Auth\Certificate' -Value $false
	Set-Item -Path 'WSMan:\localhost\Client\AllowUnencrypted' -Value $false
	Set-Item -Path 'WSMan:\localhost\Client\Auth\Basic' -Value $false
	Set-Item -Path 'WSMan:\localhost\Client\Auth\CredSSP' -Value $false
	Set-Item -Path 'WSMan:\localhost\Client\Auth\Kerberos' -Value $false
# Configure WinRM Service 
	Set-Item -Path 'WSMan:\localhost\Service\Auth\Certificate' -Value $false
	Set-Item -Path 'WSMan:\localhost\Service\AllowUnencrypted' -Value $false
	Set-Item -Path 'WSMan:\localhost\Service\Auth\Basic' -Value $true
	Set-Item -Path 'WSMan:\localhost\Service\Auth\CredSSP' -Value $true
	Set-Item -Path 'WSMan:\localhost\Service\Auth\Kerberos' -Value $false

# If you are using Basic authentication i.e. Local usernames , then you need to set it as True using the following commands in Powershell (As admin)
#winrm set winrm/config/client/auth '@{Basic="true"}'
#winrm set winrm/config/service/auth '@{Basic="true"}'

# If you are using the AWS and you have a fresh instance the password of the default user `Administrator` is generated temporarly with the private key
# So if you have a fresh instance we need to persist a new password securely
$environment = Read-Host "Are you using AWS? (Type 'yes' or 'no')"

if ($environment -eq "yes") {
	$Password = Read-Host "Enter the new password" -AsSecureString
	$UserAccount = Get-LocalUser -Name "Administrator"
	$UserAccount | Set-LocalUser -Password $Password
}
elseif ($environment -eq "no") {
	Write-Host "Check and persist a password with a no expiration date"
}
else {
    Write-Host "Invalid input. Please type 'yes' or 'no' to choose the environment."
}

# Set WinRM service startup type to automatic
Set-Service WinRM -StartupType 'Automatic'

# Create a firewall rule to allow WinRM HTTPS inbound
# AWS Security Group Management and enabling WinRM HTTPS for both IPv4 and IPv6
    Write-Host "1) Add AWS Security Group rules for WinRM HTTPS in 0.0.0.0 and ::/0  "
    # Enabling WinRM ports for both IPv4 and IPv6 using New-NetFirewallRule
    Write-Host "2) Enabling WinRM ports for both IPv4 and IPv6 on the local server..."
    New-NetFirewallRule -DisplayName "Allow WinRM HTTPS IPv4" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow
    # Later to fix we need to enable IPV6 because somme softwares needs IPV6 to work
	#New-NetFirewallRule -DisplayName "Allow WinRM HTTPS IPv6" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow -LocalAddress ::/0
    Write-Host "3) WinRM HTTPS ports enabled for both IPv4 and IPv6."



# Configure TrustedHosts
Write-Host "Trusting All Hosts..."
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

#Configuring user (For more security of the machines we will create a dedicated user for the automation JOB)
Write-Host "Setting up the automation User..."
function Get-SecurePassword {
    param (
        [string]$Prompt = "Enter a strong password for the user "
    )

    $ValidPassword = $false
    $securePassword = $null

    while (-not $ValidPassword) {
        $securePassword = Read-Host -AsSecureString -Prompt $Prompt

        # Check if the password meets the complexity requirements
        $isValidPassword = $securePassword | ConvertTo-SecureString -AsPlainText -Force
        if ($isValidPassword) {
            $ValidPassword = $true
        } else {
            Write-Host "Password does not meet the complexity requirements. Please try again."
        }
    }

    return $securePassword
}

# Get the desired username from the user
$username = Read-Host "Enter the username for the new automation user"

# Get a valid secure password
$password = Get-SecurePassword

# Create the new user
try {
    New-LocalUser -Name $username -Password $password -PasswordNeverExpires
    Write-Host "User '$username' has been created."
} catch {
    Write-Host "Error creating user: $_"
}
# !!!!!!! (dont give those group permissions to the user) Add user to Administrators and Remote Management Users groups (Optional) 
 net localgroup Administrators $username /add #Dont do this in production
# net localgroup "Remote Management Users" $username /add


# UAC

# Certificate management
# Create Certificate
$IPAddress = Read-Host "Enter Servers IP address WinRM"
New-SelfSignedCertificate -DnsName $IPAddress -CertStoreLocation Cert:\LocalMachine\My
# Extract thumbprint
  # Get the certificates from the LocalMachine\My store
  $certificates = Get-ChildItem -Path "Cert:\LocalMachine\My"
 
  # Filter certificates that have a matching hostname in SAN or Subject
  $matchingCert = $certificates | Where-Object { $_.DnsNameList -contains $IPAddress -or $_.Subject -match "CN=$IPAddress" }

if ($matchingCert) {
    # Found a matching certificate, extract its thumbprint
    $Thumbprint = $matchingCert.Thumbprint
    Write-Output $Thumbprint
}
else {
    Write-Host "No certificate found with Hostname: $IPAddress"
}
# List certificates available
function Get-Certificates {
    # Get the certificates from the LocalMachine\My store
    $certificates = Get-ChildItem -Path "Cert:\LocalMachine\My"

    # Display the certificate information
    if ($certificates.Count -gt 0) {
        foreach ($cert in $certificates) {
            Write-Host "Certificate Subject: $($cert.Subject)"
            Write-Host "Thumbprint: $($cert.Thumbprint)"
            Write-Host "Issuer: $($cert.Issuer)"
            Write-Host "NotBefore: $($cert.NotBefore)"
            Write-Host "NotAfter: $($cert.NotAfter)"
            Write-Host "----------------------"
        }
    } else {
        Write-Host "No certificates found in the LocalMachine\My store."
    }
}
 Get-Certificates

# Export certificate from a thumbprint
function Export-CertificateByThumbprint {
    param (
        [string]$Thumbprint,
        [string]$ExportFilePath
    )

    # Get the certificate by thumbprint from the LocalMachine\My store
    $certificate = Get-ChildItem -Path "Cert:\LocalMachine\My" | Where-Object { $_.Thumbprint -eq $Thumbprint }

    if ($certificate) {
        # Export the certificate to the specified file
        $certificate | Export-Certificate -FilePath $ExportFilePath -Force
        Write-Host "Certificate with thumbprint '$Thumbprint' has been exported to: $ExportFilePath"
    } else {
        Write-Host "Certificate with thumbprint '$Thumbprint' not found."
    }
}
# Example usage: Export the certificate with the specified thumbprint
$thumbprintToExport = $Thumbprint
$exportFilePath = "C:\Users\Administrator\certificate.cer" # Change this to the desired export path
Export-CertificateByThumbprint -Thumbprint $thumbprintToExport -ExportFilePath $exportFilePath

#Import a certificate to the TRUSTED CA stores
function Import-CertificateToTrustedRoot {
    param (
        [string]$CertificatePath
    )

    # Import the certificate to the Trusted Root Certification Authorities store
    Import-Certificate -FilePath $CertificatePath -CertStoreLocation Cert:\LocalMachine\Root

    Write-Host "Certificate imported to Trusted Root Certification Authorities store."

    # Delete the certificate file from the file system
    Remove-Item $CertificatePath -Force
}

# Prompt the user for the path to the certificate file
$certificatePath = "C:\Users\Administrator\certificate.cer"

# Call the function to import the certificate and delete the file
Import-CertificateToTrustedRoot -CertificatePath $certificatePath



# Delete Certificate from thumbprint function
function Remove-CertificateByThumbprint {
    param (
        [string]$Thumbprint
    )

    # Get the certificate by thumbprint from the LocalMachine\My store
    $certificate = Get-ChildItem -Path "Cert:\LocalMachine\My" | Where-Object { $_.Thumbprint -eq $Thumbprint }

    if ($certificate) {
        # Delete the certificate
        $certificate | Remove-Item
        Write-Host "Certificate with thumbprint '$Thumbprint' has been deleted."
    } else {
        Write-Host "Certificate with thumbprint '$Thumbprint' not found."
    }
}
# Call the function with the desired thumbprint
#$thumbprintToDelete = Read-Host "Enter the certificate thumbprint to delete"
#Remove-CertificateByThumbprint -Thumbprint $thumbprintToDelete

# Enable powershell remoting 
Enable-PSRemoting -Force

# Configuring Winrm
# Delete any old https listeners
winrm delete winrm/config/listener?Address=*+Transport=HTTP
winrm delete winrm/config/listener?Address=*+Transport=HTTPS 

Write-Host "The ip address is $IPAddress && the Thumbprint of the Trusted CA is $Thumbprint"

$hostname=$IPAddress
# Create Listener
# Configure WinRM to use HTTPS and create a listener
$command = "winrm create winrm/config/listener?Address=*+Transport=HTTPS '@{Hostname=""$hostname"";CertificateThumbprint=""$Thumbprint"";port=""5986""}'"
Invoke-Expression $command


# Restart the WinRM service
	Restart-Service WinRM



############# Winrm administrationcapabilities ############# 
# Check winrm config
#winrm get winrm/config

# Check if listener is setup
#netstat -ano | findstr ":5985"

# Check users permission group
#Set-PSSessionConfiguration -ShowSecurityDescriptorUI -Name Microsoft.PowerShell

# List users that are members of Administrators group
#net localgroup Administrators


