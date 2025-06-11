#!/bin/bash
set -e

echo "🛠️  Starting AppServer Build & Deploy to EKS..."

# Step 0: Set up environment
export AWS_REGION=${AWS_REGION:-us-east-1}  # Use secret or default
echo "🔁 Using AWS region: $AWS_REGION"

# Step 1: Docker Build
docker build -t appserver:latest .

# Step 2: Tag & Push to ECR
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO_NAME="appserver"
REPO_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"

# Create ECR repo if it doesn't exist
aws ecr describe-repositories --repository-names $REPO_NAME --region $AWS_REGION > /dev/null 2>&1 || \
aws ecr create-repository --repository-name $REPO_NAME --region $AWS_REGION

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URI
docker tag appserver:latest $REPO_URI:latest
docker push $REPO_URI:latest

# Step 3: Replace image URI in YAML
echo "🔁 Replacing image URL in deployment..."
DEPLOYMENT_FILE="k8s/deployment.yaml"
cp $DEPLOYMENT_FILE ${DEPLOYMENT_FILE}.bak
sed -i "s|<ecr_image_uri>|$REPO_URI:latest|g" $DEPLOYMENT_FILE

# Step 4: Deploy to EKS
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "✅ AppServer deployed to EKS successfully."

