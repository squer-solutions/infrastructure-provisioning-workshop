# SQUER Brainfood Session | ArgoCD
https://argo-cd.readthedocs.io/en/stable/

This repository contains the presented examples from the SQUER internal Brainfood Session in May 2022.
It gives a gentle introduction to ArgoCD and might help getting started with the GitOps approach by providing an environment
for playing around and exploring ArgoCD.

## Prerequisites
+ k3d installed (``brew install k3d``)
+ (Optional) argocd cli installed (``brew install argocd``)
+ (Recommended) Watch Nana on Youtube: https://www.youtube.com/watch?v=MeU5_k9ssrs

## Local Cluster Setup

Execute the following command to create a new k8s (k3d) cluster and install ArgoCD

``make bootstrap``

Running ``kubectl get pods -A`` shows you all the pods running on your newly created cluster. As soon as a pod in namespace
``argocd`` starting with the name ``argocd-server-*`` is in status ``Running``, you can execute the following command to access the
argocd-ui:

``make expose-argo``

This allows you to access argo at https://localhost:8080 . The username is per default ``admin`` and the password can be 
retrieved via ``make show-password``. You can either use the argo-ui from the browser or the the argocd-cli using the commandline.
For using the cli you simply enter ``argocd login localhost:8080`` for authentication.

## Create your first ArgoCD Application

You have three options to create a new "Application" in ArgoCD:

+ ArgoCD UI
+ ArgoCD CLI
+ Kubernetes CRD

If you are used to writing k8s yaml files, the possibility of using K8S Custom Ressource Definitions (CRD) avoids 
technical context switches and learning a new cli, nevertheless provides all the advantages of infrastructure-as-a-code setups.

To create our little hello-world frontend application we simply run ``kubectl apply -f app.yaml``. This creates the ArgoCD
CRD "Application" with the name "frontend". From now on, the infrastructure state of our frontend application is defined in the folder
``frontend`` in this repository. Whatever kubernetes yaml file we add, this gets automatically applied in our K8S cluster.
The syncronisation is triggered via Git-Webhooks, whereas this is not working on our local machines. Therefore we either trigger
the sync in the ArgoCD UI or we use the CLI:

``argocd app sync frontend``

This command tells argo to load the newest changes from the git repo and applies them in the cluster.

However, this is only relevant if we change the yamls after our initial sync. The creation of the ArgoCD aplication triggers
the sync as well. So, by running `` kubectl port-forward svc/helloworld -n frontend 8081:80`` we expose our newly created
frontend applcation at port ``8081`` (http://localhost:8081)

