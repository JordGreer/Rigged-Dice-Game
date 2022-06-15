const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const diceGame = await ethers.getContract("DiceGame", deployer);

  
  await deploy("RiggedRoll", {
   from: deployer,
   args: [diceGame.address],
   log: true,
  });
  
  riggedRoll = await ethers.getContract("RiggedRoll", deployer);
  console.log("Transfering ownership to front end address");
  const ownershipTransaction = await riggedRoll.transferOwnership("0x623F725eAaD6247AcC0BaECc8150CC628f3537eb");
  console.log("Transfered");
  

};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["RiggedRoll"];
