# DAO Down

## Story

You are working at an IT Security Consultant company called *AllmostAllsafe*.
The biggest customer of *AllmostAllsafe* is *EveCorp*. 
*EveCorp* is highly interested in Blokchain and SmartContract projects lately.
Their latest project is a fund raising DAO (*Directed* Autonomous Organisation).
This *EDao* was used to gather large amounts of *EveCoins* and used to invest them into different projects. 

There are rumours that the *EDao* has a severe bug that might be exploited by one of the already funded projects. 
Since it is a smart contract we cannot simply patch this vulnerability.
The only way out would be a hard fork to undo all malicious activities but this would crush the reputation of *EveCoin*. 

Your task is it to avoid such a situation.
Find the vulnerability, exploit it and withdraw all the money from 
the *EDao* before an attacker can do that. 

## Technical description

There is an instance of the *EDao* for every student. 
You received a public/private key pair (i.e., a *geth* account) together with the address and ABI of the SmartContract you have to exploit. 
Your public/private key pair is associated with your contract.
This means that you are the *owner* of that contract and therefore only you can solve this challenge for your *EDao* instance.
To use your pre-generated `geth` account just copy the file starting with `UTC...` into your `keystore` folder in the data directory of your client. 

Your *EDao* as has a balance of `30` *EveCoins*.
The challenge is solved when the balance of your *EDao* is `0`. 

## Hint 

This paper outlines the vulnerability and attack. The contract you have to exloit is named `EDao`, which has the substring **DAO** in its name.
* https://allquantor.at/blockchainbib/pdf/atzei2016survey.pdf


