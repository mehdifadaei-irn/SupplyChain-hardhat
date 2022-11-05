require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("hardhat-deploy")
require("solidity-coverage")
require("hardhat-gas-reporter")
require("hardhat-contract-sizer")
require("./tasks")
require("@appliedblockchain/chainlink-plugins-fund-link")
require("dotenv").config()

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

const MAINNET_RPC_URL =
  process.env.MAINNET_RPC_URL ||
  process.env.ALCHEMY_MAINNET_RPC_URL ||
  "https://eth-mainnet.alchemyapi.io/v2/your-api-key"
const POLYGON_MAINNET_RPC_URL =
  process.env.POLYGON_MAINNET_RPC_URL || "https://polygon-mainnet.alchemyapi.io/v2/your-api-key"
const GOERLI_RPC_URL =
  process.env.GOERLI_RPC_URL || "https://eth-goerli.alchemyapi.io/v2/your-api-key"
const PRIVATE_KEY = process.env.PRIVATE_KEY
// optional
const MNEMONIC = process.env.MNEMONIC || "Your mnemonic"
const FORKING_BLOCK_NUMBER = process.env.FORKING_BLOCK_NUMBER

// Your API key for Etherscan, obtain one at https://etherscan.io/
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "Your etherscan API key"
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY || "Your polygonscan API key"
const REPORT_GAS = process.env.REPORT_GAS || false

module.exports = {
  defaultNetwork: "hardhat",
  solidity: {
    compilers: [
      { version: "0.4.19" },
      { version: "0.6.12" },
      { version: "0.6.6" },
      { version: "0.8.7" },
      { version: "0.8.0" },
    ],
  },
  networks: {
    hardhat: {
      chainId: 31337,
      // forking: {
      //   url: "https://eth-mainnet.g.alchemy.com/v2/T2mVrmLbAvp-kZ_-lLvo2j5xWIqoglbk",
      // },
      // blockConfirmations: 1
    },
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/H56uoJhC7IqjtizCUgxsn4I_TmSI7m1o",
      accounts: ["bc4f3d33b152f763143e8cadb233f7a3b4dc66a25fedfa8a9269da0c9f56ed69"],
      chainId: 5,
      blockConfirmations: 6,
    },
  },
  etherscan: {
    apiKey: "7B7D9JUQT8I2V79PDE844A7P7ZGPFXX8Z9",
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
    // coinmarketcap: COINMARKETCAP_API_KEY,
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
      1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
    player: {
      default: 1,
    },
  },
}
