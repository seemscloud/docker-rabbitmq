FROM ubuntu:focal

ARG APPDIR="/opt/app"

ENV APPDIR="${APPDIR}"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install python3 python3-pip -y

RUN pip3 install --upgrade pip && \
    pip3 install fastapi uvicorn pika

RUN useradd -s /bin/bash -m -d ${APPDIR} fastapi && \
    chmod 700 ${APPDIR}

WORKDIR /opt/app

COPY ./files/main.py .

CMD ["uvicorn", "--host", "0.0.0.0", "--port", "8080", "main:app"]