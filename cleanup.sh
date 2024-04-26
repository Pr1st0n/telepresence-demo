#!/bin/sh

# Ensure Minikube is running
minikube status > /dev/null || { echo "Minikube is not running. Please start Minikube and try again."; exit 1; }

# Switch to Minikube context
echo "Configuring Kubernetes context to use Minikube..."
kubectl config use-context minikube

# Clean up Kubernetes resources safely
echo "Removing existing Kubernetes deployments and services..."
kubectl delete -f ./ping/k8s/deployment.yaml --ignore-not-found
kubectl delete -f ./pong/k8s/deployment.yaml --ignore-not-found
kubectl delete -f ./ping/k8s/service.yaml --ignore-not-found
kubectl delete -f ./pong/k8s/service.yaml --ignore-not-found

# Set up Docker environment
eval $(minikube docker-env)

# Remove Docker images safely
echo "Cleaning up Docker images..."
docker rmi ping pong --force || true

echo "Cleanup complete. All specified resources and images have been removed."