pragma solidity ^0.4.25;

contract SimpleStorage {
    uint public stored_data;

    function set(uint num) public {
        stored_data = num;
    }

    function get() public constant returns (uint) {
        return stored_data;
    }
}
