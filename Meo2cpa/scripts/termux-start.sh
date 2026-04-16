#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_PATH="${MEO2CPA_BIN_PATH:-${ROOT_DIR}/bin/meo2cpa}"
CONFIG_PATH="${MEO2CPA_CONFIG_PATH:-${ROOT_DIR}/config.yaml}"
AUTH_PATH="${MEO2CPA_AUTH_PATH:-${ROOT_DIR}/auths}"
LOG_PATH="${MEO2CPA_LOG_PATH:-${ROOT_DIR}/logs}"
RUN_PATH="${MEO2CPA_RUN_PATH:-${ROOT_DIR}/run}"
PANEL_PATH="${MEO2CPA_PANEL_PATH:-${ROOT_DIR}/panel}"
TMP_PATH="${MEO2CPA_TMP_PATH:-${ROOT_DIR}/tmp}"
PID_FILE="${RUN_PATH}/meo2cpa.pid"
STDOUT_LOG="${LOG_PATH}/meo2cpa.out.log"
STDERR_LOG="${LOG_PATH}/meo2cpa.err.log"
AUTO_BUILD="${MEO2CPA_AUTO_BUILD:-1}"
AUTO_BOOTSTRAP="${MEO2CPA_AUTO_BOOTSTRAP:-1}"

mkdir -p "${AUTH_PATH}" "${LOG_PATH}" "${RUN_PATH}" "${PANEL_PATH}" "${TMP_PATH}"

if [[ "${AUTO_BOOTSTRAP}" == "1" ]]; then
  bash "${ROOT_DIR}/scripts/termux-bootstrap.sh" >/dev/null
fi

if [[ ! -f "${CONFIG_PATH}" ]]; then
  if [[ -f "${ROOT_DIR}/config.example.yaml" ]]; then
    cp "${ROOT_DIR}/config.example.yaml" "${CONFIG_PATH}"
    echo "Config initialized from template: ${CONFIG_PATH}"
  else
    echo "Config template not found: ${ROOT_DIR}/config.example.yaml" >&2
    exit 1
  fi
fi

if [[ ! -x "${BIN_PATH}" ]]; then
  if [[ "${AUTO_BUILD}" == "1" ]]; then
    echo "Binary not found, running build automatically..."
    bash "${ROOT_DIR}/scripts/termux-build.sh"
  else
    echo "Binary not found: ${BIN_PATH}" >&2
    echo "Run bash ./scripts/termux-build.sh first." >&2
    exit 1
  fi
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
export TMPDIR="${TMP_PATH}"

nohup "${BIN_PATH}" --config "${CONFIG_PATH}" >"${STDOUT_LOG}" 2>"${STDERR_LOG}" &
NEW_PID=$!
echo "${NEW_PID}" > "${PID_FILE}"

echo "Meo2cpa started with PID ${NEW_PID}"
echo "config: ${CONFIG_PATH}"
echo "stdout: ${STDOUT_LOG}"
echo "stderr: ${STDERR_LOG}"
echo "status: bash ./scripts/termux-status.sh"
