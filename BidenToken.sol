// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

contract BidenCoin is ERC20 {
    
    FundMe fundMe;

    constructor(address fundMeAddr) ERC20("BidenCoin", "BDC") {
        fundMe = FundMe(fundMeAddr);
    }

    function mint(uint256 amount) public {
        require(fundMe.funder2Amount(msg.sender) >= amount, "you must fund more into FundMe.sol");
        require(fundMe.isContractEnd(),"please wait for the FundMe.sol ended");
        _mint(msg.sender, amount);
        fundMe.setFunder2Amount(msg.sender, fundMe.funder2Amount(msg.sender) - amount);
    }

    function claim(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount,"Your don't have enough ERC20 tokens");
        _burn(msg.sender, amount);
    }



}
