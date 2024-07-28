FROM ruby:3.2.2-bookworm as builder

ARG NAROU_VERSION=3.9.0
ARG AOZORAEPUB3_VERSION=1.1.1b18Q
ARG AOZORAEPUB3_FILE=AozoraEpub3-${AOZORAEPUB3_VERSION}

RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    jlink --no-header-files --no-man-pages --compress=2 --strip-debug \
    	  --add-modules java.base,java.datatransfer,java.desktop \
          --output /opt/jre && \
    gem install narou -v ${NAROU_VERSION} --no-document && \
    wget https://github.com/kyukyunyorituryo/AozoraEpub3/releases/download/v${AOZORAEPUB3_VERSION}/${AOZORAEPUB3_FILE}.zip && \
    unzip ${AOZORAEPUB3_FILE} && \
    mv ${AOZORAEPUB3_FILE} /opt/aozoraepub3

FROM ruby:3.2.2-slim-bookworm

ARG UID=1000
ARG GID=1000

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /opt /opt
COPY --from=builder /lib/x86_64-linux-gnu/libjpeg* /lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjpeg* /usr/lib/x86_64-linux-gnu/
COPY init.sh /usr/local/bin

ENV JAVA_HOME=/opt/jre
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN groupadd -g ${GID} narou && \
    useradd -m -s /bin/bash -u ${UID} -g ${GID} narou && \
    chmod +x /usr/local/bin/init.sh

USER narou

WORKDIR /home/narou/novel

EXPOSE 33000-33001

ENTRYPOINT ["init.sh"]
CMD ["narou", "web", "-np", "33000"]
