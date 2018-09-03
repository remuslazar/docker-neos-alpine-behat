FROM remuslazar/docker-neos-alpine:testing-php56
MAINTAINER Remus Lazar <rl@cron.eu>

# install jre, selenium, firefox and xvfb
RUN apk --update add openjdk8 xorg-server xvfb firefox-esr curl libvncserver openssl dbus \
  && curl -sSL -o /usr/bin/selenium-server-standalone.jar http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar \
  && rm -rf /var/cache/apk/*

# remove unneeded services for our scope
RUN rm -rf /etc/services.d/{nginx,php-fpm,sshd,crond}

# we do compile x11vnc from sources (unfortunately there is no binary package available..)
RUN apk --update add --virtual=.x11vncdeps gcc g++ automake autoconf make openssl-dev libx11-dev libvncserver-dev \
  && mkdir -p /src && cd /src \
  && git clone https://github.com/LibVNC/x11vnc \
  && cd x11vnc \
  && ./autogen.sh \
  && make \
  && make install \
  && apk del .x11vncdeps \
  && cd / && rm -rf /src \
  && rm -rf /var/cache/apk/*

ENV \
  DISPLAY=:99 \
  SCREEN_DIMENSION=1600x1000x24 \
  VNC_PASSWORD=password

COPY container-files /

EXPOSE 4444 5900

ENTRYPOINT ["/bootstrap.sh"]
