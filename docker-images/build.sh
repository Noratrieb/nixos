#!/usr/bin/env bash

p=$(dirname "$0")

for dockerfile in "$p"/*.Dockerfile; do
    imgname=$(basename "$dockerfile" .Dockerfile)
    echo "Building $dockerfile"

    docker build "$p" -t "$imgname:latest" -f "$dockerfile"
done
