

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

interface IERC20{
    function totalSupply() external view returns(uint);
    function balanceOf(address addr) external view returns(uint);
    function transfer(address recipient, uint amount) external returns(bool);
    function approve(address spender, uint amount) external returns (bool);
    function allowance(address owner, address spender) external returns(uint);
    function transferFrom(address owner, address recipient, uint amount) external returns (bool);
}