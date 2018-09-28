FROM centos:7

MAINTAINER  <admin@vyunwei.com>

# - Install basic packages (e.g. python-setuptools is required to have python's easy_install)
# - Install yum-utils so we have yum-config-manager tool available
# - Install inotify, needed to automate daemon restarts after config file changes
# - Install jq, small library for handling JSON files/api from CLI
# - Install supervisord (via python's easy_install - as it has the newest 3.x version)
# - Install rsync

RUN \
  rpm --rebuilddb && yum clean all && \
  yum install -y epel-release && \
  yum update -y && \
  yum install -y \
                  iproute \
                  python-setuptools \
                  hostname \
                  inotify-tools \
                  yum-utils \
                  which \
                  jq \
                  rsync \
                  python-pip \
                  privoxy && \
  yum clean all && \
  easy_install supervisor \
  pip install shadowsocks

# Add supervisord conf, bootstrap.sh files
COPY container-files /
COPY shadowsocks/shadowsocks.json /data/www/
COPY supervisord/ss.conf   /etc/supervisor.d/
COPY privoxy/config        /etc/privoxy/config

ENTRYPOINT ["/config/bootstrap.sh"]
