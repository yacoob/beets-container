FROM yacoob/interactive:latest
USER root
RUN apt-get update && apt-get install -y python3 python3-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER yacoob
RUN python3 -mvenv beets && ./beets/bin/pip install beets pylast flask python3-discogs-client && echo 'source ~/beets/bin/activate' > ~/.zshrc.local