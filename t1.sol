// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract contractNameWhoYourDad {
    
    uint256 public constant MY_CONSTANT =
        1234567890123456789012345678901234567890;

    uint256 public a = 1999;
    string public b = "Hello, World!";
    bool public c = true;
    address public d = 0x1234567890123456789012345678901234567890;
    uint256 public max = 2 ** 256 - 1;
    uint256 public max2 = type(uint256).max;
    uint256[] public arr = [1, 2, 3, 4, 5];
    NftInfo[] public arms = [
        NftInfo("NFT1", 100, true),
        NftInfo("NFT2", 200, false)
    ];
    mapping(address => UserInfo) userMap;
    mapping(address => uint256) balanceMapping;
    mapping(address => mapping(address => uint256)) nestedMapping;

    struct NftInfo {
        string name;
        uint256 attack;
        bool state;
    }

    struct UserInfo {
        string name;
        uint256 age;
        bool state;
    }
}
