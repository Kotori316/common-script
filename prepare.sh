#!/bin/bash

set -eu

GOOGLE_CLOUD_PROJECT="kotori316-mods-resources"
STORAGE_BUCKET="kotori316-resources"

# ============================================================================
# Download files from Google Cloud Storage
# ============================================================================
echo "Downloading signing files from Google Cloud Storage..."
TMP_DIR="$(mktemp -d)"

# Download Private Key
echo "Downloading private key..."
gcloud storage cp "gs://${STORAGE_BUCKET}/secring.gpg" "${TMP_DIR}/secring.gpg"
export SECRET_KEY_RING_FILE="${TMP_DIR}/secring.gpg"

# Download JKS keystore
echo "Downloading JKS keystore..."
gcloud storage cp "gs://${STORAGE_BUCKET}/kotori316_keystore.jks" "${TMP_DIR}/kotori316_keystore.jks"
export KEY_LOCATION="${TMP_DIR}/kotori316_keystore.jks"

# Download and import Public Key
echo "Downloading and importing public key..."
gcloud storage cp "gs://${STORAGE_BUCKET}/pgp_public.pub" "${TMP_DIR}/pgp_public.pub"
gpg --import "${TMP_DIR}/pgp_public.pub"

echo "Downloaded files in ${TMP_DIR}"

# ============================================================================
# Get secrets from Google Cloud Secret Manager
# ============================================================================
echo "Retrieving secrets from Google Cloud Secret Manager..."

# Convert secret manager access to CLI commands
export KEY_ID=$(gcloud secrets versions access latest --secret="signing-key-id" --project="${GOOGLE_CLOUD_PROJECT}")
export KEY_PASSWORD=$(gcloud secrets versions access latest --secret="signing-password" --project="${GOOGLE_CLOUD_PROJECT}")
export JAR_PASSWORD=$(gcloud secrets versions access latest --secret="jar-sign-key-password" --project="${GOOGLE_CLOUD_PROJECT}")
export MODRINTH_TOKEN=$(gcloud secrets versions access latest --secret="modrinth_token" --project="${GOOGLE_CLOUD_PROJECT}")
export CURSE_TOKEN=$(gcloud secrets versions access latest --secret="curseforge_token" --project="${GOOGLE_CLOUD_PROJECT}")
export CLOUDFLARE_S3_ENDPOINT=$(gcloud secrets versions access latest --secret="cloudflare_s3_endpoint" --project="${GOOGLE_CLOUD_PROJECT}")
export R2_ACCESS_KEY=$(gcloud secrets versions access latest --secret="cloudflare_access_key" --project="${GOOGLE_CLOUD_PROJECT}")
export R2_SECRET_KEY=$(gcloud secrets versions access latest --secret="cloudflare_secret_key" --project="${GOOGLE_CLOUD_PROJECT}")
export MAVEN_USERNAME=$(gcloud secrets versions access latest --secret="repolisite-publisher-name" --project="${GOOGLE_CLOUD_PROJECT}")
export MAVEN_PASSWORD=$(gcloud secrets versions access latest --secret="repolisite-publisher-password" --project="${GOOGLE_CLOUD_PROJECT}")
