#!/bin/bash

IMAGE="abates314/adb-server"

echo "Building Docker images"
docker buildx build --push --platform linux/arm,linux/386,linux/amd64 -t $IMAGE .
