#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Checking Bun authentication..."
if ! bun pm whoami &>/dev/null; then
    echo "❌ Not logged in to npm registry."
    echo "Run 'bunx npm login' first, then try again."
    exit 1
fi
echo "✅ Authenticated"

if [[ -n $(git status --porcelain) ]]; then
    echo "❌ Working directory is dirty — commit your changes first."
    exit 1
fi

echo "Enter version bump (patch/minor/major):"
read -r VERSION_TYPE

echo "🚀 Bumping version..."
bun version "$VERSION_TYPE"

echo "📥 Pushing to GitHub (with tags)..."
git push origin main --tags

echo "📦 Publishing..."
bun publish --access public

echo "✅ Done."
