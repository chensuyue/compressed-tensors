#!/bin/bash

echo "Trigger test scripts..."
echo "NUMA_NODE is $NUMA_NODE"
echo "NUMA_CPUSET is $NUMA_CPUSET"
echo "ZE_AFFINITY_MASK is $ZE_AFFINITY_MASK"
echo "NODE_LABEL is $NODE_LABEL"
echo "Hello world" && sleep 20 && echo "End."
CONTAINER_NAME=vllm-test-container-$NODE_LABEL
IMAGE_NAME=vllm-xpu-test:py312
REPO_PATH="${BUILDKITE_BUILD_CHECKOUT_PATH:-$PWD}"
docker run -tid --disable-content-trust --privileged --name "$CONTAINER_NAME" -v "$REPO_PATH:/workspace" -w /workspace "$IMAGE_NAME"
docker exec -e NUMA_NODE=${NUMA_NODE} -e NUMA_CPUSET=${NUMA_CPUSET} -e ZE_AFFINITY_MASK=${ZE_AFFINITY_MASK} $CONTAINER_NAME \
              bash -c "env | grep -E 'NUMA_NODE|NUMA_CPUSET|ZE_AFFINITY_MASK' && \
                       echo Hello world && sleep 20 && echo End."