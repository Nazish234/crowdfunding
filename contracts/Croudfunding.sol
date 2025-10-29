// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalFunds;
    mapping(address => uint256) public contributions;

    constructor(uint256 _goal, uint256 _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    // Function to contribute to the campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Contribution must be greater than zero");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function for the owner to withdraw funds once goal is met
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Funding goal not reached");
        require(block.timestamp >= deadline, "Campaign still active");
        payable(owner).transfer(address(this).balance);
    }

    // Function to allow contributors to refund if goal not met
    function refund() external {
        require(block.timestamp >= deadline, "Campaign not yet ended");
        require(totalFunds < goal, "Goal was reached, no refunds");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contributions to refund");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Function to check the contract’s ETH balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
