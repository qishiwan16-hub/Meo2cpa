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
mkdir -p "${AUTH_PATH}" "${LOG_PATH}" "${RUN_PATH}" "${PANEL_PATH}" "${TMP_PATH}"

if [[ ! -f "${CONFIG_PATH}" ]]; then
  echo "Config not found: ${CONFIG_PATH}" >&2
  echo "Run bash ./scripts/termux-bootstrap.sh first." >&2
  exit 1
fi

if [[ ! -x "${BIN_PATH}" ]]; then
  echo "Binary not found: ${BIN_PATH}" >&2
  echo "Run bash ./scripts/termux-bootstrap.sh first." >&2
  exit 1
fi

export WRITABLE_PATH="${PANEL_PATH}"
export MEO2CPA_ROOT="${ROOT_DIR}"
export MEO2CPA_PROJECT_ROOT="${ROOT_DIR}"
export MEO2CPA_PANEL_PATH="${PANEL_PATH}"
export TMPDIR="${TMP_PATH}"

echo "Meo2cpa starting in foreground"
echo "config: ${CONFIG_PATH}"
echo "stop: Ctrl+C"

exec "${BIN_PATH}" --config "${CONFIG_PATH}"
