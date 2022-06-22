ARGO_VERSION ?= v2.3.4

install-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$(ARGO_VERSION)/manifests/install.yaml

create-cluster:
	k3d cluster create argo-bfs -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-arg "--no-deploy=traefik@server:*"

delete-cluster:
	k3d cluster delete argo-bfs

expose-argo:
	kubectl port-forward svc/argocd-server -n argocd 8080:443

show-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

bootstrap: create-cluster install-argocd