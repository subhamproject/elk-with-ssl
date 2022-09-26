FROM ubuntu:22.04
RUN apt-get update && apt-get install -y wget curl gnupg2 openjdk-11-jdk \
                                                          apt-transport-https 
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
   echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" |  tee –a /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update && apt-get install -y elasticsearch  \
             vim \
             git \
             python3.9 \
             openssh-server \
             sudo \
             gettext-base && \
             mkdir -p /var/run/sshd && \
             echo "vm.max_map_count=262144" >> /etc/sysctl.conf && \
             sysctl -p && \
             mkdir -p /data && \
             chown -R elasticsearch:elasticsearch  /data && \
             gpasswd -a elasticsearch sudo && \
             usermod -s /bin/bash elasticsearch && \
             echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
COPY entry.sh wait_for_peer.sh wait_for_port.sh /usr/bin/
EXPOSE 22 9200 9300
USER elasticsearch
ENTRYPOINT ["entry.sh"]
