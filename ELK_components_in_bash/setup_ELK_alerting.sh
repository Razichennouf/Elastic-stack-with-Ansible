sudo /usr/share/kibana/bin/kibana-encryption-keys generate

# YOu will get output like this
## Kibana Encryption Key Generation Utility

The 'generate' command guides you through the process of setting encryption keys for:

xpack.encryptedSavedObjects.encryptionKey
    Used to encrypt stored objects such as dashboards and visualizations
    https://www.elastic.co/guide/en/kibana/current/xpack-security-secure-saved-objects.html#xpack-security-secure-saved-objects

xpack.reporting.encryptionKey
    Used to encrypt saved reports
    https://www.elastic.co/guide/en/kibana/current/reporting-settings-kb.html#general-reporting-settings

xpack.security.encryptionKey
    Used to encrypt session information
    https://www.elastic.co/guide/en/kibana/current/security-settings-kb.html#security-session-and-cookie-settings


Already defined settings are ignored and can be regenerated using the --force flag.  Check the documentation links for instructions on how to rotate encryption keys.
Definitions should be set in the kibana.yml used configure Kibana.

Settings:
xpack.encryptedSavedObjects.encryptionKey: 6a34f8a3806e96fcc26554f1a2a2c1ee
xpack.reporting.encryptionKey: 6e6aea49c327915f3dad1eb01a5068f2
xpack.security.encryptionKey: 4879d65fc96363a095c487a078ed3816

# Add the three last lines to kibana.yml
 vim /etc/kibana/kibana.yml

# Restart kibana and elastic search
sudo systemctl restart kibana
sudo systemctl restart elasticsearch
