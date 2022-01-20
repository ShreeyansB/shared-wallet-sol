pragma solidity ^0.8.11;
// SPDX-License-Identifier: MIT

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";


contract Allowance is Ownable {
    mapping(address => uint) public allowance;

    event AllowanceChanged(address indexed _forWho, address indexed _byWho, uint _oldAmount, uint _newAmount);

    function setAllowance(address _to, uint _amount) public onlyOwner {
        emit AllowanceChanged(_to, msg.sender, allowance[_to], _amount);
        allowance[_to] = _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
    require(msg.sender == owner() || allowance[msg.sender] >= _amount, "You are not allowed.");
    _;
    }


    function reduceAllowance(address _to, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_to, msg.sender, allowance[_to], allowance[_to] - _amount);
        allowance[_to] -= _amount;
    }


}

contract SharedWallet is Ownable, Allowance {

    receive() external payable {

    }

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money.");
        if(msg.sender != owner()) {
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }    

}

