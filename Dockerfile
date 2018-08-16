FROM ubuntu:18.04

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    jq

RUN AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
    curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN apt-get update -qq && apt-get install -qqy \
    python-pip \
    azure-cli

RUN az extension add --name azure-cli-iot-ext

RUN pip install -U azure-iot-edge-runtime-ctl

RUN curl -sSL https://get.docker.com/ | sh

COPY edge-provision.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/edge-provision.sh

VOLUME /var/lib/docker

EXPOSE 2375

ENTRYPOINT ["bash", "edge-provision.sh"]

CMD []