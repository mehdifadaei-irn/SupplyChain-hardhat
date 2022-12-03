// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* Errors */
error SupplyChain__ProductIdIsNotValid();
error SupplyChain__OnlyOwnerCanChangeOwnibility();

/**@title A sample SupplyChain Contract
 * @author Mehdi Fadaei
 * @notice This contract is for creating a SupplyChain
 */

contract SupplyChain {
  uint256 private prodId = 0;

  struct Product {
    uint256 productId;
    address creator;
    string productName;
    uint256 timeCreated;
    uint256 initialCost;
    uint256 OwnStateId;
    uint256 CostStateId;
  }

  struct OwnState {
    address owner;
    uint256 timeOwned;
    string description;
  }

  struct CostState {
    uint256 cost;
    uint256 timeCosted;
    string description;
  }

  event Added(uint256 indexed itemId, string indexed itemName);
  event OwnerStateAdded(uint256 indexed itemId, uint256 indexed ownStateId);
  event CostStateAdded(uint256 indexed itemId, uint256 indexed ownStateId);

  mapping(uint256 => mapping(uint256 => OwnState)) s_productOwnerState;
  mapping(uint256 => mapping(uint256 => CostState)) s_productCostState;

  mapping(uint256 => Product) public s_allProducts;

  // for track each address how many Product have?

  modifier onlyOwner(uint256 _prodId) {
    address lastOwner = OwnerOf(_prodId);
    if (msg.sender != lastOwner) revert SupplyChain__OnlyOwnerCanChangeOwnibility();
    _;
  }

  /////////////////////
  // Main Functions //
  /////////////////////

  function createItem(string memory _productName, uint256 _cost) public returns (bool) {
    Product memory newProd = Product(
      prodId,
      msg.sender,
      _productName,
      block.timestamp,
      _cost,
      0,
      0
    );

    s_allProducts[prodId] = newProd;

    emit Added(prodId, _productName);

    prodId++;
    return true;
  }

  function addOwnItemState(
    uint256 _prodId,
    address _newOwner,
    string memory _disc
  ) public onlyOwner(_prodId) returns (bool) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }

    s_allProducts[_prodId].OwnStateId++;
    s_productOwnerState[_prodId][s_allProducts[_prodId].OwnStateId].owner = _newOwner;
    s_productOwnerState[_prodId][s_allProducts[_prodId].OwnStateId].timeOwned = block.timestamp;
    s_productOwnerState[_prodId][s_allProducts[_prodId].OwnStateId].description = _disc;

    emit OwnerStateAdded(_prodId, s_allProducts[_prodId].OwnStateId);

    return true;
  }

  function addCostItemState(
    uint256 _prodId,
    uint256 _cost,
    string memory _disc
  ) public onlyOwner(_prodId) returns (bool) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }

    s_allProducts[_prodId].CostStateId++;
    s_productCostState[_prodId][s_allProducts[_prodId].CostStateId].cost = _cost;
    s_productCostState[_prodId][s_allProducts[_prodId].CostStateId].timeCosted = block.timestamp;
    s_productCostState[_prodId][s_allProducts[_prodId].CostStateId].description = _disc;

    emit CostStateAdded(_prodId, s_allProducts[_prodId].OwnStateId);

    return true;
  }

  /////////////////////
  // Getter Functions //
  /////////////////////

  // get the last owner of specific product
  function OwnerOf(uint256 _prodId) public view returns (address) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }
    if (s_allProducts[_prodId].OwnStateId == 0) {
      return s_allProducts[_prodId].creator;
    } else {
      return s_productOwnerState[_prodId][s_allProducts[_prodId].OwnStateId].owner;
    }
  }

  // return last time for item when his owner changed
  function LastTimeOwned(uint256 _prodId) public view returns (uint256) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }
    if (s_allProducts[_prodId].OwnStateId == 0) {
      return s_allProducts[_prodId].timeCreated;
    } else {
      return s_productOwnerState[_prodId][s_allProducts[_prodId].OwnStateId].timeOwned;
    }
  }

  // return last description for item when  owner changed
  function LastDiscriptionOwned(uint256 _prodId) public view returns (string memory) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }
    if (s_allProducts[_prodId].OwnStateId == 0) {
      return "";
    } else {
      return s_productOwnerState[_prodId][s_allProducts[_prodId].OwnStateId].description;
    }
  }

  // get the last cost of specific product
  function CostOf(uint256 _prodId) public view returns (uint256) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }
    if (s_allProducts[_prodId].CostStateId == 0) {
      return s_allProducts[_prodId].initialCost;
    } else {
      return s_productCostState[_prodId][s_allProducts[_prodId].CostStateId].cost;
    }
  }

  // return last time for item when item'sCost changed
  function LastTimeCosted(uint256 _prodId) public view returns (uint256) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }
    if (s_allProducts[_prodId].CostStateId == 0) {
      return s_allProducts[_prodId].timeCreated;
    } else {
      return s_productCostState[_prodId][s_allProducts[_prodId].CostStateId].timeCosted;
    }
  }

  // return last description for item when item'sCost changed
  function LastDescriptionCosted(uint256 _prodId) public view returns (string memory) {
    if (!(_prodId <= prodId)) {
      revert SupplyChain__ProductIdIsNotValid();
    }
    if (s_allProducts[_prodId].CostStateId == 0) {
      return "";
    } else {
      return s_productCostState[_prodId][s_allProducts[_prodId].CostStateId].description;
    }
  }

  // getCurrent prodId or how much Product we have now
  function getProdId() public view returns (uint256) {
    return prodId;
  }

  // get specific product detail with prodId
  function getProduct(uint256 _prodId) public view returns (Product memory) {
    return s_allProducts[_prodId];
  }

  // get how many owners this item with this prodId have
  function getNumberOfOwners(uint256 _prodId) public view returns (uint256) {
    return s_allProducts[_prodId].OwnStateId;
  }

  // get how many costs this item with this prodId have
  function getNumberOfCosts(uint256 _prodId) public view returns (uint256) {
    return s_allProducts[_prodId].CostStateId;
  }

  // get witch item and ther own ownerAddress at that state
  function getSpecificOwner(uint256 _prodId, uint256 _state) public view returns (OwnState memory) {
    return s_productOwnerState[_prodId][_state];
  }

  // get witch item and ther own costPrice at that state
  function getSpecificCost(uint256 _prodId, uint256 _state) public view returns (CostState memory) {
    return s_productCostState[_prodId][_state];
  }

  // struct Product {
  //   uint256 productId;
  //   address creator;
  //   string productName;
  //   uint256 timeCreated;
  //   uint256 initialCost;
  //   uint256 OwnStateId;
  //   uint256 CostStateId;
  // }

  // returns array of all Product with  our speific address
  function getProdWithAddress(address _address) public view returns (Product[] memory) {
    Product[] memory result = new Product[](5);
    uint256 index = 0;
    for (uint256 j = 0; j < prodId; j++) {
      if (OwnerOf(j) == _address) {
        result[index].productId = s_allProducts[j].productId;
        result[index].creator = s_allProducts[j].creator;
        result[index].productName = s_allProducts[j].productName;
        result[index].timeCreated = s_allProducts[j].timeCreated;
        result[index].initialCost = s_allProducts[j].initialCost;
        result[index].OwnStateId = s_allProducts[j].OwnStateId;
        result[index].CostStateId = s_allProducts[j].CostStateId;
        index++;
      }
    }

    return result;
  }

  // returns history of costs in specific product
  function getHistoryOfCosts(uint256 _prodId) public view returns (uint256[] memory) {
    uint256[] memory result = new uint256[](10);
    uint256 index = 0;
    if (s_allProducts[_prodId].OwnStateId == 0) {
      result[index] = CostOf(_prodId);
    } else {
      for (uint256 k = 0; k <= s_allProducts[_prodId].CostStateId; k++) {
        if (k == 0) {
          result[index] = s_allProducts[_prodId].initialCost;
          index++;
        }
        result[index] = s_productCostState[_prodId][k + 1].cost;
        index++;
      }
    }

    return result;
  }

  function getHistoryOfOwners(uint256 _prodId) public view returns (address[] memory) {
    address[] memory result = new address[](10);
    uint256 index = 0;
    if (s_allProducts[_prodId].CostStateId == 0) {
      result[index] = OwnerOf(_prodId);
    } else {
      for (uint256 k = 0; k <= s_allProducts[_prodId].CostStateId; k++) {
        if (k == 0) {
          result[index] = s_allProducts[_prodId].creator;
          index++;
        }
        result[index] = s_productOwnerState[_prodId][k + 1].owner;
        index++;
      }
    }

    return result;
  }
}
