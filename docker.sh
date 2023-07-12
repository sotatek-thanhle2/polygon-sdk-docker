# ./polygon-edge secrets init --data-dir test-chain-1 --insecure > test-chain-1.txt
# # ./polygon-edge secrets init --data-dir test-chain-2 --insecure > test-chain-2.txt
# # ./polygon-edge secrets init --data-dir test-chain-3 --insecure > test-chain-3.txt
# # ./polygon-edge secrets init --data-dir test-chain-4 --insecure > test-chain-4.txt
# # ./polygon-edge secrets init --data-dir test-chain-4 --insecure > test-chain-5.txt
# # ./polygon-edge secrets init --data-dir test-chain-4 --insecure > test-chain-6.txt
# # ./polygon-edge secrets init --data-dir test-chain-4 --insecure > test-chain-7.txt
# # ./polygon-edge secrets init --data-dir test-chain-4 --insecure > test-chain-8.txt
# # ./polygon-edge secrets init --data-dir test-chain-4 --insecure > test-chain-9.txt

# docker network create polygon-sdk-test

# ./polygon-edge genesis --consensus ibft \
#     --ibft-validators-prefix-path test-chain- \
#     --bootnode /dns4/test-chain-1/tcp/1478/p2p/$(cat test-chain-1.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
#     --premine 0x2e355567c6C7127219C75868CCe4C5AD9A2F57f1:100000000000000000000000000
#     # --bootnode /dns4/test-chain-2/tcp/1478/p2p/$(cat test-chain-2.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
#     # --bootnode /dns4/test-chain-3/tcp/1478/p2p/$(cat test-chain-3.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
#     # --bootnode /dns4/test-chain-4/tcp/1478/p2p/$(cat test-chain-4.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \


# docker build --build-arg CHAIN=test-chain-1 -t test-chain-1 . --no-cache
# # docker build --build-arg CHAIN=test-chain-2 -t test-chain-2 . --no-cache
# # docker build --build-arg CHAIN=test-chain-3 -t test-chain-3 . --no-cache
# # docker build --build-arg CHAIN=test-chain-4 -t test-chain-4 . --no-cache
# # docker build --build-arg CHAIN=test-chain-5 -t test-chain-5 . --no-cache
# # docker build --build-arg CHAIN=test-chain-6 -t test-chain-6 . --no-cache
# # docker build --build-arg CHAIN=test-chain-7 -t test-chain-7 . --no-cache
# # docker build --build-arg CHAIN=test-chain-8 -t test-chain-8 . --no-cache
# # docker build --build-arg CHAIN=test-chain-9 -t test-chain-9 . --no-cache

# docker run -d --name test-chain-1 -v /home/sotatek/3rd/polygon-sdk-stg/volume-mount:/home/polygon-sdk -p 0.0.0.0:10001:8545 -p 0.0.0.0:20001:8545 -p 0.0.0.0:30001:8545 test-chain-1
# # docker run -d --name test-chain-2 -p 0.0.0.0:10002:8545 -p 0.0.0.0:20002:8545 -p 0.0.0.0:30002:8545 --network polygon-sdk-prod test-chain-2
# # docker run -d --name test-chain-3 -p 0.0.0.0:10003:8545 -p 0.0.0.0:20003:8545 -p 0.0.0.0:30003:8545 --network polygon-sdk-prod test-chain-3
# # docker run -d --name test-chain-4 -p 0.0.0.0:10004:8545 -p 0.0.0.0:20004:8545 -p 0.0.0.0:30004:8545 --network polygon-sdk-prod test-chain-4
# # docker run -d --name test-chain-5 -p 0.0.0.0:10005:8545 -p 0.0.0.0:20005:8545 -p 0.0.0.0:30005:8545 --network polygon-sdk-prod test-chain-5
# # docker run -d --name test-chain-6 -p 0.0.0.0:10006:8545 -p 0.0.0.0:20006:8545 -p 0.0.0.0:30006:8545 --network polygon-sdk-prod test-chain-6
# # docker run -d --name test-chain-7 -p 0.0.0.0:10007:8545 -p 0.0.0.0:20007:8545 -p 0.0.0.0:30007:8545 --network polygon-sdk-prod test-chain-7
# # docker run -d --name test-chain-8 -p 0.0.0.0:10008:8545 -p 0.0.0.0:20008:8545 -p 0.0.0.0:30008:8545 --network polygon-sdk-prod test-chain-8
# # docker run -d --name test-chain-9 -p 0.0.0.0:10009:8545 -p 0.0.0.0:20009:8545 -p 0.0.0.0:30009:8545 --network polygon-sdk-prod test-chain-9

# # ./polygon-edge server --data-dir ./3rd-dev-chain --chain  genesis.json --grpc-address 0.0.0.0:19632 --libp2p 0.0.0.0:11478 --jsonrpc 0.0.0.0:18545 --seal







rm -rf test
sleep 3
mkdir test && cp -R $(ls -p | egrep -v /$) ./test/
cd test

./polygon-edge secrets init --data-dir bootnode-1 --insecure > bootnode-1.txt
./polygon-edge secrets init --data-dir bootnode-2 --insecure > bootnode-2.txt

