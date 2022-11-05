const { ethers } = require("hardhat")

async function main() {
  const SupplyChain = await ethers.getContractFactory("SupplyChain")
  console.log("Deploying contract...")
  const supplyChain = await SupplyChain.deploy()
  await supplyChain.deployed()
  console.log(`Deployed contract to: ${supplyChain.address}`)

  const test = await supplyChain.getTest()
  console.log(`current value is ${test.toString()}`)
  console.log("1----------------------")
  const tx = await supplyChain.testing()
  await tx.wait(1)
  const test2 = await supplyChain.getTest()
  console.log(`updated value is : ${test2.toString()}`)
  console.log("2----------------------")
  await supplyChain.setCal()
  const tx5 = await supplyChain.testing()
  await tx5.wait(1)
  const test3 = await supplyChain.getTest()
  console.log(`third level : ${test3}`)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
