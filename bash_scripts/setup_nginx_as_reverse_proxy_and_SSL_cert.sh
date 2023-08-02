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

sudo apt install certbot && sudo apt install python3-certbot-nginx

# Adding these lines to the nginx server configuration file
server {

        server_name "ansi-elk.duckdns.org" "www.ansi-elk.duckdns.org";


# Deploy certificate using the certbot
sudo certbot --nginx -d ansi-elk.duckdns.org -d www.ansi-elk.duckdns.org

sudo crontab -e
        0 12 * * * /usr/bin/certbot renew --quiet
