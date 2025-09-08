FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1 TZ=Etc/UTC
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-venv ca-certificates tzdata \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Copy the *whole repo* so docker run matches your working tree
COPY ../../ /app

# Default entry: run the app
ENTRYPOINT ["python3", "-m", "apps.queue_automation.main"]