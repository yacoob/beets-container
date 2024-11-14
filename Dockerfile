# hadolint global ignore=DL3041

FROM yacoob/interactive:base AS builder
USER root
RUN dnf install --setopt=install_weak_deps=False -y \
      ffmpeg \
      python3 \
      aubio-python3 \
      python3-numpy \
      python3-pylast \
  && dnf clean all
WORKDIR /tmp
# Install beets + plugin
USER yacoob
WORKDIR /home/yacoob
RUN python3 -mvenv --system-site-packages beets && \
  ./beets/bin/pip install \
    beets \
    beets-bpmanalyser \
    beets-describe \
    python3-discogs-client \
  && rm -rf /home/yacoob/.cache \
  && echo 'source ~/beets/bin/activate' >> ~/.zshrc.local

FROM yacoob/interactive:base AS beets
COPY --from=builder / /