./polygon-edge secrets init --data-dir validator-1 --insecure > validator-1.txt
./polygon-edge secrets init --data-dir validator-2 --insecure > validator-2.txt
./polygon-edge secrets init --data-dir validator-3 --insecure > validator-3.txt
./polygon-edge secrets init --data-dir validator-4 --insecure > validator-4.txt
./polygon-edge secrets init --data-dir validator-5 --insecure > validator-5.txt
./polygon-edge secrets init --data-dir validator-6 --insecure > validator-6.txt

./polygon-edge secrets init --data-dir rpcnode-1 --insecure > rpcnode-1.txt
./polygon-edge secrets init --data-dir rpcnode-2 --insecure > rpcnode-2.txt

docker network create polygon-sdk-dev-v2

./polygon-edge genesis --consensus ibft \
    --ibft-validators-prefix-path validator \
    --chain-id 1213 \
    --bootnode /dns4/bootnode-1/tcp/1478/p2p/$(cat bootnode-1.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --bootnode /dns4/bootnode-2/tcp/1478/p2p/$(cat bootnode-2.txt | awk -F "=" {'print $2'} | tail -2 | awk '{gsub(" ", "", $0); print}') \
    --premine 0x2e355567c6C7127219C75868CCe4C5AD9A2F57f1:1000000000000000000000000000

docker build -f Dockerfile.bootnode --build-arg CHAIN=bootnode-1 -t bootnode-1 . --no-cache
docker build -f Dockerfile.bootnode --build-arg CHAIN=bootnode-2 -t bootnode-2 . --no-cache

docker build -f Dockerfile.rpcnode --build-arg CHAIN=rpcnode-1 -t rpcnode-1 . --no-cache
docker build -f Dockerfile.rpcnode --build-arg CHAIN=rpcnode-2 -t rpcnode-2 . --no-cache

docker build -f Dockerfile.validator --build-arg CHAIN=validator-1 -t validator-1 . --no-cache
docker build -f Dockerfile.validator --build-arg CHAIN=validator-2 -t validator-2 . --no-cache
docker build -f Dockerfile.validator --build-arg CHAIN=validator-3 -t validator-3 . --no-cache
docker build -f Dockerfile.validator --build-arg CHAIN=validator-4 -t validator-4 . --no-cache
# docker build -f Dockerfile.validator --build-arg CHAIN=validator-5 -t validator-5 . --no-cache
# docker build -f Dockerfile.validator --build-arg CHAIN=validator-6 -t validator-6 . --no-cache

docker run -d --name bootnode-1 --network polygon-sdk-dev-v2 bootnode-1
docker run -d --name bootnode-2 --network polygon-sdk-dev-v2 bootnode-2

docker run -d --name rpcnode-1 -p 0.0.0.0:8546:8545 -p 0.0.0.0:9633:9632 -p 0.0.0.0:1479:1478 -p 0.0.0.0:9091:9090 --network polygon-sdk-dev-v2 rpcnode-1
docker run -d --name rpcnode-2 --network polygon-sdk-dev-v2 rpcnode-2

docker run -d --name validator-1 --network polygon-sdk-dev-v2 validator-1
docker run -d --name validator-2 --network polygon-sdk-dev-v2 validator-2
docker run -d --name validator-3 --network polygon-sdk-dev-v2 validator-3
docker run -d --name validator-4 --network polygon-sdk-dev-v2 validator-4
# docker run -d --name validator-5 --network polygon-sdk-dev-v2 validator-5
# docker run -d --name validator-6 --network polygon-sdk-dev-v2 validator-6


# docker restart bootnode-1 bootnode-2 rpcnode-1 rpcnode-2 validator-1 validator-2 validator-3 validator-4
# docker stop bootnode-1 bootnode-2 rpcnode-1 rpcnode-2 validator-1 validator-2 validator-3 validator-4 validator-5 && docker rm bootnode-1 bootnode-2 rpcnode-1 rpcnode-2 validator-1 validator-2 validator-3 validator-4 validator-5

# ./polygon-edge ibft propose --grpc-address validator-1:9632 --addr 0xa96C22ebbaC28EE79ACE7F4dEbB8c95ea8C7018d --bls 0x81d44cfcac8c832cc4515e1e3deccffca7275047841776d61801f33063d898bb34ae6242b512b57f909c4bd713dbf8e0 --vote auth
# ./polygon-edge ibft propose --grpc-address validator-2:9632 --addr 0xa96C22ebbaC28EE79ACE7F4dEbB8c95ea8C7018d --bls 0x81d44cfcac8c832cc4515e1e3deccffca7275047841776d61801f33063d898bb34ae6242b512b57f909c4bd713dbf8e0 --vote auth
# ./polygon-edge ibft propose --grpc-address validator-3:9632 --addr 0xa96C22ebbaC28EE79ACE7F4dEbB8c95ea8C7018d --bls 0x81d44cfcac8c832cc4515e1e3deccffca7275047841776d61801f33063d898bb34ae6242b512b57f909c4bd713dbf8e0 --vote auth
# ./polygon-edge ibft propose --grpc-address validator-4:9632 --addr 0xa96C22ebbaC28EE79ACE7F4dEbB8c95ea8C7018d --bls 0x81d44cfcac8c832cc4515e1e3deccffca7275047841776d61801f33063d898bb34ae6242b512b57f909c4bd713dbf8e0 --vote auth