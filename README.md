# Smartenv

Environment for local/private ethereum chains 
Default environment is using `geth`

## Install docker ce 

https://docs.docker.com/engine/install/ubuntu/

## Build docker image 

The next step is building the docker image for the container that is running the ethereum node. 
It is possible to use already available go-ethereum sources (and builds) located in this directory
in a folder named `go-ethereum`. If such a folder is not available the current sources will be fetched. 
It is also possible to provide a specific version tag to the docker build script. 
```bash
$ DOCKERFILE=smartenv.geth.stable.Dockerfile VERSIONTAG=v1.9.23 bash docker_build_smartenv.sh
```

## Create consensus node account and test account

```bash
$ PWFILE=./passwordfile DATADIR=./datadir/alice/ bash geth_account.sh new
[...]
Public address of the key:   0xe63419B7c0be62A6127923fb70C32A5ca1926a16
Path of the secret key file: datadir/alice/keystore/UTC--2020-11-12T09-53-29.399025746Z--e63419b7c0be62a6127923fb70c32a5ca1926a16
[...]

$ PWFILE=./passwordfile DATADIR=./datadir/bob/ bash geth_account.sh new
[...]
Public address of the key:   0x594DbFDF2Ba652d0Bee6f644099b448a99B1cf9f
Path of the secret key file: datadir/bob/keystore/UTC--2020-11-12T09-54-53.562249037Z--594dbfdf2ba652d0bee6f644099b448a99b1cf9f
[...]
```

## Parameterize node

Adapt genesis json file with account of `alice` our one clique node
```bash 
$ cp genesis_template.json genesis.json
$ bash replace_address.sh genesis.json e63419B7c0be62A6127923fb70C32A5ca1926a16
```

Initialize alice
```bash
$ bash geth_init_alice.sh 
```

## Create student accounts 
TODO
