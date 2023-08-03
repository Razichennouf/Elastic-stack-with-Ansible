#!/bin/bash

Under http block in /etc/nginx/nginx.conf:
	server_tokens off;

Under default (website path) /etc/nginx/sites-available/default:
		Under server block:
	        server_name "ansi-elk.duckdns.org" "www.ansi-elk.duckdns.org";
		 location / {
        		proxy_pass http://localhost:5601;
            		proxy_http_version 1.1;
            		proxy_set_header Upgrade $http_upgrade;
            		proxy_set_header Connection 'upgrade';
            		proxy_set_header Host $host;
            		proxy_cache_bypass $http_upgrade;
          			}
			#add_header Content-Security-Policy "default-src 'self'; script-src>
			 add_header X-XSS-Protection "1; mode=block";
         		 add_header X-Frame-Options "SAMEORIGIN";
        		 add_header X-Content-Type-Options "nosniff";
         		 add_header Referrer-Policy "no-referrer";
       		 	 add_header 'Access-Control-Allow-Origin' '*';
       			 add_header Strict-Transport-Security "max-age=31536000";
			 #Performance
		          #limit_req zone=req_zone burst=10 nodelay;



