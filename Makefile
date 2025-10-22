SHELL := /usr/bin/env bash
ENV ?= dev
ENV_DIR := envs/$(ENV)
KUBECTL ?= kubectl

.PHONY: help bootstrap fmt validate plan apply destroy kctx kubeconfig

help: ; @echo "Targets: bootstrap | fmt | validate | plan | apply | destroy | kctx | kubeconfig"

bootstrap: ; cd $(ENV_DIR) && terraform init
fmt:       ; cd $(ENV_DIR) && terraform fmt -recursive
validate:  ; cd $(ENV_DIR) && terraform validate
plan: fmt validate ; cd $(ENV_DIR) && terraform plan
apply:     ; cd $(ENV_DIR) && terraform apply -auto-approve
destroy:   ; cd $(ENV_DIR) && terraform destroy -auto-approve

kctx: ; $(KUBECTL) config use-context $${KUBECTX:-dev}
kubeconfig:
	aws eks update-kubeconfig \
	  --name $$(terraform -chdir=$(ENV_DIR) output -raw cluster_name 2>/dev/null || echo shopstack-dev) \
	  --region $$(terraform -chdir=$(ENV_DIR) output -raw region 2>/dev/null || echo us-east-1)
