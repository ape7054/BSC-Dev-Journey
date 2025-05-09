// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // 指定 Solidity 编译器版本

contract SimpleStorage {
    uint256 public myNumber; // 一个公共的无符号整型状态变量，用于存储数字

    // 事件，当数字被改变时触发
    event NumberChanged(uint256 indexed oldNumber, uint256 indexed newNumber, address changer);

    // 函数，用于存储一个新的数字
    function store(uint256 _number) public {
        uint256 oldNumber = myNumber; // 记录旧值
        myNumber = _number; // 更新状态变量 myNumber 的值
        emit NumberChanged(oldNumber, _number, msg.sender); // 触发事件
    }

    // 函数，用于读取存储的数字
    // 'view' 关键字表示这个函数只读取状态，不修改状态，因此不消耗 Gas (在链下调用时)
    function retrieve() public view returns (uint256) {
        return myNumber; // 返回状态变量 myNumber 的值
    }
}