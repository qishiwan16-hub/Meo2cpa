#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_PATH="${MEO2CPA_RUN_PATH:-${ROOT_DIR}/run}"
LOG_PATH="${MEO2CPA_LOG_PATH:-${ROOT_DIR}/logs}"
PID_FILE="${RUN_PATH}/meo2cpa.pid"
STDOUT_LOG="${LOG_PATH}/meo2cpa.out.log"
STDERR_LOG="${LOG_PATH}/meo2cpa.err.log"

if [[ ! -f "${PID_FILE}" ]]; then
  echo "status=stopped"
  exit 0
fi

PID="$(cat "${PID_FILE}")"
if [[ -n "${PID}" ]] && kill -0 "${PID}" 2>/dev/null; then
  echo "status=running"
  echo "pid=${PID}"
  echo "stdout_log=${STDOUT_LOG}"
  echo "stderr_log=${STDERR_LOG}"
  exit 0
fi

rm -f "${PID_FILE}"
echo "status=stale-pid-removed"
