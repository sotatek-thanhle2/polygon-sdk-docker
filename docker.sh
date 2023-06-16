./polygon-edge secrets init --data-dir test-chain-1 --insecure > test-chain-1.txt
./polygon-edge secrets init --data-dir test-chain-2 --insecure > test-chain-2.txt
./polygon-edge secrets init --data-dir test-chain-3 --insecure > test-chain-3.txt
./polygon-edge secrets init --data-dir test-chain-4 --insecure > test-chain-4.txt

docker network create polygon-sdk-test

# Create a new genesis.json file
./polygon-edge genesis --consensus ibft \
    --ibft-validators-prefix-path test-chain- \
    --chain-id 1213 \
    --bootnode /dns4/test-chain-1/tcp/1478/p2p/$(cat test-chain-1.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --bootnode /dns4/test-chain-2/tcp/1478/p2p/$(cat test-chain-2.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --premine 0x2e355567c6C7127219C75868CCe4C5AD9A2F57f1:100000000000000000000000000


docker build --build-arg CHAIN=test-chain-1 -t test-chain-1 . --no-cache
docker build --build-arg CHAIN=test-chain-2 -t test-chain-2 . --no-cache
docker build --build-arg CHAIN=test-chain-3 -t test-chain-3 . --no-cache
docker build --build-arg CHAIN=test-chain-4 -t test-chain-4 . --no-cache

docker run -d --name test-chain-1 -p 0.0.0.0:9001:8545 -p 0.0.0.0:8001:1478 -p 0.0.0.0:7001:9632 --network polygon-sdk-test test-chain-1
docker run -d --name test-chain-2 -p 0.0.0.0:9002:8545 -p 0.0.0.0:8002:1478 -p 0.0.0.0:7002:9632 --network polygon-sdk-test test-chain-2
docker run -d --name test-chain-3 -p 0.0.0.0:9003:8545 -p 0.0.0.0:8003:1478 -p 0.0.0.0:7003:9632 --network polygon-sdk-test test-chain-3
docker run -d --name test-chain-4 -p 0.0.0.0:9004:8545 -p 0.0.0.0:8004:1478 -p 0.0.0.0:7004:9632 --network polygon-sdk-test test-chain-4
