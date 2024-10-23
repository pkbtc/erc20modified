// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol" ;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

    /**
     * @title Cryptix
     * @author pk.eth
     * @notice 
     */

      contract Cryptix is  ERC20Capped, Pausable, Ownable {
            address payable public fessAddress;
            uint256 public fessAmount=1;

            mapping(address => uint256) public lockTime;

            constructor(uint256 initialSupply,uint256 max) ERC20("Cryptix", "CIX") ERC20Capped(max * (10 ** decimals()))  Ownable(msg.sender) {
                _mint(msg.sender, initialSupply* (10 ** decimals()));   
            }
            event TokenMinted(address indexed account, uint256 amount);
            event TokenBurn(address indexed account, uint256 amount);
            event Withdraw(address indexed to,uint256 amount);

            function mint(address account,uint256 amount) external onlyOwner returns (bool) {
                require(account!=address(0) && amount!=0,"You can't mint 0 tokens and invalid address");
                _mint(account ,amount);
                emit TokenMinted(account,amount);
                return true;
            }
            function burn(address account,uint256 amount) external onlyOwner returns(bool){
                require(account!=address(0) && amount!=0,"You can't burn 0 tokens and invalid address");
                _burn(account,amount);
                emit TokenBurn(account,amount);
                return true;
            }
            function tranfer(address from,address to ,uint amount) external {
                require(from!=address(0) && to!=address(0),"invalid address");
                require(amount!=0,"You can't transfer 0 tokens");
                uint fee=(amount*fessAmount)/100;
                require(amount>fee,"You can't transfer less than fees");
                uint amountAfterFees=amount-fee;
                super._transfer(from,fessAddress,fee);
                super._transfer(from,to,amountAfterFees);


            }

            function withdraw(uint256 amount) external onlyOwner returns(bool){
                require(amount!=0,"You can't withdraw 0 tokens");
                require(amount>=address(this).balance,"You don't have enough balance");
                payable(msg.sender).transfer(amount);
                return true;
            }

            function lockOwnerTokens(uint256 duration) external onlyOwner{
                lockTime[msg.sender]=block.timestamp+duration;
            }

            function unlockOwnerTokens() external onlyOwner{
                require(block.timestamp>=lockTime[msg.sender],"tokens are still locked");
                lockTime[msg.sender]=0;
            }

            function pause() external onlyOwner{
                _pause();
            }

            function setFeesAddress(address _setFeesAddress) external onlyOwner{
                fessAddress=payable(_setFeesAddress);
            }

            function getFeesAdress() external view returns(address){
                return fessAddress;
            }

            function getFessAmount() external view returns(uint256){
                return fessAmount;
            }

            function getOwner() external view returns(address){
                return owner();
            }


      } 
