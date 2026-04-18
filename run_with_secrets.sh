#!/bin/bash

set -eu

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <command> [args...]"
  exit 1
fi

GOOGLE_CLOUD_PROJECT="kotori316-mods-resources"
STORAGE_BUCKET="kotori316-resources"

# ============================================================================
# Download files from Google Cloud Storage
# ============================================================================
echo "Downloading signing files from Google Cloud Storage..."
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

# Download Private Key
echo "Downloading private key..."
gcloud storage cp "gs://${STORAGE_BUCKET}/secring.gpg" "${TMP_DIR}/secring.gpg"
SIGNING_SECRET_KEY_RING_FILE="${TMP_DIR}/secring.gpg"

# Download JKS keystore
echo "Downloading JKS keystore..."
gcloud storage cp "gs://${STORAGE_BUCKET}/kotori316_keystore.jks" "${TMP_DIR}/kotori316_keystore.jks"
SIGN_KEY_LOCATION="${TMP_DIR}/kotori316_keystore.jks"

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
SIGNING_KEY_ID=$(gcloud secrets versions access latest --secret="signing-key-id" --project="${GOOGLE_CLOUD_PROJECT}")
SIGNING_PASSWORD=$(gcloud secrets versions access latest --secret="signing-password" --project="${GOOGLE_CLOUD_PROJECT}")
SIGN_KEY_ALIAS="ko316"
SIGN_STORE_PASS=$(gcloud secrets versions access latest --secret="jar-sign-key-password" --project="${GOOGLE_CLOUD_PROJECT}")
MODRINTH_TOKEN=$(gcloud secrets versions access latest --secret="modrinth_token" --project="${GOOGLE_CLOUD_PROJECT}")
CURSE_TOKEN=$(gcloud secrets versions access latest --secret="curseforge_token" --project="${GOOGLE_CLOUD_PROJECT}")
CLOUDFLARE_S3_ENDPOINT=$(gcloud secrets versions access latest --secret="cloudflare_s3_endpoint" --project="${GOOGLE_CLOUD_PROJECT}")
R2_ACCESS_KEY=$(gcloud secrets versions access latest --secret="cloudflare_access_key" --project="${GOOGLE_CLOUD_PROJECT}")
R2_SECRET_KEY=$(gcloud secrets versions access latest --secret="cloudflare_secret_key" --project="${GOOGLE_CLOUD_PROJECT}")
MAVEN_USERNAME=$(gcloud secrets versions access latest --secret="repolisite-publisher-name" --project="${GOOGLE_CLOUD_PROJECT}")
MAVEN_PASSWORD=$(gcloud secrets versions access latest --secret="repolisite-publisher-password" --project="${GOOGLE_CLOUD_PROJECT}")

# ============================================================================
# Execute passed commands
# ============================================================================
echo "Executing passed commands: $@"
SIGNING_SECRET_KEY_RING_FILE="${SIGNING_SECRET_KEY_RING_FILE}" \
  SIGNING_KEY_ID="${SIGNING_KEY_ID}" \
  SIGNING_PASSWORD="${SIGNING_PASSWORD}" \
  SIGN_KEY_LOCATION="${SIGN_KEY_LOCATION}" \
  SIGN_KEY_ALIAS="${SIGN_KEY_ALIAS}" \
  SIGN_STORE_PASS="${SIGN_STORE_PASS}" \
  MODRINTH_TOKEN="${MODRINTH_TOKEN}" \
  CURSE_TOKEN="${CURSE_TOKEN}" \
  CLOUDFLARE_S3_ENDPOINT="${CLOUDFLARE_S3_ENDPOINT}" \
  R2_ACCESS_KEY="${R2_ACCESS_KEY}" \
  R2_SECRET_KEY="${R2_SECRET_KEY}" \
  MAVEN_USERNAME="${MAVEN_USERNAME}" \
  MAVEN_PASSWORD="${MAVEN_PASSWORD}" \
  "$@"
