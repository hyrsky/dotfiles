# dotfiles

Machine configuration, managed with Ansible.

## Quick start

On a fresh machine:

```sh
./bootstrap.sh
```

`bootstrap.sh` creates a Python virtualenv (`.venv/`), installs Ansible into it,
installs the required Galaxy collections, and runs the playbook.

## Re-running

Once bootstrapped, use the Makefile (also venv-based):

```sh
make run     # apply the playbook
make check   # dry-run with --check --diff, no changes
make lint    # syntax-check the playbook
make deps    # reinstall venv deps + collections
make clean   # remove the venv
```

## Layout

```
site.yml              Top-level playbook; includes roles by OS
inventory.ini         Targets localhost via a local connection
group_vars/all.yml    Tunable settings (see below)
requirements.txt      Python deps for the venv (Ansible)
requirements.yml      Ansible Galaxy collections
roles/
  common/             Cross-platform tasks
  macos/              macOS-only tasks
  linux/              Linux-only tasks
```
