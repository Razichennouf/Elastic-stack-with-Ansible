#!/bin/bash

# If you are using HTTPS over HTTP on elasticsearch you need to get the fingerprint of the CA to set it up on metricbeat's elasticsearch.output settingsfrom kibana.yml (easiest way to retrieve the Fingerprint)
 sudo grep -Eo "ca_trusted_fingerprint:.*" /etc/kibana/kibana.yml | sed 's/ca_trusted_fingerprint: *//; s/[}].*//'

 # Put this under output.elasticsearch
ssl:
    enabled: true
    ca_trusted_fingerprint: "3175acec9f1404e5d5c49cc226dc5aca5d75e640bbd74c00837307239227f5ba"


# Create the keystore to secure the password in metricbeat config file
filebeat keystore create
# Add keys
filebeat keystore add ES_PWD

# Put this in password
 username: "elastic"
 password: "${ES_PWD}"

# Enable the module to use for metric collection : for example we will collect metrics of system:

sudo filebeat modules enable system
- module: system
  # Syslog
  syslog:
    enabled: true

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    #var.paths:

  # Authorization logs
  auth:
    enabled: true

# Enable nginx module and config file
sudo filebeat modules enable nginx
- module: nginx
  # Access logs
  access:
    enabled: true
    var.paths: ["/var/log/nginx/access.log*"]

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    #var.paths:

  # Error logs
  error:
    enabled: true
    var.paths: ["/var/log/nginx/error.log*"]


# Enable elasticsearch cluster logs
https://www.elastic.co/guide/en/beats/filebeat/8.9/filebeat-module-elasticsearch.html

# After enabling the modules needed we have not to setup the filebeat to start collecting metrics :
filebeat setup -e

# Restart elasticsearch soft
systemctl restart elasticsearch	
