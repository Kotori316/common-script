#!/bin/bash

set -eu

# See https://docs.cloud.google.com/sdk/docs/install-sdk?hl=ja#deb

apt-get update
apt-get install -y --no-install-recommends ca-certificates gnupg curl

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get update && apt-get install -y --no-install-recommends google-cloud-cli
