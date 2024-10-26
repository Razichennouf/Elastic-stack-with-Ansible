https://discuss.elastic.co/t/how-to-configure-kibana-behind-nginx-balancer/304654/2
In ELK setting up a balancer is tricky and the  case. server.basePath asymetrically affects the URL. Meaning that all request URLs remain the same but response URLs have included the subdomin. For example, the kibana home page is still accessed at http://x.x.x.x:5601/app/kibana but all hrefs URLs include the subdomain /kibana4.

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

        server_name "somedomain.org" "www.somedomain.org";


# Deploy certificate using the certbot
sudo certbot --nginx -d somedomain.org -d somedomain.org

sudo crontab -e
        0 12 * * * /usr/bin/certbot renew --quiet
