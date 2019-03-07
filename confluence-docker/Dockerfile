FROM openjdk:8-alpine

ENV CONF_DIR            /var/atlassian/confluence
ENV INSTALL_DIR         /opt/atlassian/confluence
ENV CONFLUENCE_VERSION  6.14.2

ENV JAVA_CACERTS        $JAVA_HOME/jre/lib/security/cacerts
ENV CERTIFICATE         $CONF_DIR/certificate

# Required tools
RUN apk --no-cache add curl xmlstarlet bash

# Configure the configuration directory
RUN mkdir -p "${CONF_DIR}" && \
    chmod -R 700 "${CONF_DIR}" && \
    chown daemon:daemon "${CONF_DIR}"

# Configure the install directory
RUN mkdir -p "${INSTALL_DIR}" && \
    curl -Ls "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz" \
    | tar -xz --directory "${INSTALL_DIR}" --strip-components=1 --no-same-owner

# Give the correct rights to java certs
RUN chown daemon:daemon "${JAVA_CACERTS}"

# Give the correct rights to the installation directory
RUN chmod -R 700 "${INSTALL_DIR}" && chown -R daemon:daemon "${INSTALL_DIR}"

# Configure the confluence HOME in properties
RUN echo -e "\nconfluence.home=$CONF_DIR" >> "${INSTALL_DIR}/confluence/WEB-INF/classes/confluence-init.properties"

RUN xmlstarlet ed --inplace \
    --delete "Server/@debug" \
    --delete "Server/Service/Connector/@debug" \
    --delete "Server/Service/Connector/@useURIValidationHack" \
    --delete "Server/Service/Connector/@minProcessors" \
    --delete "Server/Service/Connector/@maxProcessors" \
    --delete "Server/Service/Engine/@debug" \
    --delete "Server/Service/Engine/Host/@debug" \
    --delete "Server/Service/Engine/Host/Context/@debug" \
    "${INSTALL_DIR}/conf/server.xml"

USER daemon:daemon
WORKDIR /var/atlassian/confluence

CMD ["/bin/bash", "/opt/atlassian/confluence/bin/start-confluence.sh", "-fg"]
