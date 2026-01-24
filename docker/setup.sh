#!/usr/bin/env bash
set -e

VOLUME_NAME="cmock-dev-workspace"
IMAGE_NAME="cmock-dev-arch"
DOCKERFILE_PATH="./Resources/Dockerfile"
CONTEXT_DIR="."

SCRIPT_DIR="$(cd -- "$(dirname -- "$BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$SCRIPT_DIR/Resources/logging.sh"

section "Cleaning up dangling Docker volumes..."
docker volume prune -f

success "Docker cleanup completed"

section "Checking if Docker volume '$VOLUME_NAME' exists..."
if ! docker volume inspect "$VOLUME_NAME" > /dev/null 2>&1; then
	log "Volume '$VOLUME_NAME' does not exist. Creating..."
	docker volume create "$VOLUME_NAME"
	success "Volume '$VOLUME_NAME' created."
else
	success "Volume '$VOLUME_NAME' found."
fi

echo "Building Docker image '$IMAGE_NAME' from $DOCKERFILE_PATH..."

# Temporarily forward ssh to allow for cloning during image build
DOCKER_BUILDKIT=1 docker build \
	-t "$IMAGE_NAME" \
	-f "$DOCKERFILE_PATH" \
	"$CONTEXT_DIR"
success "Docker image '$IMAGE_NAME' built successfully."

log "Setup complete. Volume: $VOLUME_NAME | Image: $IMAGE_NAME"
log "Run with ./run.sh"
echo;
