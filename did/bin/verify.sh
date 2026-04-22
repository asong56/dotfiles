#!/bin/bash

MSG="$1"
SIGN="$2"

if [ -z "$MSG" ] || [ -z "$SIGN" ]; then
  echo "Usage: verify \"message\" \"signature\""
  exit 1
fi

echo "$SIGN" | base64 -d > /tmp/sig.bin

echo -n "$MSG" | openssl dgst -sha256 -verify identity/public.key -signature /tmp/sig.bin
