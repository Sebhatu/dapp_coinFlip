pragma solidity >0.5.8 <0.6.5;

contract Ownable{
    address public owner;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _; //Continue execution
    }

    constructor() public{
        owner = msg.sender;
    }
}