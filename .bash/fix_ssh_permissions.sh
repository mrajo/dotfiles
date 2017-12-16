#!/usr/bin/env bash

echo 'Fixing permissions on ssh keys...'
chmod 0700 ~/.ssh
chmod 0644 ~/.ssh/id_rsa.pub
chmod 0600 ~/.ssh/id_rsa
