FROM debian:bookworm
RUN apt update && apt install -y xdotool xvfb curl firefox-esr dbus-x11 x11vnc x11-apps imagemagick chromium locales chromium-driver


RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then URL="https://github.com/mozilla/geckodriver/releases/download/v0.32.0/geckodriver-v0.32.0-linux64.tar.gz"; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then URL="https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-arm7hf.tar.gz"; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then URL="https://github.com/mozilla/geckodriver/releases/download/v0.32.0/geckodriver-v0.32.0-aarch64.tar.gz"; else URL="https://github.com/mozilla/geckodriver/releases/download/v0.32.0/geckodriver-v0.32.0-linux64.tar.gz"; fi \
    && curl -L "$URL" -o geckodriver.tar.gz \
    && tar -xf geckodriver.tar.gz && mv geckodriver /usr/bin/geckodriver && rm geckodriver.tar.gz

# Set the locale
RUN sed -i '/es_ES.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES:es  
ENV LC_ALL es_ES.UTF-8     

ENV DISPLAY=:0

ENV VNC=false
ENV CHROME=false
ENV FIREFOX=false

COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT [ "./docker-entrypoint.sh" ]
