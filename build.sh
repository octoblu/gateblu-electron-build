#!/bin/bash
#!/bin/bash

echo "** Starting..."

START_DIR=`pwd`

if [ -z "$PLATFORMS" ]; then
  PLATFORMS="darwin-x64 linux-x64 linux-ia32 win32-ia32 win32-x64"
fi

ulimit -n 8192
BUILD_DIR=$START_DIR/build
CACHE_DIR=$BUILD_DIR/cache
ELECTRON_VERSION=0.33.3

mkdir -p build/cache/electron

for ELECTRON_PLATFORM in $PLATFORMS; do
  cd $CACHE_DIR/electron

  echo "** Starting build for [$ELECTRON_PLATFORM]..."

  JUST_ELECTRON_PLATFORM=`echo $ELECTRON_PLATFORM | sed "s/-x64//" | sed "s/-ia32//"`
  JUST_ELECTRON_ARCH=`echo $ELECTRON_PLATFORM | sed "s/darwin-//" | sed "s/linux-//" | sed "s/win32-//"`

  APP_ICON=$START_DIR/assets/gateblu-icon.icns
  if [ $JUST_ELECTRON_PLATFORM == "win32" ]; then
    APP_ICON=$START_DIR/assets/gateblu-icon.ico
  fi

  echo "** Packaging for [$ELECTRON_PLATFORM]..."

  $START_DIR/node_modules/.bin/electron-packager $START_DIR/app Gateblu \
      --platform=$JUST_ELECTRON_PLATFORM \
      --arch=$JUST_ELECTRON_ARCH \
      --version=$ELECTRON_VERSION \
      --icon=$APP_ICON \
      --out=$CACHE_DIR \
      --cache=$CACHE_DIR/electron \
      --overwrite \
      --version-string.CompanyName=Octoblu \
      --version-string.ProductName=Gateblu

  PACKAGE_FOLDER=$BUILD_DIR/gateblu-v$ELECTRON_VERSION-$ELECTRON_PLATFORM

  echo "** Renaming App [$ELECTRON_PLATFORM]..."
  mv $CACHE_DIR/Gateblu-$ELECTRON_PLATFORM $PACKAGE_FOLDER

  echo "** Zipping App [$ELECTRON_PLATFORM]..."
  cd $PACKAGE_FOLDER
  zip -9rqy $PACKAGE_FOLDER.zip *

done
cd $START_DIR
mkdir -p dpl_s3
cp build/gateblu-*.zip dpl_s3/
