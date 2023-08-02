sudo /usr/share/kibana/bin/kibana-encryption-keys  generate
Put them in :  sudo vim /etc/kibana/kibana.yml :
	xpack.encryptedSavedObjects.encryptionKey: 4294c2026676c9de56f6a6788cb9f304
	xpack.reporting.encryptionKey: 3f48662ead2913f1901c86e5d4aae416
	xpack.security.encryptionKey: 821e5635dc2742057aee7f4f894dc90b

Secure saved objects
