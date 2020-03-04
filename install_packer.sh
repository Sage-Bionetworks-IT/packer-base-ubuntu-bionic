#!/bin/bash -e

workdir=/tmp/packer
pversion=1.4.3

which packer || {
  mkdir -p $workdir
  cd $workdir
  apt-get -qqy install unzip wget
  wget https://releases.hashicorp.com/packer/$pversion/packer_${pversion}_linux_amd64.zip && \
  unzip packer_${pversion}_linux_amd64.zip && \
  mv packer /usr/local/bin/
  rm -Rf $workdir
  packer_bin=$(which packer)
  echo "packer installed at ${packer_bin}"
  packer -v
}
