FROM arangodb:3.5.3

# Build arguments passed into the docker command for image metadata
ARG BUILD_DATE
ARG COMMIT
ARG BRANCH

# RUN pip install requests docker python-json-logger structlog && \
RUN apk update && \
    apk add p7zip && \
    cd /tmp && \
    wget https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    mv rclone-v1.55.1-linux-amd64/rclone /bin/rclone && \
    mkdir -p /root/.config/rclone/

COPY rclone.conf /root/.config/rclone/rclone.conf
COPY app/ /app/

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/kbase/db_zip2cloud.git" \
      org.label-schema.vcs-ref=$COMMIT \
      org.label-schema.schema-version="1.0.0-rc1" \
      us.kbase.vcs-branch=$BRANCH  \
      maintainer="Steve Chan sychan@lbl.gov" \
      org.opencontainers.image.source="https://github.com/kbase/db_zip2cloud"

WORKDIR /app

ENTRYPOINT /bin/sh

CMD /app/zip2cloud
