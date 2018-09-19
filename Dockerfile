FROM ubuntu:18.04

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    jq \
    net-tools \
    iptables \
    iproute2 \
    systemd && \
    rm -rf /var/lib/apt/lists/*

RUN AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
    curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > ./microsoft-prod.list && \
    cp ./microsoft-prod.list /etc/apt/sources.list.d/ && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    cp ./microsoft.gpg /etc/apt/trusted.gpg.d/ 

RUN apt-get update && apt-get install -y --no-install-recommends \
    azure-cli \
    moby-cli \
    moby-engine && \ 
    apt-get install -y --no-install-recommends iotedge=1.0.0-1 && \ 
    rm -rf /var/lib/apt/lists/*
    
RUN az extension add --name azure-cli-iot-ext

COPY edge-provision.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/edge-provision.sh

VOLUME /var/lib/docker

EXPOSE 2375
EXPOSE 15580
EXPOSE 15581

ENTRYPOINT ["bash", "edge-provision.sh"]

CMD []