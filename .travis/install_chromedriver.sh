#!/usr/bin/env bash

CHROME_STABLE_VER=75.0.3770.140

INSTALL_PREFIX=/usr/bin
REMOTE_URL=https://chromedriver.storage.googleapis.com/${CHROME_STABLE_VER}/chromedriver_linux64.zip

wget --quiet $REMOTE_URL -P /tmp
sudo unzip /tmp/chromedriver_linux64.zip -d $INSTALL_PREFIX
sudo chmod +x $INSTALL_PREFIX/chromedriver
