    #!/bin/bash

    provision(){
    echo "***Start Docker in Docker***"
    dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &
    echo "***Authenticating with Azure CLI***"
    az login --service-principal -u $spAppUrl -p $spPassword --tenant $tenantId
    az account set --subscription $subscriptionId
    echo "***Configuring IoT Edge Runtime***"
    az iot hub device-identity create --device-id $(hostname) --hub-name $iothub_name --edge-enabled
    connectionString=$(az iot hub device-identity show-connection-string --device-id $(hostname) --hub-name $iothub_name | jq -r '.cs')
    az iot hub device-twin update --device-id $(hostname) --hub-name $iothub_name --set tags='{"environment":"'$environment'"}'

    echo "***The connection string***"
    docker info

    iotedgectl setup --connection-string $connectionString --auto-cert-gen-force-no-passwords
    iotedgectl login --address $acr_host --username $acr_user --password $acr_password
    iotedgectl start
    }

    # Check Arguments
    provision