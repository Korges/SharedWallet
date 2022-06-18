// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    mapping(address => uint) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        allowance[_who] -= _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(owner() == _msgSender() || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }
}

contract SimpleWallet is Allowance {

    function withdrawMoney(address payable _to, uint _amount) public onlyOwner {
        require(_amount <= address(this).balance, "There are not anough funds stored in the smart contract!");
        if(owner() != _msgSender()) {
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }

    function getBalance() public view returns(uint balance) {
        return address(this).balance;
    }

    receive() external payable {
        
    }

}