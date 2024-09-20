# # Use the Apache Airflow base image with Python 3.9
# FROM apache/airflow:2.6.0-python3.9

# # Switch to root user temporarily to install system dependencies
# USER root

# # Install system dependencies
# RUN apt-get update && \
#     apt-get install -y gcc python3-dev && \
#     rm -rf /var/lib/apt/lists/*

# # Switch back to the airflow user
# USER airflow

# # Set the working directory to the airflow home directory
# WORKDIR /opt/airflow

# # Copy requirements.txt and install dependencies
# COPY requirements.txt /requirements.txt
# RUN pip install --no-cache-dir -r /requirements.txt

# # Copy entrypoint script
# COPY script/entrypoint.sh /opt/airflow/script/entrypoint.sh 
# #

# # Set executable permissions on the entrypoint script
# # RUN chmod +x /opt/airflow/script/entrypoint.sh

# # Expose the webserver portdocker ps
# EXPOSE 8080

# # Set the entrypoint command for the webserver
# ENTRYPOINT ["/opt/airflow/script/entrypoint.sh"]

# # Set default command to run the webserver
# CMD ["webserver"]

# Use the Apache Airflow base image with Python 3.9
FROM apache/airflow:latest

# Switch to root user temporarily to install system dependencies
USER root

# Install system dependencies
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         gcc \
#         python3-dev \
#         && rm -rf /var/lib/apt/lists/*
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
        curl \
        iputils-ping \
        && rm -rf /var/lib/apt/lists/*

# Switch back to the airflow user
USER airflow

# Set the working directory to the airflow home directory
WORKDIR /opt/airflow

# Install additional Python packages
RUN pip install --no-cache-dir kafka-python six   
##############

# Copy requirements.txt and install dependencies
COPY requirements.txt /opt/airflow/requirements.txt
RUN pip install --no-cache-dir -r /opt/airflow/requirements.txt

# Set PYTHONPATH
ENV PYTHONPATH="/home/airflow/.local/lib/python3.12/site-packages:${PYTHONPATH}"

# Copy entrypoint script
COPY script/entrypoint.sh /opt/airflow/script/entrypoint.sh
# RUN chmod +x /opt/airflow/script/entrypoint.sh

# Expose the webserver port
EXPOSE 8080

# Set the entrypoint command for the webserver
ENTRYPOINT ["/opt/airflow/script/entrypoint.sh"]

# Set default command to run the webserver
CMD ["webserver"]

