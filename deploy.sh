#!/bin/bash

set -e # Stop on error

# kubectl delete all --all # Delete all the pods and services running

# Remove the Docker images
docker rmi fastapi-image-test-k8 || true # || true means if error comes, skip onto next process
docker rmi maheshjackett/fastapi-image-test-k8 || true

# Delete all the Kubernetes deployments
# kubectl delete deployment fastapi-deployment || true
# kubectl delete deployment mongo-express-deployment || true
# kubectl delete deployment kibana-deployment || true
# kubectl delete deployment logstash-deployment || true
# kubectl delete deployment elasticsearch-deployment || true
kubectl delete deployments --all

# Delete the Services
kubectl delete services fastapi-app-service || true
kubectl delete services mongo-express-service || true
kubectl delete services mongodb-service || true
kubectl delete services kibana-service || true
kubectl delete services logstash-service || true
kubectl delete services elasticsearch-service || true

# Delete all StatefulSets
# kubectl delete  statefulset mongodb-stateful || true
kubectl delete  statefulsets --all


# Build the Docker image
docker build --no-cache -t fastapi-image-test-k8 ./fastapi_code/.

# Tag and push the Docker image
docker tag fastapi-image-test-k8 maheshjackett/fastapi-image-test-k8
docker push maheshjackett/fastapi-image-test-k8

# Apply all the files in stepwise manner
kubectl apply -f ./k8_configs/mongo_secrets.yaml # secrets
kubectl apply -f ./k8_configs/mongo_configmap.yaml # Configs
kubectl apply -f ./k8_configs/mongo_depl_serv.yaml # DB should be run first. One files has deployment and service
kubectl apply -f ./k8_configs/mongo_express_depl_serv.yaml # One file for both deployment and service
kubectl apply -f ./k8_configs/fastapi_deployment_file.yaml # FastAPI Deployment pod
kubectl apply -f ./k8_configs/fastapi_service_file.yaml # FastAPI service
kubectl apply -f ./k8_configs/elastic_depl_serv.yaml # Elastic Search
kubectl apply -f ./k8_configs/logstash_depl_serv.yaml  # Logstash
kubectl apply -f ./k8_configs/kibana_depl_serv.yaml  # kibana dashboard
kubectl apply -f ./k8_configs/ingress.yaml # Enable ingress for routing