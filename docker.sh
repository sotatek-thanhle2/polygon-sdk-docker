NUMBER_NODES="${1:-4}"
PREFIX_NAME_CHAIN="${2:-"prod-chain"}"
PREMINE_WALLET="${3:-"0x2e355567c6C7127219C75868CCe4C5AD9A2F57f1"}"
PREMINE_AMOUNT="${4:-10000000000000000000000}"

ARRAY_NUMBER_NODES=()
NAME_NODES=()
DOCKER_NETWORK=polygon-sdk-prod

if [ "$NUMBER_NODES" -lt 4 ]; then
    echo " => Error: Numbers Node should be >= to 4"
    exit 1
fi

for ((i=1; i<=$NUMBER_NODES; i++)); do
    ARRAY_NUMBER_NODES+=("$i")
    NAME_NODES+=("$PREFIX_NAME_CHAIN-$i")
done

# install wget for ubuntu
apt-get update && apt-get install -y wget

# download polygon-edge 0.9.0
wget https://github.com/0xPolygon/polygon-edge/releases/download/v0.9.0/polygon-edge_0.9.0_linux_amd64.tar.gz && tar -xzf polygon-edge_0.9.0_linux_amd64.tar.gz
# cp ~/3rd/polygon-edge_0.9.0_linux_amd64.tar.gz ~/3rd/polygon-sdk-prod && tar -xzf polygon-edge_0.9.0_linux_amd64.tar.gz

# Run and get NodeId of Node
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  ./polygon-edge secrets init --data-dir ${NAME_NODES[$((i)) - 1]} --insecure > ${NAME_NODES[$((i)) - 1]}.txt
done

# Stop container if it already exists
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  docker stop ${NAME_NODES[$((i)) - 1]}
done

# clear network if it already exists
docker network rm $DOCKER_NETWORK
docker system prune

# Create network
docker network create $DOCKER_NETWORK

# Remove genesis.json file if it already exists
rm -rf genesis.json

# Create a new genesis.json file
./polygon-edge genesis --consensus ibft \
    --ibft-validators-prefix-path $PREFIX_NAME_CHAIN- \
    --bootnode /dns4/${NAME_NODES[0]}/tcp/1478/p2p/$(cat ${NAME_NODES[0]}.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --bootnode /dns4/${NAME_NODES[1]}/tcp/1478/p2p/$(cat ${NAME_NODES[1]}.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --premine $PREMINE_WALLET:$PREMINE_AMOUNT

# Build images
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  docker build --build-arg CHAIN=${NAME_NODES[$((i)) - 1]} -t ${NAME_NODES[$((i)) - 1]} . --no-cache
done

# Run images
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  docker run -d --name ${NAME_NODES[$((i)) - 1]} -p 0.0.0.0:1110$i:8545 --network $DOCKER_NETWORK ${NAME_NODES[$((i)) - 1]}
done

# # Delete file NodeId
# for i in "${ARRAY_NUMBER_NODES[@]}"; do
#   rm ${NAME_NODES[$((i)) - 1]}.txt
# done
