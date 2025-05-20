FROM debian:bullseye-slim

RUN apt-get update -qq && apt-get install -qq --no-install-recommends -y \
    curl \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG CODE_SERVER_VERSION=4.21.1

RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=${CODE_SERVER_VERSION}

RUN mkdir -p /root/workspace /root/.config/code-server \
    && echo "bind-addr: 0.0.0.0:8080\nauth: password\npassword: yexxura\ncert: false" > /root/.config/code-server/config.yaml

RUN echo '#!/bin/bash\nwhile true; do\n  code-server --bind-addr 0.0.0.0:8080 --auth password --user-data-dir /root/.config/code-server\n  echo "code-server exited with status $?. Restarting in 15 seconds..."\n  sleep 15\ndone' > /root/start.sh \
    && chmod +x /root/start.sh

WORKDIR /root/workspace

EXPOSE 8080

CMD ["/root/start.sh"]
