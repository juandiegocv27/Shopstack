# 🏗️ **ShopStack Architecture Overview**

A complete overview of the **ShopStack** project architecture and repository relationships.

---

## 📦 **Repositories Overview**

| Repository | Purpose | Main Technologies |
|-------------|----------|-------------------|
| **infra-terraform** | Defines and provisions the foundational infrastructure (S3 backend, DynamoDB for locks, Terraform remote state). | Terraform, AWS |
| **cluster-gitops** | Manages cluster provisioning, configuration, and repeatability testing using Kind and GitOps workflows. | Kind, Kubectl, Makefile |
| **apps-sre** | Hosts applications and observability stacks that run inside the Kubernetes cluster. | Docker, Helm, ArgoCD *(future)* |

---

## 🧭 **Architecture Diagram (Text Representation)**

```plaintext
Developer
│
├── infra-terraform
│   ├── S3 bucket (Terraform backend)
│   └── DynamoDB table (state lock)
│
├── cluster-gitops
│   ├── Kind cluster (shopstack)
│   ├── kube-system components (CoreDNS, etc.)
│   └── Repeatability automation via Makefile
│
└── apps-sre
    ├── App deployment (CI/CD)
    └── Future observability stack (Grafana, Prometheus)
```
---

## 🪜 **Bootstrap Sequence Summary**

### 1. Infrastructure Setup
Initialize the Terraform backend in AWS S3 and DynamoDB:

```bash
cd infra-terraform/envs/dev
terraform init
terraform plan
terraform apply
```

2. Cluster Creation

Switch to the cluster-gitops repository and create the local Kind cluster:
```bash
cd ../cluster-gitops
kind create cluster --name shopstack --config kind-config.yaml
```
3. Validation

Verify cluster readiness:
```bash
kubectl get nodes
kubectl get pods -n kube-system | grep coredns
```
4. Repeatability Test

Run automated validation:
```bash
make repeat-test
```
Results are saved to repeat.log.

---

🔒 Security Notes
    - No public endpoints exposed (local Kind cluster).
	- Kubeconfig protected with:
```plaintext
chmod 600 ~/.kube/config
```
Docker daemon restricted to local use.
Terraform state secured in private AWS S3 bucket with DynamoDB locking.

---

🧩 Future Improvements

	- Add CI/CD pipeline for infrastructure changes.
	- Integrate EKS managed cluster for cloud testing.
	- Enable security scanning tools (Trivy, kube-bench).
	- Automate bootstrap across all repositories with a unified Makefile.
---

🗂️ Folder Structure
```bash
infra-terraform/
├── envs/
│   └── dev/
│       ├── backend.tf
│       ├── main.tf
│       └── versions.tf
├── .github/
│   └── workflows/terraform-ci.yml
├── Makefile
└── docs/
    └── ARCHITECTURE.md
```
---

🧭 Additional Documentation

This document complements:
```plaintext
    - cluster-gitops/docs/BOOTSTRAP.md → Cluster operations
	- apps-sre/docs/README.md → Application deployments
```
Together, all repositories form a reproducible, modular, and secure DevOps workflow under the ShopStack project umbrella.


