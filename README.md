# 🚀 AppServer CI/CD with GitHub Actions & Amazon EKS

A complete CI/CD pipeline for deploying a Python application to Amazon EKS using GitHub Actions, Docker, and AWS services.

## 🔧 Tech Stack

- **🐳 Docker** — Containerization
- **☁️ Amazon ECR** — Container Registry
- **☸️ Amazon EKS** — Kubernetes Cluster
- **🤖 GitHub Actions** — CI/CD Pipeline
- **🐍 Python 3** — Application Runtime
- **📦 pip** — Python Package Installer
- **🛠️ kubectl** — Kubernetes CLI
- **📜 eksctl** — EKS Cluster Manager

## 📦 Project Structure

```
.
├── app.py
├── Dockerfile
├── requirements.txt
├── tools/
│   └── build_release.sh
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
└── .github/
    └── workflows/
        └── deploy.yml
```

## 🪜 Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/appserver.git
cd appserver
```

### 2. Create an ECR Repository

```bash
aws ecr create-repository --repository-name appserver --region <your-region>
```

### 3. (Optional) Create an EKS Cluster

```bash
eksctl create cluster \
  --name dev-cluster \
  --region <your-region> \
  --nodegroup-name dev-nodes \
  --nodes 2
```

### 4. Configure GitHub Secrets

Add the following secrets to your GitHub repository (`Settings > Secrets and variables > Actions`):

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

### 5. Push Code to GitHub

```bash
git add .
git commit -m "🚀 Initial AppServer CI/CD setup"
git push origin main
```

### 6. GitHub Actions Workflow

The GitHub Actions workflow will automatically:

- ✅ Build Docker image
- ✅ Push to ECR
- ✅ Replace image URI in Kubernetes YAML
- ✅ Deploy to EKS via kubectl

## ✅ Verify Deployment

After the workflow completes, verify your deployment:

```bash
# Check pods status
kubectl get pods

# Check service status
kubectl get svc appserver-service
```

## 🚀 Getting Started

1. Fork or clone this repository
2. Update the repository name in the clone URL
3. Replace `<your-region>` with your AWS region
4. Configure your GitHub secrets
5. Push your changes to trigger the CI/CD pipeline

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- kubectl installed and configured
- eksctl installed (for cluster creation)
- GitHub repository with Actions enabled

## 🔧 Configuration

Make sure to update the following files with your specific configuration:

- Update AWS region in deployment steps
- Modify `k8s/deployment.yaml` and `k8s/service.yaml` as needed
- Adjust the GitHub Actions workflow in `.github/workflows/deploy.yml`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Happy Deploying!** 🎉
