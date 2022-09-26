FROM ubuntu:22.04
RUN apt-get update && apt-get install -y wget curl gnupg2 openjdk-11-jdk \
                                                          apt-transport-https 
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
   echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" |  tee –a /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update && apt-get install -y filebeat   \
             vim \
             git \
             python3.9  \
             gettext-base && \
             echo "vm.max_map_count=262144" >> /etc/sysctl.conf && \
             sysctl -p
COPY entry.sh wait_for_elastic.sh /usr/bin/
EXPOSE 5404
ENTRYPOINT ["entry.sh"]
