pragma solidity ^0.8.11;
// SPDX-License-Identifier: MIT

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {

    mapping(address => uint) public allowance;

    receive() external payable {

    }

    function addAllowance(address _to, uint _amount) public onlyOwner {
        allowance[_to] = _amount;
    }

    function reduceAllowance(address _to, uint _amount) internal ownerOrAllowed(_amount) {
        allowance[_to] -= _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
    require(msg.sender == owner() || allowance[msg.sender] >= _amount, "You are not allowed.");
    _;
    }

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        if(msg.sender != owner()) {
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }    

}

