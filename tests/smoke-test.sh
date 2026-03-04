#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== AI Sandbox Smoke Tests ==="
echo

# Test 1: Docker image builds
echo "--- Building Docker image ---"
if docker build -t ai-sandbox . > /dev/null 2>&1; then
  pass "Docker image builds successfully"
else
  fail "Docker image build failed"
fi

# Test 2: docker-compose config is valid
echo "--- Validating docker-compose config ---"
if docker compose config --quiet 2>/dev/null || docker-compose config --quiet 2>/dev/null; then
  pass "docker-compose config is valid"
else
  fail "docker-compose config is invalid"
fi

# Test 3: Required files exist
echo "--- Checking required files ---"
for f in Dockerfile docker-compose.yml README.md LICENSE CODE_OF_CONDUCT.md CONTRIBUTING.md DEVELOPER_GUIDE.md; do
  if [ -f "$f" ]; then
    pass "File exists: $f"
  else
    fail "File missing: $f"
  fi
done

echo
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1
