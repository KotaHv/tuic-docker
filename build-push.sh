#!/bin/bash

if test -z "$TUIC_VERSION";then
	echo "TUIC_VERSION not exist"
    exit 1;
fi

echo "tuic version: $TUIC_VERSION"

docker buildx build --platform linux/arm,linux/arm64,linux/amd64 --target tuic-client -t kotahv/tuic-client:latest -t "kotahv/tuic-client:$TUIC_VERSION" --build-arg "TUIC_VERSION=$TUIC_VERSION" . --push

docker buildx build --platform linux/arm,linux/arm64,linux/amd64 --target tuic-server -t kotahv/tuic-server:latest -t "kotahv/tuic-server:$TUIC_VERSION" --build-arg "TUIC_VERSION=$TUIC_VERSION" . --push
