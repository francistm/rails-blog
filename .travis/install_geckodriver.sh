#!/usr/bin/env bash

GECKO_DRIVER_VER=v0.24.0
INSTALL_PREFIX=/usr/bin
REMOTE_URL=https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VER/geckodriver-$GECKO_DRIVER_VER-linux64.tar.gz

wget --quiet $REMOTE_URL -P /tmp
sudo tar zxf /tmp/geckodriver-v0.24.0-linux64.tar.gz -C $INSTALL_PREFIX
sudo chmod +x $INSTALL_PREFIX/geckodriver
