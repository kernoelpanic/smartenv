# Makefile 

WORKDIR_HOST ?= $(shell pwd)
WORKDIR_CONTAINER=/smartenv
SETUPDIR=./setup/environment/
DOCKER_UID ?= $(shell id -u)
DOCKER_GID ?= $(shell id -g)

DOCKER_IMAGE_GETH=smartenv-geth
GETH_VERSIONTAG ?= v1.10.3
DOCKER_IMAGE_WEB3PY=smartenv-web3py
DOCKER_IMAGE_GANACHE=trufflesuite/ganache-cli

DOCKER_NETWORK_NAME=smartnet
DOCKER_NETWORK_SUBNET=172.18.0.0/16
DOCKER_IP_GETH_BOB=172.18.0.8
DOCKER_IP_GETH_ALICE=172.18.0.8
DOCKER_IP_WEB3PY=172.18.0.3
DOCKER_IP_GANACHE=172.18.0.2

DOCKER_HOSTNAME_GANACHE=ganache
DOCKER_PORT_GANACHE ?= 8545
HOST_PORT_GANACHE ?= 8540

DOCKER_HOSTNAME_WEB3PY=web3py
DOCKER_PORT_WEB3PY ?= 8888
HOST_PORT_WEB3PY ?= 8888

DOCKER_HOSTNAME_GETH_BOB ?= bob
DOCKER_INTERFACE_GETH_BOB ?= 127.0.0.1
DOCKER_PORT_GETH_BOB ?= 30303
HOST_PORT_GETH_BOB ?= 30303
DOCKER_RPCPORT_GETH_BOB ?= 8545
HOST_RPCPORT_GETH_BOB ?= 8545
DOCKER_WSPORT_GETH_BOB ?= 8546
HOST_WSPORT_GETH_BOB ?= 8546
GETH_BOB_NODEID=$(DOCKER_HOSTNAME_GETH_BOB)
GETH_BOB_NETID=25519
GETH_BOB_DATADIR=$(WORKDIR_CONTAINER)/datadir/bob
GETH_BOB_BOOTNODE=enode://9d3297cebb326554af6e6d3146c19856b42a4e97f5a361bd51d8cdf66881ddc65ca54ba4082a2bcba236f1a18082ad3315fb2f5065c617dc7bead1d0c07b6f61@131.130.126.71:30303?discport=30303
GETH_BOB_RPCPORT_INTERFACE=0.0.0.0
GEHT_BOB_WSPORT_INTERFACE=0.0.0.0

DOCKER_HOSTNAME_GETH_ALICE ?= alice
DOCKER_INTERFACE_GETH_ALICE ?= 0.0.0.0
DOCKER_PORT_GETH_ALICE ?= 30303
HOST_PORT_GETH_ALICE ?= 30303
DOCKER_RPCPORT_GETH_ALICE ?= 8545
HOST_RPCPORT_GETH_ALICE ?= 8545
DOCKER_WSPORT_GETH_ALICE ?= 8546
HOST_WSPORT_GETH_ALICE ?= 8546
GETH_ALICE_NODEID=$(DOCKER_HOSTNAME_GETH_ALICE)
GETH_ALICE_NETID=25519
GETH_ALICE_DATADIR=$(WORKDIR_CONTAINER)/datadir/alice
GETH_ALICE_RPCPORT_INTERFACE=0.0.0.0
GEHT_ALICE_WSPORT_INTERFACE=0.0.0.0
GETH_ALICE_ADDRESS=0x33f4f5ac17d677e188ab8d43149717632f9960d8
PASSWORDFILE=$(SETUPDIR)passwordfile


BTC_DATADIR_HOST=$(WORKDIR_HOST)/data/bitcoin/
BTC_DATADIR_TESTNET=$(BTC_DATADIR_HOST)testnet/
DOCKER_IMAGE_BTC_TESTNET=ruimarinho/bitcoin-core
BTC_TESTNET_RPCPORT_INTERFACE=0.0.0.0
HOST_RPCPORT_BTC_TESTNET ?= 18332
DOCKER_RPCPORT_BTC_TESTNET ?= 18332
HOST_PORT_BTC_TESTNET ?= 18333
DOCKER_PORT_BTC_TESTNET ?= 18333


