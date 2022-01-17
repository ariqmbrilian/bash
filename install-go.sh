#!/bin/bash
wget https://golang.org/dl/go${VERSION}.linux-${ARCH}.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${VERSION}.linux-${ARCH}.tar.gz
touch ~/.profile
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
go version
