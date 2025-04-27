# Cloud ML Final Project Deployment


## Dev setup
1. Install the minikuber in the computer and start the k8s
2. Deployment the services `make deploy-all`
3. Expose the web and kafka service with minikuber command `minikube service cloudml-app-service kafka-service -n log-collectors`


PS： If you want to direct connect the kafka outside of the k8s, please use forward the port `kubectl port-forward -n log-collectors service/kafka-service 29092:29092`