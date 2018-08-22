# azure-iot-edge-device-container
An Azure IoT Edge Device in a Docker container

[![Docker Build Status](https://dockerbuildbadges.quelltext.eu/status.svg?organization=toolboc&repository=azure-iot-edge-device-container)](https://hub.docker.com/r/toolboc/azure-iot-edge-device-container/builds) [![Docker Pulls](https://img.shields.io/docker/pulls/toolboc/azure-iot-edge-device-container.svg?style=flat-square)](https://hub.docker.com/r/toolboc/azure-iot-edge-device-container/)

# Quickstart

Create an [Azure IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-create-through-portal)

Install the [Azure-Cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) 

Run `az login` to sign in with the azure cli and set the appropriate subscription with:

    az account set --subscription

Create a Service Principal for your subscription with the azure cli:

    az ad sp create-for-rbac --name <name> --password <password>

You should see output similar to:

    {
    "appId": "12345678-1234-1234-1234-1234567890ab",
    "displayName": "azure-iot-edge-device-container-sp",
    "name": "http://azure-iot-edge-device-container-sp",
    "password": "MyPassword",
    "tenant": "abcdefgh-abcd-abcd-abcd-abcdefghijkl"
    }

Take note of the `name`, `password`, and `tenant` as these values will be used later for `<spAppURl>`, `<spPassword>`, and `<tenant>` respectively. 

Obtain the following Parameters:

| Parameter      | Description |           |
| -------------- | ------------| --------- |
| spAppUrl      | The Service Principal app URL | Required  |
| spPassword   | The Password for the Service Principal | Required |
| tenantId   | The tenant id for the Service Principal | Required |
| subscriptionId   | The azure subscription id where the IoT Hub is deployed | Required |
| iothub_name   | The name of the Azure IoT Hub | Required |
| environment   | A value to use for the envrionment tag in the created device's devicetwin | Optional |

Start a container instance with:

    docker run -it -d --privileged -e spAppUrl='<spAppUrl>' -e spPassword='<spPassword>' -e tenantId='<tenantId>' -e subscriptionId='<subscriptionId>' -e iothub_name='<iothub_name>' -e environment='<environment>' toolboc/azure-iot-edge-device-container

The device will automatically register itself as an Edge device within the specified IoT Hub using the hostname of the container instance.  

You can use the environment tag to specify a Target Condition to apply apply an IoT Deployment definition. 

![Edge Deployment Configuration](https://raw.githubusercontent.com/toolboc/azure-iot-edge-device-container/master/Content/Deployment.PNG)

# Deploy to k8s using helm:

Create an [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)
[Install helm and install tiller](https://docs.helm.sh/using_helm/#quickstart-guide) in your cluster

Navigate to the helm directory in this repo and execute the following:

    helm install --name azure-iot-edge-device-container azure-iot-edge-device-container --set spAppUrl=<spAppUrl> --set spPassword=<spPassword> --set tenantId=<tenantId> --set subscriptionId=<subscriptionId> --set iothub_name=<iothub_name> --set environment=<environment> --set replicaCount=1


