#! /usr/bin/env bash
set -e

IMAGE_NAME="cmock-dev-arch"
VOLUME_NAME="cmock-dev-workspace"
CONTAINER_WORKDIR="/workspace"

export MSYS_NO_PATHCONV=1

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$SCRIPT_DIR/Resources/logging.sh"

set -a
source <(grep -v '^\s*#' $SCRIPT_DIR/.env | grep -v '^\s*$')
set +a

OS_TYPE="$(uname -s)"

DOCKER_RUN_ARGS=(
	-it
	--rm
	-e GIT_USER_NAME=$GIT_USER_NAME
	-e GIT_USER_EMAIL=$GIT_USER_EMAIL
	-v "${VOLUME_NAME}:${CONTAINER_WORKDIR}"
	-w "${CONTAINER_WORKDIR}"
	-v "${HOME}/.ssh/id_ed25519:/home/Dev/.ssh/id_ed25519:ro"
	-v "${HOME}/.ssh/id_ed25519.pub:/home/Dev/.ssh/id_ed25519.pub:ro"
	-v "${HOME}/.ssh/id_rsa:/home/Dev/.ssh/id_rsa:ro"
	-v "${HOME}/.ssh/id_rsa.pub:/home/Dev/.ssh/id_rsa.pub:ro"
)

docker run --env-file .env ${DOCKER_RUN_ARGS[@]} "$IMAGE_NAME"
