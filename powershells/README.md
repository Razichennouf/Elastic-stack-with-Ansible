<h1>PowerShell Script for Enabling WinRM and Configuring Remote Management</h1>

<p>This PowerShell script enables WinRM (Windows Remote Management) and configures various settings for remote management on the local machine. It is designed to facilitate secure remote access and automation tasks in Windows environments.</p>

<h2>Script Features:</h2>
<ul>
  <li><strong>Enable-PSRemoting:</strong> This cmdlet enables PowerShell remoting on the local machine.</li>
  <li><strong>Configure WinRM Service:</strong> Sets various configuration settings for the WinRM service, including enabling certificate-based authentication, allowing unencrypted traffic, and enabling basic and CredSSP (Credential Security Support Provider) authentication.</li>
  <li><strong>Setting a New Password (AWS Environment):</strong> If the script is running in an AWS environment and the machine is a fresh instance, it prompts the user to enter a new password for the default user 'Administrator' and sets it securely.</li>
  <li><strong>Set WinRM Service Startup Type to Automatic:</strong> Configures the WinRM service to start automatically.</li>
  <li><strong>Create a Firewall Rule:</strong> Opens inbound ports (5986) for WinRM over HTTPS to allow remote connections.</li>
  <li><strong>Configure TrustedHosts:</strong> Sets the TrustedHosts setting to "*", allowing connections to any remote host (not recommended for production environments).</li>
  <li><strong>Setting up an Automation User:</strong> Prompts the user to enter a username and password to create a new local user account on the machine for automation purposes.</li>
  <li><strong>Setting Basic Authentication:</strong> Enables Basic authentication for both the client and service configurations.</li>
  <li><strong>Certificate Management:</strong> Creates a self-signed certificate for WinRM and sets it up as the HTTPS listener certificate for secure remote connections.</li>
  <li><strong>Restart the WinRM Service:</strong> Finally, it restarts the WinRM service to apply the changes made.</li>
</ul>

<p>Please note that the script contains some commented-out code, which is usually used as examples or for additional functionalities. Some parts of the script, like adding the user to the Administrators and Remote Management Users groups, should be used with caution, especially in a production environment.</p>

---

<p align="center"><em>This README is a part of the PowerShell WinRM Configuration project. For more details, please refer to the source code and documentation.</em></p>
