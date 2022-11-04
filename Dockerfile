FROM --platform=$BUILDPLATFORM alpine:3.16 AS builder

RUN apk add --no-cache curl

ARG TARGETARCH

ARG TUIC_VERSION

WORKDIR /tmp

RUN case "$TARGETARCH" in \
    "amd64") \
    TARGET="x86_64-linux-musl" \
    ;; \
    "arm64") \
    TARGET="aarch64-linux-musl" \
    ;; \
    "arm") \
    TARGET="armv7-linux-musleabihf" \
    ;; \
    *) \
    echo "Doesn't support $TARGETARCH architecture" \
    exit 1 \
    ;; \
    esac \
    && curl -o tuic-client -L "https://github.com/EAimTY/tuic/releases/download/$TUIC_VERSION/tuic-client-$TUIC_VERSION-$TARGET" \
    && curl -o tuic-server -L "https://github.com/EAimTY/tuic/releases/download/$TUIC_VERSION/tuic-server-$TUIC_VERSION-$TARGET" \
    && chmod +x tuic-client && chmod +x tuic-server

FROM alpine:3.16 AS tuic-client

COPY --from=builder /tmp/tuic-client /usr/local/bin/

CMD [ "/usr/local/bin/tuic-client", "-c", "/etc/tuic-client/config.json" ]

FROM alpine:3.16 AS tuic-server

COPY --from=builder /tmp/tuic-server /usr/local/bin/

CMD [ "/usr/local/bin/tuic-server", "-c", "/etc/tuic-server/config.json" ]
