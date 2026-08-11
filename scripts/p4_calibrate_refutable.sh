#!/bin/bash
# Full P4 REFUTABLE: 66 × 4 = 264 slots. Publish pid for monitors.
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="$HOME/.pyenv/shims:$PATH"
: "${XAI_API_KEY:?set XAI_API_KEY}"
if ! sandbox-exec -p '(version 1)(allow default)' /bin/echo ok >/dev/null 2>&1; then
  echo "FATAL: sandbox-exec not usable in this environment" >&2
  exit 3
fi
mkdir -p /tmp/basin-p4
echo $$ > /tmp/basin-p4/p4_calibrate.pid
{
  echo "start $(date -Iseconds)"
  echo "stratum=REFUTABLE model=grok-4.5 arm=family-x temp=0.7"
  echo "cwd $(pwd)"
} > /tmp/basin-p4/p4_calibrate.meta
python3 sweep.py \
  --model grok-4.5 \
  --arm family-x \
  --temperature 0.7 \
  --endpoint https://api.x.ai/v1/chat/completions \
  --key-env XAI_API_KEY \
  --stratum REFUTABLE \
  --sample-workers 4 \
  --lean-workers 4 \
  2>&1 | tee /tmp/basin-p4/p4_calibrate.log
echo "exit:$?" | tee -a /tmp/basin-p4/p4_calibrate.meta
DAY=$(date +%Y-%m-%d)
python3 analyze.py "runs/${DAY}.jsonl" | tee /tmp/basin-p4/p4_analyze.txt
