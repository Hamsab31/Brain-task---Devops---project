🧠 Brain Tasks App
End-to-End DevOps CI/CD Pipeline on AWS EKS

📌 Project Overview
Brain Tasks App is a production-ready DevOps project that demonstrates a complete CI/CD pipeline for deploying a React application on AWS EKS (Kubernetes).
The application is:
Containerized using Docker
Built and pushed automatically to Amazon ECR
Deployed to AWS EKS using Kubernetes manifests
Fully automated using AWS CodePipeline & CodeBuild
Monitored using AWS CloudWatch Logs
This project follows real-world DevOps practices used in modern cloud environments.

🏗️ Architecture Overview
GitHub
   ↓
AWS CodePipeline
   ↓
AWS CodeBuild (Build & Push Docker Image)
   ↓
Amazon ECR
   ↓
AWS CodeBuild (Deploy Stage)
   ↓
AWS EKS (Kubernetes)
   ↓
Application Load Balancer (Public Access)

📦 Application Details
Item	Description
Application Type	React (Static Build)
Web Server	Nginx
Container Runtime	Docker
Orchestration	Kubernetes (EKS)
Container Port	80
Access Type	Public LoadBalancer

🔧 Tools & AWS Services Used
Category	Tool / Service
Version Control	GitHub
CI/CD Pipeline	AWS CodePipeline
Build Automation	AWS CodeBuild
Container Registry	Amazon ECR
Container Orchestration	Amazon EKS
Monitoring & Logs	Amazon CloudWatch
CLI Tools	Docker, kubectl, AWS CLI

📂 Repository Structure
Brain-Tasks-App/
│
├── Dockerfile
├── buildspec.yml
├── appspec.yaml
├── nginx.conf
├── README.md
│
├── dist/                  # React production build
│
├── k8/
│   ├── deployment.yaml
│   └── service.yaml

🚀 Step-by-Step Implementation

1️⃣ Clone the Repository
git clone https://github.com/Vennilavan12/Brain-Tasks-App.git
cd Brain-Tasks-App

2️⃣ Dockerize the Application
Dockerfile highlights
Base image: nginx:stable-alpine
Serves React build from /usr/share/nginx/html
Build & run locally:
docker build -t brain-task .
docker run -p 3000:80 brain-task
✅ Verify the app runs at:
http://localhost:3000

3️⃣ Create Amazon ECR Repository
aws ecr create-repository \
  --repository-name brain-task \
  --region ap-south-1
Login to ECR
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com
Tag & Push Image
docker tag brain-task:latest <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/brain-task:latest
docker push <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/brain-task:latest

4️⃣ Create EKS Cluster
eksctl create cluster \
  --name brain-cluster \
  --region ap-south-1
Verify nodes:
kubectl get nodes
✅ All nodes should be in Ready state

5️⃣ Kubernetes Deployment
Deployment
Runs container image from ECR
Replica count: 1
Service
Type: LoadBalancer
Exposes application publicly
kubectl apply -f k8/
kubectl get pods
kubectl get svc

6️⃣ CodeBuild – Build Stage
Build Actions
Login to Amazon ECR
Build Docker image
Push image to ECR
Export Kubernetes manifests as artifacts
Artifact Configuration
artifacts:
  files:
    - output/**/*
    
7️⃣ CodePipeline Setup
Stage	Service
Source	GitHub
Build	AWS CodeBuild
Deploy	AWS CodeBuild (kubectl apply)

8️⃣ CodeBuild – Deploy to EKS
Deploy Stage Actions
Install kubectl
Update kubeconfig
Apply Kubernetes manifests
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name brain-cluster

kubectl apply -f output/k8/

9️⃣ IAM & aws-auth Configuration (Critical)
The CodeBuild deploy role must be added to EKS access.
- rolearn: arn:aws:iam::<ACCOUNT_ID>:role/codebuild-brain-task-deploy-pipeline-service-role
  username: codebuild
  groups:
    - system:masters
Apply:
kubectl apply -f aws-auth.yaml
🔍 Monitoring & Logs
CloudWatch Logs Locations
Build Logs
/aws/codebuild/brain-task-build
Deploy Logs
/aws/codebuild/brain-task-deploy
Logs include:
Docker build output
Image push status
kubectl deployment logs

🌐 Application Access
Get LoadBalancer URL:
kubectl get svc
Example:
EXTERNAL-IP:
aaacf4ae2d70240a08a787bcccca263f-1478610608.ap-south-1.elb.amazonaws.com
Open in browser:
http://<EXTERNAL-IP>

📸 Screenshots Required for Submission
No	Screenshot Name
1	1_GitHub_Repo.png
2	2_ECR_Image.png
3	3_CodeBuild_Build_Logs.png
4	4_EKS_Cluster_Nodes_Ready.png
5	5_Kubernetes_Pods_Running.png
6	6_LoadBalancer_External_IP.png
7	7_CodePipeline_Success.png
8	8_CloudWatch_Logs.png
9	9_Live_Application.png

⚠️ Common Mistakes & Fixes (Very Important)
❌ Missing IAM Permissions
Issue
CodeBuild failed to access ECR or EKS
Fix
Add permissions:
ecr:GetAuthorizationToken
eks:DescribeCluster
codebuild:StartBuild
❌ buildspec.yml Not Found
Cause
Wrong file name or incorrect source configuration
Fix
File name must be buildspec.yml
Ensure GitHub is selected as source
❌ kubectl Authentication Error
the server has asked for the client to provide credentials
Fix
Add CodeBuild role to aws-auth ConfigMap
❌ Artifacts Not Passed Between Stages
Error
Input Artifact not declared
Fix
Ensure artifact names match in Source → Build → Deploy
❌ Dockerfile Not Found
Cause
Wrong build context
Fix
Dockerfile must be in repository root

✅ Final Outcome
✔ Fully automated CI/CD pipeline
✔ Docker image built & stored in ECR
✔ Application deployed to EKS
✔ Public LoadBalancer access
✔ Logs monitored via CloudWatch

🏁 Conclusion
This project demonstrates real-world DevOps engineering skills including:
CI/CD automation
Docker containerization
Kubernetes deployments
AWS IAM security
Cloud monitoring & logging
It reflects production-grade DevOps standards and is ideal for interviews, assignments, and portfolio projects.
