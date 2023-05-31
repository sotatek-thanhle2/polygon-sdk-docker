NUMBER_NODES="${1:-4}"
PREFIX_NAME_CHAIN="${2:-"test-chain"}"
PREMINE_WALLET="${3:-"0x2e355567c6C7127219C75868CCe4C5AD9A2F57f1"}"
PREMINE_AMOUNT="${4:-10000000000000000000000}"

ARRAY_NUMBER_NODES=()
NAME_NODES=()
IP_NODES=()
DOCKER_NETWORK=polygon-sdk

if [ "$NUMBER_NODES" -lt 4 ]; then
    echo " => Error: Numbers Node should be >= to 4"
    exit 1
fi

for ((i=1; i<=$NUMBER_NODES; i++)); do
    ARRAY_NUMBER_NODES+=("$i")
    NAME_NODES+=("$PREFIX_NAME_CHAIN-$i")
    IP_NODES+=("172.28.0."$i)
done

# install wget for ubuntu
apt-get update && apt-get install -y wget

# download polygon-edge 0.9.0
wget https://github.com/0xPolygon/polygon-edge/releases/download/v0.9.0/polygon-edge_0.9.0_linux_amd64.tar.gz && tar -xzf polygon-edge_0.9.0_linux_amd64.tar.gz

# Run and get NodeId of Node
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  ./polygon-edge secrets init --data-dir $PREFIX_NAME_CHAIN-$i --insecure > $PREFIX_NAME_CHAIN-$i.txt
done

# Stop container if it already exists
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  docker stop $PREFIX_NAME_CHAIN-$i
done

# clear network if it already exists
docker network rm $DOCKER_NETWORK

# Create network
docker network create $DOCKER_NETWORK --ip-range=172.28.0.0/24 --driver=bridge --subnet=172.28.0.0/16 --gateway=172.28.5.254

# Remove genesis.json file if it already exists
rm -rf genesis.json

# Create a new genesis.json file
./polygon-edge genesis --consensus ibft \
    --ibft-validators-prefix-path $PREFIX_NAME_CHAIN- \
    --bootnode /ip4/${IP_NODES[0]}/tcp/1478/p2p/$(cat ${NAME_NODES[0]}.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --bootnode /ip4/${IP_NODES[1]}/tcp/1478/p2p/$(cat ${NAME_NODES[1]}.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --premine $PREMINE_WALLET:$PREMINE_AMOUNT

# Build images
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  docker build --build-arg CHAIN=$PREFIX_NAME_CHAIN-$i -t $PREFIX_NAME_CHAIN-$i . --no-cache
done

# Run images
for i in "${ARRAY_NUMBER_NODES[@]}"; do
  docker run -d --name ${NAME_NODES[$((i)) - 1]} -p 0.0.0.0:1100$i:8545 --network $DOCKER_NETWORK --ip ${IP_NODES[$((i)) - 1]} ${NAME_NODES[$((i)) - 1]}
done
