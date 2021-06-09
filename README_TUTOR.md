# Setup for Tutors 

So your are tutor - poor soul :) 
Good news is, after you have managed to setup this environment 
the grading later will work almost instantly ;) 

## Create PoA node account and test account

```bash
$ PWFILE=./passwordfile DATADIR=./datadir/alice/ bash geth_account.sh new
[...]
Public address of the key:   0xe63419B7c0be62A6127923fb70C32A5ca1926a16
Path of the secret key file: datadir/alice/keystore/UTC--2020-11-12T09-53-29.399025746Z--e63419b7c0be62a6127923fb70c32a5ca1926a16
[...]
```

## Parameterize node

Based on the generated key files, replace the addresses of the PoA node in the `gen.py`.
Adapt genesis json file with account of `alice` our one (and only) PoA clique node.
```bash
$ cd genesis_config/go-ethereum/berlin
$ vim gen.py
$ python gen.py
```

Initialize `alice`
```bash
$ cp genesis_config/go-ethereum/berlin/genesis.json datadir/alice/genesis.json
$ bash geth_init_alice.sh 
```

## Run node and extract enode connection information

```bash
$ bash geth_run_alice.sh
$ RPCPORT=8544 bash geth_attach.sh
> admin.nodeInfo.enode
"enode://4f6ddbb594825127b63186a6933e40885d743f8df6483701ab2ae1ccc1635408c061258d689875ca6048accecc6367d17c8339c2bf8cbddbb575f74fffaf3f9a@127.0.0.1:30303?discport=0"
```

Enter the node info as default in: 
```bash
$ vim geth_run_bob.sh # and enter the enode info
```

**Note:** Remember to change the localhost IP (127.0.0.1) in this enode string to the actual IP of the remote server (or the docker container).  

## Try to connect to the server

Now you can try to connect to the server and execute the following steps from the main [README](../README.md):

* ** 5) Connection to the Custom Testnet **
* ** 6) Go through the Crash Course **


## Setup the challenges 

From here you can continue with the [setup.ipynb](./notebooks/challenges/setup.ipynb) 
to setup the challenges for the participants. 
