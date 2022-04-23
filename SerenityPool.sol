// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import {ISuperfluid, ISuperToken, ISuperApp} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {IConstantFlowAgreementV1} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import {CFAv1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/CFAv1Library.sol";

contract SerenityPool is Ownable {
    ISuperfluid private _host; // host
    IConstantFlowAgreementV1 private _cfa; // the stored constant flow agreement class address

    using CFAv1Library for CFAv1Library.InitData;
    CFAv1Library.InitData public _cfaV1; //initialize cfaV1 variable

    ISuperToken public _acceptedToken; // accepted token
    mapping(address => bool) internal _burn;

    constructor(ISuperfluid host, IConstantFlowAgreementV1 cfa, ISuperToken acceptedToken) {
        _host = host;
        _cfa = cfa;
        _acceptedToken = acceptedToken;

        _cfaV1 = CFAv1Library.InitData(
            host,
            IConstantFlowAgreementV1(
                address(host.getAgreementClass(
                    keccak256("org.superfluid-finance.agreements.ConstantFlowAgreement.v1")
                ))
            )
        );
    }

    // flowrate: wei/second
    function openStream(address to, int96 flowrate) public notBurned(to){
        _burn[to]=true;
        _cfaV1.createFlow(to, _acceptedToken, flowrate);
    }

    function closeStream(address to) public {
        _cfaV1.deleteFlow(address(this), to, _acceptedToken);
    }

    modifier notBurned(address to) {
        require(!_burn[to],"already burned");
        _;
    }
}