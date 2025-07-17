FROM lscr.io/linuxserver/webtop:latest

WORKDIR /config

# Create the start.sh script, change the timezone if necessary
# Credits: https://github.com/WebGoat/WebGoat/blob/main/config/desktop/start_webgoat.sh
RUN echo "#!/bin/sh" > /config/start.sh && \
    echo "zap.sh -port 8090 &" >> /config/start.sh && \
    echo "java \\" >> /config/start.sh && \
    echo "  -Duser.home=/config \\" >> /config/start.sh && \
    echo "  -Dfile.encoding=UTF-8 \\" >> /config/start.sh && \
    echo "  -DTZ=Europe/Helsinki \\" >> /config/start.sh && \
    echo "  --add-opens java.base/java.lang=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.base/java.util=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.base/java.lang.reflect=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.base/java.text=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.desktop/java.beans=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.desktop/java.awt.font=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.base/sun.nio.ch=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.base/java.io=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  --add-opens java.base/java.util=ALL-UNNAMED \\" >> /config/start.sh && \
    echo "  -Drunning.in.docker=false \\" >> /config/start.sh && \
    echo "  -jar /config/webgoat.jar" >> /config/start.sh && \
	chmod +x /config/start.sh

# Prepare the virtual machine
RUN \
	echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && apk --no-cache add openjdk23-jdk firefox && \
    wget -O /config/webgoat.jar https://github.com/WebGoat/WebGoat/releases/download/v2025.3/webgoat-2025.3.jar && \
    wget https://github.com/zaproxy/zaproxy/releases/download/v2.16.1/ZAP_2_16_1_unix.sh && \
    sudo sh ZAP_2_16_1_unix.sh -q && \
    rm ZAP_2_16_1_unix.sh

WORKDIR /config/Desktop