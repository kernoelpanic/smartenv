#!/usr/bin/env python3

import fileinput
import shutil
import os

#chainId="1337"
chainId="20211102"

# clique:
period="16"
epoch="30000"

gasLimit="\"15000000\""

address0="D6abfD59de4B5c832F74d8f0AB9FD844E0aD0255"
balance0=str(1_000_000*10**(18))

address_list=[ "b1Cef50494b3C82Aa199DCedD212D333C9265697",
                "22f9752D7933D89bE858e9a6Fbd0f6CAE2aDAAE0",
                "1DE8Ea7FD0fE6E656964a68665DAe4Cc1eB630F1" ]
usr_balance=str(1_000_000*10**(18))

# addresses to prevent bugs because auf built in contracts 
# with no balance
std_addresses=""
i=0
for i in range(0,257):
    std_addresses+="\n\"{:040x}\":{{\"balance\": \"0x1\"}},".format(i)

#address0="\n\"{}\":{{\"balance\": \"{}\"}},".format(address0,balance0)

# user addresses
usr_addresses=""
for addr in address_list:
    usr_addresses+="\n\"{}\":{{\"balance\": \"{}\"}},".format(addr,usr_balance)

# copy file
src = r'./genesis_template.json'
dst =  r'./genesis.json'
shutil.copyfile(src, dst)

# replace strings
with fileinput.FileInput("genesis.json", inplace=True) as file:
    for line in file:
            newline = line
            newline = newline.replace("{{chainId}}", chainId)
            newline = newline.replace("{{period}}", period)
            newline = newline.replace("{{epoch}}", epoch)
            newline = newline.replace("{{gasLimit}}", gasLimit)
            newline = newline.replace("{{std_addresses}}", std_addresses)
            newline = newline.replace("{{address0}}", address0)
            newline = newline.replace("{{usr_addresses}}", usr_addresses)
            print(newline, end='')
