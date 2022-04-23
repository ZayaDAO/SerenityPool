// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SerenityPool is ERC20, Ownable {
    constructor() ERC20("Zaya DAO Serenity Token", "SERENITY") {}

    bool[] public meetings;

    function startMeeting() public onlyOwner {
        meetings.push(true);
    }
    function endMeeting(uint _idx) public onlyOwner {
        meetings[_idx]=false;
    }

    mapping (address => mapping (uint => )) sessions;

    function startSession(uint _idx) public {
        require(meetings[_idx], "meeting not found");
        sessions[msg.sender][_idx] = block.timestamp;
    }

    function endSession(uint _idx) public {
        require(meetings[_idx], "meeting not found");
        sessions[msg.sender][_idx] = block.timestamp;
    }

    // struct UserInfo{
    //     uint256 amountToClaim;
    //     uint256 lastStartTime;
    // }

    // mapping (address => UserInfo) public userInfos;

    // struct EventInfo{
    //     uint256 eventStartTime;
    // }

    // mapping (uint256 => EventInfo) public userInfos;


    // function startSession() external {
    //     userInfos[msg.sender].lastStartTime = block.timestamp;
    // }

    // function endSession() external {
    //     require(userInfos[msg.sender].lastStartTime!=0, "session not started");
    //     require(block.timestamp - userInfos[msg.sender].lastStartTime, "session not started");
    //     uint256 sessionTime = block.timestamp - userInfos[msg.sender].lastStartTime;

    //     userInfos[msg.sender].amountToClaim += sessionTime/60 * 1e18;
    //     userInfos[msg.sender].lastStartTime = 0;
    // }

    // function claimReward() external {
    //     _mint(msg.sender, userInfos[msg.sender].amountToClaim);
    //     userInfos[msg.sender].amountToClaim = 0;
    // }


}