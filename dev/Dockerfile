FROM easybe/alpine-reviewboard:4.0.1

RUN apk --no-cache add \
        nodejs-npm && \
    pip install --no-cache-dir \
        kgb \
        mock \
        nose

VOLUME "/src"
WORKDIR /src
EXPOSE 8080

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
