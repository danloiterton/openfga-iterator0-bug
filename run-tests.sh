#!/usr/bin/env bash
set -euo pipefail

export FGA_API_URL="http://openfga:8080"

echo "⏳ Waiting for OpenFGA API at $FGA_API_URL ..."
until curl -s "$FGA_API_URL/healthz" >/dev/null; do sleep 1; done;
echo "✅ OpenFGA API is up"

echo "📦 Creating store..."
RESULT=$(fga store create --name "test-store")
export FGA_STORE_ID=$(echo "$RESULT" | jq -r '.store.id')
echo "Using store: $FGA_STORE_ID"

echo "📄 Uploading model..."
RESULT=$(fga model write --file authModel.fga)
MODEL_ID=$(echo "$RESULT" | jq -r '.authorization_model_id')
echo "Model uploaded: $MODEL_ID"

echo "➕ Writing tuples..."
fga tuple write --file tuples.json

echo "🧪 Running tests..."
RESULT=$(fga query check user:a member project:a)
echo "Check result:"
echo "$RESULT"