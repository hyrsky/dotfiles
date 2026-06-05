# Convenience wrapper around the venv-based Ansible workflow.
# Everything runs through .venv so Ansible never touches the system Python.

VENV    := .venv
PY      := $(VENV)/bin/python
ANSIBLE := $(VENV)/bin/ansible-playbook
GALAXY  := $(VENV)/bin/ansible-galaxy

.DEFAULT_GOAL := run

.PHONY: venv deps run check lint clean

$(VENV)/bin/python:
	python3 -m venv $(VENV)
	$(PY) -m pip install --upgrade pip

venv: $(VENV)/bin/python ## Create the virtualenv

deps: venv ## Install Python deps + Galaxy collections into the venv
	$(PY) -m pip install -r requirements.txt
	$(GALAXY) collection install -r requirements.yml

run: deps ## Run the playbook (prompts for sudo password)
	$(ANSIBLE) site.yml --ask-become-pass

check: deps ## Dry-run the playbook (no changes made)
	$(ANSIBLE) site.yml --ask-become-pass --check --diff

lint: deps ## Syntax-check the playbook
	$(ANSIBLE) site.yml --syntax-check

clean: ## Remove the virtualenv
	rm -rf $(VENV)
