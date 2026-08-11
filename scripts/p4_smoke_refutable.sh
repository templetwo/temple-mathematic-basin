#!/bin/bash
# P4 smoke: 2 REFUTABLE items × 4 samples. Requires real macOS sandbox-exec.
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="$HOME/.pyenv/shims:$PATH"
: "${XAI_API_KEY:?set XAI_API_KEY}"
if ! sandbox-exec -p '(version 1)(allow default)' /bin/echo ok >/dev/null 2>&1; then
  echo "FATAL: sandbox-exec not usable in this environment" >&2
  exit 3
fi
python3 sweep.py \
  --model grok-4.5 \
  --arm family-x \
  --temperature 0.7 \
  --endpoint https://api.x.ai/v1/chat/completions \
  --key-env XAI_API_KEY \
  --stratum REFUTABLE \
  --limit 2 \
  --sample-workers 2 \
  --lean-workers 2
