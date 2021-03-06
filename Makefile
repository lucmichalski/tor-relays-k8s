# Declare config vars
CONTAINER_REGISTRY=quay.io/conorsch
CONTAINER_NAME=tor-relay

.PHONY: container
container:
	docker build docker/ -t $(CONTAINER_REGISTRY)/$(CONTAINER_NAME)
	docker push $(CONTAINER_REGISTRY)/$(CONTAINER_NAME)

.PHONY: k8s
k8s:
	kubectl apply -f k8s/ -R
	./scripts/config-maps

.PHONY: all
all: container k8s

.PHONY: destroy
destroy:
	kubectl delete -f k8s -R --ignore-not-found
	kubectl delete configmap tor-relay-config-1 --ignore-not-found
	kubectl delete configmap tor-relay-config-2 --ignore-not-found