.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
  match = re.match(r'^([a-zA-Z0-9_-]+):.*?## (.*)$$', line)
  if match:
    target, help = match.groups()
    print("%-23s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

.PHONY: help
help:
	@echo "Help:"
	@echo "Check out the variables at the beginning of the Makefile"
	@echo
	@echo "Targets:"
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)


.PHONY: build
build: build-ganache-cli build-smartenv-web3py build-smartenv-geth ## Build all docker images

.PHONY: all
all: build network run-smartenv-web3py ## Run compleate setup and start basic dev container environment

.PHONY: build-ganache-cli
build-ganache-cli: ## Download std. docker image for ganache-cli 
	( \
	  docker pull $(DOCKER_IMAGE_GANACHE):latest \
	)

.PHONY: build-smartenv-web3py
build-smartenv-web3py: ## Build docker image for smartenv-web3py according to docker file
	( \
	  docker build --build-arg UID=$(DOCKER_UID) \
	  			   --build-arg GID=$(DOCKER_GID) \
				   --build-arg WORKDIR_CONTAINER=$(WORKDIR_CONTAINER) \
				   --build-arg SETUPDIR=$(SETUPDIR) \
				   --no-cache \
				   -f $(SETUPDIR)/dockerfiles/$(DOCKER_IMAGE_WEB3PY).latest.Dockerfile \
				   -t $(DOCKER_IMAGE_WEB3PY):latest . \
	)

.PHONY: build-smartenv-geth
build-smartenv-geth: ## Build docker image for smartenv-geth according to docker file
	( \
	mkdir -p src-clients/go-ethereum; \
	docker build --build-arg UID=$(DOCKER_UID) \
	  			   --build-arg GID=$(DOCKER_GID) \
				   --build-arg WORKDIR_CONTAINER=$(WORKDIR_CONTAINER) \
				   --build-arg VERSIONTAG=$(GETH_VERSIONTAG) \
				   --no-cache \
				   -f $(SETUPDIR)/dockerfiles/$(DOCKER_IMAGE_GETH).latest.Dockerfile \
				   -t $(DOCKER_IMAGE_GETH):latest . \
	)

.PHONY: network
network: ## Setup the docker network as configures in Makefile header
	@( \
		if [ -z "$(shell docker network ls | grep $(DOCKER_NETWORK_NAME))" ]; then \
			docker network create --subnet=$(DOCKER_NETWORK_SUBNET) --driver bridge $(DOCKER_NETWORK_NAME); \
			echo "\nNetwork created:"; \
		else \
			echo "\nNetwork already exists:"; \
		fi; \
		docker network ls;\
	)

.PHONY: run-ganache-cli
run-ganache-cli: ## Run ganache-cli docker container, remove flag -d in Makefile for non-determinsitic mode
	( \
  	docker run \
	    -p 127.0.0.1:$(HOST_PORT_GANACHE):$(DOCKER_PORT_GANACHE) \
  		--net $(DOCKER_NETWORK_NAME) \
  		--hostname $(DOCKER_HOSTNAME_GANACHE) \
  		--ip $(DOCKER_IP_GANACHE) \
  		-it $(DOCKER_IMAGE_GANACHE):latest -d --gasLimit 80000000 --allowUnlimitedContractSize \
	)

.PHONY: run-smartenv-web3py
run-smartenv-web3py: ## Run smartenv-web3py docker container
	( \
  	docker run \
	    -p 127.0.0.1:$(HOST_PORT_WEB3PY):$(DOCKER_PORT_WEB3PY) \
		-e CONTAINER_PORT=$(DOCKER_PORT_WEB3PY) \
		--mount type=bind,source=$(WORKDIR_HOST),target=$(WORKDIR_CONTAINER) \
  		--net $(DOCKER_NETWORK_NAME) \
  		--hostname $(DOCKER_HOSTNAME_WEB3PY) \
  		--ip $(DOCKER_IP_WEB3PY) \
  		-it $(DOCKER_IMAGE_WEB3PY):latest \
	)

.PHONY: debug-smartenv-web3py
debug-smartenv-web3py: ## Run debug shell instead of command in smartenv-web3py docker container: $ HOST_PORT_WEB3PY=8889 DOCKER_PORT_WEB3PY=8888 make debug-smartenv-web3py DOCKER_UID=0
	( \
  	docker run \
	    -p 127.0.0.1:$(HOST_PORT_WEB3PY):$(DOCKER_PORT_WEB3PY) \
		-e CONTAINER_PORT=$(DOCKER_PORT_WEB3PY) \
		--mount type=bind,source=$(WORKDIR_HOST),target=$(WORKDIR_CONTAINER) \
  		--net $(DOCKER_NETWORK_NAME) \
  		--hostname $(DOCKER_HOSTNAME_WEB3PY) \
  		--ip $(DOCKER_IP_WEB3PY) \
		--user $(DOCKER_UID) \
  		-it --entrypoint /bin/bash $(DOCKER_IMAGE_WEB3PY):latest \
	)

