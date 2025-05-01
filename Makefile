# Create required namespaces
create-namespaces:
	kubectl create namespace cloudml --dry-run=client -o yaml | kubectl apply -f -

# Create Fluentd service account and config
setup-fluentd:
	kubectl create serviceaccount fluentd -n cloudml --dry-run=client -o yaml | kubectl apply -f -
	kubectl create configmap fluentd-config -n cloudml --from-file=fluent.conf --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f fluentd-rbac.yaml

# Create the agent service account and config
setup-agent:
	kubectl apply -f agent-rbac.yaml
	kubectl apply -f agent-secret.yaml

# Deploy all components
deploy-all: create-namespaces setup-fluentd deploy-kafka deploy-app deploy-fluentd setup-agent deploy-agent

# Deploy Kafka and Zookeeper
deploy-kafka:
	kubectl apply -f kafka-deployment.yaml

# Deploy the main application
deploy-app:
	kubectl apply -f deployment.yaml

# Deploy Fluentd
deploy-fluentd:
	kubectl apply -f fluentd-daemonset.yaml

# Deploy the agent
deploy-agent:
	kubectl apply -f agent-deployment.yaml

# forward the port of kafka service
forward-kafka:
	kubectl port-forward -n cloudml service/kafka-service 30902:30902

# forward app
forward-app:
	minikube service cloudml-app-service -n cloudml

# Clean up all resources
cleanup:
	kubectl delete -f kafka-deployment.yaml
	kubectl delete -f deployment.yaml
	kubectl delete -f fluentd-daemonset.yaml
	kubectl delete -f agent-deployment.yaml
	kubectl delete namespace cloudml

encode-secret:
	chmod +x encode.sh
	./encode.sh
