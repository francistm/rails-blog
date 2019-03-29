#!/usr/bin/env bash

INSTALL_PREFIX=/usr/bin
REMOTE_URL=http://chromedriver.storage.googleapis.com/74.0.3729.6/chromedriver_linux64.zip

wget $REMOTE_URL -P /tmp
sudo unzip /tmp/chromedriver_linux64.zip -d $INSTALL_PREFIX
