// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Cryptix} from "../src/Cryptic.sol";



contract Deploy is Script {
        uint intialSupply=6000;
        uint maxSupply=10000;
        Cryptix cryptix;
        function run() external returns(Cryptix) {
            cryptix=new Cryptix(intialSupply,maxSupply);
            return cryptix;
        }
}