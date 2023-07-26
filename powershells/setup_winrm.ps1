# Enable PowerShell remoting
Enable-PSRemoting -Force

# Configure WinRM Service
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
Set-Item -Path 'WSMan:\localhost\Service\AllowUnencrypted' -Value $true
Set-Item -Path 'WSMan:\localhost\Service\Auth\Basic' -Value $true
Set-Item -Path 'WSMan:\localhost\Service\Auth\CredSSP' -Value $true

# Set WinRM service startup type to automatic
Set-Service WinRM -StartupType 'Automatic'

# If you are using AWS and your instance behind the Security group you dont need to mess with windows Firewall just manage your SG rules
# If you are not behind the SG
# Create a firewall rule to allow WinRM HTTPS inbound
New-NetFirewallRule -DisplayName "Allow WinRM HTTPS" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow

# Configure TrustedHosts
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

#Configuring user (For more security of the machines we will create a dedicated user for the automation JOB)
function Get-SecurePassword {
    param (
        [string]$Prompt = "Enter a strong password for the user:"
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
$username = Read-Host "Enter the username for the new user"

# Get a valid secure password
$password = Get-SecurePassword

# Create the new user
try {
    New-LocalUser -Name $username -Password $password -PasswordNeverExpires
    Write-Host "User '$username' has been created."
} catch {
    Write-Host "Error creating user: $_"
}


# Add user to Administrators and Remote Management Users groups
net localgroup Administrators $username /add
net localgroup "Remote Desktop Users" $username /add


# Certificate management

# UAC

# Delete any old https listeners
winrm delete winrm/config/listener?Address=*+Transport=HTTPS
# Create Listener
winrm create winrm/config/listener?Address=*+Transport=HTTPS '@{Hostname="$ip";CertificateThumbprint="TheThumbprintYouCopied";port="5986"}'


# Restart the WinRM service
Restart-Service WinRM

