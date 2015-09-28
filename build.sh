#!/bin/bash

echo "** Starting..."

rm -rf dpl_s3
mkdir -p dpl_s3
rm -rf build
mkdir build

echo "** Building..."
./node_modules/.bin/electron-packager ./build/electron Gateblu --platform=all --arch=all --version=0.33.2