.PHONY: exec-smartenv-web3py
exec-smartenv-web3py: ## Execute shell in already running container: $ make exec DOCKER_UID=0
	( \
		export CONTAINER_ID=$$(docker ps | grep $(DOCKER_IMAGE_WEB3PY) | cut -d" " -f1); \
		docker exec \
			--user $(DOCKER_UID) \
			-it $${CONTAINER_ID} /bin/bash \
	)

.PHONY: init-smartenv-geth-bob
init-smartenv-geth-bob: ## Initialized smartenv-geth datadir for client bob
	( \
	mkdir -p datadir/logs; \
  	docker run \
		-p ${DOCKER_INTERFACE_GETH_BOB}:${HOST_PORT_GETH_BOB}:${DOCKER_PORT_GETH_BOB} \
		-p 127.0.0.1:${HOST_RPCPORT_GETH_BOB}:${DOCKER_RPCPORT_GETH_BOB} \
		-p 127.0.0.1:${HOST_WSPORT_GETH_BOB}:${DOCKER_WSPORT_GETH_BOB} \
		--mount type=bind,source=$(WORKDIR_HOST),target=$(WORKDIR_CONTAINER) \
		--net $(DOCKER_NETWORK_NAME) \
		--hostname $(DOCKER_HOSTNAME_GETH_BOB) \
		--ip $(DOCKER_IP_GETH_BOB) \
		-it $(DOCKER_IMAGE_GETH):latest geth \
			--identity "$(GETH_BOB_NODEID)" \
			--networkid "$(GETH_BOB_NETID)" \
			--datadir "$(GETH_BOB_DATADIR)" \
			--verbosity 6 \
			init $(SETUPDIR)genesis_config/go-ethereum/berlin/genesis.json \
			2>&1 | tee "datadir/logs/$(GETH_BOB_NODEID)_$(shell date -Is)_run.log" \
	)

.PHONY: init-smartenv-geth-alice
init-smartenv-geth-alice: ## Initialized smartenv-geth datadir for client alice
	( \
	mkdir -p datadir/logs; \
	docker run \
		-p ${DOCKER_INTERFACE_GETH_ALICE}:${HOST_PORT_GETH_ALICE}:${DOCKER_PORT_GETH_ALICE} \
		-p 127.0.0.1:${HOST_RPCPORT_GETH_ALICE}:${DOCKER_RPCPORT_GETH_ALICE} \
		-p 127.0.0.1:${HOST_WSPORT_GETH_ALICE}:${DOCKER_WSPORT_GETH_ALICE} \
		--mount type=bind,source=$(WORKDIR_HOST),target=$(WORKDIR_CONTAINER) \
		--net $(DOCKER_NETWORK_NAME) \
		--hostname $(DOCKER_HOSTNAME_GETH_ALICE) \
		--ip $(DOCKER_IP_GETH_ALICE) \
		-it $(DOCKER_IMAGE_GETH):latest geth \
		--identity "$(GETH_ALICE_NODEID)" \
			--identity "$(GETH_ALICE_NODEID)" \
			--networkid "$(GETH_ALICE_NETID)" \
			--datadir "$(GETH_ALICE_DATADIR)" \
			--verbosity 6 \
			init $(SETUPDIR)genesis_config/go-ethereum/berlin/genesis.json \
			2>&1 | tee "datadir/logs/$(GETH_ALICE_NODEID)_$(shell date -Is)_run.log" \
	)

