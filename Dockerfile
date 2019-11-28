FROM python:3.7-alpine
RUN apk add gcc python3-dev musl-dev make
COPY . /
WORKDIR /
RUN make setup dist


FROM python:3.8.0-alpine3.10
LABEL maintainer="Wazo Authors <dev@wazo.community>"
ENV VERSION 1.1.0
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
    vim \
    nano \
    jq \
    python3 \
    py-pip
RUN pip3 install pytest
COPY --from=0 /dist /dist
RUN pip3 install /dist/wazotester-1.1-py3-none-any.whl && rm -r /dist/
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --update consul-template && rm -rf /var/lib/apt/lists/*
COPY ./scripts/wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for
