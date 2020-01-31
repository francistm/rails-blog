#!/usr/bin/env bash

INSTALL_PREFIX=/usr/bin
VERSION_FILE_URI=https://chromedriver.storage.googleapis.com/LATEST_RELEASE

DRIVER_VERSION=`curl -s ${VERSION_FILE_URI}`

if [[ -n "${DRIVER_VERSION}" ]]; then
  echo "Download and installing chromedriver ${DRIVER_VERSION}"
else
  echo "Cannot retrieve chromedriver version from ${VERSION_FILE_URI}"
  exit 1
fi

REMOTE_URI="https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip"

wget --quiet "$REMOTE_URI" -P /tmp
sudo unzip /tmp/chromedriver_linux64.zip -d $INSTALL_PREFIX
sudo chmod +x $INSTALL_PREFIX/chromedriver
