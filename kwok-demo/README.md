# KWOK Demo

This demo showcases the usage of KWOK (Kubernetes WithOut Kubelet) for simulating Kubernetes clusters.

## Installation

```sh
brew install kwok
```

## Usage

1. **Create a Cluster**:
   ```sh
   kwokctl create cluster --name=kwok
   ```

2. **Scale Nodes**:
   ```sh
   kwokctl scale node --replicas 2
   ```

3. **Create a Deployment**:
   ```sh
   kubectl create deployment pod --image=pod --replicas=5
   ```

4. **Delete the Cluster**:
   ```sh
   kwokctl delete cluster --name=kwok
   ```

## References

- [KWOK Demo Repository](https://github.com/kubernetes-sigs/kwok/tree/main/demo)

### More Simulators

- [Kube Scheduler Simulator](https://github.com/kubernetes-sigs/kube-scheduler-simulator)
- [Autoscaling Simulator](https://github.com/Remit/autoscaling-simulator)