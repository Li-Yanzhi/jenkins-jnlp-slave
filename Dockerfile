FROM jenkinsci/jnlp-slave

WORKDIR /

USER root

# Install docker client, kubectl and helm
RUN curl -sSL https://get.docker.com/ | sh && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm -f get_helm.sh && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod 755 kubectl && \
    mv kubectl /usr/local/bin/kubectl

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
