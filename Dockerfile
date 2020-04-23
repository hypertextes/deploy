# Docker Image
FROM debian:bulleyes-slim

# Github Action Metadata
LABEL "com.github.actions.name"="hypertextes/deploy"

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install wget & git
RUN apt-get update && apt-get install -y wget git

# Install Zola
RUN wget -q -O - \
"https://github.com/getzola/zola/releases/download/v0.10.1/zola-v0.10.1-x86_64-unknown-linux-gnu.tar.gz" \
| tar xzf - -C /usr/local/bin

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]