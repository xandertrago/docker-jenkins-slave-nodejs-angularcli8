FROM ubuntu:18.04
MAINTAINER Szczepan Kozioł <szczepankoziol@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update && apt-get -qy full-upgrade && apt-get -qy install \
    git \
    curl \
    apt-transport-https \
    build-essential \
# Install a basic SSH server
    openssh-server \
# Install JDK
    default-jdk && \    
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install NodeJS
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -qy nodejs && \
# Install Angular CLI 8
    npm update && \
    npm install -g @angular/cli@8 && \
    npm install -g @angular-devkit/build-angular && \
    npm install -g @angular/compiler-cli && \
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
