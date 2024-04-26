#!/bin/sh

# Check if Minikube is running
minikube status || { echo "Minikube is not running. Please start Minikube and retry."; exit 1; }

# Check for kubectl and Docker
command -v kubectl >/dev/null 2>&1 || { echo "kubectl is not installed. Aborting."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker is not installed. Aborting."; exit 1; }

echo "Switching to Minikube context..."
kubectl config use-context minikube

echo "Setting up Docker environment..."
eval $(minikube docker-env)

docker build -t ping ./ping
docker build -t pong ./pong

kubectl apply -f ./ping/k8s/service.yaml
kubectl apply -f ./pong/k8s/service.yaml

kubectl apply -f ./ping/k8s/deployment.yaml
kubectl apply -f ./pong/k8s/deployment.yaml

echo "All services and deployments have been applied successfully"