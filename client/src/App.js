import React, { Component } from "react";
import MarketPlace from "./contracts/MarketPlace.json";
import getWeb3 from "./utils/getWeb3";
import truffleContract from "truffle-contract";
import Header from './components/Header';
import Owner from './components/Owner';
import Admin from './components/Admin';
import StoreOwner from './components/StoreOwner';
import Shopper from './components/Shopper';
import "./App.css";


class App extends React.Component {

  state = {MarketState: null, addressType: null, web3: null, accounts: null, contract: null, balance: null };

  componentDidMount = async () => {
    try {
      const web3 = await getWeb3();

      const accounts = await web3.eth.getAccounts();
      const balance = await web3.eth.getBalance(accounts[0]);
      
      const Contract = truffleContract(MarketPlace);
      Contract.setProvider(web3.currentProvider);
      const instance = await Contract.deployed();

      this.setState({ web3, accounts, contract: instance , balance}, this.start);

    } catch (error) {
      alert("Error: " + error);
    }
  };

  start = async () => {
    const { accounts, contract } = this.state;

    const addressType = await contract.addressType.call({ from: accounts[0] });

    const _MarketState = await contract.getMarketState.call({ from: accounts[0] });

    this.setState({ addressType: addressType, MarketState: _MarketState });

  }; 

  render() {
    const AddressType = this.state.addressType;
    return (
     <React.Fragment>
 	<div>  	<Header {...this.state}/> </div>  
	<div>
	{
	   (() => {
	       if (AddressType == 0)	
		  return <div><Owner {...this.state}/> </div>
	       else if (AddressType == 1)	
		  return <div><Admin {...this.state}/> </div>
	       else if (AddressType == 2)	
		 return <div><StoreOwner {...this.state}/> </div>
	       else if (AddressType == 3)	
		  return <div><Shopper {...this.state}/> </div>
	   })()
	}      
  </div>
    </React.Fragment>
    );
  }
}
export default App;
