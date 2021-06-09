# Ethereum Smart Contract Challenges 

Task and setup description for Participants

## Challenge Setup Summary for Participants  

So your are a participants in a course/lecture/training which uses this challenge environment and challenges. 

You should have received:

* A **public/private key pair** (i.e., an external account). This is the file starting with `UTC--`.
This account should be initialized with a balance of `16` *EveCoins* (our private fake ether),  which should be more than enough to solve all challenges.
To use your pre-generated account just copy the file starting with `UTC--` into your `datadir/bob/keystore` folder in the data directory of your client.

* The **password file** to this account. This is the file `passwordfile`.
It contains the password to unlock and use this account. 

* A `genesis.json` file describing the first block of our custom Proof-of-Authority (PoA) Ethereum blockchain. 

* The node information on how to find and connect to our custom Ethereum (geth) PoA chain.
This is the file `enodes`.

* The addresses of the personalized contracts to exploit in the challenges.
This is the file `addresses`.

**Note:** Check all your contracts if they have the right initial balance.
There should be 3 contracts with `30` *EveCoins* each and one with `10` *EveCoins*.

## Task

Your task is it to exploit the (personalized) challenges and use their  
funds to increase the balance of **your** *external account*, which was initialized with `16` *EveCoins*.

All your challenges can award you with `100` *EveCoins* max. (`30*3 + 10`), including your initial funds you can get more than `100` *EveCoins*.

Grading is done by counting the *EveCoins* in your *external account*:
1. More than 80 *EveCoins* on your external account 
    - and at least 4 personalized contracts exploited such that they have 0 funds 
2. More than 70 *EveCoins* on your external account
    - and at least 3 personalized contracts exploited such that they have 0 funds 
3. More than 60 *EveCoins* on your external account
    - and at least 2 personalized contracts exploited such that they have 0 funds
4. More than 50 *EveCoins* on your external account
    - and at least 2 personalized contracts exploited such that they have 0 funds

Be careful not to "burn" your *EveCoins* due to mistakes or in risky pyramid schemes. 
If your funds are gone they are gone!
So you might want to test your solutions first in a `ganache` test network as shown in the tutorial. 

(In rare cases if you screwed up very badly and have a really good excuse we *might* bail you out, but then you have to write a _detailed_ report on how you solved all the challenges)

In case of questions, or confessing painful mistakes please contact your tutor. 

**Note:** 
Just in case that murphy's law manifests itself, also keep track of an description (in markdown or as plain text file) of how you solved the challenges as a backup and as a reminder for you in case you have to "replay" your solutions on a newly initialized blockchain instance.
You can keep the description very short and informal consisting mainly of commands and source code dumps. 



