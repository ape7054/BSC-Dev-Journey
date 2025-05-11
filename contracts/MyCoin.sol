// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 从 OpenZeppelin 导入 ERC20 合约
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// MyCoin 合约，继承自 OpenZeppelin 的 ERC20 标准实现
contract MyCoin is ERC20 {
    // 构造函数，部署时设置代币名称、符号和初始供应量
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        // 铸造初始供应量，全部分配给部署者
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
    }
}