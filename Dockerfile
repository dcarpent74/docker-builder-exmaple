FROM centos:centos7.9.2009
RUN yum update -y && yum clean all
RUN yum install sudo gcc make glibc-static -y && yum clean all
ARG UID=1000
ARG GID=1000
ARG USERNAME=testuser
ARG GROUPNAME=testuser
RUN groupadd -g $GID $GROUPNAME
RUN useradd -d /home/$USERNAME -m -k /etc/skel -u $UID -g $GROUPNAME -G wheel $USERNAME
RUN echo $USERNAME:password | chpasswd
USER $USERNAME:$GROUPNAME
WORKDIR /src
CMD [ "make clean ; make ; make install" ]
ENTRYPOINT [ "/bin/bash", "-c" ]
