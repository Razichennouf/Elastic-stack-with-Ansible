sudo crontab -e
	@reboot sudo python3 /home/ubuntu/block_tor_network.py


sudo apt install ipset

import requests
import subprocess

# Define the URL for the Tor bulk exit list
url = "https://check.torproject.org/torbulkexitlist"

# Make a request to the URL and retrieve the response
response = requests.get(url)

# Split the response into individual IP addresses
ip_addresses = response.text.strip().split()

# Check if IPset already exists
ipset_exists = subprocess.run(['sudo', 'ipset', 'list', 'tor-exit-nodes'], capture_output=True).returncode == 0

if ipset_exists:
    # IPset already exists, prompt the user for action
    response = input("IPset 'tor-exit-nodes' already exists. Do you want to continue and overwrite it? (y/n): ")
    if response.lower() != 'y':
        print("Aborting script.")
        exit()

# Create or flush the IPset
subprocess.run(['sudo', 'ipset', 'create', 'tor-exit-nodes', 'hash:ip'], check=True)
subprocess.run(['sudo', 'ipset', 'flush', 'tor-exit-nodes'], check=True)

# Add each IP address to the IPset
for ip in ip_addresses:
    subprocess.run(['sudo', 'ipset', 'add', 'tor-exit-nodes', ip], check=True)
# Persist ipset
subprocess.run(['sudo','ipset','save','-f','/etc/ipset.conf'], check=True)
# Update iptables rules
subprocess.run(['sudo', 'iptables', '-A', 'INPUT', '-m', 'set', '--match-set', 'tor-exit-nodes', 'src', '-j', 'DROP'], check=True)

# Save iptables rules to a file
with open('/etc/iptables/rules.v4', 'w') as f:
    subprocess.run(['sudo', 'iptables-save'], check=True, stdout=f)

