FROM yacoob/interactive:base AS builder
USER root
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
      python3 \
      python3-aubio \
      python3-discogs-client \
      python3-numpy \
      python3-pylast \
      python3-venv \
      xz-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /tmp
# Grab a static ffmpeg build - about 160MB worth of saving compared to the pkg
RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz && \
    tar xf ffmpeg-release-amd64-static.tar.xz && \
    install ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg && \
    rm -rf /tmp/ffmpeg*
# Install beets + plugin
USER yacoob
WORKDIR /home/yacoob
RUN python3 -mvenv --system-site-packages beets && \
    ./beets/bin/pip install \
      beets \
      beets-bpmanalyser \
      beets-describe && \
    rm -rf /home/yacoob/.cache && \
    echo 'source ~/beets/bin/activate' >> ~/.zshrc.local

FROM yacoob/interactive:base AS beets
COPY --from=builder / /
