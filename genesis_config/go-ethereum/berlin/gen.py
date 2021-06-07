#!/usr/bin/env python

import fileinput
import shutil
import os

chainId="1337"

# clique:
period="16"
epoch="30000"

gasLimit="\"15000000\""

address0="33f4f5ac17d677e188ab8d43149717632f9960d8"
balance0=str(1_000_000*10**(18))

address_list=[ "a1273F73C607Bd0af4D2916f4C9e6A550581dCA6",
                "9a74797788982C84cC9d6B8D9f2E5Cf1f64c4306",
                "122bb7246883Af6C45FF3C3Ec7AEaf0630e956C8" ]
usr_balance=str(1_000_000*10**(18))

# addresses to prevent bugs because auf built in contracts 
# with no balance
std_addresses=""
i=0
for i in range(0,257):
    std_addresses+="\n\"{:040d}\":{{\"balance\": \"0x1\"}},".format(i)

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
