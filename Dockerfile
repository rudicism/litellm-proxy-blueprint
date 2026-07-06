FROM ghcr.io/berriai/litellm:main-latest
COPY litellm-config.yaml /app/config.yaml
# The image's entrypoint is `litellm`, so we pass only args. PORT is pinned to 4000 in
# render.yaml so Render routes to the same port the proxy listens on.
CMD ["--config", "/app/config.yaml", "--host", "0.0.0.0", "--port", "4000"]
