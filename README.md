# ML-Ops Practice
1. Github `Ci-CD` working fine with `EC2`
2. Kubernets API working with `FastAPI + MondoDB + Mongo-express`

# Steps:
1. `minikube start` + `minikube addons enable ingress` (for routing)
1. Create and apply `secrets.yaml`
2. Create and apply `config.yaml` 
3. Create and apply `mongo-depl-serv.yaml` which run a `MongoDB` as a pod inside cluster
4. Create and apply `mongo-express-dep-serv.yaml` which will run a n`Mongo-express` dashboard interactiong with `MongoDB`. Create a new DB, New Collection and add documents using that Dashboard. It can be accessed at `http://192.168.49.2:30001` as it is running at Port 30001 (defined in `mongo_express.yaml` file)
5. Create your `FastApi` app inside `main.py` referencing the db and collection above
6. Create a `Docker` image of your app and push to Hub
7. Lastly create and apply `fastapi` deployment and service files
8. Now you can hit `FastAPI` app at `http://192.168.49.2:30000` as it is running at Port 30000 (defined in `fastapi-service.yaml` file)
9. Edit `/etc/hosts` to map `my-deployed-app.com` to where your `FastAPI` ia running by using:  `echo '192.168.49.2 my-deployed-app.com' | sudo tee -a /etc/` or `echo "$(minikube ip) service.express.mongo" | sudo tee -a /etc/hosts` hosts (For Local system only)
11. Apply `ingress.yaml` to reroute the traffic


# Some Helpful Info & Tips:
1. [Tag Docker images before pushing](https://stackoverflow.com/questions/41984399/denied-requested-access-to-the-resource-is-denied-docker)
2. `kubectl get deployment fastapi-app-deployment -o yaml > fastapi-etcd-cluster-status.yaml` Gives you the status of cluster for the Deployment (which has replicas or pods) named `fastapi-app-deployment` in a file named `fastapi-etcd-cluster-status.yaml` where you can cross check your `deployment.yaml` and `service.yaml` to know how the clusters are managed according to the specifications (`spec` field in files). This info is stored in `etcd` which supervises all the failures and auto creation of pods cross checking with this file
3. Create and apply the `ConfigMap` and `Secrets` files first and then apply the Service and Deployment else it'll result in the error if any of the service uses those secrets and configurations
4. If there is a `Service` running inside cluster, it is allocated **INTERNAL IP ADDRESS** so the system knows that at which particular address the service is running. So in case we want to access the data from that service, we use **THAT** internal address to communicate. So in other terms, How and where to connect with an app is defined in it's `service.yaml` file and whenever we want to know the address like `MongoDB` url, we refer to that service instead of static url.
