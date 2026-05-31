#!/bin/bash
# Manual fallback script for backend container deployment
echo "Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REGISTRY
echo "Building and pushing new image..."
cd ../backend
docker build -t $ECR_REGISTRY/starttech-backend:latest .
docker push $ECR_REGISTRY/starttech-backend:latest
echo "Triggering ASG Rolling Update..."
aws autoscaling start-instance-refresh --auto-scaling-group-name starttech-prod-asg
echo "Backend deployment triggered."