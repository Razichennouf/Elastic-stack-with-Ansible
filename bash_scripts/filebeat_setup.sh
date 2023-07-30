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

# After enabling the modules needed we have not to setup the filebeat to start collecting metrics :
filebeat setup -e
