#!/bin/bash

set -eu

# ============================================================================
# Download files from Google Cloud Storage
# ============================================================================
echo "Downloading signing files from Google Cloud Storage..."
TMP_DIR="$(mktemp -d)"

# Download Private Key
echo "Downloading private key..."
gcloud storage cp gs://kotori316-resources/secring.gpg "${TMP_DIR}/secring.gpg"
export SECRET_KEY_RING_FILE="${TMP_DIR}/secring.gpg"

# Download JKS keystore
echo "Downloading JKS keystore..."
gcloud storage cp gs://kotori316-resources/kotori316_keystore.jks "${TMP_DIR}/kotori316_keystore.jks"
export KEY_LOCATION="${TMP_DIR}/kotori316_keystore.jks"

# Download and import Public Key
echo "Downloading and importing public key..."
gcloud storage cp gs://kotori316-resources/pgp_public.pub "${TMP_DIR}/pgp_public.pub"
gpg --import "${TMP_DIR}/pgp_public.pub"

echo "Downloaded files in ${TMP_DIR}"

# ============================================================================
# Get secrets from Google Cloud Secret Manager
# ============================================================================
echo "Retrieving secrets from Google Cloud Secret Manager..."

# Convert secret manager access to CLI commands
export KEY_ID=$(gcloud secrets versions access latest --secret="signing-key-id" --project="kotori316-mods-resources")
export KEY_PASSWORD=$(gcloud secrets versions access latest --secret="signing-password" --project="kotori316-mods-resources")
export JAR_PASSWORD=$(gcloud secrets versions access latest --secret="jar-sign-key-password" --project="kotori316-mods-resources")
export MODRINTH_TOKEN=$(gcloud secrets versions access latest --secret="modrinth_token" --project="kotori316-mods-resources")
export CURSE_TOKEN=$(gcloud secrets versions access latest --secret="curseforge_token" --project="kotori316-mods-resources")
export CLOUDFLARE_S3_ENDPOINT=$(gcloud secrets versions access latest --secret="cloudflare_s3_endpoint" --project="kotori316-mods-resources")
export R2_ACCESS_KEY=$(gcloud secrets versions access latest --secret="cloudflare_access_key" --project="kotori316-mods-resources")
export R2_SECRET_KEY=$(gcloud secrets versions access latest --secret="cloudflare_secret_key" --project="kotori316-mods-resources")
export MAVEN_USERNAME=$(gcloud secrets versions access latest --secret="repolisite-publisher-name" --project="kotori316-mods-resources")
export MAVEN_PASSWORD=$(gcloud secrets versions access latest --secret="repolisite-publisher-password" --project="kotori316-mods-resources")
