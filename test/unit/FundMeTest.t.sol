// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;

    address USER = makeAddr("user"); 
    uint256 constant SEND_VALUE = 0.1 ether; 
    uint256 constant STARTING_BALANCE = 100 ether; 
    uint256 constant GAS_PRICE = 1; 

    function setUp() external {
        //fundme = new FundMe();
        DeployFundMe deployFundMe = new DeployFundMe();
        (fundme, ) = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); 
    }

    function testMinimumDollarIsFive() public {
        console.log(fundme.MINIMUM_USD());
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundme.getOwner());
        console.log(msg.sender);
        assertEq(fundme.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundme.getVersion();
        assertEq(fundme.getVersion(), 4);
    }
    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); 
        fundme.fund(); 
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); 
        fundme.fund{value:SEND_VALUE}(); 
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);   
        assertEq(amountFunded, SEND_VALUE); 
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER); 
        fundme.fund{value:SEND_VALUE}(); 
        address funder = fundme.getFunder(0); 
        assertEq(funder, USER); 
    }

    modifier funded {
        vm.prank(USER); 
        fundme.fund{value:SEND_VALUE}(); 
        _; 
    }

    function testOnlyOwnerCanWithdraw() public {
         vm.prank(USER); 
        fundme.fund{value:SEND_VALUE}();
        vm.expectRevert(); 
        vm.prank(USER); 
        fundme.withdraw(); 
    }

    function testWithdrawWithASingleFunder() public funded {
        uint256 startingOwnerBalance = fundme.getOwner().balance; 
        uint256 startingFundMeBalance = address(fundme).balance; 

        uint256 gasStart = gasleft(); 
        vm.txGasPrice(GAS_PRICE); 
        vm.prank(fundme.getOwner()); 
        fundme.withdraw(); 
        uint256 gasEnd = gasleft(); 
        uint256 gasUsed = (gasStart - gasEnd)* tx.gasprice; 

        uint256 endingOwnerBalance = fundme.getOwner().balance; 
        uint256 endingFundMeBalance = address(fundme).balance; 
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance); 
    }

    function testWithdrawFromMultipleFunders() public {
        uint160 numberOfFunders = 10; 
        uint160 startingFunderIndex = 0; 
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE); 
            fundme.fund{value:SEND_VALUE}(); 

        }
        uint256 startingOwnerBalance = fundme.getOwner().balance; 
        uint256 startingFundMeBalance = address(fundme).balance; 


        vm.txGasPrice(GAS_PRICE); 
        vm.startPrank(fundme.getOwner()); 
        fundme.withdraw();
        vm.stopPrank();  
        assert(address(fundme).balance == 0); 
        assert(startingFundMeBalance + startingOwnerBalance == fundme.getOwner().balance); 
    }

}
