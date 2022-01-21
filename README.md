<img src="https://cdn-icons-png.flaticon.com/512/214/214362.png" width="95" align="right" hspace="20" />

# Shared Wallet
## Overview
This Smart Contract acts as a Shared Wallet which is controlled by the Owner and allows the Employees to withdraw funds according to the allowance assigned to them by the Owner.

## Roles
| Name | Description  |
|--|--|
| Owner | Manages allowances and can transfer funds to contract. |
| Employee | Withdraws funds and can transfer funds to contract. |

## Exposed Variables
- `owner`: Address of the Owner of the Contract.
- `allowance[address]`: Shows the current allowance of the specified address.
## Exposed Functions and Variables
- `renounceOwnership()`: Disabled
- `transferOwnership(address_newOwner)`: Transfer Ownership to specified address. Can only be accessed by the Owner.
 - `setAllowance(address _to, uint amount)`: Sets the allowance of a particular address to the specified amount. Can only be accessed by the Owner.
 - `withdrawMoney(address _to, uint amount)`: Withdraw funds to the specified address. Can be accessed by owner or if employee[allowance] >= specified amount. Fails if contract balance < specified amount.
 ## Events
 - `AllowanceChanged(address  indexed _forWho,  address  indexed _byWho,  uint _oldAmount,  uint _newAmount)`
 - `MoneySent(address  indexed _to,  uint _amount)`
- `MoneyReceived(address  indexed _from,  uint _amount)`

