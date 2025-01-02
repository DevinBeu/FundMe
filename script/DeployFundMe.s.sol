// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function deployFundMe() public returns (FundMe, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig(); // Initialize HelperConfig
        
        // Access the priceFeed directly from the struct
        (address priceFeed) = helperConfig.activeNetworkConfig(); 

        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed); // Pass the price feed to FundMe
        vm.stopBroadcast();

        return (fundMe, helperConfig);
    }

    function run() external returns (FundMe, HelperConfig) {
        return deployFundMe();
    }
}