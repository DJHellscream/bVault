// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { hre } = require("hardhat");

async function main() {
  const [owner, treasuryAddress, depositor1, depositor2, depositor3, depositor4, depositor5] = await ethers.getSigners();

  const susqContract = await ethers.deployContract("SusieQ");

  await susqContract.waitForDeployment();

  const vaultContract = await ethers.deployContract("KimboCollege", [susqContract, treasuryAddress, treasuryAddress, treasuryAddress]);
  await vaultContract.waitForDeployment();

  const vaultAddress = await vaultContract.getAddress();
  const susqAddress = await susqContract.getAddress();

  const d1Amount = ethers.parseEther("100");
  const d2Amount = ethers.parseEther("100");
  const d3Amount = ethers.parseEther("100");
  const d4Amount = ethers.parseEther("100");
  await susqContract.transfer(depositor1, d1Amount);
  await susqContract.transfer(depositor2, d2Amount);
  await susqContract.transfer(depositor3, d3Amount);
  await susqContract.transfer(depositor4, d4Amount);

  await susqContract.connect(depositor1).approve(vaultContract, d1Amount);
  await vaultContract.connect(depositor1).deposit(d1Amount, depositor1);

  await susqContract.connect(depositor2).approve(vaultContract, d2Amount);
  await vaultContract.connect(depositor2).deposit(d2Amount, depositor2);

  // await susqContract.connect(depositor3).approve(vaultContract, d3Amount);
  // await vaultContract.connect(depositor3).deposit(d3Amount, depositor3);

  // console.log("Deposit 100,000 tokens into Vault");
  await susqContract.transfer(vaultContract, ethers.parseEther("2"));

  //await vaultContract.connect(depositor1).transfer(depositor5, await vaultContract.balanceOf(depositor1));

  console.log(`KimboCollege Deployed at ${await vaultContract.getAddress()}`);
  console.log(`SusieQ Deployed at ${await susqContract.getAddress()}`);
  console.log(`owner Address as ${await owner.getAddress()}`);
  console.log(`owner Balance at ${await susqContract.balanceOf(owner)}`);
  console.log(`depositor1 Address as ${await depositor1.getAddress()}`);
  console.log(`depositor1 SusQBalance at ${await susqContract.balanceOf(depositor1)}`);
  console.log(`depositor1 xSusQBalance at ${await vaultContract.balanceOf(depositor1)}`);
  console.log(`depositor2 Address as ${await depositor2.getAddress()}`);
  console.log(`depositor2 SusQBalance at ${await susqContract.balanceOf(depositor2)}`);
  console.log(`depositor2 xSusQBalance at ${await vaultContract.balanceOf(depositor2)}`);
  // console.log(`depositor3 Address as ${await depositor3.getAddress()}`);
  // console.log(`depositor3 SusQBalance at ${await susqContract.balanceOf(depositor3)}`);
  // console.log(`depositor3 xSusQBalance at ${await vaultContract.balanceOf(depositor3)}`);
  // console.log(`depositor4 Address as ${await depositor4.getAddress()}`);
  // console.log(`depositor4 SusQBalance at ${await susqContract.balanceOf(depositor4)}`);
  // console.log(`depositor4 xSusQBalance at ${await vaultContract.balanceOf(depositor4)}`);
  // console.log(`depositor5 Address as ${await depositor5.getAddress()}`);
  // console.log(`depositor5 SusQBalance at ${await susqContract.balanceOf(depositor5)}`);
  // console.log(`depositor5 xSusQBalance at ${await vaultContract.balanceOf(depositor5)}`);
  console.log(`vault SusQBalance at ${await vaultContract.totalAssets()}`);
  console.log(`xSusQ value at ${await vaultContract.totalAssets()} ${await vaultContract.totalSupply()}`);
  console.log(`treasury xSusQBalance at ${await vaultContract.balanceOf(treasuryAddress)}`);
  console.log(`previewRedeem ${await vaultContract.previewRedeem(await vaultContract.balanceOf(depositor1))}`);
  console.log(`maxWithdraw ${await vaultContract.maxWithdraw(depositor1)}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
