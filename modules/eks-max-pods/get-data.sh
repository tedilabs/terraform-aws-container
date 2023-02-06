#!/usr/bin/env sh

aws ec2 describe-instance-types \
  --query "InstanceTypes[].{type: InstanceType, vcpu: VCpuInfo.DefaultVCpus, max_enis: NetworkInfo.MaximumNetworkInterfaces, max_ipv4_addrs_per_eni: NetworkInfo.Ipv4AddressesPerInterface}" \
  --output json > data.json
