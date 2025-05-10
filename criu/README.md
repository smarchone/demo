# CRIU (Checkpoint/Restore In Userspace)

CRIU is a software tool for checkpointing and restoring the state of processes. It allows you to freeze a running application and save its state to disk, then restore it later.

## Introduction

- [CRIU GitHub Repository](https://github.com/checkpoint-restore)
- [Simple Loop Example](https://criu.org/Simple_loop)
- [CRIU Coordinator](https://github.com/checkpoint-restore/criu-coordinator): The coordinator interacts with CRIU over Unix sockets for checkpointing and restoring container states.

## Features

- **Live Migration**: [p.haul](https://github.com/checkpoint-restore/p.haul)
- **Checkpointing Archive**: [checkpointctl](https://github.com/checkpoint-restore/checkpointctl)

## CRIU Demo

```sh
cat > test.sh <<-EOF
#!/bin/sh
while :; do
    sleep 1
    date
done
EOF
chmod +x test.sh
setsid ./test.sh < /dev/null &> test.log &
criu dump -t $(pgrep test.sh) -v1 -o dump.log && echo OK
criu restore -d -v1 -o restore.log && echo OK
```

## Remarks

- **CRIU 3.1**: Fails on Ubuntu. Build it from source and install dependencies ([Installation Dependencies](https://criu.org/Installation#Dependencies)).
- **CRIU 4.1**: Works well. Refer to the [Installation Guide](https://github.com/checkpoint-restore/criu/blob/criu-dev/INSTALL.md).
- **Rust Compiler**: Requires `rustc > 1.86`. See [Issue #2563](https://github.com/checkpoint-restore/criu/issues/2563).

## References

### Kubernetes
- [Forensic Container Checkpointing (Alpha)](https://kubernetes.io/blog/2022/12/05/forensic-container-checkpointing-alpha/)
- [Kubelet Checkpoint API](https://kubernetes.io/docs/reference/node/kubelet-checkpoint-api/)
- [K8s CRIU Container Checkpointing](https://seifrajhi.github.io/blog/k8s-criu-container-checkpointing/)
- [Checkpoint Restore Operator](https://github.com/hitachienergy/checkpoint-restore-operator)

### CRAC
- [CRAC Official Website](https://crac.org/)
- [AWS Lambda SnapStart with CRAC and CRIU](https://antukhov.medium.com/aws-amplify-aws-lambda-snapstart-activation-serverless-java-with-crac-and-criu-cfed09f770b7)

### Fly.io
- [Fly Machine Snapshot Restore](https://community.fly.io/t/fly-machine-snapshot-restore/8818)
- [Suspend/Resume for Machines](https://community.fly.io/t/new-feature-in-preview-suspend-resume-for-machines/20672)
- [Autosuspend Feature](https://community.fly.io/t/autosuspend-is-here-machine-suspension-is-enabled-everywhere/20942)
- [Using Containers with Flyctl](https://community.fly.io/t/using-containers-with-flyctl/24729)
