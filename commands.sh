#!/bin/bash

# Set Variables
DEPLOYMENT_NAME="go-app"
POD_NAME="go-app-pod"
IMAGE_NAME="go-app-image"
NEW_IMAGE_TAG="v2"
PORT=8000

# Create Deployment
kubectl create deployment $DEPLOYMENT_NAME --image=$IMAGE_NAME:$NEW_IMAGE_TAG

# Expose the Deployment
# Use LoadBalancer for cloud or NodePort for local Minikube/kind
kubectl expose deployment $DEPLOYMENT_NAME --type=LoadBalancer --port=$PORT
kubectl expose deployment $DEPLOYMENT_NAME --type=NodePort --port=$PORT
minikube service $DEPLOYMENT_NAME

# Scale Deployment
kubectl scale deployment $DEPLOYMENT_NAME --replicas=3

# Get Deployment, Service, and Pod Details
kubectl get deployments
kubectl get services
kubectl get pods

# Inspect Deployment, Service, and Pod
kubectl describe deployment $DEPLOYMENT_NAME
kubectl describe service $DEPLOYMENT_NAME
kubectl describe pod $POD_NAME

# Update Deployment Image (Rolling Update)
kubectl set image deployment/$DEPLOYMENT_NAME $DEPLOYMENT_NAME=$IMAGE_NAME:$NEW_IMAGE_TAG

# Monitor Rollout Status
kubectl rollout status deployment/$DEPLOYMENT_NAME
kubectl rollout history deployment/$DEPLOYMENT_NAME

# Rollback if needed
kubectl rollout undo deployment/$DEPLOYMENT_NAME
kubectl rollout history deployment/$DEPLOYMENT_NAME --revision=1
kubectl rollout undo deployment/$DEPLOYMENT_NAME --to-revision=1

# Delete Deployment and Service
kubectl delete deployment $DEPLOYMENT_NAME
kubectl delete service $DEPLOYMENT_NAME
