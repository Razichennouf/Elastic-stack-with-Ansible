#!/bin/bash

# The location of the Certificate Authority file.
# This is generated by Elasticsearch in the setup container and mounted into the container.
GenerateFleet-cert()
{

}
CA=/certs/ca/ca.crt

# The host and port of the Elasticsearch server.
ELASTIC_HOST=localhost:9200

# The username this script uses to connect to Elasticsearch.
ELASTIC_USER=elastic

# The password this script uses to connect to Elasticsearch.
ELASTIC_PASS="4SmgqgKJ5r=*A8FqE=k="

# The URL to the Kibana server, without a trailing slash.
KIBANA_URL=http://localhost:5601

createServiceAccountToken()
{
   echo -n 'Creating service account token... '

   # Create a random name for the token so it does not collied with any existing tokens.
   tokenName=`cat /proc/sys/kernel/random/uuid`

   # Create the token.
   response=`curl \
       -u $ELASTIC_USER:$ELASTIC_PASS \
       --silent \
       --cacert $CA \
       -X POST "https://$ELASTIC_HOST/_security/service/elastic/fleet-server/credential/token/$tokenName?pretty"`

   # Check that the response was successful.
   if ! echo "$response" | grep --silent '"created" : true'; then
       echo 'failed'
       echo "$response"
       exit 1
   fi

   # Parse the token out of the response.
   token=`echo "$response" | awk '/value/ { print $3 }' | sed 's/"//g'`

   echo "success: $token"
}

createAgentPolicy()
{
   echo -n 'Creating Fleet server policy... '

   response=`curl \
       -u $ELASTIC_USER:$ELASTIC_PASS \
       --silent \
       --request POST \
       --url $KIBANA_URL/api/fleet/agent_policies?sys_monitoring=true \
       --header 'content-type: application/json' \
       --header 'kbn-xsrf: true' \
       --data '{"id": "docker-fleet-server-policy","name":"Docker Fleet Server Policy","namespace":"default","monitoring_enabled":["logs","metrics"],"is_default_fleet_server": true}'`

   if echo "$response" | grep --silent 'document already exists'; then
       echo 'already exists'
       return 0
   fi

   echo 'success'
}

addServerIntegration()
{
   echo -n 'Adding Fleet server integration to policy... '

   response=`curl \
       -u $ELASTIC_USER:$ELASTIC_PASS \
       --silent \
       --request POST \
       --url $KIBANA_URL/api/fleet/package_policies \
       --header 'content-type: application/json' \
       --header 'kbn-xsrf: true' \
       --data '
       {
           "policy_id": "fleet-server-policy",
           "package": {
               "name": "fleet_server",
               "version": "1.2.0"
           },
           "name": "fleet_server",
           "description": "",
           "namespace": "default",
           "inputs": {
               "fleet_server-fleet-server": {
               "enabled": true,
               "vars": {
                   "host": "fleet",
                   "port": [
                   8220
                   ],
                   "custom": ""
               },
               "streams": {}
               }
           }
       }'`

   if echo $response | grep --silent 'already exists'; then
       echo 'already exists';
       return 0
   fi

   if echo $response | grep --silent 'error'; then
       echo 'failed'
       echo "$response"
       exit 1
   fi

   echo 'success'
}

addServerHost()
{
   echo -n 'Checking if Fleet server host exists... '

   response=`curl \
       -u elastic:elastic \
       --silent \
       --request GET \
       --cacert /usr/share/kibana/config/certs/ca/ca.crt \
       --url http://kibana:5601/api/fleet/fleet_server_hosts/fleet-server \
       --header 'content-type: application/json' \
       --header 'kbn-xsrf: true'`

   if ! echo $response | grep --silent 'Not Found'; then
       echo 'already exists'
       return 0
   else
       echo 'does not exist'
   fi

   echo -n 'Adding Fleet server host... '

   response=`curl \
       -u $ELASTIC_USER:$ELASTIC_PASS \
       --silent \
       --request POST \
       --url $KIBANA_URL/api/fleet/fleet_server_hosts \
       --header 'content-type: application/json' \
       --header 'kbn-xsrf: true' \
       --data '
       {
           "id": "fleet-server",
           "name": "Fleet Server",
           "is_default": true,
           "host_urls": [
               "https://fleet:8220"
           ]
       }'`

   if echo $response | grep --silent 'error'; then
       echo 'failed'
       echo "$response"
       exit 1
   fi

   echo 'success'
}

setOutput()
{
   echo -n 'Setting agent output location... '

   response=`curl \
       -u $ELASTIC_USER:$ELASTIC_PASS \
       --silent \
       --request PUT \
       --url $KIBANA_URL/api/fleet/outputs/fleet-default-output \
       --header 'content-type: application/json' \
       --header 'kbn-xsrf: true' \
       --data "
       {
           \"name\": \"default\",
           \"type\": \"elasticsearch\",
           \"is_default\": true,
           \"is_default_monitoring\": true,
           \"hosts\": [
               \"https://$ELASTIC_HOST\"
           ],
           \"config_yaml\": \"ssl.certificate_authorities: ['/certs/ca/ca.crt']\"
       }"`

   if echo "$response" | grep --silent 'document already exists'; then
       echo 'already exists'
       return 0
   fi

   if echo $response | grep --silent 'error'; then
       echo 'failed'
       echo "$response"
       exit 1
   fi

   echo 'success'
}

installFleet()
{
   apt update
   apt install -y curl
   curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.6.0-linux-x86_64.tar.gz
   tar xzvf elastic-agent-8.6.0-linux-x86_64.tar.gz
   cd elastic-agent-8.6.0-linux-x86_64

   ./elastic-agent install \
       --non-interactive \
       --fleet-server-es=https://$ELASTIC_HOST \
       --fleet-server-service-token=$token  \
       --fleet-server-policy=docker-fleet-server-policy \
       --fleet-server-es-ca=/certs/ca/ca.crt \
       --fleet-server-cert=/certs/fleet/fleet.crt \
       --fleet-server-cert-key=/certs/fleet/fleet.key \
       --certificate-authorities=/certs/ca/ca.crt \
       --url=https://fleet:8220
}

# Main program
createServiceAccountToken
createAgentPolicy
addServerIntegration
addServerHost
setOutput
installFleet

