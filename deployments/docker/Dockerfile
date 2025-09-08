# deployments/docker/Dockerfile
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1 TZ=Etc/UTC

# System deps: python + venv + cron + tzdata
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-venv cron tzdata ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Create a dedicated virtualenv and use it for all Python commands
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

WORKDIR /app

# Install deps with good Docker layer caching
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Then copy the rest of the code
COPY . /app

# Cron-based entrypoint that uses python from the venv via PATH
ENTRYPOINT ["/app/deployments/docker/entrypoint.sh"]