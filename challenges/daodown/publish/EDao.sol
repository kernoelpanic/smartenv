
pragma solidity ^0.4.25;

contract EDao {
    address public owner; 
    
    //Events
    event Success(address src,uint256 ret);
    event Fail(address src,uint256 ret);
    event NotEnoughFunds(address src, uint256 req, uint256 avail, uint256 balance);

    //Structs 
    struct Fund {
        address payoutAddr;
        uint256 amount;
    }
    struct Investor {
        bool canFund;
        bool canAddInvestor;
    }
    
    //Mappings  
    mapping(address => Investor) investors;
    mapping(address => Fund) funds;

    constructor(address student) public payable {
				owner = student;
        // Set the student as one of the investors
        investors[owner] = Investor({canFund:true, canAddInvestor:true});
        
        // Set the deployer as one of the investors
        investors[msg.sender] = Investor({canFund:true, canAddInvestor:true});
    }
    
    function fundit(address to) public payable {
        Investor memory b = investors[msg.sender];
        if (b.canFund) {
            Fund storage f = funds[to];
            f.payoutAddr = to; 
            f.amount += msg.value;
            emit Success(msg.sender,0);
        } else {
            emit Fail(msg.sender,1);
            revert();
        }
    }

    function queryFunds(address addr) public view returns (uint256) {
        Fund memory f = funds[addr];
        return f.amount;
    }

    function withdraw(address addr,uint256 amount) public returns (bool) {
        Fund storage f = funds[addr];
        if (f.amount >= amount && amount <= address(this).balance) {
            if (f.payoutAddr.call.value(amount)()) {
                f.amount = f.amount - amount;
                return true;
            }
        }
        emit NotEnoughFunds(msg.sender,amount,f.amount,address(this).balance);
        return false;
    }    

		function getStudent() public view returns (address) {
				return owner;
		}

    function addInvestor(address investorAddr,bool canAdd) public {
        Investor memory b = investors[msg.sender];
        if (b.canAddInvestor) {
            investors[investorAddr] = Investor({canFund:true, canAddInvestor:canAdd});
            emit Success(msg.sender,0);
        } else {
            emit Fail(msg.sender,2);    
        }
    }

    function getInvestor(address investorAddr) public view returns (bool canFund, bool canAddInvestor) {
        Investor memory b = investors[investorAddr];
        canFund = b.canFund;
        canAddInvestor = b.canAddInvestor;
				return (canFund, canAddInvestor);
    }

}


