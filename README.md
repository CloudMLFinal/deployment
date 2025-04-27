# Cloud ML Final Project Deployment


## Dev setup
1. Install the minikuber in the computer and start the k8s
2. Deployment the services `make deploy-all`
3. Expose the web and kafka service with minikuber command `minikube service cloudml-app-service kafka-service -n log-collectors`