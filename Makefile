# Convenience wrapper around the venv-based Ansible workflow.
# Everything runs through .venv so Ansible never touches the system Python.

VENV    := .venv
PY      := $(VENV)/bin/python
ANSIBLE := $(VENV)/bin/ansible-playbook
GALAXY  := $(VENV)/bin/ansible-galaxy

.DEFAULT_GOAL := run

.PHONY: venv deps run check privileged all lint clean

$(VENV)/bin/python:
	python3 -m venv $(VENV)
	$(PY) -m pip install --upgrade pip

venv: $(VENV)/bin/python ## Create the virtualenv

deps: venv ## Install Python deps + Galaxy collections into the venv
	$(PY) -m pip install -r requirements.txt
	$(GALAXY) collection install -r requirements.yml

run: deps ## Apply the playbook, skipping steps that need sudo (no password prompt)
	$(ANSIBLE) site.yml --skip-tags privileged

check: deps ## Dry-run the non-privileged steps (no changes, no password prompt)
	$(ANSIBLE) site.yml --skip-tags privileged --check --diff

privileged: deps ## Run only the steps that require sudo (prompts for password)
	$(ANSIBLE) site.yml --tags privileged --ask-become-pass

all: deps ## Apply everything: non-privileged steps + the privileged ones
	$(ANSIBLE) site.yml --ask-become-pass

lint: deps ## Syntax-check the playbook
	$(ANSIBLE) site.yml --syntax-check

clean: ## Remove the virtualenv
	rm -rf $(VENV)
