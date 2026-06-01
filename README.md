# StartTech Cloud Infrastructure & CI/CD Deployment

##  Live Application Links
* **Frontend (CloudFront):** `https://d1r20y0lsm0v1z.cloudfront.net/`
* **Backend API (ALB):** `starttech-prod-alb-179067028.us-east-1.elb.amazonaws.com`

##  Project Overview
This project is a complete, automated cloud deployment of the StartTech full-stack application (React frontend, Golang backend, MongoDB database). The infrastructure is provisioned immutably using Terraform, and the application is continuously integrated and deployed via GitHub Actions to an AWS environment designed for high availability and scalability.

## Cloud Architecture
* **Frontend:** Built with Vite and React, hosted on a private **AWS S3** bucket, and distributed globally via an **AWS CloudFront** CDN for low-latency access and caching.
* **Backend:** A Golang REST API containerized with Docker, deployed across an **AWS Auto Scaling Group (ASG)** of EC2 instances, and load-balanced by an **Application Load Balancer (ALB)**.
* **Database:** Hosted externally on **MongoDB Atlas** for managed replication and automated backups.
* **Infrastructure as Code:** All networking (VPC, Subnets, Internet Gateway), security groups, IAM roles, and compute resources were provisioned using **Terraform**.

##  CI/CD Pipelines
Automation is handled via GitHub Actions with two distinct workflows:

1. **Frontend Pipeline (`frontend-ci-cd.yml`):**
   * Triggered on changes to the `frontend/` directory.
   * Runs Node 20 environment setup and dependency installation.
   * Executes `npm audit` for dependency vulnerability scanning.
   * Compiles the Vite build into the `dist/` directory.
   * Syncs the compiled assets to the AWS S3 bucket.
   * Invalidates the CloudFront cache to serve the latest version globally.

2. **Backend Pipeline (`backend-ci-cd.yml`):**
   * Triggered on changes to the `backend/` directory.
   * Sets up Go 1.25 and runs a suite of unit tests.
   * Builds the Docker image and tags it for the current run.
   * Runs an **Aqua Security Trivy** scan to check the container image for High/Critical CVEs.
   * Pushes the verified image to **Amazon Elastic Container Registry (ECR)**.
   * Triggers an AWS Auto Scaling Group Instance Refresh for zero-downtime rolling updates.

##  Deployment Scripts
Fallback manual deployment and utility scripts are located in the `/scripts` directory.

* `deploy-backend.sh`: Manually builds the Go Docker image, authenticates with AWS, pushes to ECR, and initiates an ASG Instance Refresh.
* `deploy-frontend.sh`: Manually builds the Vite React app, syncs it to S3, and triggers a CloudFront invalidation.
* `health-check.sh`: Pings the Application Load Balancer's `/health` endpoint and verifies a `200 OK` status response to ensure the ASG instances are healthy.
* `rollback.sh`: Cancels any active Auto Scaling Group Instance Refresh in the event of a faulty deployment.

## Security & Secrets
No credentials are hardcoded in this repository. The CI/CD pipelines rely on the following GitHub Secrets:
* `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` (Used for CI/CD execution)
* `MONGO_URI`
* `S3_BUCKET`
* `CLOUDFRONT_DIST_ID`
