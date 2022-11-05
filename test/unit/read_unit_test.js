const { expect, assert } = require("chai")
const hre = require("hardhat")

describe("SupplyChain", () => {
  let supplyChain, signers
  beforeEach(async () => {
    const SupplyChain = await hre.ethers.getContractFactory("SupplyChain")
    supplyChain = await SupplyChain.deploy()
    signers = await hre.ethers.getSigners()
  })

  it("Initial Should start at 0", async () => {
    const currentProdId = await supplyChain.getProdId()

    assert.equal(currentProdId, 0)
  })

  describe("create file succesfully", async () => {
    let productCreated
    let prodName = "mamad"
    let prodCost = 199
    beforeEach(async () => {
      const createItemResponse = await supplyChain.createItem(prodName, prodCost)
      await createItemResponse.wait(1)

      productCreated = await supplyChain.getProduct(0)
    })

    it("prodId of item that was created must be 0", async () => {
      const createdProductId = parseInt(productCreated.productId._hex)
      assert.equal(createdProductId, 0)
    })
    it("creator of item that was created must be me", async () => {
      const signerAddress = signers[0].address
      const createdProductSigner = productCreated.creator
      assert.equal(signerAddress, createdProductSigner)
    })
    it("ProductName of item that was created must Right", async () => {
      const createdProductName = productCreated.productName
      assert.equal(createdProductName, prodName)
    })
    it("ProductCost of item that was created must Right", async () => {
      const createdProductCost = parseInt(productCreated.initialCost)
      assert.equal(createdProductCost, prodCost)
    })
    it("ownState and ownId must be 0", async () => {
      const OwnStateId = parseInt(productCreated.OwnStateId)
      const CostStateId = parseInt(productCreated.CostStateId)
      assert.equal(OwnStateId, 0)
      assert.equal(CostStateId, 0)
    })
    it("prodId ++", async () => {
      const currentProdId = await supplyChain.getProdId()
      assert(currentProdId, 1)
    })
    it("emit with Added", async () => {
      await expect(supplyChain.createItem("mmd", 89)).to.emit(supplyChain, "Added")
    })
  })

  // assert that the value is correct
  // expect(await lock.unlockTime()).to.equal(unlockTime)
})
