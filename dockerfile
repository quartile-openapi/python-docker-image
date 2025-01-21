FROM python:3.13-slim-bullseye
# Install system dependencies
RUN apt update && apt upgrade -y && \
    apt install unixodbc-dev curl gnupg gcc -y && \
    curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17  && \
    apt purge unixodbc-dev curl gnupg -y && apt autoremove -y && apt clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /var/tmp/* && \
    apt update && apt full-upgrade -y &&\
    python -m pip install -U setuptools pip wheel

# Env Vars
ENV PYTHONUNBUFFERED=1
ENV PIP_DEFAULT_TIMEOUT=100
# Copy poetry files
COPY poetry.lock .
COPY pyproject.toml .
# Install poetry
RUN pip install poetry poetry-plugin-export && \
    poetry export -f requirements.txt --output requirements.txt --without-hashes --with azure,logger,dataeng,web,database,others,excel && \
    rm -rf poetry.lock pyproject.toml && \
    python -m pip install --upgrade -r requirements.txt && \
    rm requirements.txt
