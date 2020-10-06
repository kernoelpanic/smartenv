/**

Look Mom, I coded my first wallet contract to learn solidity!
It even supports multiple users!

**/

///TODO - Discover the wallet flaw and drain it of its funds!

/**

Contract ABI

[{"constant":false,"inputs":[{"name":"oldowner","type":"address"}],"name":"removeOwner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"}],"name":"withdraw","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newowner","type":"address"}],"name":"addOwner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getStudent","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"deposit","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"inputs":[{"name":"_student","type":"address"}],"payable":true,"stateMutability":"payable","type":"constructor"}]

**/


pragma solidity ^0.4.25;

contract NotAWallet{

		address public owner;
    address public student;
    mapping (address => bool) owners;
   
    constructor(address _student) public payable{
        student = _student;
        owner = msg.sender;
    }

    function deposit() public payable  {  
    }   

    function addOwner(address newowner) public {
        require (owners[msg.sender] == true || msg.sender == owner);
        owners[newowner] = true;
    }   

    function removeOwner(address oldowner) public rightStudent {
        require(owners[msg.sender] = true); 
				owners[oldowner] = false;
    }

    function withdraw(uint256 amount) public {
        // only owners can withdraw funds
        require(owners[msg.sender] == true);
        msg.sender.transfer(amount);
    }

    function getStudent() public view returns (address) {
        return student;
    }

		function isOwner(address testowner) public view returns (bool) {
				if (owners[testowner] == true) {
					return true;
				} else {
					return false;
				}
		}

		/// ensure that only designated target EOA has access
    modifier rightStudent() {
        require(msg.sender == student || msg.sender == owner, "Access dendied!");
        _;
    }

}

