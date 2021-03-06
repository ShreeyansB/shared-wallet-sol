pragma solidity ^0.8.11;
// SPDX-License-Identifier: MIT

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "./Allowance.sol";


contract SharedWallet is Ownable, Allowance {

    event MoneySent(address indexed _to, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money.");
        if(msg.sender != owner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }    

    function renounceOwnership() public view override onlyOwner {
        revert("Cannot renounceOwnership here.");
    }

}

