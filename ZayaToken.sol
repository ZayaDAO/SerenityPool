// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import {ISuperfluid, ISuperToken, ISuperApp} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {IConstantFlowAgreementV1} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import {CFAv1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/CFAv1Library.sol";

contract ZayaToken is Ownable {
    ISuperfluid private _host; // host
    IConstantFlowAgreementV1 private _cfa; // the stored constant flow agreement class address

    using CFAv1Library for CFAv1Library.InitData;
    CFAv1Library.InitData public cfaV1; //initialize cfaV1 variable

    ISuperToken public _acceptedToken; // accepted token

    constructor(ISuperfluid host, IConstantFlowAgreementV1 cfa, ISuperToken _acceptedToken) {
        _host = host;
        _cfa = cfa;
        cfaV1 = CFAv1Library.InitData(
            host,
        //here, we are deriving the address of the CFA using the host contract
            IConstantFlowAgreementV1(
                address(host.getAgreementClass(
                    keccak256("org.superfluid-finance.agreements.ConstantFlowAgreement.v1")
                ))
            )
        );
    }

    // flowrate == wei/second

    function openStream(address to, int96 flowrate) public onlyOwner {
        cfaV1.createFlow(to, flowrate, _acceptedToken);
    }


    function closeStream(address to) public onlyOwner {
        cfaV1.deleteFlow(address(this), to, _acceptedToken);
    }




    bool[] public meetings;

    function startMeeting() public onlyOwner {
        meetings.push(true);
    }

    function endMeeting(uint _idx) public onlyOwner {
        meetings[_idx]=false;
    }

    struct session {
        uint startedAt;
        uint finishedAt;
    }

    mapping (address => mapping (uint => unit)) sessions;

    function startSession(uint _idx) public {
        require(meetings[_idx], "meeting not found");
        sessions[msg.sender][_idx] = block.timestamp;
    }

    function endSession(uint _idx) public {
        require(meetings[_idx], "meeting not found");
        sessions[msg.sender][_idx] = block.timestmp;
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