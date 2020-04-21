FROM ubuntu:19.04
MAINTAINER Szczepan Kozioł <szczepankoziol@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git && \
    apt-get install -qy curl && \
    apt-get install -qy build-essential && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 8 (latest stable edition at 2019-04-01)
    apt-get install -qy default-jdk && \
# Install NodeJS
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -qy nodejs && \
# Install NPM
    apt-get install -qy npm && \
# Install Angular CLI 8
    npm install -g @angular/cli@8 && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd
    
#RUN chown -R jenkins:jenkins /home/jenkins/.m2/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
