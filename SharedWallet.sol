pragma solidity ^0.8.11;
// SPDX-License-Identifier: MIT

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {

    using SafeMath for uint;
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
        emit AllowanceChanged(_to, msg.sender, allowance[_to], allowance[_to].sub(_amount));
        allowance[_to] = allowance[_to].sub(_amount);
    }


}

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

    function renounceOwnership() public override onlyOwner {
        revert("Cannot renounceOwnership here.");
    }

}

