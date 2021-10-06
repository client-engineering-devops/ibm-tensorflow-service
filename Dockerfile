FROM tensorflow/serving:2.4.2 as TENSORFLOW_SERVER

SHELL ["/bin/bash", "-c"]

# Set the locale
RUN  echo 'Acquire {http::Pipeline-Depth "0";};' >> /etc/apt/apt.conf
RUN DEBIAN_FRONTEND="noninteractive"
RUN apt-get update  && apt-get -y install --no-install-recommends locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y --no-install-recommends \
    wget \
    git \
    python3-pip \
    openssh-client \
    python3-setuptools \
    google-perftools && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash -g root -G sudo -u 1000 tflow 

WORKDIR /tmp