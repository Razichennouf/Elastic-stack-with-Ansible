# Installing dependencies
apt upate -y && apt upgrade -y
apt install -y libmodsecurity-dev libmodsecurity3
apt install make gcc build-essential autoconf automake libtool libfuzzy-dev ssdeep gettext pkg-config libcurl4-openssl-dev liblua5.3-dev libpcre3 libpcre3-dev libxml2 libxml2-dev libyajl-dev doxygen libcurl4 libgeoip-dev libssl-dev zlib1g-dev libxslt-dev liblmdb-dev libpcre++-dev libgd-dev

# Manage www-data user

# add this to nginx.conf
include /etc/nginx/modules-enabled/*.conf;
load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;

http {
	modsecurity on;
        modsecurity_rules_file /etc/nginx/modsec/main.conf;