.PHONY: run-smartenv-geth-bob
run-smartenv-geth-bob: ## run smartenv-geth docker container for client bob
	( \
  	docker run \
		-p ${DOCKER_INTERFACE_GETH_BOB}:${HOST_PORT_GETH_BOB}:${DOCKER_PORT_GETH_BOB} \
		-p 127.0.0.1:${HOST_RPCPORT_GETH_BOB}:${DOCKER_RPCPORT_GETH_BOB} \
		-p 127.0.0.1:${HOST_WSPORT_GETH_BOB}:${DOCKER_WSPORT_GETH_BOB} \
		--mount type=bind,source=$(WORKDIR_HOST),target=$(WORKDIR_CONTAINER) \
		--net $(DOCKER_NETWORK_NAME) \
		--hostname $(DOCKER_HOSTNAME_GETH_BOB) \
		--ip $(DOCKER_IP_GETH_BOB) \
		-it $(DOCKER_IMAGE_GETH):latest geth \
		--identity "$(GETH_BOB_NODEID)" \
			--networkid "$(GETH_BOB_NETID)" \
			--datadir "$(GETH_BOB_DATADIR)" \
			--http \
			--http.port "$(DOCKER_RPCPORT_GETH_BOB)" \
			--http.addr "$(GETH_BOB_RPCPORT_INTERFACE)" \
			--http.api "eth,net,web3,personal,debug,admin,miner,txpool,clique" \
			--http.corsdomain "*" \
			--http.vhosts "*" \
			--allow-insecure-unlock `# not good practise for production use` \
			--ws \
			--ws.port "$(DOCKER_WSPORT_GETH_BOB)" \
			--ws.addr "$(GEHT_BOB_WSPORT_INTERFACE)" \
			--ws.api "eth,net,web3,personal,debug,admin,miner,txpool,clique" \
			--ws.origins "*" \
			--ipcdisable \
			--bootnodes "$(GETH_BOB_BOOTNODE)" \
			--metrics \
			--verbosity 6 \
			console \
			2>&1 | tee "datadir/logs/$(GETH_BOB_NODEID)_$(shell date -Is)_run.log" \
	)

.PHONY: run-smartenv-geth-alice
run-smartenv-geth-alice: ## Run smartenv-geth docker container for PoA node alice
	( \
  	docker run \
		-p ${DOCKER_INTERFACE_GETH_ALICE}:${HOST_PORT_GETH_ALICE}:${DOCKER_PORT_GETH_ALICE} \
		-p 127.0.0.1:${HOST_RPCPORT_GETH_ALICE}:${DOCKER_RPCPORT_GETH_ALICE} \
		-p 127.0.0.1:${HOST_WSPORT_GETH_ALICE}:${DOCKER_WSPORT_GETH_ALICE} \
		--mount type=bind,source=$(WORKDIR_HOST),target=$(WORKDIR_CONTAINER) \
		--net $(DOCKER_NETWORK_NAME) \
		--hostname $(DOCKER_HOSTNAME_GETH_ALICE) \
		--ip $(DOCKER_IP_GETH_ALICE) \
		-it $(DOCKER_IMAGE_GETH):latest geth \
		--identity "$(GETH_ALICE_NODEID)" \
			--networkid "$(GETH_ALICE_NETID)" \
			--datadir "$(GETH_ALICE_DATADIR)" \
			--http \
			--http.port "$(DOCKER_RPCPORT_GETH_ALICE)" \
			--http.addr "$(GETH_ALICE_RPCPORT_INTERFACE)" \
			--http.api "eth,net,web3,personal,debug,admin,miner,txpool,clique" \
			--http.corsdomain "*" \
			--http.vhosts "*" \
			--allow-insecure-unlock `# not good practise for production use` \
			--ws \
			--ws.port "$(DOCKER_WSPORT_GETH_ALICE)" \
			--ws.addr "$(GEHT_ALICE_WSPORT_INTERFACE)" \
			--ws.api "eth,net,web3,personal,debug,admin,miner,txpool,clique" \
			--ws.origins "*" \
			--ipcdisable \
			--password $(PASSWORDFILE) \
			--unlock $(GETH_ALICE_ADDRESS) \
			--mine \
			--nodiscover \
			--metrics \
			--verbosity 6 \
			console \
			2>&1 | tee "datadir/logs/$(GETH_ALICE_NODEID)_$(shell date -Is)_run.log" \
	)

