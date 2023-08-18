  <title>🚀 Single-node ELK Stack Deployment and Windows Agent Setup Driven by Ansible Automation 🛡️</title>
</head>
<body>
  <header>
    <h1>Automated Deployment of ELK Stack and Windows Security Monitoring with Ansible</h1>
    <p>
      Streamline your infrastructure management with Ansible by effortlessly setting up and scaling the ELK (Elasticsearch, Logstash, Kibana) stack on Linux servers and fortifying Windows machines with Sysmon for robust security monitoring.
    </p>
  </header>
  <section>
    <h2>Key Features:</h2>
    <ul>
      <li>📈 <strong>ELK Stack Deployment</strong>: Effortlessly installs and configures Elasticsearch, Logstash, and Kibana on Linux servers for effective log aggregation, analysis, and visualization.</li>
      <li>🔒 <strong>Windows Security Monitoring</strong>: Deploys Sysmon, a potent system monitoring tool from Microsoft's Sysinternals suite, on Windows systems to record and monitor security-related events, enhancing incident detection.</li>
      <li>🔐 <strong>WinRM Certificate Management</strong>: Seamlessly manages WinRM certificates on Windows machines, safeguarding remote management communications through encrypted channels.</li>
      <li>👤 <strong>User Management</strong>: Establishes dedicated automation users on Windows systems, ensuring secure execution of remote tasks.</li>
    </ul>
  </section>
  <section>
    <h2>Securing Sensitive Data with Ansible Vault</h2>
    <p>
      In order to protect sensitive information, like Windows user passwords, contained within the inventory, Ansible Vault is employed. This ensures data confidentiality while allowing streamlined decryption at runtime using a single password.
    </p>
    <p>
      For instance, the password for Windows user authentication has been encrypted within the inventory using Ansible Vault. This encryption guarantees that the password is stored securely, preventing unauthorized access.
    </p>
    <p>
      Furthermore, the same password has been utilized across multiple vaults, enabling efficient decryption of all encrypted data during runtime using a single password. To execute this process, include the <code>--ask-vault-pass</code> flag when running Ansible commands, prompting you to provide the decryption password.
    </p>
  </section>
  <section>
    <h2>Deployment Guide for Windows WinRM</h2>
    <h3>Important Note for AWS Users</h3>
    <p>
      If deploying WinRM on AWS instances, ensure robust security by following these steps to update the Administrator password securely:
    </p>
    <ol>
      <li>Access the private key associated with your AWS instance.</li>
      <li>Open a PowerShell session on your local machine.</li>
      <li>Execute the following commands:</li>
    </ol>
    <pre>
      $Password = Read-Host "Enter the new password" -AsSecureString
      $UserAccount = Get-LocalUser -Name "Administrator"
      $UserAccount | Set-LocalUser -Password $Password
    </pre>
    <p>
      This process will establish a new password for the default user, 'Administrator,' on your AWS instance, enhancing security.
    </p>
