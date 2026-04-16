#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_PATH="${MEO2CPA_RUN_PATH:-${ROOT_DIR}/run}"
PID_FILE="${RUN_PATH}/meo2cpa.pid"

if [[ ! -f "${PID_FILE}" ]]; then
  echo "Meo2cpa is not running"
  exit 0
fi

PID="$(cat "${PID_FILE}")"
if [[ -z "${PID}" ]]; then
  rm -f "${PID_FILE}"
  echo "Removed empty PID file"
  exit 0
fi

if kill -0 "${PID}" 2>/dev/null; then
  kill "${PID}"
  for _ in {1..15}; do
    if ! kill -0 "${PID}" 2>/dev/null; then
      break
    fi
    sleep 1
  done
fi

if kill -0 "${PID}" 2>/dev/null; then
  kill -9 "${PID}"
fi

rm -f "${PID_FILE}"
echo "Meo2cpa stopped"