.PHONY: debug-smartenv-geth
debug-smartenv-geth: ## Run debug shell instead of command in smartenv-geth docker container: $ make debug-smartenv-geth DOCKER_UID=0
	( \
  	docker run \
	    -p ${DOCKER_INTERFACE_GETH_BOB}:${HOST_PORT_GETH_BOB}:${DOCKER_PORT_GETH_BOB} \
		-p 127.0.0.1:${HOST_RPCPORT_GETH_BOB}:${DOCKER_RPCPORT_GETH_BOB} \
		-p 127.0.0.1:${HOST_WSPORT_GETH_BOB}:${DOCKER_WSPORT_GETH_BOB} \
		--mount type=bind,source=$(WORKDIR_HOST),target=$(WORKDIR_CONTAINER) \
  		--net $(DOCKER_NETWORK_NAME) \
  		--hostname $(DOCKER_HOSTNAME_GETH_BOB) \
  		--ip $(DOCKER_IP_GETH_BOB) \
		--user $(DOCKER_UID) \
  		-it --entrypoint /bin/bash $(DOCKER_IMAGE_GETH):latest \
	)

.PHONY: exec-smartenv-geth
exec-smartenv-geth: ## Run debug shell instead of command in smartenv-geth docker container: $ make debug-smartenv-geth DOCKER_UID=0
	( \
		export CONTAINER_ID=$$(docker ps | grep $(DOCKER_IMAGE_GETH) | cut -d" " -f1); \
		docker exec \
			--user $(DOCKER_UID) \
			-it $${CONTAINER_ID} /bin/bash \
	)


.PHONY: run-smartenv-bitcoin-testnet
run-smartenv-bitcoin-testnet: ## Run bitcoin testnet in docker container connected to smartnet 
#loads bitcoin.conf from $(SETUPDIR)bitcoin/testnet/
	( \
	mkdir -p $(BTC_DATADIR_TESTNET); \
    cp --update $(SETUPDIR)bitcoin/testnet/bitcoin.conf $(BTC_DATADIR_TESTNET)bitcoin.conf; \
  	docker run \
        --rm -it \
        --name bitcoin-testnet \
        --net $(DOCKER_NETWORK_NAME) \
        -p 127.0.0.1:${HOST_RPCPORT_BTC_TESTNET}:${DOCKER_RPCPORT_BTC_TESTNET} \
        -p 127.0.0.1:${HOST_PORT_BTC_TESTNET}:${DOCKER_PORT_BTC_TESTNET} \
        -v $(BTC_DATADIR_TESTNET):/home/bitcoin/.bitcoin \
    $(DOCKER_IMAGE_BTC_TESTNET):latest \
        -printtoconsole \
        -testnet=1 \
        -rpcallowip=$(DOCKER_NETWORK_SUBNET) \
        -rpcbind=$(BTC_TESTNET_RPCPORT_INTERFACE) \
	)


list_ipynb: ## List jupyter notebooks in dir tree
	( \
		export CONTAINER_ID=$$(docker ps | grep $(DOCKER_IMAGE_WEB3PY) | cut -d" " -f1); \
		docker exec \
			--user $(DOCKER_UID) \
			-it $${CONTAINER_ID} /bin/bash -c "find ./ -iname "*.ipynb" | grep -v "_checkpoints" | grep -v "./venv/" | xargs -I{} echo {}" \
	)

.PHONY: html
html: ## Export jupyter notebooks to .html files in dir tree
	( \
		export CONTAINER_ID=$$(docker ps | grep $(DOCKER_IMAGE_WEB3PY) | cut -d" " -f1); \
		docker exec \
			--user $(DOCKER_UID) \
			-it $${CONTAINER_ID} /bin/bash -c "find ./ -iname "*.ipynb" | grep -v "_checkpoints" | | grep -v "./venv/" | xargs -I{} jupyter nbconvert --to html {}" \
	)

.PHONY: html
slides: ## Export jupyter notebooks to .html files in dir tree
	( \
		export CONTAINER_ID=$$(docker ps | grep $(DOCKER_IMAGE_WEB3PY) | cut -d" " -f1); \
		docker exec \
			--user $(DOCKER_UID) \
			-it $${CONTAINER_ID} /bin/bash -c "find ./course -iname "*.ipynb" | grep -v "_checkpoints" | | grep -v "./venv/" | xargs -I{} jupyter nbconvert --to slides {}" \
	)

#jupyter nbconvert --to html $(HTMLPATH)*.ipynb

# Initialize virtual environment in local folder
# This is not needed if docker setup is used
venv: ## Creat python virtualenv without docker setup, not needed in most cases 
	( \
		virtualenv -p /usr/local/bin/python3 venv; \
  		. ./venv/bin/activate; \
		python --version; \
		python -m pip install -r ./setup/environment/smartenv-web3py.requirements.txt; \
	)

#clean:
#	-rm -i $(HTMLPATH)*.html

