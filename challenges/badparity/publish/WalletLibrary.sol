pragma solidity ^0.4.12;

contract WalletLibrary {
     address walletLibrary; 
     address owner;

     event LogValue(uint256 exitcode,uint256 amount);

     function initWallet(address _owner) public payable {
        owner = _owner;
     }

     function getOwner() public view returns (address) {
        return owner;
     }

     function changeOwner(address new_owner) public returns (bool success) {
        if (msg.sender == owner) {
            owner = new_owner;
        } else {
            return false;
        }
     }

     function withdraw(uint256 amount) public returns (bool success) {
         if (msg.sender == owner) {
             return owner.send(amount);
         } else {
             return false;
         }
     }
    
     function () public payable {
         emit LogValue(200,msg.value);
     }
}
