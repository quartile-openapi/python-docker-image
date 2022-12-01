FROM docker.io/quartile/basepython:alpine@sha256:3bc1e25094f44a4445efc1a459a2035aa4e678756cd84f8835d1148ca7751182
# INSTALL DEPENDENCIES
RUN apk update
RUN apk add \
    build-base \
    freetds-dev \
    g++ \
    gcc \
    gfortran \
    gnupg \
    libffi-dev \
    libpng-dev \
    libsasl \
    openblas-dev \
    openssl-dev \
    unixodbc \
    unixodbc-dev

RUN apk add git cmake
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
# REMOVE CACHE
RUN rm -rf /var/cache/apk/*
# UPDATE APT-GET
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.8.1.1-1_amd64.apk
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.8.1.1-1_amd64.apk
# (Optional) Verify signature, if 'gpg' is missing install it using 'apk add gnupg':
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.8.1.1-1_amd64.sig
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.8.1.1-1_amd64.sig
# Add MS keys
RUN curl https://packages.microsoft.com/keys/microsoft.asc  | gpg --import -
RUN gpg --verify msodbcsql17_17.8.1.1-1_amd64.sig msodbcsql17_17.8.1.1-1_amd64.apk
RUN gpg --verify mssql-tools_17.8.1.1-1_amd64.sig mssql-tools_17.8.1.1-1_amd64.apk
# Install the package(s)
RUN apk add --allow-untrusted msodbcsql17_17.8.1.1-1_amd64.apk
RUN apk add --allow-untrusted mssql-tools_17.8.1.1-1_amd64.apk
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

RUN echo "http://dl-8.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
# Remove download file
RUN rm -rf ms*
# Update PIP
RUN pip install -U setuptools pip
# Copy file
COPY requirements.txt .
# Install pip requirements
RUN pip install -r requirements.txt
# show libs
RUN echo $(pip freeze) && sleep 11