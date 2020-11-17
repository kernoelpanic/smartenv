# Setup for Tutors 

So your are tutor - poor soul :) 
Good news is, after you have managed to setup this environment 
the grading later will work almost instantly ;) 

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

## Run node and extract information

```bash
$ bash geth_run_alice.sh
$ bash geth_attach.sh
> admin.nodeInfo.enode
"enode://4f840bf9e6db654e7930a38aca6d1870c3a6a28ddc62aa4bd04c1703455404ec3ff120b357eafa013fd2d05cf3ea31d7f6fa1d27ff4f0bfaab2d9dd2b87d1bba@127.0.0.1:30303?discport=0"
```

## Test client bob

On a different machine 

## Create student accounts 
TODO
