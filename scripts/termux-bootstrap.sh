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

if command -v pkg >/dev/null 2>&1; then
  yes | pkg update >/dev/null 2>&1 || true
  yes | pkg upgrade >/dev/null 2>&1 || true
  pkg install -y golang git curl jq termux-api termux-services >/dev/null 2>&1 || true
fi

if [[ ! -f "${CONFIG_PATH}" && -f "${ROOT_DIR}/config.example.yaml" ]]; then
  cp "${ROOT_DIR}/config.example.yaml" "${CONFIG_PATH}"
fi

if [[ ! -x "${BIN_PATH}" ]]; then
  bash "${ROOT_DIR}/scripts/termux-build.sh"
fi

cat <<EOF
Meo2cpa install completed.

root: ${ROOT_DIR}
config: ${CONFIG_PATH}
bin: ${BIN_PATH}
auths: ${AUTH_PATH}
logs: ${LOG_PATH}
run: ${RUN_PATH}
panel: ${PANEL_PATH}
state: ${STATE_PATH}
tmp: ${TMP_PATH}
prefix: ${PREFIX_DIR}

Next step:
  bash ./scripts/termux-start.sh
EOF
