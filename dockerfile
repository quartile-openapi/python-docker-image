FROM python:latest
# Install system dependencies
RUN apt update && apt upgrade -y && apt install unixodbc-dev curl gnupg libreoffice -y
# odbc driver
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
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
RUN pip install poetry
# Create requirements.txt
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes --with others
# Install pip requirements
RUN python -m pip install --upgrade -r requirements.txt && rm requirements.txt
