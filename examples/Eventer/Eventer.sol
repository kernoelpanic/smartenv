pragma solidity ^0.5.12;

contract Eventer {

    event create(uint256 v);
    event funcall(address caller,uint256 value);
    event funcall2(address indexed caller,uint256 indexed value);
    event fallcall(address caller);

    constructor() public {
        emit create(1);
    }

    function func1(uint256 v) public {
        emit funcall(msg.sender,v);
    }

    function func2(uint256 v) public {
        emit funcall2(msg.sender,v);
    }

    function() external payable{
        emit fallcall(msg.sender);
    }

}
