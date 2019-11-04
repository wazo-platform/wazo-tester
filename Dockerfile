FROM alpine:3.10
LABEL maintainer="Wazo Authors <dev@wazo.community>"
ENV VERSION 1.0.0

RUN apk add --update \
    bash \
    sudo \
    netcat-openbsd \
    iproute2 \
    sngrep \
    ngrep \
    sipsak \
    sipp \
    curl \
    jq \
    python3 \
    py-pip

COPY ./dist/wazotester-1.0.tar.gz /wazotester-1.0.tar.gz
RUN pip3 install /wazotester-1.0.tar.gz

COPY ./scripts/wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for
