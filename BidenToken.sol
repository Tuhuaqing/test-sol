// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BidenCoin is ERC20 {

    uint public MAX = 21000000;

    constructor() ERC20("BidenCoin", "BDC") {

    }

}
