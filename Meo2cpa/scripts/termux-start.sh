#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_PATH="${MEO2CPA_BIN_PATH:-${ROOT_DIR}/bin/meo2cpa}"
CONFIG_PATH="${MEO2CPA_CONFIG_PATH:-${ROOT_DIR}/config.yaml}"
AUTH_PATH="${MEO2CPA_AUTH_PATH:-${ROOT_DIR}/auths}"
LOG_PATH="${MEO2CPA_LOG_PATH:-${ROOT_DIR}/logs}"
RUN_PATH="${MEO2CPA_RUN_PATH:-${ROOT_DIR}/run}"
PANEL_PATH="${MEO2CPA_PANEL_PATH:-${ROOT_DIR}/panel}"
PID_FILE="${RUN_PATH}/meo2cpa.pid"
STDOUT_LOG="${LOG_PATH}/meo2cpa.out.log"
STDERR_LOG="${LOG_PATH}/meo2cpa.err.log"

mkdir -p "${AUTH_PATH}" "${LOG_PATH}" "${RUN_PATH}" "${PANEL_PATH}"

if [[ ! -x "${BIN_PATH}" ]]; then
  echo "Binary not found: ${BIN_PATH}" >&2
  echo "Run bash ./scripts/termux-build.sh first." >&2
  exit 1
fi

if [[ ! -f "${CONFIG_PATH}" ]]; then
  echo "Config not found: ${CONFIG_PATH}" >&2
  echo "Copy ./config.example.yaml to ./config.yaml and adjust values first." >&2
  exit 1
fi

if [[ -f "${PID_FILE}" ]]; then
  EXISTING_PID="$(cat "${PID_FILE}")"
  if [[ -n "${EXISTING_PID}" ]] && kill -0 "${EXISTING_PID}" 2>/dev/null; then
    echo "Meo2cpa is already running with PID ${EXISTING_PID}"
    exit 0
  fi
  rm -f "${PID_FILE}"
fi

export WRITABLE_PATH="${PANEL_PATH}"
export MEO2CPA_ROOT="${ROOT_DIR}"
export MEO2CPA_PROJECT_ROOT="${ROOT_DIR}"
export MEO2CPA_PANEL_PATH="${PANEL_PATH}"
export TMPDIR="${ROOT_DIR}/tmp"

nohup "${BIN_PATH}" --config "${CONFIG_PATH}" >"${STDOUT_LOG}" 2>"${STDERR_LOG}" &
NEW_PID=$!
echo "${NEW_PID}" > "${PID_FILE}"

echo "Meo2cpa started with PID ${NEW_PID}"
echo "stdout: ${STDOUT_LOG}"
echo "stderr: ${STDERR_LOG}"
