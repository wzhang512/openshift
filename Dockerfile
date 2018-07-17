# Use centos as the base layer
FROM centos

USER root

# MAINTAINER is deprecated, use LABEL instead
LABEL maintainer="Ian Yan <iyan@tibco.com>"

# Product specific labels
LABEL io.k8s.display-name="TIBCO DataSynapse GridServer Engine"
LABEL tibco.gridserver.version="6.2.0"
LABEL summary="Provides GridServer Engine base image"

# Obtain the vendor-provided archive from external storage
#ARG GS_ARCHIVE_URL=http://192.168.0.8:8080/livecluster/public_html/register/install/unixengine/DSEngineLinux64.tar.gz
ARG GS_ARCHIVE_URL=http://lin64vm475.rofa.tibco.com:8080/livecluster/public_html/register/install/unixengine/DSEngineLinux64.tar.gz
#ARG GS_ARCHIVE_URL=http://192.168.0.8:888/download/DSEngineLinux64-6.2.0.tar.gz

# The maximum heap size, in MB, as specified by the -Xmx<size> java option.
# Default is 1024m
ARG JVM_MAX_HEAP="1024m"

# Download the archive and extract it without writing the archive file to disk
RUN curl $GS_ARCHIVE_URL | tar xz -C /opt

# Manager communications (between directors and brokers)
EXPOSE 27159/tcp

RUN yum -y install bind-utils file hostname iproute iputils net-tools nmap traceroute && yum clean all -y

WORKDIR /opt/datasynapse/engine

RUN chmod -R a+w /opt/datasynapse/engine

CMD cd /opt/datasynapse/engine && ./configure.sh -s lin64vm475.rofa.tibco.com:8080 && ./engine.sh start && tail -F /etc/hosts