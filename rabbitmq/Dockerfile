FROM ubuntu:focal

ARG RABBITMQ_VERSION
ARG ERLANG_VERSION
ARG APPDIR="/opt/app"

ENV APPDIR="${APPDIR}"

ENV PATH="/opt/rabbitmq/${RABBITMQ_VERSION}/sbin:${PATH}"
ENV PATH="/opt/erlang/${ERLANG_VERSION}/bin:${PATH}"

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install wget xz-utils openjdk-11-jdk lib32ncurses-dev make g++ unixodbc-dev libssh-dev libwxgtk-webview3.0-gtk3-dev -y

RUN useradd -s /bin/bash -m -d ${APPDIR} rabbitmq && \
    chmod 700 ${APPDIR}

WORKDIR /tmp

RUN mkdir -p /opt/rabbitmq/${RABBITMQ_VERSION} && \
    wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz -O rabbit.tar.xz && \
    tar -xf rabbit.tar.xz -C /opt/rabbitmq/${RABBITMQ_VERSION} --strip-components=1 && \
    rm -f rabbit.tar.xz

RUN mkdir -p /opt/erlang/${ERLANG_VERSION} && \
    wget https://erlang.org/download/otp_src_${ERLANG_VERSION}.tar.gz -O erlang.tar.gz && \
    tar -xf erlang.tar.gz -C . --strip-components=1 && \
    rm -f erlang.tar.gz

RUN ./configure --prefix=/opt/erlang/${ERLANG_VERSION} &&  \
    make && \
    make install

RUN apt-get install -y locales

USER rabbitmq
WORKDIR ${APPDIR}

RUN mkdir -p etc log lib/mnesia

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV IS_MGMT="false"
ENV RABBITMQ_HOME="${APPDIR}"
ENV RABBITMQ_CONFIG_FILE="${APPDIR}/etc/rabbitmq.conf"
ENV RABBITMQ_LOG_BASE="${APPDIR}/log"
ENV RABBITMQ_MNESIA_BASE="${APPDIR}/lib/mnesia"
ENV RABBITMQ_ENABLED_PLUGINS_FILE="${APPDIR}/etc/enabled_plugins"

COPY --chown=rabbitmq ./files/erlang.cookie .erlang.cookie
RUN chmod 400 .erlang.cookie

COPY --chown=rabbitmq ./entrypoint.sh .

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]