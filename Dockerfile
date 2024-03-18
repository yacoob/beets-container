FROM yacoob/interactive:base as builder
USER root
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
      ffmpeg \
      python3-aubio \
      python3-discogs-client \
      python3-minimal \
      python3-numpy \
      python3-pylast \
      python3-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER yacoob
WORKDIR /home/yacoob
RUN python3 -mvenv --system-site-packages beets && \
    ./beets/bin/pip install \
      beets \
      beets-bpmanalyser \
      beets-describe && \
    echo 'source ~/beets/bin/activate' > ~/.zshrc.local

FROM yacoob/interactive:base as beets
COPY --from=builder / /
