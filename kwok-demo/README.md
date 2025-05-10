brew install kwok
kwokctl create cluster --name=kwok
kwokctl scale node --replicas 2
kubectl create deployment pod --image=pod --replicas=5
kwokctl delete cluster --name=kwok


https://github.com/kubernetes-sigs/kwok/tree/main/demo

more sims:
https://github.com/kubernetes-sigs/kube-scheduler-simulator
https://github.com/Remit/autoscaling-simulator