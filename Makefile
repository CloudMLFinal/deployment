# Create required namespaces
create-namespaces:
	kubectl create namespace log-collectors --dry-run=client -o yaml | kubectl apply -f -

# Create Fluentd service account and config
setup-fluentd:
	kubectl create serviceaccount fluentd -n log-collectors --dry-run=client -o yaml | kubectl apply -f -
	kubectl create configmap fluentd-config -n log-collectors --from-file=fluent.conf --dry-run=client -o yaml | kubectl apply -f -

# Deploy all components
deploy-all: create-namespaces setup-fluentd deploy-kafka deploy-app deploy-fluentd

# Deploy Kafka and Zookeeper
deploy-kafka:
	kubectl apply -f kafka-deployment.yaml

# Deploy the main application
deploy-app:
	kubectl apply -f deployment.yaml

# Deploy Fluentd
deploy-fluentd:
	kubectl apply -f fluentd-daemonset.yaml

# Clean up all resources
cleanup:
	kubectl delete -f kafka-deployment.yaml
	kubectl delete -f deployment.yaml
	kubectl delete -f fluentd-daemonset.yaml
	kubectl delete namespace log-collectors