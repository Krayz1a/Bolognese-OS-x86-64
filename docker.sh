#!/bin/bash

sudo docker run --rm -v $(pwd):/workspace os-builder ./build.sh
