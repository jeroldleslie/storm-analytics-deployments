FROM ubuntu:latest
MAINTAINER Peter Jerold Leslie 


RUN apt-get update -y

#"Add software-properties-common"
RUN apt-get install -y software-properties-common 
#Required for apt-add-repository
#RUN apt-add-repository ppa:ansible/ansible
#RUN apt-get update

RUN apt-add-repository ppa:ansible/ansible

RUN apt-get update -y

RUN apt-get install ansible -y

RUN apt-get install git -y

#"Expose SSH port"
EXPOSE 22 2181 9092 50070 8088 9000 9300

#"Install openssh"
RUN apt-get install -y openssh-server openssh-client 

##"Install ansible"
#RUN apt-get install -y ansible

#"Install basic packages"
RUN apt-get install -y vim nano wget

#"Configure root Account"
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd

#"Install OpenJDK8"
RUN apt-get install -y openjdk-8-jdk
RUN echo 'JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> /etc/environment

#"SSH login fix for Docker"
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

#"Setup sneha user"
RUN useradd -m -d /home/sneha -s /bin/bash -c "sneha user" -p $(openssl passwd -1 sneha)  sneha
#"sneha ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R sneha:sneha /opt

#"Sets up public keys for ssh.  Assumes your public keys are stored in ./tmp"
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
ADD tmp/authorized_keys /root/.ssh/authorized_keys
RUN chmod 644 /root/.ssh/authorized_keys

RUN mkdir -p /home/sneha/.ssh
RUN chown -R sneha:sneha /home/sneha/.ssh
RUN chmod 700 /home/sneha/.ssh
ADD tmp/authorized_keys /home/sneha/.ssh/authorized_keys
RUN chmod 644 /home/sneha/.ssh/authorized_keys

#"Start sshd service"
CMD ["/usr/sbin/sshd", "-D"]
