FROM adriagalin/jenkins-jnlp-slave:1.4

WORKDIR /

#Add Helm
ENV HELM_VERSION v2.14.3
ENV HELM_FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz
RUN curl -L http://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} | tar zxv -C /tmp && \
    cp /tmp/linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm

#Add Azure Cli
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list && \
    echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list && \
    sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get -y install curl apt-transport-https lsb-release gnupg && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
      gpg --dearmor | \
      tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    export AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
      tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get -y install azure-cli

RUN helm init --client-only && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin list
