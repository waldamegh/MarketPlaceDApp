import React, { Component } from "react";

class Owner extends React.Component {

constructor(props) {
  super(props);
  this.state = { numAdmin:'', numStoreOwners: '', AddAdmin: '', RemoveAdmin: '' , IsAdmin:'', accounts: this.props.accounts, contract: this.props.contract, MarketState: this.props.MarketState};
}

componentDidMount = async () => {
  try {
      this.start();
      this.handleChange = this.handleChange.bind(this);
    } catch (error) {
      alert("Error: " + error);
    }
};

start = async () => {
    const { accounts, contract } = this.state;
    const marketState = await contract.getMarketState.call({from: accounts[0]});
    const admins = await contract.getNumberOfAdmins.call({from: accounts[0]});
    const storeOwners = await contract.getNumberOfStoreOwners.call({from: accounts[0]});
    this.setState({numAdmin: admins, numStoreOwners: storeOwners, MarketState: marketState});

};

handleChange(event) { this.setState({ [event.target.name]: event.target.value });}

AddNewAdmin(event) { 
    event.preventDefault();
    const { accounts, contract } = this.state;	
    var value = this.state.AddAdmin;
    if(!value) {
      alert("Please enter the address");
   } else{
     contract.addAdmin(value, {from : accounts[0]}).then(result => {
       this.forceUpdate(); 
     });
     this.setState({ AddAdmin: ''});
    }
}

RemoveAdmin(event) { 
    event.preventDefault();
    const { accounts, contract } = this.state;	
    var value = this.state.RemoveAdmin;
    if(!value) {
      alert("Please enter the address");
   } else{
     contract.removeAdmin(value, {from : accounts[0]}).then(result => { 
       this.forceUpdate(); 
     });
     this.setState({ RemoveAdmin: ''});
    }
}

IsAdmin(event) { 
    event.preventDefault();
    const { accounts, contract } = this.state;	
    var value = this.state.IsAdmin;
    if(!value) {
      alert("Please enter the address");
   } else{
      contract.isAdmin(value, {from : accounts[0]}).then(result => {  		
      if(result) {
        alert(value + " is an admin address");
      }else{
        alert(value + " is Not an admin address!");
      }
     });
     this.setState({ IsAdmin: ''});
    }
}

ChangeMarketState(event) {
  event.preventDefault();
  const { accounts, contract, MarketState } = this.state;	
  alert('Do you want to change market state?');
  contract.changeMarketState(!MarketState, {from : accounts[0]}).then(result => {
    this.start();
    this.forceUpdate(); 
  });
}

render() {
  return ( 	
  <form>
  <div>
    <h3> Loged as Market Owner</h3> 
    <h4>Number of Admins = {String(this.state.numAdmin)}  |  Number of Store Owners = {String(this.state.numStoreOwners)}</h4>
  </div>
  <div >
    <h2>Add a New Admin</h2>
    <li><input type="text" ref="admininput" name="AddAdmin" value={this.state.AddAdmin} onChange={this.handleChange} placeholder="Admin Address"/></li>
    <li><button onClick={this.AddNewAdmin.bind(this)}>Add</button></li>
    <br/>
  </div>
  <div>
    <h2>Remove Admin</h2>
    <li><input type="text" ref="admininput2" name="RemoveAdmin" value={this.state.RemoveAdmin} onChange={this.handleChange} placeholder="Admin Address"/></li>
    <li><button onClick={this.RemoveAdmin.bind(this)}>Remove</button> </li>
  </div>
  <br/>
  <div>
    <h2>Check Admin Address</h2>
    <li><input type="text" ref="admininput3" name="IsAdmin" value={this.state.IsAdmin} onChange={this.handleChange} placeholder="Admin Address"/></li>
    <li><button onClick={this.IsAdmin.bind(this)}>Check</button> </li>
  </div>
  <br/>
  <div>
    <h2>change Market State</h2>
    <button onClick={this.ChangeMarketState.bind(this)}>Change Market State</button>
  </div>
  </form>	
    );
  }
}
export default Owner;
