# azure-iot-edge-device-container
An Azure IoT Edge Device in a Docker container

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
| acr_user   | User name for [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/) or private Docker registry | Optional |
| acr_password   | Password for the ACR or private Docker Registry | Optional |


Start a container instance with:

    docker run -it -d --privileged -e spAppUrl='<spAppUrl>' -e spPassword='<spPassword>' -e tenantId='<tenantId>' -e subscriptionId='<subscriptionId>' -e iothub_name='<iothub_name>' -e environment='<environment>' -e acr_host='<acr_host>' -e acr_user='<acr_user>' -e acr_password='<acr_password>' toolboc/azure-iot-edge-device-container

The device will automatically register itself as an Edge device within the specified IoT Hub using the hostname of the container instance.  

You can use the environment tag to specify a Target Condition to apply apply an IoT Deployment definition. 

![Edge Deployment Configuration](/Content/Deployment.PNG)
