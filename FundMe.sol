// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    // 1w dollar
    uint256 public MIN_VALUE = 10000 * 10**8;
    // 10w dollar
    uint256 public TARGET = 100000 * 10**8;
    address public owner;
    mapping(address => uint256) public funder2Amount;
    AggregatorV3Interface private dataFeed;
    uint256 public startTime;
    uint256 public lockDuration;
    uint256 public expirationTime;
    address public erc20Addr;
    bool public isContractEnd = false;

    constructor() {
        /**
         * Network: Sepolia
         * Aggregator: ETH/USD
         * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
         */
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        owner = msg.sender;
        startTime = block.timestamp;
        lockDuration = 5 * 60; // 5 minutes
        expirationTime = startTime + lockDuration;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can change owner");
        _;
    }

    modifier inWindow() {
        require(
            block.timestamp < expirationTime,
            "this fund project is expired!"
        );
        _;
    }

    modifier outWindow() {
        require(
            block.timestamp >= expirationTime,
            "please wait for the project expired!"
        );
        _;
    }

    /////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int256) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function fund() external payable inWindow {
        require(ethWei2Usd(msg.value) >= MIN_VALUE, "please fund more ETH/USD");
        funder2Amount[msg.sender] += msg.value;
    }

    // return the usd of wei with 10*8
    function ethWei2Usd(uint256 eth) private view returns (uint256) {
        uint256 ethWeiPrice = (uint256)(getChainlinkDataFeedLatestAnswer());
        return (eth * ethWeiPrice) / (10**18);
    }

    function changeOwner() public onlyOwner {
        owner = msg.sender;
    }

    function drawFun() public outWindow onlyOwner {
        require(
            ethWei2Usd(funder2Amount[msg.sender]) >= TARGET,
            "you don't have enough ETH to draw"
        );
        require(msg.sender == owner, "only owner can get fund");
        // transfer: no return
        // payable(msg.sender).transfer(address(this).balance);

        // send: with return bool
        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success, "failed");

        // call: call another function and return bool,result
        (bool success, ) = payable(msg.sender).call{value: contractBalance()}("");
        require(success, "failed");
        isContractEnd = true;
    }

    function refund() external inWindow {
        uint256 refundAmount = funder2Amount[msg.sender];
        require(refundAmount > 0, "you have no eth to refund");
        funder2Amount[msg.sender] -= refundAmount;
        (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
        require(success, "refund failed");
    }

    function getBalanceUsd() public view returns (uint256) {
        return ethWei2Usd(address(this).balance) / 10**8;
    }

    function getMyFund() public view returns (uint256) {
        return ethWei2Usd(funder2Amount[msg.sender]) / 10**8;
    }

    function setFunder2Amount(address funder, uint256 amount) public onlyOwner {
        require(msg.sender == erc20Addr, "only erc20 can update the amount");
        funder2Amount[funder] = amount;
    }

    function setErc20(address _erc20Addr) public onlyOwner {
        erc20Addr = _erc20Addr;
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
