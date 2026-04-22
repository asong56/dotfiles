#!/bin/bash

MSG="$1"

if [ -z "$MSG" ]; then
  echo "Usage: sign \"message\""
  exit 1
fi

SIGN=$(echo -n "$MSG" | openssl dgst -sha256 -sign identity/private.key | base64)

echo "$SIGN"
