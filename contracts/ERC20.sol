

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract WizT{

    uint private tokenTotalSupply;

    mapping (address => uint) private balances;
    mapping (address => mapping (address => uint)) private allowedSpenderAmount;

    constructor(uint _totalSupply){
        tokenTotalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() external view returns (uint){
        return tokenTotalSupply;
    }

    function balanceOf(address addr) external view returns (uint){
        return balances[addr];
    }

    function transfer(address to, uint amount) external {
        uint totalPay = amount + calculteBurnCharge(amount);
        checker(balances[msg.sender], totalPay, to);
        transferring(msg.sender, to, amount);
    }

    function transferring(address owner, address to, uint amount) private {
        uint charge = calculteBurnCharge(amount);
        balances[owner] = balances[owner] - (amount + charge);
        balances[to] = balances[to] + amount;
        balances[address(0)] = balances[address(0)] + charge;
        tokenTotalSupply = tokenTotalSupply - charge;
    }


    function calculteBurnCharge(uint amount) private pure returns (uint){
        return amount * 10 / 100;
    }

    function approve(address addr, uint amount) external {
        checker(balances[msg.sender], amount, addr);
        allowedSpenderAmount[msg.sender][addr] = allowedSpenderAmount[msg.sender][addr] + amount;
    }

    function checker(uint balance, uint amount, address addr) private pure  {
        require(amount > 0, "Cannot send zero amount");
        require(balance >= amount, "Amount should equal or lesser than available balance");
        require(addr != address(0), "transfer to this address not allowed");
    }

    function allowance(address realOwner) external view returns (uint){
        return allowedSpenderAmount[realOwner][msg.sender];
    }

    function transferFrom(address realOwner, address to, uint amount) external {
        require(allowedSpenderAmount[realOwner][msg.sender] >= (amount+calculteBurnCharge(amount)), "exceed allowed tranfer");
        transferring(realOwner, to, amount);
        allowedSpenderAmount[realOwner][msg.sender] = amount - calculteBurnCharge(amount);
    }
}
