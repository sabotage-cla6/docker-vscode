FROM sabotagecla6/vscode_base

# ***********************************************
# prepare add user
# ***********************************************
RUN chmod u+s /usr/sbin/useradd \
    && chmod u+s /usr/sbin/groupadd \
    && chmod u+s /usr/sbin/chpasswd

RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL

# ***********************************************
# copy entrypoint shell
# ***********************************************
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
