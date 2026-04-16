#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_BIN="${MEO2CPA_BIN_PATH:-${ROOT_DIR}/bin/meo2cpa}"
VERSION="${MEO2CPA_VERSION:-termux-dev}"
COMMIT="${MEO2CPA_COMMIT:-$(git -C "${ROOT_DIR}" rev-parse --short HEAD 2>/dev/null || echo unknown)}"
BUILD_DATE="${MEO2CPA_BUILD_DATE:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"
MAIN_PKG="./cmd/server"

mkdir -p "$(dirname "${OUTPUT_BIN}")"

LDFLAGS="-s -w -X main.Version=${VERSION} -X main.Commit=${COMMIT} -X main.BuildDate=${BUILD_DATE}"

echo "Building Meo2cpa for Termux..."
echo "  output: ${OUTPUT_BIN}"
echo "  version: ${VERSION}"
echo "  commit: ${COMMIT}"
echo "  build date: ${BUILD_DATE}"

cd "${ROOT_DIR}"
CGO_ENABLED=${CGO_ENABLED:-0} go build -trimpath -ldflags "${LDFLAGS}" -o "${OUTPUT_BIN}" "${MAIN_PKG}"
chmod +x "${OUTPUT_BIN}"

echo "Build completed: ${OUTPUT_BIN}"
