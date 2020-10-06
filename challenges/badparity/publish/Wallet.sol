pragma solidity ^0.4.12;

contract Wallet {
    address walletLibrary;
    address owner;

    event LogValue(uint256 exitcode,uint256 amount);

    // constructor, called once when this contract is created 
    constructor(address lib) public payable {
        walletLibrary = lib; // hardcode lib address at deploy time
        walletLibrary.delegatecall(bytes4(keccak256("initWallet(address)")), msg.sender); // init the owner with the creator of the contract
    }

    function getOwner() public view returns (address) {
        return owner;
    } 

    function getWalletLibrary() public view returns (address) {
        return walletLibrary;
    }

    function withdraw(uint256 amount) public returns (bool success) {
        if ( walletLibrary.delegatecall(bytes4(keccak256("withdraw(uint256)")), amount) ) {
            emit LogValue(200,amount);
            return true;
        } else {
            emit LogValue(401,amount);
            return false;
        }
    }

    function changeOwner(address new_owner) public returns (bool success) {
        return walletLibrary.delegatecall(bytes4(keccak256("changeOwner(address)")), new_owner);
    }

    // fallback function gets called if no other function matches call
    function () public payable {
        emit LogValue(301,msg.value);
        walletLibrary.delegatecall(msg.data);
    }
}
