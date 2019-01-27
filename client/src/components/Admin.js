import React, { Component } from "react";

class Admin extends React.Component {

constructor(props) {
  super(props);
  this.state = { storeNums:'', numStoreOwners:'', addStoreOwner:'', removeStoreOwner:'', IsStoreOwner:'', approveStoreFront:'', PendingStores: [], accounts: this.props.accounts, contract: this.props.contract };
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
    let pendingList = [];
    let storeNums =[];

    const storeOwners = await contract.getNumberOfStoreOwners.call({from: accounts[0]});
    const storeFrontCount = await contract.getStoreFrontCount.call({ from: accounts[0] });
 
    for (let i = 0; i < storeFrontCount; i++) 
    {
      const storeFront = await contract.getStoreFrontInfo.call(i, { from: accounts[0] });
      if(!storeFront[5] && storeFront[2] == "0x0000000000000000000000000000000000000000"){
        pendingList.push( "Store Number: " + i +  " , Store Name: " + storeFront[0]);
        storeNums.push(i);
      }
   }
    this.setState({storeNums: storeNums ,numStoreOwners: storeOwners, PendingStores: pendingList});
  };


handleChange(event) {this.setState({ [event.target.name]: event.target.value }); }

AddNewStoreOwner(event) { 
  event.preventDefault();
  const { accounts, contract } = this.state;	
  var value = this.state.addStoreOwner;
  if(!value) {
    alert("Please enter the address");
 } else{
    var check = contract.isStoreOwner(value, {from : accounts[0]}).then(result => {
      if (!result){
         contract.addStoreOwner(value, {from : accounts[0]}).then(result => {
           this.forceUpdate();
         });
        
      }else{
       alert("Address is a store owner");
      }
      this.setState({ addStoreOwner: ''});
    });
    
   }
}

RemoveStoreOwner(event) { 
  event.preventDefault();
  const { accounts, contract } = this.state;	
  var value = this.state.removeStoreOwner;
  if(!value) {
    alert("Please enter the address");
 } else{
   var check = contract.isStoreOwner(value, {from : accounts[0]}).then(result => {
     if (result){
        contract.removeStoreOwner(value, {from : accounts[0]}).then(result => {
          this.forceUpdate();
        });
     }else{
      alert("Address is Not a store owner");
     }
     this.setState({ removeStoreOwner: ''});
   });
  }
}

IsStoreOwner(event) { 
  event.preventDefault();
  const { accounts, contract } = this.state;	
  var value = this.state.IsStoreOwner;
  if(!value) {
    alert("Please enter the address");
 } else{
    contract.isStoreOwner(value, {from : accounts[0]}).then(result => {  		
    if(result) {
      alert(value + " is an store owner address");
    }else{
      alert(value + " is Not an srote owner address!");
    }
   });
   this.setState({ IsStoreOwner: ''});
  }
}

ApproveStoreFront(event) { 
  event.preventDefault();
  const { accounts, contract, storeNums } = this.state;	
  var value = this.state.approveStoreFront;
  if(!value) {
    alert("Please enter a store number");
 } else{
   for(let i=0; i< storeNums.length; i++ ){
      if(storeNums[i] == value){
        contract.approveStoreFront(value, {from : accounts[0]}).then(result => {
          console.log(result)
          this.start();
          this.forceUpdate();
       });
       break;
      }
   }
   this.setState({ approveStoreFront: ''});
  }
}

render() {

  var pendingstorelist = this.state.PendingStores;

  return (
  <form >
  <div>
    <h3> Loged as Admin</h3> 
    <h4> Number of Store Owners = {String(this.state.numStoreOwners)}</h4>
  </div>
  <div >
    <h2>Add a New Store Owner</h2>
    <li><input type="text" ref="admininput" name="addStoreOwner" value={this.state.addStoreOwner} onChange={this.handleChange} placeholder="Store Owner Address"/></li>
    <li><button onClick={this.AddNewStoreOwner.bind(this)}>Add</button></li>
    <br/>
  </div>
  <div>
    <h2>Remove Store Owner</h2>
    <li><input type="text" ref="admininput2" name="removeStoreOwner" value={this.state.removeStoreOwner} onChange={this.handleChange} placeholder="Store Owner Address"/></li>
    <li><button onClick={this.RemoveStoreOwner.bind(this)}>Remove</button> </li>
  </div>
  <br/>
  <div>
    <h2>Check Store Owner Address</h2>
    <li><input type="text" ref="admininput3" name="IsStoreOwner" value={this.state.IsStoreOwner} onChange={this.handleChange} placeholder="Admin Address"/></li>
    <li><button onClick={this.IsStoreOwner.bind(this)}>Check</button> </li>
  </div>
  <br/>
  <div>
    <h2>Aprove Store Front</h2>
    <li><input type="text" ref="admininput4" name="approveStoreFront" value={this.state.approveStoreFront} onChange={this.handleChange} placeholder="Store Number"/></li>
    <li><button onClick={this.ApproveStoreFront.bind(this)}>Approve</button> </li>
  </div>
  <br/>
	<div>
    <h5>Pending Store Fronts are:
        {pendingstorelist.map(function(pendingstorelist, index){
         return <li key={ index }>{pendingstorelist}</li>;
         })}
  </h5>
  </div>
  </form>	
    );
  }
}
export default Admin;


