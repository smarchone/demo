# AWS Standby Pool Demo

Testing out boot times of EC2 nodes!

## Key Findings

- **Fastest Machine Availability**: Around 10 seconds.
- **Optimization**: It seems we cannot achieve better times with the current setup.

## AWS CLI Commands

- `run-instance`
- `start-instance`
- `stop-instance` (with `--hibernate` option)

## References

- [EKS Node Group with Warm Pool](https://github.com/aws-samples/eks-node-group-with-warm-pool)
- [Faster EC2 Boot Time](https://depot.dev/blog/faster-ec2-boot-time)
- [Infrastructure Provisioner v3](https://depot.dev/blog/infrastructure-provisioner-v3)
- [EC2 Launch Times](https://www.martysweet.co.uk/ec2-launch-times/)
- [EC2 Launch Times GitHub](https://github.com/martysweet/ec2-launch-times/blob/main/README.md)
- [Move Fast and Break the Cloud](https://robaboukhalil.medium.com/move-fast-and-break-the-cloud-b55b899e3683)
- [AWS Plain English Blog](https://aws.plainenglish.io/)
- [EC2 Hibernate: Faster Restarts and Memory Preservation](https://aws.plainenglish.io/ec2-hibernate-faster-restarts-and-memory-preservation-for-your-aws-instances-44d8b10020c8)
- [EC2 Boot Time Benchmarking](https://www.daemonology.net/blog/2021-08-12-EC2-boot-time-benchmarking.html)
