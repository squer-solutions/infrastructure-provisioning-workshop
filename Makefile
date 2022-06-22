create-cluster:
	k3d cluster create workshop -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-arg "--no-deploy=traefik@server:*"

delete-cluster:
	k3d cluster delete workshop

expose-frontend:
	kubectl port-forward svc/helloworld -n frontend 8081:80

install-app:
	kubectl apply -f frontend/frontend.yaml

bootstrap: create-cluster install-app
	