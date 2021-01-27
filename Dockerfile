FROM sabotagecla6/ubuntu_ui_jp

# ***********************************************
# install packages for xrdp, and do setting
# ***********************************************
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gnupg firefox

# ***********************************************
# prepare add user
# ***********************************************
RUN chmod u+s /usr/sbin/useradd \
    && chmod u+s /usr/sbin/groupadd \
    && chmod u+s /usr/sbin/chpasswd

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL

# ***********************************************
# install vscode
# ***********************************************
ADD https://az764295.vo.msecnd.net/stable/ea3859d4ba2f3e577a159bc91e3074c5d85c0523/code_1.52.1-1608136922_amd64.deb /tmp/code_1.52.1-1608136922_amd64.deb
RUN dpkg -i /tmp/code_1.52.1-1608136922_amd64.deb

RUN echo "uninitilze" > /tmp/uninitilze

# ***********************************************
# copy entrypoint shell
# ***********************************************
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]