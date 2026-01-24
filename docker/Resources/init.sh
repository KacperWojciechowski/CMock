#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$SCRIPT_DIR/logging.sh"

section "Running container initialization.."

if [[ -n "${GIT_USER_NAME:-}" ]]; then
	git config --global user.name "$GIT_USER_NAME"
fi

if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
	git config --global user.email "$GIT_USER_EMAIL"
fi

git config --global credential.helper 'cache --timeout=36000'

section "Git config inside container:"
log "User name: $(git config --global --get user.name || "(user.name not set)")"
log "User email: $(git config --global --get user.email || "(user.email not set)")"

section "Searching for CMock forked repository"

REPO_PATH=$(find -iname "CMock")

if [[ -z $REPO_PATH ]]; then
	git clone git@github.com:$GIT_USER_NAME/CMock.git
fi

echo;
