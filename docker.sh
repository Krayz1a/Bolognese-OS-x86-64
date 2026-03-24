#!/bin/bash

IMAGE_NAME="os-builder"

# Check if the Docker image already exists locally
if [[ "$(sudo docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "--> Image '$IMAGE_NAME' not found. Building it for the first time (this will take a few minutes)..."
    sudo docker build -t $IMAGE_NAME .
fi

# Run the build script inside the container
sudo docker run --rm -v "$(pwd):/workspace" $IMAGE_NAME ./build.sh
