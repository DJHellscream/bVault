const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const exp = require("constants");

describe("Market", function () {
  async function deployVaultFixture() {
    const [owner, treasuryAddress, depositor1, depositor2, depositor3] = await ethers.getSigners();

    const susqContract = await ethers.deployContract("SusieQ");

    await susqContract.waitForDeployment();

    const vaultContract = await ethers.deployContract("KimboSchool", [susqContract, treasuryAddress]);
    await vaultContract.waitForDeployment();

    const vaultAddress = await vaultContract.getAddress();
    const susqAddress = await susqContract.getAddress();

    console.log("vaultAddress: %s", vaultAddress);
    console.log("susqAddress: %s", susqAddress);

    return {
      vaultContract, vaultAddress, susqContract, susqAddress, owner, treasuryAddress, depositor1, depositor2, depositor3
    }
  }

  describe("Deployment", function () {
    it("Should be the right owner", async function () {
      const { vaultContract, owner } = await loadFixture(deployVaultFixture);

      expect(await vaultContract.owner()).to.equal(owner.address);
    })

    it("Should assign total supply of tokens to owner", async function () {
      const { susqContract, owner } = await loadFixture(deployVaultFixture);

      const d1 = await susqContract.balanceOf(owner);
      expect(await susqContract.totalSupply()).to.equal(d1);
    })
  });

  describe("Deposit Tokens", function () {
    async function TransferAndApproveFixture() {
      const { vaultContract, susqContract, depositor1, depositor2 } = await loadFixture(deployVaultFixture);

      const amountApprovedDeposit = ethers.parseEther("100");
      const sendToDepositor2 = ethers.parseEther("105");
      await susqContract.transfer(depositor1, amountApprovedDeposit);
      await susqContract.transfer(depositor2, sendToDepositor2)

      const shares = await vaultContract.previewDeposit(amountApprovedDeposit);
      console.log("previewDeposit: %d", shares);
      await susqContract.connect(depositor1).approve(vaultContract, amountApprovedDeposit);

      const amountApprovedMint = await vaultContract.previewMint(amountApprovedDeposit);
      console.log("previewMint: %d", amountApprovedMint);
      await susqContract.connect(depositor2).approve(vaultContract, amountApprovedMint);

      return { amountApprovedDeposit, amountApprovedMint }
    }

    it("Should deposit 100 tokens and get back 100 shares - fee", async function () {
      const { vaultContract, vaultAddress, susqContract, treasuryAddress, depositor1, depositor2, depositor3 } = await loadFixture(deployVaultFixture);
      const { amountApprovedDeposit, amountApprovedMint } = await loadFixture(TransferAndApproveFixture);

      await vaultContract.connect(depositor1).deposit(amountApprovedDeposit, depositor1);
      const d1 = await vaultContract.balanceOf(depositor1);
      console.log("sharesViaDeposit: %d", d1);
      console.log("treasuryBalance after Deposit: %d", await susqContract.balanceOf(treasuryAddress));
      console.log("vaultBalance - xSusQ after Deposit: %d", await vaultContract.balanceOf(vaultAddress));

      await vaultContract.connect(depositor2).mint(amountApprovedDeposit, depositor2);
      const d2 = await vaultContract.balanceOf(depositor2);
      console.log("sharesViaMint: %d", d2);
      console.log("treasuryBalance after Mint: %d", await susqContract.balanceOf(treasuryAddress));
      console.log("vaultBalance - xSusQ after Mint: %d", await vaultContract.balanceOf(vaultAddress));

      await vaultContract.connect(depositor1).transfer(depositor3, d1);
      const d3 = await vaultContract.balanceOf(depositor3);
      console.log("sharesAfterTransfer - Despositor 1: %d", await vaultContract.balanceOf(depositor1));
      console.log("sharesAfterTransfer - Despositor 3: %d", d3);

      console.log("treasuryBalance - SusQ after Transfer: %d", await susqContract.balanceOf(treasuryAddress));
      console.log("treasuryBalance - xSusQ after Transfer: %d", await vaultContract.balanceOf(treasuryAddress));
      console.log("vaultBalance - xSusQ after Transfer: %d", await vaultContract.balanceOf(vaultAddress));

      await vaultContract.connect(depositor2).approve(depositor3, d2);
      await vaultContract.connect(depositor3).transferFrom(depositor2, depositor3, d2);
      console.log("depositor2 xSusQ Balance: %d", await vaultContract.balanceOf(depositor2));
      console.log("depositor3 xSusQ Balance: %d", await vaultContract.balanceOf(depositor3));
      console.log("treasuryBalance - xSusQ after TransferFrom: %d", await vaultContract.balanceOf(treasuryAddress));
      console.log("vaultBalance - xSusQ after TransferFrom: %d", await vaultContract.balanceOf(vaultAddress));
      // const rewards1 = await vaultContract.connect(depositor1).previewRedeem(d1);
      // const rewards2 = await vaultContract.connect(depositor2).previewRedeem(d2);
      // console.log("rewards1: %d", rewards1);
      // console.log("rewards2: %d", rewards2);

      // console.log("Deposit 100,000 tokens into Vault");
      // await susqContract.transfer(vaultContract, ethers.parseEther("100000"));

      // const rewardsPost1 = await vaultContract.connect(depositor1).previewRedeem(d1);
      // const rewardsPost2 = await vaultContract.connect(depositor2).previewRedeem(d2);
      // console.log("rewardsPost1: %d", rewardsPost1);
      // console.log("rewardsPost2: %d", rewardsPost2);

      // await vaultContract.connect(depositor1).redeem(d1, depositor1, depositor1);
      // console.log("treasuryBalance: %d", await susqContract.balanceOf(treasuryAddress));

      // const claim1 = await susqContract.balanceOf(depositor1);
      // const vaultTokens = await vaultContract.balanceOf(depositor1);
      // console.log("claim1: %d", claim1);
      // console.log("vaultTokens: %d", vaultTokens);
      // const rewardsPostClaim2 = await vaultContract.connect(depositor2).previewRedeem(d2);
      // console.log("rewardsPostClaim2: %d", rewardsPostClaim2);

      // console.log("Deposit 100,000 tokens into Vault");
      // await susqContract.transfer(vaultContract, ethers.parseEther("100000"));
      // const rewardsPostClaimX2 = await vaultContract.connect(depositor2).previewRedeem(d2);
      // console.log("rewardsPostClaimX2: %d", rewardsPostClaimX2);
    })
  });
});