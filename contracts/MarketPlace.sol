pragma solidity ^0.5.0;

/** EthPM */
//import Ownable contract from openzeppelin-solidity for basic authorization control
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
//import SafeMath library from openzeppelin-solidity for integer overflows and underflow
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/** @title MarketPlace: a simple smart contract for a market place on Ethereum.
  * @author  Wafa AlDamegh.
  * @notice  Final project for ConsenSys Academy's Developer Bootcamp 2019.
  */
contract MarketPlace is Ownable {
    
    //Uses SafeMath library to avoid integer overflow/underflow attacks
    using SafeMath for uint256; 

    //state variables
    uint public storeOwnersCount;
    uint public adminCount;
    uint public storeCount;
    uint public productCount;
    bool public marktState;
    mapping (address => bool) public admins;
    mapping (address => bool) public storeOwners;
    mapping(uint => StoreFront) public storeFronts;
    mapping(address => uint[]) public storeOwnertoStoreFront;
    mapping(uint => address) public storeFronttoStoreOwner;
    mapping(uint => Product) public StoreProducts;
    mapping(uint => uint[]) public stotrFronttoProducts;


    //struct
    struct StoreFront {
        string storeName;
        address storeOwner;
        address approverAdmin;
        uint skuCount;
        uint balance;
        bool state;
    }
    
    struct Product {
        string name;
        uint storeNum;
        uint productNum;
        uint price;
        uint quantity;
        bool isAvailable;
    } 


    //enum for address type
    enum addressTypes { marketOwner, admin, storeOwner, shopper }

    //events
    event adminAdded(address newAdmin);
    event adminRemoved(address admin);
    event storeOwnerAdded(address newStoreOwner);
    event storeOwnerRemoved(address storeOwner);
    event marketStateChanged(bool state);
    event storeFrontCreated(uint storeNum, string storeName, address storeOwner);
    event storeFrontApproved(uint storeNum, address admin);
    event productAdded(uint storeNum, string productName, uint productNum);
    event productPriceUpdated(uint storeNum, uint productNum);
    event productRemoved(uint storeNum, uint productNum);
    event storeWithdrawn(uint amount, uint storeNum, address storeOwner);
    event productPurchased(uint storeNum, uint productNum, uint quantity, address shopper);


    //modifiers
    /** @dev verifies the msg.sender is an admin */
    modifier onlyAdmin() {require(admins[msg.sender], "Sorry, you are not admin!"); _;}
    /** @dev verifies the msg.sender is the store owner */
    modifier onlyStoreOwner() {require(storeOwners[msg.sender], "Sorry, you are not a store owner!"); _;}
    /** @dev verifies market state */
    modifier isMarketActive() {require(marktState, "Sorry, Market state is inactive!"); _;}
    /** @dev verifies the msg.sender is the store owner of the store front */
    modifier verifyStoreOwner(uint storeNum) {require(storeFronttoStoreOwner[storeNum] == msg.sender, "Sorry, you are not a store owner!"); _;}
    /** @dev verifies the msg.sender is not a store owner or admin */
    modifier onlyShopper(){require(!storeOwners[msg.sender], "Sorry, store owner is not allowed to buy products!"); 
    require(!admins[msg.sender], "Sorry, admin is not allowed to buy products!"); _;}


    //functions

    /** @dev constracter initalises state variables */
    constructor() public {
        admins[msg.sender] = true;
        storeOwnersCount = 0;
        adminCount = 1;
        storeCount = 0;
        productCount = 0;
        marktState = true;
    }

    /** @dev market owner allowed to add a new admin 
      * @param _newAdmin new admin addrress 
    */
    function addAdmin(address _newAdmin) public onlyOwner() isMarketActive() {
        require(admins[_newAdmin] == false, "Sorry, Admin already exists!");
        admins[_newAdmin] = true;
        adminCount = SafeMath.add(adminCount, 1);
        emit adminAdded(_newAdmin);
    }

    /** @dev market owner allowed to remove an admin 
      * @param _admin  admin addrress 
    */
    function removeAdmin(address _admin) public onlyOwner() {
        require(admins[_admin] == true, "Sorry, Admin not exists!");
        admins[_admin] = false;
        adminCount = SafeMath.sub(adminCount, 1);
        emit adminRemoved(_admin);
    }

    /** @dev admin allowed to add a new store owner 
      * @param _newStoreOwner new store owner addrress 
    */
    function addStoreOwner(address _newStoreOwner) public onlyAdmin() isMarketActive() {
        require(storeOwners[_newStoreOwner] == false, "Sorry, store owner already exists!");
        storeOwners[_newStoreOwner] = true;
        storeOwnersCount = SafeMath.add(storeOwnersCount, 1);
        emit storeOwnerAdded(_newStoreOwner);
    }

    /** @dev admin allowed to remove a store owner
      * @param _storeOwner store owner addrress 
    */
    function removeStoreOwner(address _storeOwner) public onlyAdmin() isMarketActive() {
        require(storeOwners[_storeOwner] == true, "Sorry, store owner not exists!");
        storeOwners[_storeOwner] = false;
        storeOwnersCount = SafeMath.sub(storeOwnersCount, 1);
        emit storeOwnerRemoved(_storeOwner);
    }    

    /** @dev market owner allowed to chainge marketplace state 
      * @param _state new market state
    */
    function changeMarketState(bool _state) public onlyOwner {
        require(marktState != _state, "Sorry, it the the current state!!");
        marktState = _state;
        emit marketStateChanged(_state);
    }

    /** @dev returns the current state of marketplace */
    function getMarketState() public view returns(bool){
        return marktState;
    }

    /** @dev returns (true) if the address is an admin, otherwise returns (false) */
    function isAdmin(address _address) public view returns(bool) {
        return admins[_address];
    }

    /** @dev returns the number of active admins */
    function getNumberOfAdmins() public view onlyAdmin() returns(uint){
        return adminCount;
    }

    /** @dev returns (true) if the address is store owner, otherwise returns (false) */
    function isStoreOwner(address _address) public view returns(bool) {
        return storeOwners[_address];
    }

    /** @dev returns the number of active store owners */
    function getNumberOfStoreOwners() public view onlyAdmin() returns(uint) {
        return storeOwnersCount;
    }

    
    /** @dev returns the type of address (market owner, admin, store owner, or shopper) */
    function addressType() public view returns(addressTypes) {
        if(msg.sender == super.owner())
            return addressTypes.marketOwner;
        if(admins[msg.sender])
            return addressTypes.admin;
        if(storeOwners[msg.sender])
            return addressTypes.storeOwner;
        else
            return addressTypes.shopper;
    }

    /** @dev admin can approve created store frontreturns(bool)
      * @param _storeNum store number
    */ 
    function approveStoreFront(uint _storeNum) public onlyAdmin() isMarketActive() {
        require(_storeNum <= storeCount, "Sorry, invalid store number!");
        require((storeFronts[_storeNum].state) == false, "Sorry, store front is allrady approved!");
        storeFronts[_storeNum].approverAdmin = msg.sender;
        storeFronts[_storeNum].state = true;
        emit storeFrontApproved(_storeNum, msg.sender);
    }

    /** @dev View contract balance
      * @return balance of all store fronts
    */ 
    function getContractBalance() public view onlyOwner() returns(uint){
        return address(this).balance;
    }

    /** @dev selfdestruct the contract to destroy the contract in case of bugs */
    function destroyContract() public onlyOwner() {
        selfdestruct(address(this));
    }

    ////////////////////

    /** Store Owner functions */

    /** @dev store owner allowed to add a new store front 
      * @param _storeName new market state
      * @return the store number
    */
    function createStoreFront(string memory _storeName) public  onlyStoreOwner() isMarketActive() returns(bool){   
        storeCount = SafeMath.add(storeCount, 1);
        storeFronts[storeCount] = StoreFront({storeName: _storeName, storeOwner: msg.sender, approverAdmin: address(0), skuCount: 0, balance: 0, state: false});
        storeOwnertoStoreFront[msg.sender].push(storeCount);
        storeFronttoStoreOwner[storeCount] = msg.sender;
        emit storeFrontCreated(storeCount, _storeName, msg.sender);
        return true;
    }


    /** @dev Store owner allowed to add a new product to their store front
      * @param _storeNum store front number
      * @param _productName product name
      * @param _productPrice product price
      * @param _productQuantity available quantity of the product
    */   
    function addProduct(uint _storeNum, string memory _productName, uint _productPrice, uint _productQuantity) public verifyStoreOwner(_storeNum) isMarketActive() returns(uint){
        require(storeFronts[_storeNum].state == true,  "Sorry, store front is not approved yet!");
        require(_productPrice > 0, "Sorry, invalid product price!");
        require(_productQuantity > 0, "Sorry, invalid product quantity!");
        storeFronts[_storeNum].skuCount = SafeMath.add(storeFronts[_storeNum].skuCount, 1);
        productCount = SafeMath.add(productCount,1);
        StoreProducts[productCount]= Product({name: _productName,  storeNum: _storeNum, productNum: productCount, price: _productPrice, quantity: _productQuantity, isAvailable: true});
        stotrFronttoProducts[_storeNum].push(productCount);
        emit productAdded(_storeNum, _productName, productCount);
        return productCount;
    }

    /** @dev Store owner allowed to update product price
      * @param _storeNum store front number
      * @param _productNum product nunmber
      * @param _newProductPrice product price
    */   
    function updateProductPrice(uint _storeNum, uint _productNum, uint _newProductPrice) public verifyStoreOwner(_storeNum) isMarketActive() returns(bool){
        require(storeFronts[_storeNum].state == true,  "Sorry, store front is not approved yet!");
        require(_newProductPrice > 0, "Sorry, invalid product price!");
        StoreProducts[_productNum].price = _newProductPrice;
        emit productPriceUpdated(_storeNum, _productNum);
        return true;
    }

    /** @dev Store owner allowed to remove product
      * @param _storeNum store front number
      * @param _productNum product nunmber
    */   
    function removeProduct(uint _storeNum, uint _productNum) public verifyStoreOwner(_storeNum) isMarketActive() returns(bool){
        require(storeFronts[_storeNum].state == true,  "Sorry, store front is not approved yet!");
        StoreProducts[_productNum].isAvailable = false;
        StoreProducts[_productNum].quantity = 0;
        emit productRemoved(_storeNum, _productNum);
        return true;
    }

    /** @dev Store owner can withdraw balance from their store fronts 
      * @param _storeNum store front number
    */ 
    function withdraw(uint _storeNum) public payable verifyStoreOwner(_storeNum) isMarketActive() {
        require(storeFronts[_storeNum].balance > 0, "Sorry, no funds available!");
        uint amount = storeFronts[_storeNum].balance;
        storeFronts[_storeNum].balance = 0;
        msg.sender.transfer(amount);
        emit storeWithdrawn(amount, _storeNum, msg.sender);
    }

    /** @dev return total number of store fronts */  
    function getStoreFrontCount() public view returns (uint) {
        return storeCount;
    }
    /** @dev return total number of product in the market */  
    function getProductCount() public view returns (uint) {
        return productCount;
    }

    /** @dev return total number of products in the store front
      * @param _storeNum store front number
    */  
    function getTotalProducts(uint _storeNum) public view returns (uint) {
        return storeFronts[_storeNum].skuCount;
    }

    /** @dev return store front info
      * @param _storeNum store front number
    */ 
    function getStoreFrontInfo(uint _storeNum) public view returns(string memory, address, address, uint, uint, bool){
        return (
        storeFronts[_storeNum].storeName,
        storeFronts[_storeNum].storeOwner,
        storeFronts[_storeNum].approverAdmin,
        storeFronts[_storeNum].skuCount,
        storeFronts[_storeNum].balance,
        storeFronts[_storeNum].state 
        );
    }

    /** @dev return store front by store owner address */ 
    function getStoreFrontByStoreOwner() public view  returns(uint[] memory){
        return storeOwnertoStoreFront[msg.sender];
    }

    /** @dev return store owner address of the store front
      * @param _storeNum store front number
    */ 
    function getStoreOwnerByStoreFront(uint _storeNum) public view returns(address){
        return storeFronttoStoreOwner[_storeNum];
    }

    /** @dev return products info
      * @param _productNum product number
    */ 
    function getProductInfo(uint _productNum) public view returns(string memory, uint, uint, uint, uint, bool){
        return (
        StoreProducts[_productNum].name,
        StoreProducts[_productNum].storeNum,
        StoreProducts[_productNum].productNum,
        StoreProducts[_productNum].price,
        StoreProducts[_productNum].quantity,
        StoreProducts[_productNum].isAvailable
        );
    }

    /** @dev return products by store front
      * @param _storeNum store front number
    */ 
    function getProductsByStoreFront(uint _storeNum) public view returns(uint[] memory){
        return stotrFronttoProducts[_storeNum];
    }
    
    ////////////////////

    /** Shopper function */ 

    /** @dev Shopper allowed to purchase a product 
      * @param _storeNum store front number
      * @param _productNum product number
    */   
    function purchaseProduct( uint _storeNum, uint _productNum) public payable onlyShopper() isMarketActive() returns(bool){
        require(StoreProducts[_productNum].price <= msg.value, "Sorry, transferred value is less than the product price!");
        require(StoreProducts[_productNum].quantity > 0, "Sorry, product is not available!");
        
        uint quantity = SafeMath.div(msg.value, StoreProducts[_productNum].price);
        StoreProducts[_productNum].quantity = SafeMath.sub(StoreProducts[_productNum].quantity, quantity);
        
        if (StoreProducts[_productNum].quantity == 0){StoreProducts[_productNum].isAvailable = false;}
        
        storeFronts[_storeNum].balance = SafeMath.add(storeFronts[_storeNum].balance,msg.value);
        
        emit productPurchased(_storeNum, _productNum, quantity, msg.sender);
        return true;
    }

    /** @dev fallback function */
    function() external payable {
    }


}