# Put this block to the nginx configuration file
"""location / {
            proxy_pass http://localhost:5601;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
          }
"""
# Enable security group port 80
# Get the token and enroll it to the shell console
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token --scope kibana
