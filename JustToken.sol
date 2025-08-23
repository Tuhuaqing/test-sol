// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract JustToken {

    // 1. token name
    string public tokenName;
    // 2. token symbol
    string public tokenSymbol;
    // 3. token总数
    uint256 public total;
    // 4. owner所有者
    address public owner;
    // 5. token地址记录
    mapping(address => uint256) public balances;
    // 6. token上限
    uint256 public MAX = 21000000;

    constructor() {
        tokenName = "JustToken";
        tokenSymbol = "JKB";
        total = 0;
        owner = msg.sender;
    }

    // 获取token
    function mint(uint256 amount) public {
        require(total <= MAX, "JKB was munt out");
        // 给地址转账
        balances[msg.sender] += amount;
        total += amount;
    }

    // 销毁token
    function destroy(uint256 amount) public {
        require(
            balances[msg.sender] >= amount,
            "your JKB amount must large than amount"
        );
        balances[msg.sender] -= amount;
        total -= amount;
    }

    // 查看地址token余额
    function getBalance(address addr) public view returns (uint256) {
        return balances[addr];
    }

    // 转账
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "your JKB amount must large than amount in order to transfer");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

}
