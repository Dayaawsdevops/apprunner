#!/bin/bash
set -euo pipefail

echo "🛠️   Starting AppServer Build & Deploy to EKS..."

# Step 1: Docker Build
echo "🐳 Building Docker image: appserver:latest"
docker build -t appserver:latest .

# Step 2: Set Region and Repo URI
AWS_REGION="${AWS_REGION:-us-east-1}"
REPO_URI="390403881675.dkr.ecr.${AWS_REGION}.amazonaws.com/appserver"

# Login to ECR
echo "🔐 Logging into ECR at $REPO_URI..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REPO_URI"

# Tag and push the image
echo "📦 Tagging and pushing Docker image..."
docker tag appserver:latest "$REPO_URI:latest"
docker push "$REPO_URI:latest"

# Step 3: Replace ECR URL in deployment YAML
echo "📝 Replacing placeholder in k8s/deployment.yaml with ECR image..."
cp k8s/deployment.yaml k8s/deployment.yaml.bak  # backup

sed -i "s|<ecr_image_uri>|${REPO_URI}:latest|g" k8s/deployment.yaml

# Step 4: Deploy to EKS
echo "🚀 Deploying to EKS..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Step 5: Restore the original deployment file
mv k8s/deployment.yaml.bak k8s/deployment.yaml

echo "✅ AppServer deployed to EKS in $AWS_REGION using ECR image $REPO_URI"

