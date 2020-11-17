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

$ PWFILE=./passwordfile DATADIR=./datadir/bob/ bash geth_account.sh new
[...]
Public address of the key:   0x594DbFDF2Ba652d0Bee6f644099b448a99B1cf9f
Path of the secret key file: datadir/bob/keystore/UTC--2020-11-12T09-54-53.562249037Z--594dbfdf2ba652d0bee6f644099b448a99b1cf9f
[...]
```

## Parameterize node

Based on the generated key files, replace the address of the PoA node in the `genesis.json`.
Adapt genesis json file with account of `alice` our one (and only) PoA clique node.
```bash
$ cd genesis_config/go-ethereum
$ cp genesis_template.json genesis.json
$ bash replace_address.sh genesis.json e63419B7c0be62A6127923fb70C32A5ca1926a16
```

Initialize `alice`
```bash
$ cp genesis_config/go-ethereum/genesis.json datadir/alice/genesis.json
$ bash geth_init_alice.sh 
```

## Run node and extract enode connection information

```bash
$ bash geth_run_alice.sh
$ bash geth_attach.sh
> admin.nodeInfo.enode
"enode://4f840bf9e6db654e7930a38aca6d1870c3a6a28ddc62aa4bd04c1703455404ec3ff120b357eafa013fd2d05cf3ea31d7f6fa1d27ff4f0bfaab2d9dd2b87d1bba@127.0.0.1:30303?discport=0"
```

Remember to change the localhost IP (127.0.0.1) in this enode string to the actual IP of the remote server (or the docker container). 

## Test client bob

On a different machine you can now test if `bob` is able to connect to `alice`. 
Currently the run script for bob is configured to connect to our server at the University. 

```bash
$ cp genesis_config/go-ethereum/genesis.json datadir/bob/genesis.json
$ bash geth_init_bob.sh
$ bash geth_run_bob.sh
```

If you run `bob` on the same physical machine as `alice` take care to use another port. 

```bash
$ HPORT=30301 CPORT=30301 bash geth_init_bob.sh
$ HPORT=30301 CPORT=30301 bash geth_run_bob.sh
```

## Setup the challenges 

From here you can continue with the [setup.ipynb](./notebooks/challenges/setup.ipynb) 
to setup the challenges for the participants. 
