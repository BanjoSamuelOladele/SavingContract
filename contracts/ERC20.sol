

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./IERC20.sol";


contract WizT is IERC20{

    uint private tokenTotalSupply;

    mapping (address => uint) private balances;
    mapping (address => mapping (address => uint)) private allowedSpenderAmount;

    constructor(uint _totalSupply){
        tokenTotalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() external view virtual override returns (uint){
        return tokenTotalSupply;
    }

    function balanceOf(address addr) external view virtual override returns (uint){
        return balances[addr];
    }

    function transfer(address to, uint amount) external virtual override returns (bool){
        uint totalPay = amount + calculteBurnCharge(amount);
        checker(balances[msg.sender], totalPay, to);
        transferring(msg.sender, to, amount);
        return true;
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

    function approve(address addr, uint amount) external returns(bool){
        checker(balances[msg.sender], amount, addr);
        allowedSpenderAmount[msg.sender][addr] = allowedSpenderAmount[msg.sender][addr] + amount;
        return true;
    }

    function checker(uint balance, uint amount, address addr) private pure  {
        require(amount > 0, "Cannot send zero amount");
        require(balance >= amount, "Amount should equal or lesser than available balance");
        require(addr != address(0), "transfer to this address not allowed");
    }

    function allowance(address owner, address spender) external view returns (uint){
        return allowedSpenderAmount[owner][spender];
    }

    function transferFrom(address owner, address recipient, uint amount) external virtual override returns(bool){
        require(allowedSpenderAmount[owner][msg.sender] >= (amount+calculteBurnCharge(amount)), "exceed allowed tranfer");
        transferring(owner, recipient, amount);
        allowedSpenderAmount[owner][msg.sender] = amount - calculteBurnCharge(amount);
        return true;
    }
}
