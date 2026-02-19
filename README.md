# ShopStack — SRE/Cloud/DevOps Portfolio Project

> A production-grade e-commerce reliability engineering platform built to demonstrate enterprise SRE practices: infrastructure-as-code, GitOps, CI/CD automation, and cloud-native operations on AWS and Kubernetes.

---

## Overview

ShopStack is a portfolio project that simulates the infrastructure and operational practices of a real e-commerce platform. It is not focused on application features — it is focused on **how the platform is built, deployed, operated, and recovered**.

Every component is designed to be reproducible, auditable, and interview-demonstrable.

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Developer Laptop                     │
│         Debian 13.3 (VMware) — daily driver              │
└────────────────────┬────────────────────────────────────┘
                     │ git push
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  GitHub (apps-sre)                       │
│         GitHub Actions CI Pipeline (OIDC → AWS)          │
│   build → test → push ECR → PR to cluster-gitops         │
└────────────────────┬────────────────────────────────────┘
                     │ image bump PR
                     ▼
┌─────────────────────────────────────────────────────────┐
│              GitHub (cluster-gitops)                     │
│         GitOps source of truth (Kustomize)               │
│         Argo CD polls → syncs to cluster                 │
└────────────────────┬────────────────────────────────────┘
                     │ kubectl apply (desired state)
                     ▼
┌─────────────────────────────────────────────────────────┐
│           Local Talos Linux Kubernetes Cluster           │
│     control-plane: talos-43f-se5 (192.168.100.183)       │
│     worker:        talos-che-x98 (192.168.100.104)       │
│                                                          │
│  Namespaces: argocd | catalog | monitoring | shopstack   │
└─────────────────────────────────────────────────────────┘
                     │ IAM (OIDC)
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  AWS (us-east-1)                         │
│   ECR — container image registry                         │
│   Secrets Manager — runtime secrets                      │
│   CodeBuild — native CI executor (quota pending)         │
│   IAM — OIDC federation, least-privilege roles           │
└─────────────────────────────────────────────────────────┘
```

---

## Repositories

| Repository | Purpose |
|---|---|
| [`shopstack`](https://github.com/juandiegocv27/infra-terraform) | AWS infrastructure — ECR, IAM, Secrets Manager, CodeBuild via Terraform |
| [`apps-sre`](https://github.com/juandiegocv27/apps-sre) | Application code + GitHub Actions CI pipeline |
| [`cluster-gitops`](https://github.com/juandiegocv27/cluster-gitops) | Kubernetes GitOps config — Argo CD App-of-Apps, Kustomize overlays |

---

## Technology Stack

**Cloud & Infrastructure**
- AWS ECR — private container registry
- AWS Secrets Manager — secrets storage
- AWS CodeBuild — CI executor (native; GitHub Actions used as workaround during quota ramp-up)
- AWS IAM — OIDC federation for keyless GitHub Actions → AWS authentication
- Terraform — all AWS infrastructure provisioned as code

**Kubernetes & GitOps**
- Talos Linux — immutable, API-driven Kubernetes OS (no SSH, no shell)
- Kubernetes v1.34 — two-node local cluster (UTM/ARM)
- Argo CD — GitOps controller, App-of-Apps pattern
- Kustomize — environment-specific overlays (dev/staging/prod)
- Flannel — CNI

**CI/CD**
- GitHub Actions — CI orchestration with OIDC (no long-lived AWS credentials)
- Docker — container builds
- Automated GitOps PR — CI bumps image tag in `cluster-gitops` on every merge

**Developer Environment**
- Debian 13.3 (VMware VM)
- Terraform CLI, kubectl, talosctl, argocd CLI, AWS CLI

---

## CI/CD Pipeline Flow

```
git push to apps-sre main
        │
        ▼
GitHub Actions (ci.yml)
  1. Authenticate to AWS via OIDC (no stored secrets)
  2. Login to ECR
  3. Build Docker image
  4. Push image to ECR (tagged with commit SHA)
  5. Read app config from Secrets Manager
  6. Open PR to cluster-gitops bumping image tag
        │
        ▼
PR merged to cluster-gitops main
        │
        ▼
Argo CD detects diff (polling or webhook)
  → syncs Deployment to cluster
  → new pod rolls out
  → health check passes
```

---

## GitOps Structure (cluster-gitops)

```
apps/
├── root/                    # App-of-Apps root applications
│   ├── apps-business.yaml   # manages apps/business/*
│   ├── apps-infra.yaml      # manages apps/infra/*
│   └── apps-monitoring.yaml # manages apps/monitoring/*
├── business/
│   └── catalog-dev.yaml     # catalog Application (→ overlays/dev)
├── catalog/
│   ├── base/                # base Deployment + Service
│   └── overlays/dev/        # dev-specific image tag + namespace
├── infra/
└── monitoring/
```

---

## Infrastructure as Code (infra-terraform)

All AWS resources are Terraform-managed:

```
core/
├── ecr/          # ECR repositories
├── secrets/      # Secrets Manager secrets
├── codebuild/    # CodeBuild project
iam/
├── codebuild-role/     # IAM role for CodeBuild
├── github-oidc/        # OIDC provider + GHA trigger role
```

---

## Project Status

| Phase | Status |
|---|---|
| Requirements & Analysis | ✅ Complete |
| Design | ✅ Complete |
| Infrastructure (Terraform) | ✅ Complete |
| CI Pipeline (GitHub Actions + ECR) | ✅ Complete |
| GitOps (Argo CD + catalog-dev) | ✅ Complete |
| Observability (Prometheus + Grafana) | 🔄 In progress |
| Argo Rollouts (canary strategy) | 📋 Planned |
| CodeBuild native executor | 📋 Pending AWS quota resolution |

---

## Key Design Decisions

**Why Talos Linux?** Immutable, minimal attack surface, API-driven — mirrors production hardening practices. No SSH access forces proper tooling discipline.

**Why OIDC instead of IAM access keys?** Keyless authentication is the current best practice. No secrets stored in GitHub, no rotation burden, short-lived tokens only.

**Why App-of-Apps?** Scales cleanly as services are added. One root application manages all child applications. New services require only a manifest in `apps/business/`.

**Why GitHub Actions as CI workaround?** New AWS accounts have a CodeBuild concurrent build quota of 0. Rather than blocking progress, a hybrid approach keeps the portfolio moving while demonstrating awareness of the native target architecture.

---

## Running Locally

### Prerequisites
- AWS CLI configured (`aws configure`)
- `kubectl` with valid kubeconfig for the Talos cluster
- `argocd` CLI
- `terraform` >= 1.5

### Check cluster health
```bash
kubectl get nodes
kubectl get applications -n argocd
```

### Check CI pipeline
```bash
# Latest ECR image
aws ecr describe-images \
  --repository-name shopstack-catalog \
  --region us-east-1 \
  --query 'sort_by(imageDetails,&imagePushedAt)[-1].{tag:imageTags[0],pushed:imagePushedAt}'
```

### Check catalog app
```bash
argocd app get catalog-dev
kubectl get pods -n catalog
```

---

## AWS Account

Account ID: `770132776547` | Region: `us-east-1`
