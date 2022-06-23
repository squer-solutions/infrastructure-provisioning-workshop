ARGO_VERSION ?= v2.3.4

install-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$(ARGO_VERSION)/manifests/install.yaml

create-cluster:
	k3d cluster create workshop -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-arg "--no-deploy=traefik@server:*"

delete-cluster:
	k3d cluster delete workshop

expose-argo:
	kubectl port-forward svc/argocd-server -n argocd 8080:443

expose-frontend:
	kubectl port-forward svc/helloworld -n frontend 8081:80

show-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

generate-ssh:
	mkdir -p ./_init/ssh
ifeq (,$(wildcard ./_init/ssh/repo_read))
		ssh-keygen -t ed25519 -N "" -C "argocd-repo_read" -f ./_init/ssh/repo_read
endif

apply-init-manifests: generate-ssh
	READ_SSH_KEY=$(shell base64 _init/ssh/repo_read) envsubst <_init/repo-creds.yaml | kubectl apply -f -
	kubectl apply -f _init/furnishing.yaml
	kubectl apply -f _init/app.yaml

bootstrap: create-cluster install-argocd apply-init-manifests
	