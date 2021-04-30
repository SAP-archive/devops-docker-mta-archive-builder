FROM openjdk:8-jdk-slim

ARG MTA_USER_HOME=/home/mta
ARG MTA_HOME='/opt/sap/mta'


SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY src/shell/mtaBuild.sh ${MTA_HOME}/bin/mtaBuild.sh

RUN set -x  && \
    #
    # Provide dedicated user for running the image
    #
    useradd --home-dir "${MTA_USER_HOME}" \
            --create-home \
            --shell /bin/bash \
            --user-group \
            --uid 1000 \
            --comment 'SAP-MTA tooling' \
            --password "$(echo weUseMta |openssl passwd -1 -stdin)" mta && \
    # allow anybody to write into the images HOME
    ln -s "${MTA_HOME}/bin/mtaBuild.sh" /usr/local/bin/mtaBuild && \
    chmod a+w "${MTA_USER_HOME}"

WORKDIR /project

ENV HOME=${MTA_USER_HOME}


USER mta
