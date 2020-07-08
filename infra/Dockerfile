from ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# catch logs for background processes and send to /var/log/s6-uncaught-logs
ENV S6_LOGGING=1

RUN apt-get -qq update
RUN apt-get -qq install unzip iproute2 python3 python3-pip curl s6 less
RUN pip3 install virtualenv-tools3


RUN curl -o /tmp/nomad.zip https://releases.hashicorp.com/nomad/0.11.3/nomad_0.11.3_linux_amd64.zip
RUN unzip -d /usr/local/nomad /tmp/nomad.zip
RUN ln -s /usr/local/nomad/nomad /usr/local/bin/nomad

RUN curl -o /tmp/consul.zip https://releases.hashicorp.com/consul/1.8.0/consul_1.8.0_linux_amd64.zip
RUN unzip -d /usr/local/consul /tmp/consul.zip
RUN ln -s /usr/local/consul/consul /usr/local/bin/consul

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.0.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar --skip-old-files -zxvf /tmp/s6-overlay-amd64.tar.gz -C /

RUN curl -L -o /usr/local/bin/fabio https://github.com/fabiolb/fabio/releases/download/v1.5.13/fabio-1.5.13-go1.13.4-linux_amd64 && chmod +x /usr/local/bin/fabio

RUN curl -L https://github.com/joseluisq/static-web-server/releases/download/v1.9.2/static-web-server-v1.9.2-x86_64-unknown-linux-musl.tar.gz | tar -C /usr/local/bin/ -xz

ADD overlay/ /

ENTRYPOINT ["/init"]
