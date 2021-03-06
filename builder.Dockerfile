FROM fedora:30

ENV HOME=/home/workspace/

WORKDIR $HOME

RUN dnf install -y \
        libffi-devel \
        origin-clients \
        python3-pip \
        git \
        wget \
        python37 \
        python36 \
        gcc \
        postgresql-devel \
        python3-devel \
        make \
        krb5-devel && \
    dnf clean all && \
    curl -ksL https://url.corp.redhat.com/98bcda0 -o /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt

RUN pip3 install -U pip tox tox-venv setuptools setuptools-scm pre-commit devpi-client

RUN git init

COPY .pre-commit-config.yaml .
COPY uid_entrypoint.sh /

RUN update-ca-trust && \
    pre-commit install-hooks && \
    chmod -R g=u $HOME /etc/passwd && \
    chgrp -R 0 $HOME && \
    chmod a+x /uid_entrypoint.sh

ENV REQUESTS_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt

USER 1000

ENTRYPOINT ["/uid_entrypoint.sh"]
