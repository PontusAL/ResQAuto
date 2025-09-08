FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1 TZ=Etc/UTC

# python + cron + tzdata
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 cron tzdata ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# build context will be repo root (see compose below)
COPY . /app

# default entrypoint runs cron with your schedule
ENTRYPOINT ["/app/deployments/docker/entrypoint.sh"]