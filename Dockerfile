FROM adoptopenjdk:11-jdk-hotspot

RUN set -ex ; \
    apt-get -y update ; \
    apt-get -y install libgtk-3-0 \
              libx11-6 \
              libx11-xcb1 \
              libxcb1 \
              libxcomposite1 \
              libxcursor1 \
              libxdamage1 \
              libxext6 \
              libxfixes3 \
              libxi6 \
              libxrender1 \
              libdbus-glib-1-2 \
              libdbus-1-3 \
              libglib2.0-0 \
              libpangocairo-1.0-0 \
              libpango-1.0-0 \
              libharfbuzz0b \
              libatk1.0-0 \
              libcairo-gobject2 \
              libcairo2 \
              libgdk-pixbuf2.0-0 \
              libxcb-shm0 \
              libpangoft2-1.0-0 \
              libxt6 ; \
    apt-get clean

RUN curl -Ls "https://github.com/jbangdev/jbang/releases/download/v0.79.0/jbang-0.79.0.zip" --output jbang.zip \
              && jar xf jbang.zip && rm jbang.zip && mv jbang-* jbang && chmod +x jbang/bin/jbang

ADD ./entrypoint /bin/entrypoint

ENV SCRIPTS_HOME /scripts
ENV JBANG_VERSION 0.79.0

# Needed for secure run on openshift but breaks github actions
# removed until can find better alternative
# RUN useradd -u 10001 -r -g 0 -m \
#      -d ${SCRIPTS_HOME} -s /sbin/nologin -c "jbang user" jo \
#    && chmod -R g+w /scripts \
#    && chmod -R g+w /jbang \
#    && chgrp -R root /scripts \
#    && chgrp -R root /jbang \
#    && chmod g+w /etc/passwd \
#    && chmod +x /bin/entrypoint

VOLUME /scripts

# USER 10001

ENV PATH="${PATH}:/jbang/bin"

## github action does not allow writing to $HOME thus routing this elsewhere
ENV JBANG_DIR="/jbang/.jbang"

ENTRYPOINT ["entrypoint"]