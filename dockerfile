FROM python:3.11-bookworm
# Install system dependencies
RUN apt update && apt upgrade -y && apt install unixodbc-dev curl gnupg -y
# odbc driver
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/debian/12/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

RUN apt update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN apt install freetds-dev libssl-dev -y
RUN apt purge curl gnupg freetds-dev libssl-dev -y
# Env Vars
ENV PYTHONUNBUFFERED=1
ENV PIP_DEFAULT_TIMEOUT=100
# Update PIP
RUN python -m pip install -U setuptools pip
# Copy poetry files
COPY poetry.lock .
COPY pyproject.toml .
# Install poetry
RUN pip install poetry && \
    poetry export -f requirements.txt --output requirements.txt --without-hashes --with others,docker && \
    rm -rf poetry.lock pyproject.toml && \
    python -m pip install --upgrade -r requirements.txt && \
    rm requirements.txt
