FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    python3 \
    python3-pip \
    python3-distutils \
    curl \
    git \
    netcat \
    net-tools \
    telnet \
    dnsutils \
    iputils-ping \
    nmap \
    software-properties-common \
    sudo \
    wget \
    vim

# Install Python 3.12
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.12 python3.12-venv python3.12-distutils && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --set python3 /usr/bin/python3.12 && \
    rm -rf /var/lib/apt/lists/*

# Ensure pip is installed for Python 3.12 and upgrade setuptools
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.12 get-pip.py && \
    rm get-pip.py && \
    pip3 install --upgrade pip setuptools

# Set up SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

# Create user 'sammy', add to root group, and set password
RUN useradd -rm -d /home/sammy -s /bin/bash -g root -G sudo -u 1000 sammy
RUN echo 'sammy:sammysheu' | chpasswd

# Set up SSH for sammy
RUN mkdir -p /home/sammy/.ssh
COPY public_keys/id_rsa.pub /home/sammy/.ssh/authorized_keys
RUN chown sammy:root /home/sammy/.ssh/authorized_keys && \
    chmod 600 /home/sammy/.ssh/authorized_keys

WORKDIR /home/sammy

COPY apt_packages/apt_list.txt apt_list.txt
RUN apt-get update && xargs -a apt_list.txt apt-get install -y
RUN rm -rf /var/lib/apt/lists/*

COPY pip_packages/requirements.txt requirements.txt
RUN pip install --use-pep517 -r requirements.txt

# Copy VSCode Server setup script
COPY vscode-server-setup.sh /tmp/vscode-server-setup.sh
RUN chmod +x /tmp/vscode-server-setup.sh

# Run VSCode Server setup script
# RUN /tmp/vscode-server-setup.sh && rm /tmp/vscode-server-setup.sh

EXPOSE 22

# Copy startup script
COPY start-services.sh /start-services.sh
RUN chmod +x /start-services.sh
WORKDIR /root
CMD ["/start-services.sh"]