// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; 

import {Test, console} from "forge-std/Test.sol"; 
import {FundMe} from "../../src/FundMe.sol"; 
import {DeployFundMe} from "../../script/DeployFundMe.s.sol"; 
import {FundFundMe} from "../../script/Interactions.s.sol"; 

contract InteractionsTest is Test {
    FundMe fundme; 
    address USER = makeAddr("user"); 
    uint256 constant SEND_VALUE = 0.1 ether; 
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1; 

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        (fundme, ) = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe(); 
        
        vm.startPrank(USER);
        // Send value with the function call
        fundFundMe.fundFundMe{value: SEND_VALUE}(address(fundme));
        vm.stopPrank();

        address funder = fundme.getFunder(0); 
        assertEq(funder, USER);
        
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}