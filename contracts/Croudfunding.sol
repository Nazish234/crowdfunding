// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint256 public goal;
    uint256 public totalFunds;
    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // Function to contribute ETH to the campaign
    function contribute() external payable {
        require(msg.value > 0, "Must send some ETH");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function to withdraw funds (only by owner & if goal is met)
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Funding goal not reached");
        payable(owner).transfer(address(this).balance);
    }
}

