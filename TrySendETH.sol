// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TrySendETH {
    address public owner;

    function charge() external payable {}

    function tryPay(address addr) external {
        (bool success, ) = payable(addr).call{value: 3 * 10**18}("");
        require(success, "pay successfully");
    }
}
