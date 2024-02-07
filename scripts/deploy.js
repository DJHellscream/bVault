// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const [owner, treasuryAddress, depositor1, depositor2, depositor3] = await ethers.getSigners();

  const susqContract = await ethers.deployContract("SusieQ");

  await susqContract.waitForDeployment();

  const vaultContract = await ethers.deployContract("KimboSchool", [susqContract, treasuryAddress]);
  await vaultContract.waitForDeployment();

  const vaultAddress = await vaultContract.getAddress();
  const susqAddress = await susqContract.getAddress();

  const d1Amount = ethers.parseEther("100");
  const d2Amount = ethers.parseEther("105");
  await susqContract.transfer(depositor1, d1Amount);
  await susqContract.transfer(depositor2, d2Amount);

  await susqContract.connect(depositor1).approve(vaultContract, d1Amount);

  const amountApprovedMint = await vaultContract.previewMint(d1Amount);
  await susqContract.connect(depositor2).approve(vaultContract, amountApprovedMint);

  console.log(`KimboSchool Deployed at ${await vaultContract.getAddress()}`);
  console.log(`SusieQ Deployed at ${await susqContract.getAddress()}`);
  console.log(`owner Address as ${await owner.getAddress()}`);
  console.log(`owner Balance at ${await susqContract.balanceOf(owner)}`);
  console.log(`depositor1 Address as ${await depositor1.getAddress()}`);
  console.log(`depositor1 Balance at ${await susqContract.balanceOf(depositor1)}`);
  console.log(`depositor2 Address as ${await depositor2.getAddress()}`);
  console.log(`depositor2 Balance at ${await susqContract.balanceOf(depositor2)}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
