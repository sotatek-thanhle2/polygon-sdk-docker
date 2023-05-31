NUMBER_JOIN_NODES="${1:-2}"
PREFIX_NAME_CHAIN="${2:-"prod-chain-join"}"
ARRAY_NUMBER_JOIN_NODES=()
NAME_JOIN_NODES=()
DOCKER_NETWORK=polygon-sdk-prod

for ((i=1; i<=$NUMBER_JOIN_NODES; i++)); do
    ARRAY_NUMBER_JOIN_NODES+=("$i")
    NAME_JOIN_NODES+=("$PREFIX_NAME_CHAIN-$i")
done

for i in "${ARRAY_NUMBER_JOIN_NODES[@]}"; do
  ./polygon-edge secrets init --data-dir ${NAME_JOIN_NODES[$((i)) - 1]} --insecure > ${NAME_JOIN_NODES[$((i)) - 1]}.txt
done

# Build images
for i in "${ARRAY_NUMBER_JOIN_NODES[@]}"; do
  docker build --build-arg CHAIN=${NAME_JOIN_NODES[$((i)) - 1]} -t ${NAME_JOIN_NODES[$((i)) - 1]} . --no-cache
done

# Run images
for i in "${ARRAY_NUMBER_JOIN_NODES[@]}"; do
  docker run -d --name ${NAME_JOIN_NODES[$((i)) - 1]} -p 0.0.0.0:2220$i:8545 --network $DOCKER_NETWORK ${NAME_JOIN_NODES[$((i)) - 1]}
done
