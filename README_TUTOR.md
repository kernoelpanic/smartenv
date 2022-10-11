# Setup for Tutors 

So your are tutor - poor soul :) 
Good news is, after you have managed to setup this environment 
the grading later will work almost instantly ;) 

## Create PoA node account and test account

```bash
$ PWFILE=./passwordfile DATADIR=./datadir/alice/ bash ./util/scripts/geth_account.sh new
[...]
Public address of the key:   0xe63419B7c0be62A6127923fb70C32A5ca1926a16
Path of the secret key file: datadir/alice/keystore/UTC--2020-11-12T09-53-29.399025746Z--e63419b7c0be62a6127923fb70c32a5ca1926a16
[...]
```

### If you already have an account
If you already have an account/keyfile you want to use just copy it over and create the according folder structure:
```bash
$ mkdir -p ./datadir/alice/
$ cp -r $FROM_SOMEWHERE/keystore ./datadir/alice/
```

## Parameterize node

Based on the generated key files, replace the addresses of the PoA node in the `gen.py`.
Adapt genesis json file with account of `alice` our one (and only) PoA clique node.
```bash
$ cd setup/environment/
$ cd genesis_config/go-ethereum/berlin
$ vim gen.py
$ python gen.py
```

Initialize `alice`
```bash
$ cp setup/environment/genesis_config/go-ethereum/berlin/genesis.json datadir/alice/genesis.json
$ make init-smartenv-geth-alice 
```

## Run node and extract enode connection information

Then edit the `Makefile` and set the variable `GETH_ALICE_ADDRESS` based on the previously generated address 
which should be unlocked for the PoA node. Then you can run the PoA node alice.  

```bash
$ make run-smartenv-geth-alice
$ RPCPORT=8544 bash ./util/scripts/geth_attach.sh
> admin.nodeInfo.enode
"enode://9d3297cebb326554af6e6d3146c19856b42a4e97f5a361bd51d8cdf66881ddc65ca54ba4082a2bcba236f1a18082ad3315fb2f5065c617dc7bead1d0c07b6f61@127.0.0.1:30303?discport=0"
```

Remember to change the IP: 
```bash
enode://9d3297cebb326554af6e6d3146c19856b42a4e97f5a361bd51d8cdf66881ddc65ca54ba4082a2bcba236f1a18082ad3315fb2f5065c617dc7bead1d0c07b6f61@131.130.126.71:30303?discport=30303
```

Enter the node info as default in the `Makefile` as variable `GETH_BOB_BOOTNODE`  and run bob as client: 
```bash
$ make init-smartenv-geth-bob
$ make run-smartenv-geth-bob 
```

**Note:** Remember to change the localhost IP (127.0.0.1) in this enode string to the actual IP of the remote server (or the docker container).  

## Try to connect to the server

Now you can try to connect to the server and execute the following steps from the main [README](../README.md):

* ** 5) Connection to the Custom Testnet **
* ** 6) Go through the Crash Course **


## Setup the challenges 

From here you can continue with the [setup.ipynb](./setup/challenges/setup.ipynb) 
to setup the challenges for the participants. 
