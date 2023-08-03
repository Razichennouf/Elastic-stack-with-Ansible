<!DOCTYPE html>
<html>
<body>
  <h1>🚀 ELK Stack Deployment and Windows Agent setup Driven by Automation using <strong>Ansible</strong> 🛡️</h1>

  <p>
    This project automates the deployment of the ELK (Elasticsearch, Logstash, Kibana) stack on Linux servers and sets up
    security monitoring on Windows machines using Sysmon. It leverages Ansible for seamless configuration management,
    making it easy to deploy, manage, and scale ELK stack instances and Windows security settings across multiple servers.
  </p>

  <h2>Features:</h2>
  <ul>
    <li>📈 <strong>ELK Stack Deployment</strong>: Automates the installation and configuration of Elasticsearch, Logstash, and Kibana on Linux servers, providing a powerful platform for log aggregation, analysis, and visualization.</li>
    <li>🔒 <strong>Windows Security Monitoring</strong>: Deploys Sysmon on Windows machines, a powerful system monitoring tool from Microsoft's Sysinternals suite, to monitor and record security-related events for enhanced incident detection.</li>
    <li>🔐 <strong>WinRM Certificate Management</strong>: Automates the creation and management of WinRM certificates on Windows machines, securing remote management channels with encrypted communication.</li>
    <li>👤 <strong>User Management</strong>: Sets up dedicated automation users on Windows machines for executing remote tasks securely.</li>
  </ul>

  <h2>How to Use:</h2>
  <ol>
    <li>📥 Clone this repository to your local machine:</li>
    <pre>git clone https://github.com/your-username/ansible-elk-stack.git
cd ansible-elk-stack</pre>

  <li>⚙️ Update the inventory file (<code>hosts</code>) to include the IP addresses or hostnames of your target servers. Make sure to differentiate between Linux and Windows machines in separate groups.</li>

  <li>🔧 Update the variables in the <code>vars/</code> directory to match your desired ELK stack and Sysmon configuration settings.</li>

  <li>🚀 Run the Ansible playbook to deploy the ELK stack and set up Windows security monitoring:</li>
  <pre>ansible-playbook site.yml -i hosts</pre>

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
