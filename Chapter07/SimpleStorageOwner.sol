pragma solidity ^0.4.25;

contract SimpleStorageOwner {
    uint public stored_data;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyowner {
        assert(msg.sender == owner);
        _;
    }

    function set(uint num) public onlyowner {
        stored_data = num;
    }

    function get() public constant returns (uint) {
        return stored_data;
    }
}
