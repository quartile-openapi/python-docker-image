FROM python:latest
# Install system dependencies
RUN apt update && apt upgrade && apt install unixodbc-dev curl gnupg -y
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
RUN pip install -U setuptools pip
# Copy file
COPY requirements.txt .
# Install pip requirements
RUN python3 -m pip install -r requirements.txt
