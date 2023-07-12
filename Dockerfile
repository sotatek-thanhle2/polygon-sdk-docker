FROM ubuntu:20.04

ARG CHAIN
RUN echo $CHAIN

WORKDIR /home/polygon-sdk

COPY genesis.json ./
COPY polygon-edge ./
COPY $CHAIN.txt ./test-chain.txt
COPY $CHAIN/ ./test-chain/

# RUN ls -a /home/pologon-sdk
# RUN cat /polygon-sdk/test-chain.txt
# RUN ls -a /polygon-sdk/test-chain

EXPOSE 8545 1478 9632

CMD ["./polygon-edge" ,"server" ,"--data-dir" ,"./test-chain" ,"--chain" , "genesis.json", "--grpc-address", "0.0.0.0:9632", "--libp2p", "0.0.0.0:1478", "--jsonrpc", "0.0.0.0:8545", "--seal"]