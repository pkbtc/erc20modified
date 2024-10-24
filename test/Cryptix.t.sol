// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Cryptix} from "../src/Cryptic.sol";
import {Deploy} from "../script/CryptixDeploy.s.sol";
import {console} from "forge-std/console.sol";
contract CryptixTest is Test{
    Cryptix cryptix;
    Deploy deploy;
    address feeAddress=makeAddr("feesAddress");
    address user1=makeAddr("user1");
    address owner;
    function setUp() public {
        deploy=new Deploy();
        cryptix=deploy.run();
        owner=cryptix.owner();
        vm.prank(owner);
        cryptix.setFeesAddress(feeAddress);


    }
//     function feesAddress() external view{
//         assert(cryptix.getFeesAdress()!=address(0));

//     }
// }
    //      function testFeeAddressIsNotZero() public view {
    //     assert(cryptix.setFeesAddress() != address(0));
    //     console.log("fee address is: ", feeAddress);
    // }

    function testfessisnotzero() public view{
        uint fees=cryptix.getFessAmount();
        assert(fees!=0);

    }
    function testOwnerInitalSuppy() public view {
        uint initalSup=6000 * 10 ** cryptix.decimals();
        uint ownerBalancw=cryptix.balanceOf(owner);
        assert(ownerBalancw==initalSup);
    }


    function testmintfailes() public  {
        vm.prank(user1);
        vm.expectRevert();
        cryptix.mint(owner, 2);


    }

}