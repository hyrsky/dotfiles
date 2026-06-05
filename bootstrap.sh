#!/usr/bin/env bash
# Bootstrap a fresh machine.
#
# Creates a Python virtualenv (.venv), installs Ansible into it, installs the
# required Galaxy collections, and runs the playbook. Ansible always runs from
# the venv so it never depends on (or fights with) a system Python install.
#
# Usage: ./bootstrap.sh [extra ansible-playbook args]
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

VENV_DIR="$REPO_DIR/.venv"

# --- pick a python3 ---------------------------------------------------------
if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 not found." >&2
  case "$(uname -s)" in
    Darwin) echo "Install the Xcode Command Line Tools first: xcode-select --install" >&2 ;;
    Linux)  echo "Install python3 first, e.g.: sudo dnf install -y python3" >&2 ;;
  esac
  exit 1
fi

# --- create / reuse the venv ------------------------------------------------
if [ ! -x "$VENV_DIR/bin/python" ]; then
  echo "==> Creating virtualenv at $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi

echo "==> Installing Ansible into the venv"
"$VENV_DIR/bin/python" -m pip install --upgrade pip >/dev/null
"$VENV_DIR/bin/python" -m pip install -r requirements.txt

echo "==> Installing Ansible Galaxy collections"
"$VENV_DIR/bin/ansible-galaxy" collection install -r requirements.yml

echo "==> Running playbook (you may be prompted for your sudo password)"
exec "$VENV_DIR/bin/ansible-playbook" site.yml --ask-become-pass "$@"
