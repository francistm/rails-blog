#!/usr/bin/env bash

INSTALL_PREFIX=/usr/bin
REMOTE_URL=https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz

wget $REMOTE_URL -P /tmp
sudo tar zxf /tmp/geckodriver-v0.24.0-linux64.tar.gz -C $INSTALL_PREFIX
sudo chmod +x $INSTALL_PREFIX/geckodriver
