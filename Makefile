##
# hyperdos
#
# @file
# @version v1-alpha

build-epitome-image:
	docker build -t epitome ./epitome

run-epitome-image:
	docker run --rm -it epitome

minikube-import-images:
	minikube --profile hyperbolic --alsologtostderr image load 'TODO-image-name:latest'

build-and-run-epitome-image: build-epitome-image run-epitome-image

build-sshbox-image:
	docker build -t sshbox -f sshbox/Dockerfile .

run-sshbox-image:
	docker run -t sshbox --rm -d -p '2222:2222' sshbox

build:
	cd epitome; \
	go build -o ./epitome

run-epitome:
	cd epitome; \
	export HYPERBOLIC_GATEWAY_URL='https://api.dev-hyperbolic.xyz' && \
	go run . -loglevel debug -kubeconfig ~/.kube/config

epitome-help:
	cd epitome; \
	go run . -help

mod-tidy:
	cd epitome; \
	go mod tidy

test:
	cd epitome; \
	go test ./...

.PHONY: helm-test
helm-test:
	@cd metadeployment; \
	helm template metadeployment \
		--set ref="dev" \
		.

	@cd gitapps/nvidia-smi; \
	helm template nvidia-smi \
		--set ref="dev" \
		.

	@cd gitapps/epitome; \
	helm template epitome \
		--set ref="dev" \
		.

	@cd gitapps/epitome; \
	helm template epitome \
		--set ref="main" \
		.

test-helm-install:
	@cd charts/hyperdos; \
	helm template hyperdos \
		--debug \
		--set ref="dev" \
		.
