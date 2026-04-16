#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
CONFIG_PATH="${MEO2CPA_CONFIG_PATH:-${ROOT_DIR}/config.yaml}"
AUTH_PATH="${MEO2CPA_AUTH_PATH:-${ROOT_DIR}/auths}"
LOG_PATH="${MEO2CPA_LOG_PATH:-${ROOT_DIR}/logs}"
RUN_PATH="${MEO2CPA_RUN_PATH:-${ROOT_DIR}/run}"
BIN_PATH="${MEO2CPA_BIN_PATH:-${ROOT_DIR}/bin/meo2cpa}"
PANEL_PATH="${MEO2CPA_PANEL_PATH:-${ROOT_DIR}/panel}"
STATE_PATH="${MEO2CPA_STATE_PATH:-${ROOT_DIR}/state}"
TMP_PATH="${MEO2CPA_TMP_PATH:-${ROOT_DIR}/tmp}"

mkdir -p "${AUTH_PATH}" "${LOG_PATH}" "${RUN_PATH}" "${PANEL_PATH}" "${STATE_PATH}" "${TMP_PATH}" "$(dirname "${BIN_PATH}")"

if [[ ! -f "${CONFIG_PATH}" && -f "${ROOT_DIR}/config.example.yaml" ]]; then
  cp "${ROOT_DIR}/config.example.yaml" "${CONFIG_PATH}"
fi

cat <<EOF
MEO2CPA_ROOT=${ROOT_DIR}
MEO2CPA_CONFIG_PATH=${CONFIG_PATH}
MEO2CPA_AUTH_PATH=${AUTH_PATH}
MEO2CPA_LOG_PATH=${LOG_PATH}
MEO2CPA_RUN_PATH=${RUN_PATH}
MEO2CPA_BIN_PATH=${BIN_PATH}
MEO2CPA_PANEL_PATH=${PANEL_PATH}
MEO2CPA_STATE_PATH=${STATE_PATH}
MEO2CPA_TMP_PATH=${TMP_PATH}
PREFIX=${PREFIX_DIR}

Suggested next steps:
  1. pkg update && pkg upgrade
  2. pkg install golang git curl jq termux-api termux-services
  3. cp ./config.example.yaml ./config.yaml
  4. bash ./scripts/termux-build.sh
  5. bash ./scripts/termux-start.sh
  6. bash ./scripts/termux-status.sh
EOF
