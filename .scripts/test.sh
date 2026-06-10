#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_RUNNER="$PROJECT_DIR/build/TimeMachineTrimmer-tests"
BUILD_DIR="$PROJECT_DIR/build"

echo "==> Compiling test sources..."
find "$PROJECT_DIR/Tests" -name "*.swift" -print0 | xargs -0 swiftc \
  -target arm64-apple-macosx14.4 \
  -sdk "$(xcrun --show-sdk-path)" \
  -o "$TEST_RUNNER" \
  -emit-executable \
  -O

echo ""
echo "==> Running tests..."
"$TEST_RUNNER"
