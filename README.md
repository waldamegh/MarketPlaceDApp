Online Marketplace Project
===

A simple Ethereum smart contract for online marketplace.

## Contract Main Functinality

* Market owner functionality
1. Market owner is able to add a new admin
2. Market owner is able to remove an admin
3. Market owner is able to change Market State
- Admin functionality
1. Admin is able to add a new store owner
2. Admin is able to remove a store owner
3. Admin is able to approve Store Front
* Store Owner functionality
1. Store Owner is able to create a new store front
2. Store Owner is able to add a new product
3. Store Owner is able to update product price
4. Store Owner is able to remove product
5. Store owner able to withdraw funds
* Shopper  functionality
1. Shopper is able to pruchase a product

## Installation

- npm install
```
npm install
```

- Install ganache-cli
```
npm install -g ganache-cli
```
- Install truffle
```
npm install -g truffle
```
- Install truffle-hdwallet-provider
```
npm install --save truffle-hdwallet-provider
```
- Install http-server
```
npm install -g http-server
```
- Install open-zepplin
```
npm install openzeppelin-solidity
```

## How to set it up?

Start Ganache-cli:
```
$ ganache-cli
``` 

Open a new terminal to clone this repository, compile, migrate and test smart contract. 
```
$ git clone https://github.com/dev-bootcamp-2019/final-project-waldamegh.git
$ cd final-project-waldamegh
$ truffle compile
$ truffle migrate --reset
$ truffle test
```

![image](https://imgur.com/usAgqzc.png)


## Deploy Contract in a Test Network Rinkeby

```
truffle migrate --reset --network rinkeby
```

- output
```
2_deploy_contracts.js
=====================

   Deploying 'MarketPlace'
   -----------------------
   > transaction hash:    0x01fd6c9b9fe4f170a2658dac224bebb34dc271f1b27e1df2327c1bf5dc53bd25
   > Blocks: 1            Seconds: 21
   > contract address:    0xf3644160E79187086B442238315831d88CC4BAC5
   > account:             0x1a4402e17aa645f9ea18aAaD9487678AB1550797
   > balance:             18.53963328
   > gas used:            4946012
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.09892024 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.09892024 ETH

```

## UI 

```
$ cd client
$ npm install
$ npm install http-server
$ npm run start
```
Go to [http//localhost:3000](http://localhost:3000/) 

- Market Owner Inerface
![image](https://imgur.com/dfbUZxg.png)

- Admin Inerface

![image](https://imgur.com/REQOsid.png)

- Store Owner Inerface

![image](https://imgur.com/7Z6Xu2V.png)

![image](https://imgur.com/y2vQRQI.png)

- Shopper Inerface

![image](https://imgur.com/PzQemEQ.png)
