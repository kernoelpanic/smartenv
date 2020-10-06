# Bad Parity

## Story

You are still working at an IT Security Consultant company called *AllmostAllsafe*.
The biggest customer of *AllmostAllsafe* is *EveCorp*.
*EveCorp* is highly interested in Blockchain and Smart Contract projects  lately (as almost every company...).
After the great success of their fund raising DAO, the company wants to put their funds into a very secure *Wallet contract* so that all funds are better protected. 

Therefore, they have decided to put their faith into a *Wallet contract* library form a subcontractor called *BadParity*.

That is the story so far. 

*ring ring late night emergency call*

There is a major security breach within the wallet contracts of *BadParity* and you have to handle the incident response!
Since it is a smart contract we cannot simply patch the vulnerability.
Moreover, the admin of the customer who is under the controll of the keys for the *Wallet contract* is on vacation - therefore we cannot simply use those keys.

To the rescue: It is your task to find the vulnerability, exploit it and withdraw all the money from the *Wallet contract* before an attacker can do that.

## Technical description

There is an instance of the *Wallet contract* for every student, initialized with a balance of `30` *EveCoins*. 
The *Wallet contract* is of course owned by an *EveCorp* account, that is not under your control. 

The challenge is solved when the balance of your *Wallet contract* is `0` 

## Hints

* http://hackingdistributed.com/2017/07/22/deep-dive-parity-bug/
* http://solidity.readthedocs.io/en/v0.4.23/introduction-to-smart-contracts.html
