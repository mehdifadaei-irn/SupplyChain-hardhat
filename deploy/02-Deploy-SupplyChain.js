const { verify } = require("../helper-functions")
const {
  networkConfig,
  developmentChains,
  VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config")
const { getNamedAccounts, deployments, network, run } = require("hardhat")

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId

  // i just planned this for goerli for Now
  log("------Deploying---------------------------------------")
  const supplyChain = await deploy("SupplyChain", {
    from: deployer,
    args: [],
    log: true,
    waitConfirmations: 6,
  })

  if (!developmentChains.includes(network.name)) {
    log("Verifying...")
    await verify(supplyChain.address, [])
  }
}


// module.exports.tags = ["all", "supply", "main"]
