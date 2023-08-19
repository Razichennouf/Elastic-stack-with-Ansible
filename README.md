<!DOCTYPE html>
<html>
<body>
  <h1>🚀 Single-node ELK Stack Deployment and Windows Agent setup Driven by Automation using <strong>Ansible</strong> 🛡️</h1>

  <p>
    This project automates the deployment of the ELK (Elasticsearch, Logstash, Kibana) stack on Linux servers and sets up
    security monitoring on Windows machines using Sysmon. It leverages Ansible for seamless configuration management,
    making it easy to deploy, manage, and scale ELK stack instances and Windows security settings across multiple servers.
  </p>

  <h2>Features:</h2>
  <ul>
    <li>📈 <strong>ELK Stack Deployment</strong>: Automates the installation and configuration of Elasticsearch, Logstash, and Kibana on Linux servers, providing a powerful platform for log aggregation, analysis, and visualization.</li>
    <li>🔒 <strong>Windows Monitoring component </strong>: Deploys Sysmon on Windows machines, a powerful system monitoring tool from Microsoft's Sysinternals suite, to monitor and record security-related events for enhanced incident detection.</li>
    <li>🔐 <strong>WinRM Certificate Management</strong>: Automates the creation and management of WinRM certificates on Windows machines, securing remote management channels with encrypted communication.</li>
    <li>👤 <strong>User Management</strong>: Sets up dedicated automation users on Windows machines for executing remote tasks securely.</li>
  </ul>
   <h1>Ansible advanced in automation tips :</h1>
   
   <ul>
     <li> To specify the method and the user to be used for privilege escalation while we are in a hytirogene envirenment (Windows, Linux) we should not specify it on ansible.cfg to prevent conflict errors thats we we are going to specify all in the inventory variables or inside group_vars <b>In windows </b><code>ansible_become_method= runas</code> and <b>In Linux </b><code>ansible_become_method=sudo</code></li>
   </ul>
    <h1>Windows WinRM Deployment Guide</h1>

  <h2>Important Note for AWS Users</h2>
    <p>If you are deploying WinRM on AWS instances, it's crucial to statically change the Administrator password to ensure security. Follow these steps to set a new password securely:</p>
  <ol>
        <li>Start by obtaining the private key associated with your AWS instance.</li>
        <li>Open a PowerShell session on your local machine.</li>
        <li>Execute the following commands :</li>
    </ol>
  <pre>
    $Password = Read-Host "Enter the new password" -AsSecureString
    $UserAccount = Get-LocalUser -Name "Administrator"
    $UserAccount | Set-LocalUser -Password $Password
        </pre>
  <p>This will set a new password for the default user 'Administrator' on your AWS instance.</p>

  <h2>Using Elastic IPs</h2>
  <p>For users deploying WinRM on AWS or similar cloud platforms, it is highly recommended to use Elastic IPs (EIPs). Elastic IPs provide a static public IP address that remains associated with your instance, even after stopping and starting it. This prevents potential conflicts and connectivity issues that may arise due to dynamic IP address changes.</p>
  <p>To assign an Elastic IP to your instance:</p>
   <ol>
      <li>Go to your cloud provider's management console.</li>
      <li>Allocate a new Elastic IP.</li>
      <li>Associate the Elastic IP with your instance, ensuring a stable and reliable connection.</li>
   </ol>
  <p>By following these steps and using Elastic IPs, you can avoid interruptions and connectivity problems when working with your WinRM-enabled Windows instances.</p>

  <p>Please note that this guide assumes a basic familiarity with Windows and PowerShell. If you encounter any issues or have questions, don't hesitate to seek assistance from your system administrator or support resources.</p>
 <p><strong>Caution 0:</strong> I'm using ansible vault.yml for the sensitive data inside the plays and also the same password for the encryption of the inventory file so in runtime we could decrypt both with same password without conflicts </p>
  <p><strong>Caution 1:</strong> Ansible works differently on Windows and Linux systems, and the 'become' methods for privilege escalation are different. To ensure proper execution, you need to define the 'ansible_become_method' and 'ansible_become_user' variables in your inventory file as follows:</p>
<pre>
    [windows:vars]
    ansible_become_method=runas
    ansible_become_user=Administrator
    [ubuntu:vars]
    ansible_become_method=sudo
    ansible_become_user=root
</pre>
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
 <p><strong>Caution 2:</strong> Ansible Inventory might sometimes have an insider sensitive data so you need to <strong>encrypt</strong> the <strong>inventory</strong> and <strong>decrypt</strong> it in <strong>runtime</strong> </p>
 <pre>
   PS: vault password in this repository is : "RmoutdqousorALAs 11301123##2DDQ"
     - At runtime : use <strong>--ask-vault-pass</strong> to get a prompt for the password  
         $ ansible-vault encrypt /path/to/inventory
     - If you want to go the other way without encrypting the whole inventory we will use the command ansible-vault and then specify it inside the ansible inventory but only when its in YAML format
         $ ansible-vault encrypt_string --vault-id $my_user@prompt 'ansible_password' --name 'ansible_password'</pre>
  <ol>
    <li>📥 Clone this repository to your local machine:</li>
    <pre>git clone https://github.com/Razichennouf/ansible_elk_winrm.git
cd ansible_elk_winrm</pre>

  <li>⚙️ Update the inventory file (<code>inventory</code>) to include the IP addresses or hostnames of your target servers. Make sure to differentiate between Linux and Windows machines in separate groups.</li>

  <li>🔧 Update the variables in the <code>inventory</code> under the clause [OS:vars]  to match your desired platforms settings.</li>

  <li>🚀 Run the Ansible playbook to deploy the ELK stack and set up Windows render the agents ready for monitoring:</li>
  <pre>ansible-playbook site.yml -i inventory --ask-vault-pass </pre>

  <li>🎉 Sit back and watch as Ansible automates the entire process, from ELK stack deployment to Sysmon setup and WinRM certificate management!</li>
  </ol>

  <h2>Contribution:</h2>
  <p>Contributions to this project are welcome! If you have ideas for improvements, feature requests, or bug fixes, feel free to create issues or submit pull requests.</p>

  <h2>License:</h2>
  <p>This project is licensed under the MIT License. Feel free to use, modify, and distribute it as per the terms of the license.</p>

  <h2>Disclaimer:</h2>
  <p>Please be cautious when using this project in a production environment. Always review and understand the configurations before running the automation scripts, as they may have implications on your system's security and stability.</p>
</body>

</html>
